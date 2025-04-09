import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_select.dart';

import '../../Masters/geographical/states/stateController.dart';

class CustomFormDialsogs {
  static Future<void> showAddCityDialog({
    required Function(String cityName, String stateId) onSave,
    required stateController stateController,
    required TextEditingController stateTextController,
    required TextEditingController stateIdController,
  }) {
    final cityController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.location_city, color: Colors.blue),
            SizedBox(width: 8),
            Text('Add New City'),
          ],
        ),
        content: Container(
          width: Get.width * 0.9,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => CustomSelect(
                      label: "Select State",
                      placeholder: "Please select a State",
                      mainList: stateController.states
                          .map(
                            (element) => CustomSelectItem(
                              id: element.id ?? "",
                              value: element.state ?? "",
                            ),
                          )
                          .toList(),
                      onSelect: (val) {
                        stateIdController.text = val.id;
                        stateTextController.text = val.value;
                      },
                      textEditCtlr: stateTextController,
                      showLabel: true,
                      onTapField: () {
                        stateIdController.clear();
                        stateTextController.clear();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomField(
                    hintText: "Enter City",
                    labelText: "City",
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    editingController: cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          stateIdController.text.isNotEmpty) {
                        onSave(cityController.text, stateIdController.text);
                        Get.back();
                      } else if (stateIdController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please select a state',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    buttonType: ButtonTypes.primary,
                    width: Get.width * 0.8,
                    text: "Save",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Future<void> showAddStateDialog({
    required Function(String stateName) onSave,
  }) {
    final stateController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue),
            SizedBox(width: 8),
            Text('Add New State'),
          ],
        ),
        content: Container(
          width: Get.width * 0.9,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomField(
                  hintText: "Enter State Name",
                  labelText: "State",
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.text,
                  editingController: stateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter state name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onSave(stateController.text);
                      Get.back();
                    }
                  },
                  buttonType: ButtonTypes.primary,
                  width: Get.width * 0.8,
                  text: "Save",
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
