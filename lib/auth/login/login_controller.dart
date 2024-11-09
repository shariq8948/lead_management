import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/api/api_client.dart';
import '../../utils/tags.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var loading = false.obs;
  var showPass = false.obs;

  final ApiClient apiClient = ApiClient();

  Future<void> login() async {
    loading.value = true;

    // Prepare the login request
    final response = await apiClient.loginRequest('/login', {
      'Login': emailController.text.trim(),
      'Password': passwordController.text.trim(),
    });

    // Check the response status
    if (response.success == "1") {
      // If login is successful, store the login status
      final GetStorage box = Get.find<GetStorage>(tag: StorageTags.tag);
      box.write(StorageTags.loggedIn, "yes"); // Store login status

      // Navigate to home screen on success
      Get.offAllNamed('/home');
    } else {
      // Show error message if login fails
      Get.snackbar('Error', response.message ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM);
    }

    loading.value = false;
  }

  Future<void> logout() async {
    final GetStorage box = Get.find<GetStorage>(tag: StorageTags.tag);
    await box.erase(); // Clear all stored data, including login status
    Get.offAllNamed('/login'); // Navigate to login screen
  }
}
