import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/expenseEntry/expense_entry_controller.dart';
import 'package:leads/widgets/custom_field.dart';

import '../widgets/custom_date_picker.dart';
import '../widgets/custom_select.dart';

class ExpenseEntryPage extends StatelessWidget {
  ExpenseEntryPage({super.key});
  final ExpenseEntryController controller = Get.put(ExpenseEntryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Entry"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE1FFED), // Start color
              Color(0xFFE6E6E6), // End color
            ],
          ),
        ),
        child: _buildEntryForm(context),
      ),
    );
  }

  Widget _buildEntryForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        child: ListView(
          children: [
            _buildExpandableSection
              (
              context,
              title: "General Details",
              fields: [
                CustomField(
                  labelText: "Date",
                  hintText: "Please select date",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  readOnly: true,
                  showLabel: true,
                  enabled: true,
                  editingController: controller.dateEdtCtlr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please select a date";
                    }
                    return null;
                  },
                  onFieldTap: () {
                    Get.bottomSheet(
                      CustomDatePicker(
                        confirmHandler: (date) {
                          controller.dateEdtCtlr.text = date.toString();
                        },
                      ),
                    );
                  },
                ),
                CustomSelect(
                  label: "State",
                  placeholder: "Please select a State",
                  mainList: [
                    CustomSelectItem(id: "", value: "Select State"),
                    ...controller.stateList.map(
                          (element) => CustomSelectItem(
                        id: element.id ?? "",
                        value: element.name?.replaceAll(" ", '') ?? "",
                      ),
                    ),
                  ],
                  onSelect: (val) async {
                    FocusScope.of(context).unfocus();
                    if (val.id == "") {
                      controller.stateController.clear();
                      controller.assignedState.value = null;
                    } else {
                      controller.stateController.text = val.value;
                      controller.assignedState.value = controller.stateList.firstWhereOrNull(
                            (element) => element.id == val.id,
                      );
                    }
                  },
                  textEditCtlr: controller.stateController,
                  showLabel: true,
                  onTapField: () {
                    controller.stateController.clear();
                  },
                  onTapOutsideField: (pointerDownEvent) {
                    if (controller.assignedState.value != null) {
                      controller.stateController.text =
                          controller.assignedState.value?.name?.replaceAll(" ", "") ?? "";
                    }
                  },
                  labelColor: Colors.black54,
                  filledColor: Colors.white,
                ),

                Obx(
                      () => CustomSelect(
                    label: "City",
                    placeholder: "Please select a City",
                    mainList: [
                      CustomSelectItem(
                        id: "",
                        value: "Select City",
                      ),
                      ...controller.cityList.map(
                            (element) => CustomSelectItem(
                          id: element.id ?? "",
                          value: element.name?.replaceAll(" ", '') ?? "",
                        ),
                      ),
                    ],
                    onSelect: (val) async {
                      FocusScope.of(context).unfocus();
                      if (val.id == "") {
                        controller.cityController.clear();
                        controller.assignedCity.value = null;
                      } else {
                        controller.cityController.text = val.value;
                        controller.assignedCity.value = controller.cityList.firstWhereOrNull(
                              (element) => element.id == val.id,
                        );
                        print("Selected City: ${controller.cityController.text}");
                      }
                    },
                    textEditCtlr: controller.cityController,
                    showLabel: true,
                    onTapField: () {
                      controller.cityController.clear();
                    },
                    onTapOutsideField: (pointerDownEvent) {
                      if (controller.assignedCity.value != null) {
                        controller.cityController.text =
                            controller.assignedCity.value?.name?.replaceAll(" ", "") ?? "";
                      }
                    },
                    labelColor: Colors.black54,
                    filledColor: Colors.white,
                  ),
                ),

                Obx(
                      () => CustomSelect(
                    label: "Area",
                    placeholder: "Please select an Area",
                    mainList: [
                      CustomSelectItem(
                        id: "",
                        value: "Select Area",
                      ),
                      ...controller.areaList.map(
                            (element) => CustomSelectItem(
                          id: element.id ?? "",
                          value: element.name?.replaceAll(" ", '') ?? "",
                        ),
                      ),
                    ],
                    onSelect: (val) async {
                      FocusScope.of(context).unfocus();
                      if (val.id == "") {
                        controller.areaController.clear();
                        controller.assignedArea.value = null;
                      } else {
                        controller.areaController.text = val.value;
                        controller.assignedArea.value = controller.areaList.firstWhereOrNull(
                              (element) => element.id == val.id,
                        );
                        print("Selected Area: ${controller.areaController.text}");
                      }
                    },
                    textEditCtlr: controller.areaController,
                    showLabel: true,
                    onTapField: () {
                      controller.areaController.clear();
                    },
                    onTapOutsideField: (pointerDownEvent) {
                      if (controller.assignedArea.value != null) {
                        controller.areaController.text =
                            controller.assignedArea.value?.name?.replaceAll(" ", "") ?? "";
                      }
                    },
                    labelColor: Colors.black54,
                    filledColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // Add more fields as needed
              ], controller: controller,
            ),
            Divider(thickness: 2,indent: 10,endIndent: 1,color: Colors.blueAccent,),
            _buildExpandableSection(
              context,
              title: "Local Expense",
              fields: [
                Column(
                  children: [
                    // Row for "From" and "To" fields
                    Row(
                      children: [
                        Text("From"),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomField(
                            hintText: "From",
                            labelText: "From",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.text,
                            editingController: controller.fromController,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("To"),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomField(
                            hintText: "To",
                            labelText: "To",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.text,
                            editingController: controller.toController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Row for "Travelling" field
                    Row(
                      children: [
                        SizedBox(
                          width: 100, // Fixed width for alignment
                          child: Text("Travelling"),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomField(
                            hintText: "Only Numeric Values are allowed",
                            labelText: "Travelling",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.number,
                            showLabel: false,
                            editingController: controller.travelController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Row for "Travelling KM" field
                    Row(
                      children: [
                        SizedBox(
                          width: 100, // Fixed width for alignment
                          child: Text("Travelling KM"),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomField(
                            hintText: "Only Numeric Values are allowed",
                            labelText: "Travelling KM",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.number,
                            showLabel: false,
                            editingController: controller.travelKmController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 100, // Fixed width for alignment
                          child: Text("Expense Type"),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child:
                          CustomSelect(
                            showLabel:false,
                            label: "",
                            placeholder: "Please select a Expense type",
                            mainList: [
                              CustomSelectItem(id: "", value: "Select Expense"),
                              ...controller.expenseList.map(
                                    (element) => CustomSelectItem(
                                  id: element.id ?? "",
                                  value: element.name?.replaceAll(" ", '') ?? "",
                                ),
                              ),
                            ],
                            onSelect: (val) async {
                              FocusScope.of(context).unfocus();
                              if (val.id == "") {
                                controller.expenseTypeController.clear();
                                controller.expense.value = null;
                              } else {
                                controller.expenseTypeController.text = val.value;
                                controller.expense.value = controller.expenseList.firstWhereOrNull(
                                      (element) => element.id == val.id,
                                );
                              }
                            },
                            textEditCtlr: controller.expenseTypeController,
                            onTapField: () {
                              controller.expenseTypeController.clear();
                            },
                            onTapOutsideField: (pointerDownEvent) {
                              if (controller.expense.value != null) {
                                controller.expenseTypeController.text =
                                    controller.expense.value?.name?.replaceAll(" ", "") ?? "";
                              }
                            },
                            labelColor: Colors.black54,
                            filledColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Additional fields as needed
                  ],
                ),
              ], controller: controller,
            ),
        Divider(thickness: 2,indent: 10,endIndent: 10,),

            _buildExpandableSection
              (
              context,
              title: "Outside Expense",
              fields: [
                
                CustomField(hintText: "Expanse Name",
                    labelText: "labelText",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 100, // Fixed width for alignment
                      child: Text("Travelling"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomField(
                        hintText: "Only Numeric Values are allowed",
                        labelText: "Travelling",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        showLabel: false,
                        editingController: controller.travelController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Row for "Travelling KM" field
                Row(
                  children: [
                    SizedBox(
                      width: 100, // Fixed width for alignment
                      child: Text("Food"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomField(
                        hintText: "Only Numeric Values are allowed",
                        labelText: "Travelling KM",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        showLabel: false,
                        editingController: controller.travelKmController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Add more fields as needed
              ], controller: controller,
            ),
            Divider(thickness: 2,indent: 10,endIndent: 10,),
            _buildExpandableSection
              (
              context,
              title: "Other Expense",
              fields: [

                CustomField(hintText: "Expanse Name",
                    labelText: "labelText",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 100, // Fixed width for alignment
                      child: Text("Travelling"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomField(
                        hintText: "Only Numeric Values are allowed",
                        labelText: "Travelling",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        showLabel: false,
                        editingController: controller.travelController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Row for "Travelling KM" field
                Row(
                  children: [
                    SizedBox(
                      width: 100, // Fixed width for alignment
                      child: Text("Food"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomField(
                        hintText: "Only Numeric Values are allowed",
                        labelText: "Travelling KM",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        showLabel: false,
                        editingController: controller.travelKmController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Add more fields as needed
              ], controller: controller,
            ),
            Divider(thickness: 2,indent: 10,endIndent: 10,),
            _buildExpandableSection
              (
              context,
              title: "Remarks And Attachments ",
              fields: [

                CustomField(hintText: "Expanse Name",
                    labelText: "labelText",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 100, // Fixed width for alignment
                      child: Text("Total Expanse"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomField(
                        hintText: "Only Numeric Values are allowed",
                        labelText: "Total",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        showLabel: false,
                        editingController: controller.travelController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Row for "Travelling KM" field
                Row(
                  children: [
                    SizedBox(
                      width: 100, // Fixed width for alignment
                      child: Text("Remark"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomField(
                        hintText: "Remark",
                        labelText: "",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        showLabel: false,
                        editingController: controller.travelKmController,
                        minLines: 5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Handle file attachment logic here
                        print("Attach file pressed");
                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.blue,
                      ),
                      label: Text(
                        "Attach File",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                // Add more fields as needed
              ], controller: controller,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission here, you can call a method or controller logic
                  // For example, controller.submitExpenseEntry();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Expense Submitted')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for the button
                  minimumSize: Size(double.infinity, 50), // Full width with height 50
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          SizedBox(height: 10),

            // You can continue expanding with more sections like 'Payment Type', 'Category', etc.
          ],
        ),
      ),
    );
  }
  Widget _buildExpandableSection(
      BuildContext context, {
        required String title,
        required List<Widget> fields,
        required ExpenseEntryController controller,
      }) {
    return Obx(
          () => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                    children: [
            GestureDetector(
              onTap: () => controller.toggleExpansion(title),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    controller.isExpanded(title) ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: controller.isExpanded(title) ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Visibility(
                  visible: controller.isExpanded(title),  // Keeps the content visible for animation
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: fields
                          .map((field) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: field,
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
                    ],
                  ),
          ),
    );
  }
}
