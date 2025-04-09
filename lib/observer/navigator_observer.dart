import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Tabs/homepage/homepage_controller.dart';
import '../notifications/notification_controller.dart';
import 'location_controller.dart';

class AppNavigationObserver extends NavigatorObserver
    with WidgetsBindingObserver {
  final LocationController locationController = Get.find<LocationController>();
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    // print("Page pushed: ${route.settings.name}");
    locationController.uploadLocation();
    notificationController.loadNotifications();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // print("Page popped: ${route.settings.name}");
    notificationController.loadNotifications();

    if (route.settings.name == "/CreateLeadPage") {
      final HomeController homeController = Get.find<HomeController>();
      homeController.fetchAssignedLead();
      homeController.fetchDashboardCount();
      homeController.fetchTasksByTab("Today");
      homeController.fetchFunnelData();
      homeController.fetchPieData();
    }
    locationController.uploadLocation();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // print("Page replaced: ${newRoute?.settings.name}");
    locationController.uploadLocation();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    // print("Page removed: ${route.settings.name}");
    locationController.uploadLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _appBackgroundHandler();
    } else if (state == AppLifecycleState.resumed) {
      _appForegroundHandler();
    }
  }

  // App moved to the background
  void _appBackgroundHandler() {
    // print('App moved to background');
    // Handle app background tasks such as saving state or stopping certain processes
  }

  // App moved to the foreground
  void _appForegroundHandler() {
    // print('App moved to foreground');
    // Handle app foreground tasks such as refreshing data, checking notifications, etc.
    notificationController
        .loadNotifications(); // Refresh notifications when app is back in the foreground
  }
}
