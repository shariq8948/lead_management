import 'package:get/route_manager.dart';

import '../auth/login/login_binding.dart';
import '../auth/login/login_screen.dart';
import '../splash/splash_binding.dart';
import '../splash/splash_screen.dart';


class Routes {
  // Route Names
  static const splashRoute = "/";
  static const loginRoute = "/login";
  static const main = "/main";
  static const jobslist = "/jobslist";
  static const jobdetail = "/jobdetail";
  static const stopwatch = "/stopwatch";
  static const createjob = "/createjob";
  static const noInternet = "/no-internet";
  static const createInquiry = "/createinquiry";
  static const createInquiry2 = "/createinquiry";
  static const inquiryList = "/inquiryList";
  static const inquiryDetail = "/inquiryDetail";
  static const chat = "/chat";
  static const reports = "/reports";

  // Get Pages
  static List<GetPage> routes = [
    // Splash
    GetPage(
      name: splashRoute,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),

    // Login
    GetPage(
      name: loginRoute,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),

    // Main Tabs


  ];
}
