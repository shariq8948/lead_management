import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/custom_date_picker.dart';
import '../lead_details/lead_detail_page.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_select.dart';
import 'lead_list_controller.dart';

class LeadListPage extends StatelessWidget {
  final LeadListController leadListController = Get.put(LeadListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        title: Text("Lead List"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  // First container with Filter button
                  Expanded(
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 4.0),  // optional margin between buttons
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () { _filterSheet();},
                        child: Text("Filter"),
                      ),
                    ),
                  ),
                  // Second container with Export button
                  Expanded(
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 4.0),  // optional margin between buttons
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Export"),
                            Icon(Icons.arrow_drop_down, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (leadListController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Enable vertical scrolling
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                    child: DataTable(
                      columnSpacing: 30,

                      columns: [
                        DataColumn(label: Text('Emp ID')),
                        DataColumn(label: GestureDetector(child: Text('Lead Name'),onTap:(){
                          Get.to(LeadDetailPage());
                          },
                        ),

                        ),
                        DataColumn(label: Text('Mobile No.')),
                        DataColumn(label: SizedBox.shrink()), // Arrow column
                      ],
                      rows: leadListController.leads.map((lead) {
                        return DataRow(
                          cells: [
                            DataCell(Center(child: Text(lead.empId))),
                            DataCell(Text(
                              lead.leadName,
                              style: TextStyle(color: Colors.blue),
                            )),
                            DataCell(Text(lead.mobileNo)),
                            DataCell(Icon(Icons.chevron_right)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new lead action
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Future _filterSheet() {
    return Get.bottomSheet(
      Container(
        width: Get.size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView( // Added to handle overflow and allow scrolling
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                      () => CustomSelect(
                    label: "Select Product",
                    placeholder: "Please select a product",
                    mainList: leadListController.leadSource
                        .map(
                          (element) => CustomSelectItem(
                        id: element ?? "",
                        value: element ?? "",
                      ),
                    )
                        .toList(),
                    onSelect: (val) async {
                      leadListController.leadSourceController.text = val.value;
                    },
                    textEditCtlr: leadListController.leadSourceController,
                    showLabel: true,
                    onTapField: () {
                      leadListController.leadSourceController.clear();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select a product";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                      () => CustomSelect(
                    label: "Select Product",
                    placeholder: "Please select a product",
                    mainList: leadListController.leadSource
                        .map(
                          (element) => CustomSelectItem(
                        id: element ?? "",
                        value: element ?? "",
                      ),
                    )
                        .toList(),
                    onSelect: (val) async {
                      leadListController.leadSourceController.text = val.value;
                    },
                    textEditCtlr: leadListController.leadSourceController,
                    showLabel: true,
                    onTapField: () {
                      leadListController.leadSourceController.clear();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select a product";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                      () => CustomSelect(
                    label: "Select Product",
                    placeholder: "Please select a product",
                    mainList: leadListController.leadSource
                        .map(
                          (element) => CustomSelectItem(
                        id: element ?? "",
                        value: element ?? "",
                      ),
                    )
                        .toList(),
                    onSelect: (val) async {
                      leadListController.leadSourceController.text = val.value;
                    },
                    textEditCtlr: leadListController.leadSourceController,
                    showLabel: true,
                    onTapField: () {
                      leadListController.leadSourceController.clear();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select a product";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomField(
                  withShadow: true,
                  labelText: "From Date",
                  hintText: "Select start date",
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.datetime,
                  showLabel: true,
                  bgColor: Colors.white,
                  enabled: true,
                  readOnly: true,
                  editingController: leadListController.fromDateCtlr,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  onFieldTap: () {
                    Get.bottomSheet(
                      CustomDatePicker(
                        pastAllow: true,
                        confirmHandler: (date) async {
                          leadListController.fromDateCtlr.text = date ?? "";
                          leadListController.fromDate.value = date ?? "";
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                CustomField(
                  withShadow: true,
                  labelText: "To Date",
                  hintText: "Select end date",
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.datetime,
                  showLabel: true,
                  bgColor: Colors.white,
                  enabled: true,
                  readOnly: true,
                  editingController: leadListController.toDateCtlr,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  onFieldTap: () {
                    Get.bottomSheet(
                      CustomDatePicker(
                        pastAllow: true,
                        confirmHandler: (date) async {
                          leadListController.toDateCtlr.text = date ?? "";
                          leadListController.toDate.value = date ?? "";
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add action for the confirm button
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Apply Filter",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true, // Allows the bottom sheet to expand as needed
    );
  }
}
