import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Tasks/taskDeatails/task_details_page.dart';
import '../data/api/api_client.dart';
import '../google_service/google_calendar_helper.dart';
import '../utils/routes.dart';
import '../utils/tags.dart';
import '../widgets/custom_snckbar.dart';
import 'notification_db.dart';
import 'notification_model.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📩 Background Notification Received: ${message.messageId}');

  try {
    // Initialize the database directly
    await NotificationDatabaseHelper.initDatabase();

    if (message.notification != null) {
      // Create notification object from payload structure
      final notification = _createNotificationFromMessage(message);

      // Insert directly into the database
      final result =
          await NotificationDatabaseHelper.insertNotification(notification);
      print('✅ Background notification saved to SQLite with result: $result');

      // Handle calendar event if needed
      if (message.data['Iscalendar'] == "yes") {
        // Initialize GetStorage for calendar check
        await GetStorage.init();
        final box = GetStorage();
        if (box.read(StorageTags.loggedIn) == 'yes') {
          try {
            final client = await getGoogleAuthClient();
            if (client != null) {
              final isScheduled =
                  await ApiClient().scheduleTaskOnGoogleCalendar(
                client: client,
                title: message.notification?.title ?? 'Untitled Event',
                location: message.data['MyCalendar_Location'] ?? '',
                description: message.notification?.body ?? '',
                startDate: message.data['MyCalendar_Startdate'] ?? '',
                endDate: message.data['MyCalendar_Enddate'] ?? '',
              );
              print(isScheduled
                  ? '✅ Calendar event created in background'
                  : '⚠️ Failed to create calendar event in background');
            }
          } catch (e) {
            print('❌ Error creating calendar event in background: $e');
          }
        }
      }
    }

    // Small delay to ensure operations complete
    await Future.delayed(Duration(milliseconds: 500));
  } catch (e, stackTrace) {
    print('❌ Error in background handler: $e');
    print('Stack trace: $stackTrace');
  }
}

// Helper function to create notification from message
AppNotification _createNotificationFromMessage(RemoteMessage message) {
  return AppNotification(
    id: message.messageId ?? DateTime.now().toString(),
    title: message.notification?.title ?? '',
    description: message.notification?.body ?? 'No Description',
    timestamp: DateTime.now(),
    navigationTarget: message.data['NavigationTarget'] ?? "",
    navigationId: message.data['Navigationid'] ?? "",
    imageUrl: message.notification?.android?.imageUrl ??
        message.notification?.apple?.imageUrl,
    notificationType: message.data['NotificationType'],
    notificationAction: message.data['NotificationAction'],
    isCalendar: message.data['Iscalendar'],
    location: message.data['MyCalendar_Location'],
    startDate: message.data['MyCalendar_Startdate'],
    endDate: message.data['MyCalendar_Enddate'],
    userId: message.data['UserId'],
    priority: message.data['Priority'],
    popupDataActionId: message.data['PopupData_ActionId'],
    popupDataActionType: message.data['PopupData_ActionType'],
    popupDataRemark: message.data['PopupDataRemark'],
    popupAdditionalData: message.data['PopUpAdditionalData'],
  );
}

class NotificationController extends GetxController {
  final notifications = <AppNotification>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
    loadNotifications();
  }

// The current filter Rx variable
  final RxString currentFilter = 'All'.obs;
  final RxList<AppNotification> searchResults = <AppNotification>[].obs;
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

  void setFilter(String filter) {
    currentFilter.value = filter;
    searchResults.clear();
  }

  void setSearchResults(List<AppNotification> results) {
    searchResults.assignAll(results);
    // Show a custom message for search
    currentFilter.value = 'Search';
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

        // Use the global top-level function
        FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler);

        print('✅ FCM initialized successfully');
      } else {
        print('⚠️ Push Notification permissions denied');
      }
    } catch (e) {
      print('❌ Error initializing FCM: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📬 Foreground Notification Received: ${message.messageId}');

    // Always save the notification to database regardless of action type
    await _saveNotification(message);

    // For foreground messages:
    // - Popup actions can be shown immediately
    // - Navigation actions should only happen when notification is tapped
    final action = message.data['NotificationAction'] ?? '';

    // Only handle popup notifications immediately in foreground
    // if (action == 'Popup') {
    //   _handlePopupNotification(message);
    // }

    // Process calendar events if needed regardless of action type
    _processCalendarEvent(message);
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    print('👆 Notification Tapped: ${message.messageId}');

    // Always save the notification to database
    await _saveNotification(message);

    // Process based on action type
    final action = message.data['NotificationAction'] ?? '';

    if (action == 'Navigation') {
      _handleNavigation(message);
    } else if (action == 'Popup') {
      _handlePopupNotification(message);
    } else {
      print('📌 Normal notification tapped, no special action required');
    }

    // Process calendar events if needed
    _processCalendarEvent(message);
  }

  Future<void> _saveNotification(RemoteMessage message) async {
    if (message.notification != null) {
      try {
        // Create notification using helper function
        final notification = _createNotificationFromMessage(message);

        await addNotification(notification);
      } catch (e) {
        print('❌ Error saving notification: $e');
      }
    }
  }

  void _processCalendarEvent(RemoteMessage message) {
    // Only process calendar events if Iscalendar is set to "yes"
    if (message.data['Iscalendar'] == "yes") {
      _checkUserLoggedIn().then((isLoggedIn) {
        if (isLoggedIn) {
          _handleCalendarEvent(message);
        }
      });
    }
  }

  void _handlePopupNotification(RemoteMessage message) {
    try {
      final actionType = message.data['PopupData_ActionType'] ?? "";
      final actionId = message.data['PopupData_ActionId'] ?? "";
      final remark = message.data['PopupDataRemark'] ?? "";

      print('📱 Showing popup notification: $actionType, ID: $actionId');

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.notification?.android?.imageUrl != null ||
                    message.notification?.apple?.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      message.notification?.android?.imageUrl ??
                          message.notification?.apple?.imageUrl ??
                          '',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  message.notification?.title ?? 'Notification',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  message.notification?.body ?? '',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                if (remark.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Note: $remark',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Dismiss'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle popup action based on type
                        _handlePopupAction(
                          actionType,
                          actionId,
                          message.data['PopUpAdditionalData'] ?? '',
                        );
                        Get.back();
                      },
                      child: Text(_getActionButtonText(actionType)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('❌ Error handling popup notification: $e');
    }
  }

  String _getActionButtonText(String actionType) {
    switch (actionType) {
      case 'Approval':
        return 'Approve';
      case 'PaymentCollection':
        return 'Process Payment';
      case 'ExpenseApproval':
        return 'Review Expense';
      default:
        return 'Take Action';
    }
  }

  void _handlePopupAction(
    String actionType,
    String actionId,
    String additionalData,
  ) {
    print('🔘 Handling popup action: $actionType, ID: $actionId');

    // Process the action based on type
    switch (actionType) {
      case 'Approval':
        _processApproval(actionId, additionalData);
        break;
      case 'PaymentCollection':
        _processPaymentCollection(actionId, additionalData);
        break;
      case 'ExpenseApproval':
        _processExpenseApproval(actionId, additionalData);
        break;
      default:
        print('Unknown action type: $actionType');
    }
  }

  void _processApproval(String actionId, String additionalData) {
    print('Processing approval with ID: $actionId');
    // Implement your approval logic here

    // Show success message
    CustomSnack.show(
      content: "Approval processed successfully",
      snackType: SnackType.success,
    );
  }

  void _processPaymentCollection(String actionId, String additionalData) {
    print('Processing payment collection with ID: $actionId');
    // Implement your payment collection logic here

    // Show success message
    CustomSnack.show(
      content: "Payment collection initiated",
      snackType: SnackType.success,
    );
  }

  void _processExpenseApproval(String actionId, String additionalData) {
    print('Processing expense approval with ID: $actionId');
    // Implement your expense approval logic here

    // Show success message
    CustomSnack.show(
      content: "Expense approval processed",
      snackType: SnackType.success,
    );
  }

  Future<void> _handleCalendarEvent(RemoteMessage message) async {
    try {
      final client = await getGoogleAuthClient();
      if (client != null) {
        final isScheduled = await ApiClient().scheduleTaskOnGoogleCalendar(
          client: client,
          title: message.notification?.title ?? 'Untitled Event',
          location: message.data['MyCalendar_Location'] ?? '',
          description: message.notification?.body ?? '',
          startDate: message.data['MyCalendar_Startdate'] ?? '',
          endDate: message.data['MyCalendar_Enddate'] ?? '',
        );

        if (isScheduled) {
          print('✅ Calendar event created');
          CustomSnack.show(
            content: "Event added to your calendar",
            snackType: SnackType.success,
          );
        } else {
          print('⚠️ Failed to create calendar event');
        }
      }
    } catch (e) {
      print('❌ Error creating calendar event: $e');
    }
  }

  Future<bool> _checkUserLoggedIn() async {
    return box.read(StorageTags.loggedIn) == 'yes';
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
    String navigationTarget = message.data['NavigationTarget'] ?? '';
    String navigationId = message.data['Navigationid'] ?? '';

    print('🧭 Handling navigation: Target=$navigationTarget, ID=$navigationId');

    // Only navigate if we have a target
    if (navigationTarget.isNotEmpty) {
      navigateToPage(navigationTarget, navigationId);
    } else {
      print('⚠️ Navigation requested but no target specified');
    }
  }

  void navigateToPage(String navigationTarget, String? navigationId) {
    try {
      print(navigationTarget);
      switch (navigationTarget) {
        case "task_detail_page":
          if (navigationId != null && navigationId.isNotEmpty) {
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
          CustomSnack.show(
            content: "Unknown navigation target",
            snackType: SnackType.warning,
          );
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

// Add these methods to your NotificationController class
extension NotificationControllerExtension on NotificationController {
  RxList<AppNotification> get filteredNotifications {
    if (searchResults.isNotEmpty) {
      return searchResults;
    }

    switch (currentFilter.value) {
      case 'Unread':
        return notifications.where((n) => !n.isRead).toList().obs;
      case 'task':
      case 'alert':
      case 'reminder':
      case 'approval':
        return notifications
            .where((n) =>
                (n.notificationType ?? '').toLowerCase() == currentFilter.value)
            .toList()
            .obs;
      case 'All':
      default:
        return notifications;
    }
  }
}
