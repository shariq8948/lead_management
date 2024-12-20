import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class LoadingDialog {
  static Future<void> showLoading() async {
    await Get.dialog(
      AnimatedContainer(
        duration: const Duration(
          milliseconds: 400,
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: primary1Color,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
    );
  }

  static Future<void> hideLoading() async {
    if (Get.overlayContext != null) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
