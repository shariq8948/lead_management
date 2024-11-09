import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_select.dart';

class CustomerEntryController extends GetxController {
  // Controllers for form fields
  final customerIdController = TextEditingController();
  final customerNameController = TextEditingController();
  final mobileController = TextEditingController();
  final titleController = TextEditingController();
  final displayNameController = TextEditingController();
  final lane1Controller = TextEditingController();
  final lane2Controller = TextEditingController();
  final ledgerIdController = TextEditingController();
  final tcsRateController = TextEditingController();
  final freightController = TextEditingController();
  final stateController = TextEditingController();
  final companyNameController = TextEditingController();
  final leadSourceController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final panController = TextEditingController();
  final webSiteController = TextEditingController();


  // Titles list for selection
  var titles = ["prospect", "nothing", "Test"];

  // Convert titles to CustomSelectItem list
  List<CustomSelectItem> get titleItems {
    return List<CustomSelectItem>.generate(
      titles.length,
          (index) => CustomSelectItem(id: index.toString(), value: titles[index]),
    );
  }

  // States list for selection
  var states = ["State 1", "State 2", "State 3"]; // Add your states here

  // Convert states to CustomSelectItem list
  List<CustomSelectItem> get stateItems {
    return List<CustomSelectItem>.generate(
      states.length,
          (index) => CustomSelectItem(id: index.toString(), value: states[index]),
    );
  }

  // Current page index
  var currentPage = 0.obs;

  // Form data to retain across pages
  var formData = {}.obs;

  // Function to navigate to the next page
  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
    }
  }

  // Function to navigate to the previous page
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  // Save form data
  void saveData() {
    formData['customerId'] = customerIdController.text;
    formData['customerName'] = customerNameController.text;
    formData['mobile'] = mobileController.text;
    formData['title'] = titleController.text;
    formData['displayName'] = displayNameController.text;
    formData['lane1'] = lane1Controller.text;
    formData['lane2'] = lane2Controller.text;
    formData['ledgerId'] = ledgerIdController.text;
    formData['tcsRate'] = tcsRateController.text;
    formData['freight'] = freightController.text;
    formData['state'] = stateController.text;
    formData['companyName'] = companyNameController.text;
    formData['leadSource'] = leadSourceController.text;
    // Add other fields here as needed

    Get.snackbar("Success", "Data saved successfully");
  }

  // Clear controllers when done
  @override
  void onClose() {
    customerIdController.dispose();
    customerNameController.dispose();
    mobileController.dispose();
    titleController.dispose();
    displayNameController.dispose();
    lane1Controller.dispose();
    lane2Controller.dispose();
    ledgerIdController.dispose();
    tcsRateController.dispose();
    freightController.dispose();
    stateController.dispose();
    companyNameController.dispose();
    leadSourceController.dispose();
    emailController.dispose();
    phoneController.dispose();
    panController.dispose();
    webSiteController.dispose();
    super.onClose();
  }
}
