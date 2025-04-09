import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../notifications/notification_controller.dart';
import '../utils/tags.dart';
import 'location_controller.dart';

class AppLifecycleHandler extends GetxController with WidgetsBindingObserver {
  final LocationController locationController = Get.find<LocationController>();
  late final NotificationController notificationController;
  final box = GetStorage();
  final _isHandlingLifecycleChange = false.obs;
  final _stateBeingSaved = false.obs;
  final _isCheckingLogout = false.obs;
  final _isInitialized = false.obs;
  final _backgroundStartTime = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initializeControllers();
    _checkInitialState();
    _isInitialized.value = true;
  }

  Future<void> _initializeControllers() async {
    try {
      if (!Get.isRegistered<NotificationController>()) {
        notificationController = Get.put(NotificationController());
      } else {
        notificationController = Get.find<NotificationController>();
      }
    } catch (e) {
      print('❌ Error initializing controllers: $e');
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> _checkInitialState() async {
    if (_isCheckingLogout.value) return;

    try {
      _isCheckingLogout.value = true;

      int retryCount = 0;
      bool success = false;

      while (!success && retryCount < 3) {
        try {
          await _initializeControllers();
          await Future.delayed(const Duration(milliseconds: 500));

          final hasLogout = await notificationController.checkPendingLogout();
          if (hasLogout) return;

          success = true;
        } catch (e) {
          retryCount++;
          await Future.delayed(Duration(seconds: retryCount));
          print('⚠️ Retry $retryCount: Error in initial state check: $e');
        }
      }

      if (!success) {
        print('⚠️ Failed to check initial state after retries');
      }
    } finally {
      _isCheckingLogout.value = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_isHandlingLifecycleChange.value) return;

    _isHandlingLifecycleChange.value = true;

    try {
      switch (state) {
        case AppLifecycleState.resumed:
          await _handleAppForeground();
          break;
        case AppLifecycleState.paused:
          await _handleAppBackground();
          break;
        case AppLifecycleState.inactive:
          await _handleAppInactive();
          break;
        case AppLifecycleState.detached:
          await _handleAppTermination();
          break;
        default:
          break;
      }
    } finally {
      _isHandlingLifecycleChange.value = false;
    }
  }

  Future<void> _handleAppBackground() async {
    print('📱 App moved to background');
    try {
      _backgroundStartTime.value = DateTime.now();

      // Only save state if not already logged out
      if (box.read(StorageTags.loggedIn) == "yes") {
        final currentState = {
          'timestamp': DateTime.now().toIso8601String(),
          'was_in_background': true,
          'login_state': box.read(StorageTags.loggedIn),
          'background_start': _backgroundStartTime.value?.toIso8601String(),
        };

        await Future.wait([
          box.write('was_in_background', true),
          box.write('background_start_time', DateTime.now().toIso8601String()),
          box.write('app_state', currentState),
        ]);
        print('💾 Initial background state saved: $currentState');
      }
    } catch (e) {
      print('❌ Error handling background state: $e');
    }
  }

  Future<void> _handleAppForeground() async {
    print('📱 App moved to foreground');

    try {
      // Check if this is a valid foreground resume
      final backgroundStart = box.read('background_start_time');
      if (backgroundStart != null) {
        final startTime = DateTime.parse(backgroundStart);
        final timeDifference = DateTime.now().difference(startTime);
        print('⏱️ Background duration: ${timeDifference.inSeconds} seconds');
      }

      // Retrieve saved state
      final savedState = box.read('app_state') ?? {};
      print('📦 Retrieved saved state: $savedState');

      // Check all possible login state indicators
      final loginState = box.read(StorageTags.loggedIn);
      final savedLoginState = savedState['login_state'];
      final isPendingLogout = box.read(StorageTags.PENDING_LOGOUT) == "yes";
      final hasBackupFlag = box.read('backup_logout_flag') == "yes";
      final hasForceLogout = box.read('force_logout_flag') == "yes";

      print('🔍 State verification:');
      print('Current login state: $loginState');
      print('Saved login state: $savedLoginState');
      print('Pending logout: $isPendingLogout');
      print('Backup flag: $hasBackupFlag');
      print('Force logout: $hasForceLogout');

      // If saved state indicates logged out but current state is logged in,
      // something has incorrectly reset the state
      if ((savedLoginState == "no" ||
              isPendingLogout ||
              hasBackupFlag ||
              hasForceLogout) &&
          loginState == "yes") {
        print('⚠️ Detected invalid login state reset - enforcing logout');

        // Store FCM token
        final fcmToken = box.read('fcm_token');

        // Clear everything
        await box.erase();

        // Restore FCM token and enforce logout
        if (fcmToken != null) {
          await box.write('fcm_token', fcmToken);
        }
        await box.write(StorageTags.loggedIn, "no");

        // Force navigation to login
        if (Get.currentRoute != '/login') {
          await Get.offAllNamed('/login');
          Get.snackbar(
            'Session Ended',
            'You have been logged out of your account',
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
          );
        }
        return;
      }

      // If we're logged in, proceed with normal operations
      if (loginState == "yes") {
        await Future.delayed(const Duration(milliseconds: 1000));
        await notificationController.loadNotifications();
      }
    } catch (e) {
      print('❌ Error in foreground handlers: $e');
      // Failsafe: force logout on error
      await box.write(StorageTags.loggedIn, "no");
      if (Get.currentRoute != '/login') {
        await Get.offAllNamed('/login');
      }
    } finally {
      // Clean up background tracking
      await box.remove('background_start_time');
      _backgroundStartTime.value = null;
    }
  }

  Future<void> _handleAppInactive() async {
    try {
      print('📱 App became inactive');
      await _saveAppState();
    } catch (e) {
      print('❌ Error handling inactive state: $e');
    }
  }

  Future<void> _handleAppTermination() async {
    try {
      print('📱 App is being terminated');
      await Future.wait([
        _saveAppState(),
        box.write('last_termination', DateTime.now().toIso8601String()),
        _cleanupResources(),
      ]);
      print('✅ App termination handled successfully');
    } catch (e) {
      print('❌ Error handling app termination: $e');
    }
  }

  Future<void> _saveAppState() async {
    if (_stateBeingSaved.value) return;

    _stateBeingSaved.value = true;

    try {
      // Save the current timestamp when going to background
      _backgroundStartTime.value = DateTime.now();

      final logoutFlag = box.read(StorageTags.PENDING_LOGOUT);
      final backupFlag = box.read('backup_logout_flag');
      final timestamp = box.read(StorageTags.LOGOUT_TIMESTAMP);
      final loginState = box.read(StorageTags.loggedIn);

      final stateData = {
        'timestamp': DateTime.now().toIso8601String(),
        'notifications_count': notificationController.notifications.length,
        'was_in_background': true,
        'logout_flag': logoutFlag,
        'backup_logout_flag': backupFlag,
        'logout_timestamp': timestamp,
        'login_state': loginState,
        'background_start': _backgroundStartTime.value?.toIso8601String(),
      };

      await box.write('app_state', stateData);
      print('💾 Saved app state: $stateData');
    } catch (e) {
      print('❌ Error saving app state: $e');
    } finally {
      _stateBeingSaved.value = false;
    }
  }

  Future<void> _cleanupResources() async {
    try {
      // Clean up any resources that need to be released
      // e.g., close streams, cancel subscriptions, etc.

      // Save any critical data before cleanup
      await _saveAppState();

      // Clear any temporary data
      await box.remove('temporary_data');

      print('✅ Resources cleaned up successfully');
    } catch (e) {
      print('❌ Error cleaning up resources: $e');
    }
  }

  Future<void> refreshAppState() async {
    try {
      // Refresh all necessary controllers and states
      await Future.wait([
        notificationController.loadNotifications(),
        _checkPendingActions(),
      ]);

      print('✅ App state refreshed successfully');
    } catch (e) {
      print('❌ Error refreshing app state: $e');
    }
  }

  Future<void> _checkPendingActions() async {
    try {
      final appState = box.read('app_state');
      if (appState != null) {
        // Process any pending actions from the saved state
        final pendingTasks = appState['pending_tasks'] ?? [];
        for (final task in pendingTasks) {
          await _processPendingTask(task);
        }
      }
    } catch (e) {
      print('❌ Error checking pending actions: $e');
    }
  }

  Future<void> _processPendingTask(dynamic task) async {
    try {
      // Process individual pending tasks
      print('Processing pending task: $task');
    } catch (e) {
      print('❌ Error processing pending task: $e');
    }
  }
}
