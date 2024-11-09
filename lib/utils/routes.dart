import 'package:get/route_manager.dart';
import 'package:leads/Tabs/homepage/home_page.dart';
import 'package:leads/Tabs/homepage/homepage_binding.dart';

import '../auth/login/login_binding.dart';
import '../auth/login/login_screen.dart';
import '../leadlist/lead_list_page.dart';
import '../splash/splash_binding.dart';
import '../splash/splash_screen.dart';


class Routes {
  // Route Names
  static const splashRoute = "/";
  static const leadList = "/leadlist";
  static const loginRoute = "/login";
  static const main = "/main";
  static const home = "/home";
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
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: main,
      page: () => HomeScreen(),
      binding: HomePageBinding(),
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
