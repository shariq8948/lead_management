import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Tasks/taskDeatails/task_details_page.dart';
import '../auth/login/login_controller.dart';
import '../data/api/api_client.dart';
import '../google_service/google_calendar_helper.dart';
import '../utils/routes.dart';
import '../utils/tags.dart';
import '../widgets/custom_snckbar.dart';
import 'notification_db.dart';
import 'notification_model.dart';

Future<void> initializeStorage() async {
  await GetStorage.init();
}

class NotificationController extends GetxController {
  final notifications = <AppNotification>[].obs;
  late String taskId;
  final box = GetStorage();
  final _isProcessingLogout = false.obs;

  static const String LOGOUT_LOCK_KEY = 'logout_lock';
  static const Duration LOCK_TIMEOUT = Duration(seconds: 10);

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final notificationList =
          await NotificationDatabaseHelper.getAllNotifications();
      notifications.assignAll(notificationList);
      print('✅ Notifications loaded successfully: ${notifications.length}');
    } catch (e) {
      print('❌ Error loading notifications: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await NotificationDatabaseHelper.deleteNotification(id);
      await loadNotifications();
      print('✅ Notification deleted successfully');
    } catch (e) {
      print('❌ Error deleting notification: $e');
      CustomSnack.show(
        content: "Failed to delete notification",
        snackType: SnackType.error,
      );
    }
  }

  void _initializeFCM() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();
        print('📲 FCM Token: $token');
        await box.write('fcm_token', token);

        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);

        print('✅ FCM initialized successfully');
      } else {
        print('⚠️ Push Notification permissions denied');
      }
    } catch (e) {
      print('❌ Error initializing FCM: $e');
    }
  }

  static Future<bool> _acquireLock(GetStorage box) async {
    final lockValue = DateTime.now().toIso8601String();

    // Try to acquire lock
    if (await box.read(LOGOUT_LOCK_KEY) != null) {
      // Check if lock is stale
      final existingLock = await box.read(LOGOUT_LOCK_KEY);
      final lockTime = DateTime.parse(existingLock);
      if (DateTime.now().difference(lockTime) > LOCK_TIMEOUT) {
        await box.write(LOGOUT_LOCK_KEY, lockValue);
        return true;
      }
      return false;
    }

    await box.write(LOGOUT_LOCK_KEY, lockValue);
    return true;
  }

  static Future<void> _releaseLock(GetStorage box) async {
    await box.remove(LOGOUT_LOCK_KEY);
  }

  static Future<void> _handleBackgroundNotification(
      RemoteMessage message, GetStorage box) async {
    try {
      if (message.notification != null) {
        final notification = AppNotification(
          id: message.messageId ?? DateTime.now().toString(),
          title: message.notification!.title ?? '',
          description: message.notification!.body ?? 'No Description',
          timestamp: DateTime.now(),
          navigationTarget: message.data['navigation_target'] ?? '',
          navigationId: message.data['navigation_id'] ?? '',
          imageUrl: message.data['image'] ?? '',
        );

        await NotificationDatabaseHelper.insertNotification(notification);
        print('✅ Background notification saved: ${notification.title}');

        if (message.data['isCalender'] == "yes" && await _checkUserLoggedIn()) {
          await _handleCalendarEvent(message);
        }
      }
    } catch (e) {
      print('❌ Error processing background notification: $e');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('📩 Background Notification Received: ${message.messageId}');

    await GetStorage.init();
    final box = GetStorage();

    if (message.notification?.title?.toLowerCase() == "logout") {
      await box.write(StorageTags.loggedIn, "no");
      print(box.read(StorageTags.loggedIn));
      await _handleBackgroundLogout(box);
    } else {
      await _handleBackgroundNotification(message, box);
    }
  }

  static Future<void> _handleBackgroundLogout(GetStorage box) async {
    try {
      final lockAcquired = await _acquireLock(box);
      if (!lockAcquired) {
        print('⚠️ Could not acquire background logout lock');
        return;
      }

      try {
        // Create a temporary storage for important data
        final fcmToken = box.read('fcm_token');

        // Clear all data first
        await box.erase();

        // Write logout state AFTER clearing
        await Future.wait([
          // Restore FCM token
          if (fcmToken != null) box.write('fcm_token', fcmToken),

          // Set multiple logout indicators
          box.write(StorageTags.loggedIn, "no"),
          box.write('logged_in_backup', "no"), // Backup logout state
          box.write(StorageTags.PENDING_LOGOUT, "yes"),
          box.write('backup_logout_flag', "yes"),
          box.write('force_logout_flag', "yes"),
          box.write(
              StorageTags.LOGOUT_TIMESTAMP, DateTime.now().toIso8601String()),
        ]);

        // Set state data AFTER setting primary flags
        final stateData = {
          'logout_flag': "yes",
          'backup_logout_flag': "yes",
          'logout_timestamp': DateTime.now().toIso8601String(),
          'force_logout': true,
          'logged_in': "no", // Add login state to app_state
        };
        await box.write('app_state', stateData);

        // Verify the logout state
        final verificationData = {
          'login_state': box.read(StorageTags.loggedIn),
          'login_backup': box.read('logged_in_backup'),
          'pending_logout': box.read(StorageTags.PENDING_LOGOUT),
          'backup_flag': box.read('backup_logout_flag'),
          'force_logout': box.read('force_logout_flag'),
          'app_state': box.read('app_state'),
        };

        print('🔍 Logout state verification: $verificationData');

        // Double-check login state
        final finalLoginState = box.read(StorageTags.loggedIn);
        print('📊 Final login state check: $finalLoginState');
      } finally {
        await _releaseLock(box);
      }
    } catch (e) {
      print('❌ Background logout error: $e');
      await _releaseLock(box);
    }
  }

  Future<void> forceLogout() async {
    try {
      final fcmToken = box.read('fcm_token');
      await box.erase();
      if (fcmToken != null) {
        await box.write('fcm_token', fcmToken);
      }
      await box.write(StorageTags.loggedIn, "no");
      await Get.offAllNamed('/login');
    } catch (e) {
      print('❌ Force logout error: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (_isProcessingLogout.value) return;

    if (message.notification?.title?.toLowerCase() == "logout") {
      _isProcessingLogout.value = true;
      try {
        await _logoutUser();
      } finally {
        _isProcessingLogout.value = false;
      }
      return;
    }

    await _processNotification(message);
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    print('👆 Notification Tapped: ${message.messageId}');

    if (message.notification?.title?.toLowerCase() == "logout") {
      await _logoutUser();
      return;
    }

    await _processNotification(message);
    _handleNavigation(message);
  }

  Future<void> _processNotification(RemoteMessage message) async {
    if (message.notification != null) {
      try {
        final notification = AppNotification(
          id: message.messageId ?? DateTime.now().toString(),
          title: message.notification!.title ?? '',
          description: message.notification!.body ?? 'No Description',
          timestamp: DateTime.now(),
          navigationTarget: message.data['navigation_target'] ?? '',
          navigationId: message.data['navigation_id'] ?? '',
          imageUrl: message.data['image'] ?? '',
        );

        await addNotification(notification);

        if (message.data['isCalender'] == "yes" && await _checkUserLoggedIn()) {
          await _handleCalendarEvent(message);
        }
      } catch (e) {
        print('❌ Error processing notification: $e');
      }
    }
  }

  static Future<void> _handleCalendarEvent(RemoteMessage message) async {
    try {
      final client = await getGoogleAuthClient();
      if (client != null) {
        final isScheduled = await ApiClient().scheduleTaskOnGoogleCalendar(
          client: client,
          title: message.data['title'] ?? 'Untitled Event',
          location: message.data['location'] ?? '',
          description: message.data['description'] ?? '',
          startDate: message.data['start_date'] ?? '',
          endDate: message.data['end_date'] ?? '',
        );

        print(isScheduled
            ? '✅ Calendar event created'
            : '⚠️ Failed to create calendar event');
      }
    } catch (e) {
      print('❌ Error creating calendar event: $e');
    }
  }

  static Future<bool> _checkUserLoggedIn() async {
    final box = GetStorage();
    return box.read(StorageTags.loggedIn) == 'yes';
  }

  Future<void> _logoutUser() async {
    try {
      if (!Get.isRegistered<LoginController>()) {
        await Get.put(LoginController());
      }

      final fcmToken = box.read('fcm_token');

      // Clear storage but preserve FCM token
      await box.erase();
      if (fcmToken != null) {
        await box.write('fcm_token', fcmToken);
      }

      // Navigate to login
      await Get.offAllNamed('/login');

      CustomSnack.show(
        content: "You have been logged out",
        snackType: SnackType.success,
      );

      print('✅ Logout completed successfully');
    } catch (e) {
      print("❌ Logout error: $e");
      CustomSnack.show(
        content: "Failed to log out. Please try again.",
        snackType: SnackType.error,
      );
      rethrow;
    }
  }

  Future<bool> checkPendingLogout() async {
    if (_isProcessingLogout.value) return false;

    try {
      final lockAcquired = await _acquireLock(box);
      if (!lockAcquired) {
        print('⚠️ Could not acquire lock for pending logout check');
        return false;
      }

      try {
        final savedState = box.read('app_state') ?? {};
        final isPendingLogout = box.read(StorageTags.PENDING_LOGOUT) == "yes" ||
            box.read('backup_logout_flag') == "yes" ||
            savedState['logout_flag'] == "yes" ||
            savedState['backup_logout_flag'] == "yes";

        if (isPendingLogout) {
          _isProcessingLogout.value = true;

          // Clear logout flags
          await Future.wait([
            box.remove(StorageTags.PENDING_LOGOUT),
            box.remove(StorageTags.LOGOUT_TIMESTAMP),
            box.remove('backup_logout_flag'),
            box.remove('app_state'),
          ]);

          await _logoutUser();
          return true;
        }
        return false;
      } finally {
        await _releaseLock(box);
        _isProcessingLogout.value = false;
      }
    } catch (e) {
      print('❌ Error checking pending logout: $e');
      _isProcessingLogout.value = false;
      await _releaseLock(box);
      return false;
    }
  }

  Future<void> addNotification(AppNotification notification) async {
    try {
      await NotificationDatabaseHelper.insertNotification(notification);
      await loadNotifications();
      print('✅ Notification added successfully');
    } catch (e) {
      print('❌ Error adding notification: $e');
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      await NotificationDatabaseHelper.updateNotificationStatus(id, true);
      await loadNotifications();
      print('✅ Notification marked as read');
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }

  Future<void> clearNotifications() async {
    try {
      await NotificationDatabaseHelper.deleteAllNotifications();
      await loadNotifications();
      print('✅ All notifications cleared');
    } catch (e) {
      print('❌ Error clearing notifications: $e');
      CustomSnack.show(
        content: "Failed to clear notifications",
        snackType: SnackType.error,
      );
    }
  }

  void _handleNavigation(RemoteMessage message) {
    String navigationTarget = message.data['navigation_target'] ?? '';
    String navigationId = message.data['navigation_id'] ?? '';
    navigateToPage(navigationTarget, navigationId);
  }

  void navigateToPage(String navigationTarget, String? navigationId) {
    try {
      switch (navigationTarget) {
        case "task_detail_page":
          if (navigationId != null) {
            print("📄 Navigating to task detail: $navigationId");
            Get.to(() => TaskDetailPage(), arguments: {
              "taskId": navigationId,
            });
          }
          break;
        case "lead_detail":
          print("📄 Navigating to lead detail: $navigationId");
          Get.toNamed(
            Routes.leadDetail,
            arguments: navigationId,
          );
          break;
        case "home_page":
          print("🏠 Navigating to home page");
          Get.toNamed(Routes.home);
          break;
        default:
          print("⚠️ Unknown navigation target: $navigationTarget");
      }
    } catch (e) {
      print('❌ Navigation error: $e');
      CustomSnack.show(
        content: "Failed to navigate to the requested page",
        snackType: SnackType.error,
      );
    }
  }
}
