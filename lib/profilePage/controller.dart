import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:leads/utils/tags.dart';
import 'package:leads/widgets/custom_snckbar.dart';

class ProfileController extends GetxController {
  final Rx<File?> profileImage = Rx<File?>(null);
  final box = GetStorage();
  final apiclient = ApiClient();
  final RxBool isLoading = true.obs;
  final RxBool isUploadingImage = false.obs;

  // Update profile data to match API response structure
  final Rx<Map<String, dynamic>> profileData = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    loadProfile();
    super.onInit();
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      uploadProfileImage();
    }
  }

  void loadProfile() async {
    isLoading.value = true;
    try {
      var response = await apiclient.getR(
          "${ApiEndpoints.login}/${box.read(StorageTags.userId)}",
          includeDefaultParams: false);
      print(response);
      if (response != null && response is List && response.isNotEmpty) {
        // Get the first item from the response list
        profileData.value = Map<String, dynamic>.from(response[0]);
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfileImage() async {
    if (profileImage.value == null) return;

    isUploadingImage.value = true;
    try {
      // Convert image to base64
      List<int> imageBytes = await profileImage.value!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Prepare data for API

      // Make API call to update profile image
      var response =
          await apiclient.putg("${ApiEndpoints.updateProfileImage}", data: {
        'id': box.read(StorageTags.userId),
        // 'ImageBase64': base64Image,
        'ImageBase64': "data:image/jpeg;base64,${base64Image}",
      });
      print("this is resonse ${response}");
      if (response != null && response[0]["success"] == "Success") {
        // Update local profile data with new image path if returned by API
        // if (response[0]['userlogo'] != null) {
        //   profileData.update((val) {
        //     if (val != null) {
        //       val['userlogo'] = response['userlogo'];
        //     }
        //   });
        // }

        CustomSnack.show(
            content: "${response[0]["message"]}", snackType: SnackType.success);
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      Get.snackbar('Error', 'Failed to upload profile image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white);
    } finally {
      isUploadingImage.value = false;
    }
  }

  String getUserName() {
    // Try to construct name from firstName and lastName
    String name = '';

    if (profileData.value['firstName'] != null &&
        profileData.value['firstName'].toString().isNotEmpty) {
      name += profileData.value['firstName'];
    }

    if (profileData.value['lastName'] != null &&
        profileData.value['lastName'].toString().isNotEmpty) {
      if (name.isNotEmpty) name += ' ';
      name += profileData.value['lastName'];
    }

    // If name is still empty, use username
    if (name.isEmpty && profileData.value['username'] != null) {
      name = profileData.value['username'];
    }

    return name;
  }

  String getUserEmail() {
    return profileData.value['email'] ?? '';
  }

  String getCompanyName() {
    return profileData.value['companyname'] ?? '';
  }

  String getUserMobile() {
    return profileData.value['mobile'] ?? '';
  }

  String getIndustry() {
    return profileData.value['industry'] ?? '';
  }

  String getJoiningDate() {
    String date = '';
    if (profileData.value['joiningMonth'] != null)
      date += profileData.value['joiningMonth'];
    if (profileData.value['joiningYear'] != null) {
      if (date.isNotEmpty) date += ' ';
      date += profileData.value['joiningYear'];
    }
    return date;
  }

  String getSubscriptionInfo() {
    return 'Plan: ${profileData.value['planname'] ?? 'N/A'}\n'
        'Valid: ${profileData.value['subscriptionstartdate'] ?? ''} - ${profileData.value['subscriptionenddate'] ?? ''}';
  }
}
