import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads/Tabs/homepage/homepage_controller.dart';
import 'package:leads/auth/login/login_controller.dart';
import 'package:leads/splash/splash_binding.dart';
import 'package:leads/utils/constants.dart';
import 'package:leads/utils/dependancy_injection.dart';
import 'package:leads/utils/input_theme.dart';
import 'package:leads/utils/routes.dart';


import 'alarm/alarm.dart';
import 'observer/applifecycle.dart';
import 'observer/location_controller.dart';
import 'observer/navigator_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AlarmService.initialize(); // Initialize alarm manager
  Get.put(LocationController());

  // Initialize the lifecycle handler globally
  Get.put(AppLifecycleHandler()); // Ensure the handler is initialized

  await GetStorage.init();
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
      // showPerformanceOverlay: true,
      title: "Job Card Management",
      themeMode: ThemeMode.dark,
      navigatorObservers: [AppNavigationObserver()], // Add the observer here

      navigatorKey: navigatorKey,
      initialRoute: Routes.splashRoute,
      initialBinding: SplashBinding(),
      getPages: Routes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: screenbgColor,
        primaryColor: primary3Color,
        inputDecorationTheme: MyInputTheme().theme(),
        textTheme:
            GoogleFonts.josefinSansTextTheme(), // Apply Josefin Sans globally
        useMaterial3: true,
        appBarTheme: AppBarTheme(
            color: Colors.tealAccent // Customize AppBar background color
            ),
      ),
      enableLog: true,
    );
  }
}
