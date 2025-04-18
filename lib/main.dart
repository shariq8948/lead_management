import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads/Tabs/homepage/homepage_controller.dart';
import 'package:leads/auth/login/login_controller.dart';
import 'package:leads/notifications/notification_controller.dart'; // Import to access the top-level background handler
import 'package:leads/notifications/notification_db.dart'; // Import DB helper
import 'package:leads/splash/splash_binding.dart';
import 'package:leads/utils/constants.dart';
import 'package:leads/utils/dependancy_injection.dart';
import 'package:leads/utils/input_theme.dart';
import 'package:leads/utils/routes.dart';

import 'observer/applifecycle.dart';
import 'observer/location_controller.dart';
import 'observer/navigator_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await Firebase.initializeApp();

  // Initialize database early
  await NotificationDatabaseHelper.initDatabase();

  // Register background handler directly here
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize storage
  await GetStorage.init();
  Get.put(LocationController());

  Get.put(AppLifecycleHandler());

  DependencyInjection.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(App());
}

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  App({super.key});

  final ThemeData theme = ThemeData.dark();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: bgColor,
        systemNavigationBarColor: bgColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GetMaterialApp(
      title: "Job Card Management",
      themeMode: ThemeMode.dark,
      navigatorObservers: [AppNavigationObserver()],
      navigatorKey: navigatorKey,
      initialRoute: Routes.splashRoute,
      initialBinding: SplashBinding(),
      getPages: Routes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: screenbgColor,
        primaryColor: primary3Color,
        inputDecorationTheme: MyInputTheme().theme(),
        textTheme: GoogleFonts.josefinSansTextTheme(),
        useMaterial3: true,
        appBarTheme: AppBarTheme(color: Colors.tealAccent),
      ),
      enableLog: true,
    );
  }
}
