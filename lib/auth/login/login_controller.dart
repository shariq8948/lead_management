import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/api/api_client.dart';
import '../../data/models/dropdown_list.model.dart';
import '../../data/models/login_response.model.dart';
import '../../google_service/auth_service.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/tags.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/custom_snckbar.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var loading = false.obs;
  var showPass = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  RxList<DomainListModel> domains = <DomainListModel>[].obs;
  Rx<CustomSelectItem?> selectedDomain = (null as CustomSelectItem?).obs;
  final TextEditingController domainController = TextEditingController();

  final ApiClient apiClient = ApiClient();
  final GetStorage box = Get.find<GetStorage>(tag: StorageTags.tag);

  // Future<void> login() async {
  //   try {
  //     if (loginFormKey.currentState!.validate() &&
  //         selectedDomain.value != null) {
  //       loading.value = true;
  //
  //       // Extract user input
  //       String domainText = selectedDomain.value?.id ?? "";
  //       String emailText = emailController.text.trim();
  //       String passwordText = passwordController.text.trim();
  //
  //       print("Selected Domain: $domainText");
  //
  //       // Update the base URL
  //       await apiClient.updateBaseUrl(domainText);
  //       print("Updated Base URL: ${box.read(StorageTags.baseUrl)}");
  //
  //       var loginBody = {
  //         "Login": emailText,
  //         "Password": passwordText,
  //       };
  //
  //       // Perform Login
  //       LoginResponse response = await apiClient.loginRequest(
  //         ApiEndpoints.login,
  //         loginBody,
  //       );
  //
  //       loading.value = false;
  //
  //       if (response.message != null) {
  //         // Save login details to GetStorage
  //         await box.write(
  //             StorageTags.userDetails, jsonEncode(response.toJson()));
  //         await box.write(StorageTags.userId, response.userId);
  //         await box.write(StorageTags.sysComapnyId, response.syscompanyid);
  //         await box.write(StorageTags.sysBranchId, response.sysbranchid);
  //         await box.write(
  //           StorageTags.baseComp,
  //           jsonEncode({
  //             "id": selectedDomain.value?.id,
  //             "value": selectedDomain.value?.value,
  //           }),
  //         );
  //         await box.write(StorageTags.loggedIn, "yes");
  //
  //         // Navigate to main screen
  //         Get.offAllNamed("/main");
  //
  //         CustomSnack.show(
  //           content: "Logged in successfully!",
  //           snackType: SnackType.success,
  //         );
  //       } else {
  //         // Show error
  //         CustomSnack.show(
  //           content: response.message ?? "Login failed.",
  //           snackType: SnackType.error,
  //           behavior: SnackBarBehavior.floating,
  //         );
  //       }
  //     }
  //   } catch (e, stackTrace) {
  //     loading.value = false;
  //     print("Login error: $e");
  //     if (kDebugMode) {
  //       print(stackTrace);
  //     }
  //     CustomSnack.show(
  //       content: "An unexpected error occurred during login.",
  //       snackType: SnackType.error,
  //     );
  //   }
  // }
  Future<void> login() async {
    try {
      if (loginFormKey.currentState!.validate() &&
          selectedDomain.value != null) {
        loading.value = true;

        // Sign in with Google
        final googleUser = await signInWithGoogle();
        if (googleUser == null) {
          CustomSnack.show(
            content: "Google Sign-In failed. Please try again.",
            snackType: SnackType.error,
          );
          loading.value = false;
          return;
        }

        String domainText = selectedDomain.value?.id ?? "";
        String emailText = emailController.text.trim();
        String passwordText = passwordController.text.trim();

        await apiClient.updateBaseUrl(domainText);

        String? fcmToken = await FirebaseMessaging.instance.getToken();
        print("FCM Token test: $fcmToken");

        LocationPermission permission = await Geolocator.requestPermission();

        Position? position;
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          try {
            position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            print(
                "Latitude: ${position.latitude}, Longitude: ${position.longitude}");
          } catch (e) {
            print("Location fetch error: $e");
            CustomSnack.show(
              content:
                  "Could not retrieve location. Please check device settings.",
              snackType: SnackType.warning,
            );
          }
        } else {
          await showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
              title: Text("Location Permission Required"),
              content: Text(
                  "Location access is needed to proceed with login. Please enable permissions in your device settings."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: Text("Open Settings"),
                ),
              ],
            ),
          );

          loading.value = false;
          return;
        }

        var loginBody = {
          "Login": emailText,
          "Password": passwordText,
          // "FCMToken": fcmToken,
          // "Latitude": position?.latitude,
          // "Longitude": position?.longitude
        };

        // API Login request
        LoginResponse response = await apiClient.loginRequest(
          ApiEndpoints.login,
          loginBody,
        );

        loading.value = false;

        if (response.success == "1") {
          await box.write(
              StorageTags.userDetails, jsonEncode(response.toJson()));
          await box.write(StorageTags.userId, response.userId);
          await box.write("pending_logout", false);
          await box.write(StorageTags.email, response.email);
          await box.write(StorageTags.firstName, response.firstName);
          await box.write(StorageTags.lastName, response.lastName);
          await box.write(StorageTags.sysComapnyId, response.syscompanyid);
          await box.write(StorageTags.sysBranchid, response.sysbranchid);
          await box.write(StorageTags.loggedIn, "yes");
          await box.write(StorageTags.password, passwordText);
          await box.write(StorageTags.email, emailText);

          await apiClient.updateBaseUrl(domainText);

          // Navigate to the main screen
          Get.offAllNamed("/main");
        } else {
          CustomSnack.show(
            content: response.message ?? "Login failed.",
            snackType: SnackType.error,
          );
        }
      }
    } catch (e) {
      loading.value = false;
      CustomSnack.show(
        content: "An error occurred: $e",
        snackType: SnackType.error,
      );
    }
  }

  Future<List<DomainListModel>?> fetchDomains(String filter) async {
    try {
      Dio dio = Dio();
      String reqUrl = "https://crm.psmsofttech.com/api/getdomain/crm";
      var query = {'filter': filter};
      var response = await dio.get(
        reqUrl,
        queryParameters: query,
      );

      if (response.statusCode != 200) {
        CustomSnack.show(
          content: "Something went wrong, please try again!",
          snackType: SnackType.error,
          behavior: SnackBarBehavior.floating,
        );
        return null;
      }

      if (response.data is List) {
        return response.data
            .map<DomainListModel>((cate) => DomainListModel.fromJson(cate))
            .toList();
      }
      return [];
    } catch (e) {
      print("Error fetching domains: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await box.erase(); // Clear all stored data
      Get.offAllNamed('/login');
      print("looggedd out"); // Navigate to login screen
    } catch (e) {
      print("Logout error: $e");
      CustomSnack.show(
        content: "Failed to log out. Please try again.",
        snackType: SnackType.error,
      );
    }
  }
}
