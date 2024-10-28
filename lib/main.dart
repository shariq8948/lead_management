import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/splash/splash_binding.dart';
import 'package:leads/utils/constants.dart';
import 'package:leads/utils/dependancy_injection.dart';
import 'package:leads/utils/input_theme.dart';
import 'package:leads/utils/routes.dart';

import 'package:new_version_plus/new_version_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get Storage Init
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
    final newVersionPlus = NewVersionPlus();
    newVersionPlus.showAlertIfNecessary(context: context);
    return GetMaterialApp(
      title: "Job Card Management",
      themeMode: ThemeMode.dark,
      navigatorKey: navigatorKey,
      initialRoute: Routes.splashRoute,
      initialBinding: SplashBinding(),
      getPages: Routes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primary1Color,
        inputDecorationTheme: MyInputTheme().theme(),
        textTheme: Typography().black.apply(fontFamily: 'Poppins'),
        useMaterial3: true
      ),
      enableLog: false,
    );
  }
}
