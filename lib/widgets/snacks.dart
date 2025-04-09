import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    icon: const Icon(Icons.check_circle, color: Colors.green),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green.shade50,
    borderRadius: 10,
    margin: const EdgeInsets.all(16),
    colorText: Colors.green.shade800,
    duration: const Duration(seconds: 3),
    forwardAnimationCurve: Curves.easeOutBack,
    barBlur: 10,
  );
}

void showFailureSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    icon: const Icon(Icons.error, color: Colors.red),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade50,
    borderRadius: 10,
    margin: const EdgeInsets.all(16),
    colorText: Colors.red.shade800,
    duration: const Duration(seconds: 3),
    forwardAnimationCurve: Curves.easeOutBack,
    barBlur: 10,
  );
}
