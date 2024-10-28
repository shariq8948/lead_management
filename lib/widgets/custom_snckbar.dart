import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class CustomSnack {
  static show({
    required String content,
    SnackType snackType = SnackType.info,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Duration duration = const Duration(
      seconds: 1,
    ),
    BuildContext? ctx,
  }) {
    if (snackType == SnackType.error) {
      duration = const Duration(seconds: 3);
    } else {
      duration = const Duration(seconds: 2);
    }
    final snackBar = SnackBar(
      behavior: behavior,
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        vertical: 0,
      ),
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: getBackgroundColor(snackType),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              getIcon(snackType),
              color: Colors.white,
              size: navbarTitleSize,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontFamily: "JosefinSans",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(ctx ?? Get.context!).showSnackBar(snackBar);
  }

  static Color getBackgroundColor(SnackType type) {
    if (type == SnackType.error) return Colors.red;
    if (type == SnackType.warning) return Colors.yellow.shade300;
    if (type == SnackType.info) return Colors.lightBlue;
    if (type == SnackType.success) return Colors.green;
    return Colors.white;
  }

  static IconData getIcon(SnackType type) {
    if (type == SnackType.error) return Icons.info_rounded;
    if (type == SnackType.warning) return Icons.warning_rounded;
    if (type == SnackType.info) return Icons.info_rounded;
    if (type == SnackType.success) return Icons.check_circle_rounded;
    return Icons.info_rounded;
  }
}

enum SnackType { info, warning, error, success }
