import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/splash/splash_controller.dart';

import '../utils/constants.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  // Splash Screen Controller
  final controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Obx(
                () => AnimatedOpacity(
              opacity: controller.animate.value ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Image.asset(
                  "assets/images/MumbaiCRM.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
