import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/customerList/customer_list_controller.dart';
import 'package:leads/customerList/customer_list_page.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_select.dart';
import 'customer_entry_controller.dart';

class CustomerEntryForm extends StatelessWidget {
  final CustomerEntryController controller = Get.put(CustomerEntryController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final bool isUpdate = args["isUpdate"] ?? false;
    final customer = args["customer"];

    // Populate form if it's an update scenario
    if (isUpdate && customer != null) {
      _populateForm(customer);
    }

    return WillPopScope(
      onWillPop: () async {
        controller.clearFields(); // Clear fields before navigating back
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFE1FFED),
        appBar: AppBar(title: Text("Customer Entry")),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
              ),
            ),
            child: Obx(() {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildFormPage(controller.currentPage.value),
                    ),
                  ),
                  _buildNavigationButtons(isUpdate, customer?.id),
                ],
              );
            }),
          ),
        ),
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
  }

  Widget _buildFormPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return CustomerDetailsPage();
      case 1:
        return CompanyDetailsPage();
      case 2:
        return OtherDetailsPage();
      default:
        return Container();
    }
  }

  Widget _buildNavigationButtons(bool isUpdate, String? id) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (controller.currentPage.value != 0)
            CustomButton(
              onPressed: controller.previousPage,
              buttonType: ButtonTypes.outline,
              width: 120,
              text: "Previous",
            ),
          CustomButton(
            onPressed: () {
              // Only pass id if it's an update
              if (isUpdate && id != null) {
                controller.updateCustomer(id);
              } else {
                controller.saveCustomer();
              }
            },
            buttonType: ButtonTypes.primary,
            width: 120,
            text: isUpdate ? "Update" : "Save",
          ),
          if (controller.currentPage.value != 2)
            CustomButton(
              onPressed: controller.nextPage,
              buttonType: ButtonTypes.outline,
              width: 120,
              text: "Next",
            ),
        ],
      ),
    );
  }
}

class CustomerDetailsPage extends StatelessWidget {
  final CustomerEntryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // key: this.key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomField(
                showLabel: true,
                hintText: 'Enter Mobile Number',
                labelText: 'Mobile Number',
                inputAction: TextInputAction.next,
                inputType: TextInputType.number,
                editingController: controller.mobileController,
              ),
              SizedBox(height: 10),
              CustomSelect(
                mainList: controller.titleItems,
                onSelect: (selectedItem) {
                  controller.titleController.text = selectedItem.value;
                },
                placeholder: 'Select Title',
                label: 'Title',
                textEditCtlr: controller.titleController,
                showLabel: true,
                filledColor: Colors.white,
                labelColor: Colors.black,
                withShadow: true,
              ),
              SizedBox(height: 10),
              CustomField(
                showLabel: true,
                hintText: 'Enter Customer Name',
                labelText: ' Customer Name',
                inputAction: TextInputAction.next,
                inputType: TextInputType.text,
                editingController: controller.customerNameController,
              ),
              SizedBox(height: 10),
              Obx(
                () => CustomSelect(
                  label: "Select State",
                  placeholder: "Please select a State",
                  mainList: controller.stateList
                      .map(
                        (element) => CustomSelectItem(
                          id: element.id ?? "",
                          value: element.state ?? "",
                        ),
                      )
                      .toList(),
                  onSelect: (val) async {
                    controller.stateController.text = val.id;
                    controller.showStateController.text = val.value;
                    await controller.fetchLeadCity();
                  },
                  textEditCtlr: controller.showStateController,
                  showLabel: true,
                  onTapField: () {
                    controller.stateController.clear();
                    controller.showStateController.clear();
                  },
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                // Reactively observing changes
                return CustomSelect(
                  label: "Select city",
                  placeholder: "Please select city",
                  mainList: controller.cityList
                      .map(
                        (element) => CustomSelectItem(
                          id: element.cityID ?? "",
                          value: element.city ?? "",
                        ),
                      )
                      .toList(),
                  onSelect: (val) async {
                    controller.cityController.text = val.id;
                    controller.showCityController.text = val.value;
                    await controller.fetchLeadArea();
                  },
                  textEditCtlr: controller.showCityController,
                  showLabel: true,
                  onTapField: () {
                    controller.cityController.clear();
                    controller.showCityController.clear();
                  },
                );
              }),
              const SizedBox(height: 20),
              Obx(
                () {
                  // Only show the area field if a city is selected
                  return CustomSelect(
                    label: "Select area",
                    placeholder: "Please select area",
                    mainList: controller.areaList
                        .map(
                          (element) => CustomSelectItem(
                            id: element.areaID ?? "", // Use areaID as id
                            value: element.area ?? "", // Use area as value
                          ),
                        )
                        .toList(),
                    onSelect: (val) async {
                      controller.areaController.text = val.id;
                      controller.showAreaController.text = val.value;
                    },
                    textEditCtlr: controller.showAreaController,
                    showLabel: true,
                    onTapField: () {
                      controller.areaController.clear();
                      controller.showAreaController.clear();
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              CustomField(
                showLabel: true,
                hintText: 'Enter address',
                labelText: 'Address',
                inputAction: TextInputAction.next,
                inputType: TextInputType.text,
                editingController: controller.lane1Controller,
              ),
              SizedBox(height: 10),
              CustomSelect(
                mainList: controller.typeItems,
                onSelect: (selectedItem) {
                  controller.customerTypeController.text = selectedItem.value;
                },
                placeholder: 'Customer Type',
                label: 'Customer Type',
                textEditCtlr: controller.customerTypeController,
                showLabel: true,
                filledColor: Colors.white,
                labelColor: Colors.black,
                withShadow: true,
              ),
              SizedBox(height: 10),
              CustomSelect(
                mainList: controller.registrationItems,
                onSelect: (selectedItem) {
                  controller.registrationTypeController.text =
                      selectedItem.value;
                },
                placeholder: 'Registration Type',
                label: 'Registration',
                textEditCtlr: controller.registrationTypeController,
                showLabel: true,
                filledColor: Colors.white,
                labelColor: Colors.black,
                withShadow: true,
              ),
              SizedBox(height: 10),
              CustomSelect(
                mainList: controller.partyItems,
                onSelect: (selectedItem) {
                  controller.partyTypeController.text = selectedItem.value;
                },
                placeholder: 'Party Type',
                label: 'Party',
                textEditCtlr: controller.partyTypeController,
                showLabel: true,
                filledColor: Colors.white,
                labelColor: Colors.black,
                withShadow: true,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyDetailsPage extends StatelessWidget {
  final CustomerEntryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomField(
            showLabel: true,
            hintText: 'Enter Company Name',
            labelText: 'Company Name',
            inputAction: TextInputAction.next,
            inputType: TextInputType.text,
            editingController: controller.companyNameController,
          ),
          SizedBox(height: 10),
          CustomSelect(
            mainList: controller.stateItems,
            onSelect: (selectedItem) {
              controller.stateController.text = selectedItem.value;
            },
            placeholder: 'Select Industry',
            label: 'Industry',
            textEditCtlr: controller.stateController,
            showLabel: true,
            filledColor: Colors.white,
            labelColor: Colors.black,
            withShadow: true,
          ),
          SizedBox(height: 10),
          Text("Address"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomSelect(
                  mainList: controller.stateItems,
                  onSelect: (selectedItem) {
                    controller.stateController.text = selectedItem.value;
                  },
                  placeholder: 'Select State',
                  label: 'State',
                  textEditCtlr: controller.stateController,
                  showLabel: true,
                  filledColor: Colors.white,
                  labelColor: Colors.black,
                  withShadow: true,
                ),
              ),
              SizedBox(width: 10), // Add space between the fields
              Expanded(
                child: CustomSelect(
                  mainList: controller.stateItems,
                  onSelect: (selectedItem) {
                    controller.stateController.text = selectedItem.value;
                  },
                  placeholder: 'Area',
                  label: 'Area',
                  textEditCtlr: controller.stateController,
                  showLabel: true,
                  filledColor: Colors.white,
                  labelColor: Colors.black,
                  withShadow: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomSelect(
                  mainList: controller.stateItems,
                  onSelect: (selectedItem) {
                    controller.stateController.text = selectedItem.value;
                  },
                  placeholder: 'City',
                  label: 'city',
                  textEditCtlr: controller.stateController,
                  showLabel: true,
                  filledColor: Colors.white,
                  labelColor: Colors.black,
                  withShadow: true,
                ),
              ),
              SizedBox(width: 10), // Add space between the fields
              Expanded(
                child: CustomSelect(
                  mainList: controller.stateItems,
                  onSelect: (selectedItem) {
                    controller.stateController.text = selectedItem.value;
                  },
                  placeholder: 'Pin code',
                  label: 'Pin code',
                  textEditCtlr: controller.stateController,
                  showLabel: true,
                  filledColor: Colors.white,
                  labelColor: Colors.black,
                  withShadow: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomField(
                  showLabel: true,
                  hintText: 'Annual revenue',
                  labelText: ' revenue ',
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  editingController: controller.ledgerIdController,
                ),
              ),
              SizedBox(width: 10), // Add space between the fields
              Expanded(
                child: CustomField(
                  showLabel: true,
                  hintText: 'GSTIN No',
                  labelText: 'GST',
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  editingController: controller.tcsRateController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OtherDetailsPage extends StatelessWidget {
  final CustomerEntryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomField(
            hintText: 'Lead Source',
            labelText: 'Enter Lead Source',
            inputAction: TextInputAction.next,
            inputType: TextInputType.text,
            editingController: controller.leadSourceController,
          ),
          SizedBox(height: 10),
          CustomField(
            editingController: controller.phoneController,
            hintText: 'Phone Number',
            labelText: 'Phone',
            inputAction: TextInputAction.next, inputType: TextInputType.text,
            // Add other fields as necessary
          ),
          SizedBox(height: 10),
          CustomField(
            editingController: controller.tcsRateController,
            hintText: 'TCS Rate',
            labelText: 'TCS',
            inputAction: TextInputAction.next, inputType: TextInputType.number,
            // Add other fields as necessary
          ),
          SizedBox(height: 10),
          CustomField(
            editingController: controller.freightController,
            hintText: 'Freight Percents',
            labelText: 'Freight %',
            inputAction: TextInputAction.next, inputType: TextInputType.text,
            // Add other fields as necessary
          ),
          SizedBox(height: 10),
          CustomField(
            editingController: controller.panController,
            hintText: 'Pan Number',
            labelText: 'Pan',
            inputAction: TextInputAction.next, inputType: TextInputType.text,
            // Add other fields as necessary
          ),
          SizedBox(height: 10),
          CustomField(
            editingController: controller.webSiteController,
            hintText: 'Company Website',
            labelText: 'Web Site',
            inputAction: TextInputAction.next, inputType: TextInputType.text,
            // Add other fields as necessary
          ),
        ],
      ),
    );
  }
}
