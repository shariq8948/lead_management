import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPageController extends GetxController {
  // Expandable sections controller
  final RxList<bool> _expandedSections = <bool>[].obs;

  // Initialize expandable sections
  @override
  void onInit() {
    super.onInit();
    // Initialize with false for each section
    _expandedSections.value = List.generate(5, (index) => false);
  }

  // Toggle section expansion
  void toggleSection(int index) {
    _expandedSections[index] = !_expandedSections[index];
    _expandedSections.refresh();
  }

  // Check if a section is expanded
  bool isSectionExpanded(int index) {
    return _expandedSections[index];
  }

  // Launch external URL
  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch $url',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Send support email
  void sendSupportEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@leadmanagementapp.com',
      queryParameters: {
        'subject': 'App Support Request',
      },
    );
    launchURL(emailLaunchUri.toString());
  }
}
