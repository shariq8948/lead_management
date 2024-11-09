import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_select.dart';
import 'customer_entry_controller.dart';

class CustomerEntryForm extends StatelessWidget {
  final CustomerEntryController controller = Get.put(CustomerEntryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Customer Entry"),

      ),
      body: Container(
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
              _buildNavigationButtons(),
            ],
          );
        }),
      ),
    );
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

  Widget _buildNavigationButtons() {
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
            onPressed: controller.saveData,
            buttonType: ButtonTypes.primary,
            width: 120,
            text: "Save",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSelect(
              mainList: controller.titleItems,
              onSelect: (selectedItem) {
                controller.titleController.text = selectedItem.value;
              },
              placeholder: 'Select Title',
              label: 'Prospect',
              textEditCtlr: controller.titleController,
              showLabel: true,
              filledColor: Colors.white,
              labelColor: Colors.black,
              withShadow: true,
            ),
            SizedBox(height: 10),
            // CustomField(
            //   showLabel: true,
            //   bgColor: Colors.tealAccent.withOpacity(.1),
            //   hintText: 'Enter Customer Id',
            //   labelText: ' Customer Id',
            //   inputAction: TextInputAction.next,
            //   inputType: TextInputType.text,
            //   editingController: controller.customerIdController,
            // ),
            // SizedBox(height: 10),
            CustomField(
              showLabel: true,
              hintText: 'Enter Customer Name',
              labelText: ' Customer Name',
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              editingController: controller.customerNameController,
            ),
            SizedBox(height: 10),
            CustomField(
              showLabel: true,
              hintText: 'Enter Mobile Number',
              labelText: 'Mobile Number',
              inputAction: TextInputAction.next,
              inputType: TextInputType.number,
              editingController: controller.mobileController,
            ),
            SizedBox(height: 10),
            CustomField(
              showLabel: true,
              hintText: ' Enter Email',
              labelText: 'Email',
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              editingController: controller.emailController,
            ),
            SizedBox(height: 10),

            CustomField(
              showLabel: true,
              hintText: 'Enter Ledger Id',
              labelText: 'Ledger Id',
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              editingController: controller.ledgerIdController,
            ),
            SizedBox(height: 10),
            CustomSelect(
              mainList: controller.stateItems,
              onSelect: (selectedItem) {
                controller.stateController.text = selectedItem.value;
              },
              placeholder: 'Customer Type',
              label: 'Type',
              textEditCtlr: controller.stateController,
              showLabel: true,
              filledColor: Colors.white,
              labelColor: Colors.black,
              withShadow: true,
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            CustomSelect(
              mainList: controller.stateItems,
              onSelect: (selectedItem) {
                controller.stateController.text = selectedItem.value;
              },
              placeholder: 'Registration Type',
              label: 'Registration',
              textEditCtlr: controller.stateController,
              showLabel: true,
              filledColor: Colors.white,
              labelColor: Colors.black,
              withShadow: true,
            ),
            SizedBox(height: 10),
            CustomSelect(
              mainList: controller.stateItems,
              onSelect: (selectedItem) {
                controller.stateController.text = selectedItem.value;
              },
              placeholder: 'Party Type',
              label: 'Party',
              textEditCtlr: controller.stateController,
              showLabel: true,
              filledColor: Colors.white,
              labelColor: Colors.black,
              withShadow: true,
            ),

            SizedBox(height: 10),
          ],
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
                child:
                CustomSelect(
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
                child:
                CustomSelect(
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
                child:
                CustomSelect(
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
                child:
                CustomSelect(
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
