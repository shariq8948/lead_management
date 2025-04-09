import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/Customer_entry/customer_entry_controller.dart';
import 'package:leads/utils/constants.dart';
import 'package:leads/widgets/customActionbutton.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_select.dart';
import '../../widgets/forms/location/location.dart';

class CustomerEntryForm extends GetView<CustomerEntryController> {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final bool isUpdate = args["isUpdate"] ?? false;
    final customer = args["customer"];

    if (isUpdate && customer != null) {
      _populateForm(customer);
    }

    return WillPopScope(
      onWillPop: () async {
        controller.clearFields();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Color(0xFFF5F7FA),
          appBar: _buildAppBar(isUpdate),
          body: Obx(() => Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildHeader(isUpdate),
                          _buildForm(),
                          _buildSaveOrEditButton(isUpdate, customer?.id),
                        ],
                      ),
                    ),
                  ),
                  if (controller.isLoading.value)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primary3Color),
                        ),
                      ),
                    ),
                ],
              )),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isUpdate) {
    return AppBar(
      elevation: 0,
      backgroundColor: primary3Color,
      title: Text(
        isUpdate ? "Update Customer" : "New Customer",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          controller.clearFields();
          Get.back();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.white),
          onPressed: () => _showHelp(),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isUpdate) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary3Color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            isUpdate ? Icons.edit_document : Icons.person_add,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 8),
          Text(
            isUpdate ? "Update Customer Details" : "New Customer Registration",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            "Please fill in all required fields (*)",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _populateForm(dynamic customer) {
    controller.customerNameController.text = customer.name ?? '';
    controller.mobileController.text = customer.mobile ?? '';
    controller.emailController.text = customer.email ?? '';
    controller.titleController.text = customer.title ?? '';
    controller.stateController.text = customer.stateId ?? '';
    controller.showStateController.text = customer.state ?? '';
    controller.showCityController.text = customer.city ?? '';
    controller.cityController.text = customer.cityId ?? '';
    controller.areaController.text = customer.areaId ?? '';
    controller.showAreaController.text = customer.area ?? '';
    controller.lane1Controller.text = customer.address1 ?? '';
    controller.customerTypeController.text = customer.customerType ?? '';
    controller.registrationTypeController.text =
        customer.registrationType ?? '';
    controller.partyTypeController.text = customer.partyType ?? '';

    // Trigger city and area fetching if state and city are populated
    if (customer.stateId != null && customer.stateId.isNotEmpty) {
      controller.fetchLeadCity();
    }
    if (customer.cityId != null && customer.cityId.isNotEmpty) {
      controller.fetchLeadArea();
    }
  }

  Widget _buildForm() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "Basic Information",
              Icons.person_outline,
              [
                _buildField(
                  controller: controller.mobileController,
                  label: "Mobile Number *",
                  hint: "Enter 10-digit mobile number",
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter mobile number";
                    }
                    if (value.length != 10) {
                      return "Mobile number must be 10 digits";
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Please enter only numbers";
                    }
                    return null;
                  },
                ),
                _buildField(
                  controller: controller.emailController,
                  label: "Email Address",
                  hint: "Enter email address",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!GetUtils.isEmail(value)) {
                        return "Please enter a valid email address";
                      }
                    }
                    return null;
                  },
                ),
                _buildCustomSelect(
                  label: "Title *",
                  hint: "Select title",
                  icon: Icons.person,
                  items: controller.titleItems,
                  controller: controller.titleController,
                  showController: controller.titleController,
                  onSelect: (item) {
                    controller.titleController.text = item.value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a title";
                    }
                    return null;
                  },
                ),
                _buildField(
                  controller: controller.customerNameController,
                  label: "Customer Name *",
                  hint: "Enter full name",
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter customer name";
                    }
                    if (value.length < 2) {
                      return "Name must be at least 2 characters";
                    }
                    return null;
                  },
                ),
              ],
            ),
            _buildSection(
              "Location Details",
              Icons.location_on_outlined,
              [
                Obx(() => _buildCustomSelect(
                      label: "State *",
                      hint: "Select state",
                      icon: Icons.map,
                      items: controller.stateList
                          .map((element) => CustomSelectItem(
                                id: element.id ?? "",
                                value: element.state ?? "",
                              ))
                          .toList(),
                      controller: controller.stateController,
                      showController: controller.showStateController,
                      isPlus: true,
                      onplus: () {
                        CustomFormDialogs.showAddStateDialog().then((_) {
                          controller.fetchState();
                        });
                      },
                      onSelect: (val) async {
                        controller.stateController.text = val.id;
                        controller.showStateController.text = val.value;
                        controller.cityController.clear();
                        controller.showCityController.clear();
                        controller.areaController.clear();
                        controller.showAreaController.clear();
                        await controller.fetchLeadCity();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a state";
                        }
                        return null;
                      },
                    )),
                Obx(() => _buildCustomSelect(
                      label: "City *",
                      hint: "Select city",
                      isPlus: true,
                      onplus: () {
                        CustomFormDialogs.showAddCityDialog().then((_) {
                          controller.fetchLeadCity();
                        });
                      },
                      icon: Icons.location_city,
                      items: controller.cityList
                          .map((element) => CustomSelectItem(
                                id: element.cityID ?? "",
                                value: element.city ?? "",
                              ))
                          .toList(),
                      controller: controller.cityController,
                      showController: controller.showCityController,
                      onSelect: (val) async {
                        controller.cityController.text = val.id;
                        controller.showCityController.text = val.value;
                        controller.areaController.clear();
                        controller.showAreaController.clear();
                        await controller.fetchLeadArea();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a city";
                        }
                        return null;
                      },
                    )),
                Obx(() => _buildCustomSelect(
                      label: "Area *",
                      hint: "Select area",
                      icon: Icons.location_on,
                      isPlus: true,
                      onplus: () {
                        CustomFormDialogs.showAddAreaDialog().then((_) {
                          controller.fetchLeadArea();
                        });
                      },
                      items: controller.areaList
                          .map((element) => CustomSelectItem(
                                id: element.areaID ?? "",
                                value: element.area ?? "",
                              ))
                          .toList(),
                      controller: controller.areaController,
                      showController: controller.showAreaController,
                      onSelect: (val) async {
                        controller.areaController.text = val.id;
                        controller.showAreaController.text = val.value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select an area";
                        }
                        return null;
                      },
                    )),
                _buildField(
                  controller: controller.lane1Controller,
                  label: "Address *",
                  hint: "Enter complete address",
                  icon: Icons.home,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an address";
                    }
                    if (value.length < 10) {
                      return "Please enter a complete address";
                    }
                    return null;
                  },
                ),
              ],
            ),
            _buildSection(
              "Customer Details",
              Icons.badge_outlined,
              [
                _buildCustomSelect(
                  label: "Customer Type *",
                  hint: "Select customer type",
                  icon: Icons.category,
                  items: controller.typeItems,
                  controller: controller.customerTypeController,
                  showController: controller.customerTypeController,
                  onSelect: (item) {
                    controller.customerTypeController.text = item.value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a customer type";
                    }
                    return null;
                  },
                ),
                _buildCustomSelect(
                  label: "Registration Type",
                  hint: "Select registration type",
                  icon: Icons.app_registration,
                  items: controller.registrationItems,
                  controller: controller.registrationTypeController,
                  showController: controller.registrationTypeController,
                  onSelect: (item) {
                    controller.registrationTypeController.text = item.value;
                  },
                ),
                _buildCustomSelect(
                  label: "Party Type",
                  hint: "Select party type",
                  icon: Icons.groups,
                  items: controller.partyItems,
                  controller: controller.partyTypeController,
                  showController: controller.partyTypeController,
                  onSelect: (item) {
                    controller.partyTypeController.text = item.value;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary3Color, size: 24),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary3Color,
                ),
              ),
            ],
          ),
          Divider(color: primary3Color, thickness: 1),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: CustomField(
        showLabel: true,
        hintText: hint,
        labelText: label,
        minLines: maxLines ?? 1,
        inputAction: TextInputAction.next,
        inputType: keyboardType ?? TextInputType.text,
        editingController: controller,
        validator: validator,
      ),
    );
  }

  Widget _buildCustomSelect({
    required String label,
    required String hint,
    required IconData icon,
    required List<CustomSelectItem> items,
    required TextEditingController controller,
    required TextEditingController showController,
    required Function(CustomSelectItem) onSelect,
    VoidCallback? onplus,
    VoidCallback? ontap,
    bool? isPlus,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: CustomSelect(
        label: label,
        placeholder: hint,
        mainList: items,
        onSelect: onSelect,
        textEditCtlr: showController,
        showLabel: true,
        showPlusIcon: isPlus ?? false,
        onPlusPressed: () {
          onplus?.call();
        },
        onTapField: () {
          ontap?.call();
        },
        labelColor: primary3Color,
        withShadow: true,
        validator: validator,
      ),
    );
  }

  Widget _buildSaveOrEditButton(bool isUpdate, String? id) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CustomActionButton(
            type: (isUpdate) ? CustomButtonType.edit : CustomButtonType.save,
            onPressed: () {
              if (controller.formKey.currentState!.validate()) {
                _showConfirmationDialog(isUpdate, id);
              }
            },
            label: (isUpdate) ? "Update Customer" : "Save Customer",
          ),
          SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              _showClearFormDialog();
            },
            icon: Icon(
              Icons.clear_all,
              color: Colors.red[400],
            ),
            label: Text(
              "Clear Form",
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(bool isUpdate, String? id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(
              isUpdate ? Icons.edit : Icons.save,
              color: primary3Color,
            ),
            SizedBox(width: 8),
            Text(isUpdate ? "Update Customer" : "Save Customer"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUpdate
                  ? "Are you sure you want to update this customer's information?"
                  : "Are you sure you want to save this customer?",
            ),
            SizedBox(height: 8),
            Text(
              "Please verify all the information before proceeding.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (isUpdate && id != null) {
                controller.updateCustomer(id);
              } else {
                controller.saveCustomer();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary3Color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isUpdate ? "Update" : "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearFormDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.clear_all, color: Colors.red),
            SizedBox(width: 8),
            Text("Clear Form"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you sure you want to clear all fields? This action cannot be undone.",
            ),
            SizedBox(height: 8),
            Text(
              "All unsaved changes will be lost.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.clearFields();
              Get.snackbar(
                'Form Cleared',
                'All fields have been reset',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: EdgeInsets.all(8),
                borderRadius: 10,
                duration: Duration(seconds: 2),
                icon: Icon(Icons.clear_all, color: Colors.white),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Clear",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: primary3Color),
            SizedBox(width: 8),
            Text("Help Guide"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                "Required Fields",
                "Fields marked with * are mandatory and must be filled",
                Icons.star,
              ),
              _buildHelpItem(
                "Mobile Number",
                "Enter a valid 10-digit mobile number without country code",
                Icons.phone_android,
              ),
              _buildHelpItem(
                "Email Address",
                "Optional. If provided, must be a valid email format (e.g., user@example.com)",
                Icons.email,
              ),
              _buildHelpItem(
                "Location Details",
                "Select State first, then City, and finally Area. The options will update accordingly",
                Icons.location_on,
              ),
              _buildHelpItem(
                "Address",
                "Provide a complete address with house/building number, street name, and landmarks",
                Icons.home,
              ),
              _buildHelpItem(
                "Customer Type",
                "Choose between Local, Outstation, or Export based on customer location",
                Icons.category,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary3Color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.check_circle_outline, color: Colors.white),
            label: Text("Got it!", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: primary3Color),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primary3Color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
