import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final RxBool isEditing = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);

  final RxMap<String, String> profileData = {
    'name': 'Mohd Shariq',
    'email': 'Shariq@gmail.com',
    'phone': '+918948731278',
    'location': 'Mumbai,Maharashtra',
    'bio': 'Software Engineer | Flutter & Dart Expert | Innovation Driven',
    'skills': 'Flutter'
  }.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;

    if (isEditing.value) {
      nameController.text = profileData['name'] ?? '';
      emailController.text = profileData['email'] ?? '';
      phoneController.text = profileData['phone'] ?? '';
      locationController.text = profileData['location'] ?? '';
      bioController.text = profileData['bio'] ?? '';
      skillsController.text = profileData['skills'] ?? '';
    }
  }

  void saveProfile() {
    profileData['name'] = nameController.text;
    profileData['email'] = emailController.text;
    profileData['phone'] = phoneController.text;
    profileData['location'] = locationController.text;
    profileData['bio'] = bioController.text;
    profileData['skills'] = skillsController.text;
    isEditing.value = false;
  }
}
