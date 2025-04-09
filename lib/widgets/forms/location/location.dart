// location_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:leads/widgets/customActionbutton.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_select.dart';

import 'controller.dart';

class CustomFormDialogs {
  // static final _locationController = Get.find<LocationsController>();
  static final LocationsController _locationController =
      Get.put(LocationsController());

  static Future<void> showAddStateDialog() {
    final stateController = TextEditingController();
    final stateIdController = TextEditingController();
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
                SizedBox(
                  height: 10,
                ),
                CustomField(
                  hintText: "Enter State Code",
                  labelText: "State",
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.number,
                  editingController: stateIdController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter state name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomActionButton(
                    type: CustomButtonType.save,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _locationController.saveState(
                            stateController.text, stateIdController.text);
                        Get.back(); // Close the dialog after saving
                      }
                    },
                    label: "Save")
                // CustomButton(
                //   onPressed: () {
                //     if (formKey.currentState!.validate()) {
                //       _locationController.saveState(stateController.text);
                //       Get.back(); // Close the dialog after saving
                //     }
                //   },
                //   buttonType: ButtonTypes.primary,
                //   width: Get.width * 0.8,
                //   text: "Save",
                // ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    ).then((_) {
      _locationController.clearForm();
      // Perform action when the dialog is closed
      print("Dialog closed, perform action here");
    });
  }

  static Future<void> showAddCityDialog() {
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
                      mainList: _locationController.states
                          .map(
                            (element) => CustomSelectItem(
                              id: element.id ?? "",
                              value: element.state ?? "",
                            ),
                          )
                          .toList(),
                      onSelect: (val) {
                        _locationController.stateIdController.text = val.id;
                        _locationController.stateTextController.text =
                            val.value;
                      },
                      textEditCtlr: _locationController.stateTextController,
                      showLabel: true,
                      onTapField: () {
                        _locationController.stateIdController.clear();
                        _locationController.stateTextController.clear();
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
                  CustomActionButton(
                      type: CustomButtonType.save,
                      onPressed: () {
                        if (formKey.currentState!.validate() &&
                            _locationController
                                .stateIdController.text.isNotEmpty) {
                          _locationController.saveCity(
                            cityController.text,
                            _locationController.stateIdController.text,
                          );
                        } else if (_locationController
                            .stateIdController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please select a state',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      label: "save")
                  // CustomButton(
                  //   onPressed: () {
                  //     if (formKey.currentState!.validate() &&
                  //         _locationController
                  //             .stateIdController.text.isNotEmpty) {
                  //       _locationController.saveCity(
                  //         cityController.text,
                  //         _locationController.stateIdController.text,
                  //       );
                  //     } else if (_locationController
                  //         .stateIdController.text.isEmpty) {
                  //       Get.snackbar(
                  //         'Error',
                  //         'Please select a state',
                  //         snackPosition: SnackPosition.BOTTOM,
                  //         backgroundColor: Colors.red,
                  //         colorText: Colors.white,
                  //       );
                  //     }
                  //   },
                  //   buttonType: ButtonTypes.primary,
                  //   width: Get.width * 0.8,
                  //   text: "Save",
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Future<void> showAddAreaDialog() {
    final areaController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.map, color: Colors.blue),
            SizedBox(width: 8),
            Text('Add New Area'),
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
                      mainList: _locationController.states
                          .map(
                            (element) => CustomSelectItem(
                              id: element.id ?? "",
                              value: element.state ?? "",
                            ),
                          )
                          .toList(),
                      onSelect: (val) async {
                        _locationController.stateIdController.text = val.id;
                        _locationController.stateTextController.text =
                            val.value;
                        await _locationController.fetchCities(val.id);
                      },
                      textEditCtlr: _locationController.stateTextController,
                      showLabel: true,
                      onTapField: () {
                        _locationController.clearStateData();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => CustomSelect(
                      label: "Select City",
                      placeholder: "Please select a City",
                      mainList: _locationController.cities
                          .map(
                            (element) => CustomSelectItem(
                              id: element.cityID ?? "",
                              value: element.city ?? "",
                            ),
                          )
                          .toList(),
                      onSelect: (val) {
                        _locationController.cityIdController.text = val.id;
                        _locationController.cityTextController.text = val.value;
                      },
                      textEditCtlr: _locationController.cityTextController,
                      showLabel: true,
                      onTapField: () {
                        _locationController.clearCityData();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomField(
                    hintText: "Enter Area Name",
                    labelText: "Area",
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    editingController: areaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter area name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomActionButton(
                      type: CustomButtonType.save,
                      onPressed: () {
                        if (formKey.currentState!.validate() &&
                            _locationController
                                .stateIdController.text.isNotEmpty &&
                            _locationController
                                .cityIdController.text.isNotEmpty) {
                          _locationController.saveArea(
                              areaController.text,
                              _locationController.cityIdController.text,
                              _locationController.stateIdController.text);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please select both state and city',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      label: "Save")
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
