import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/create_lead/create_lead_page.dart';
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
      appBar: AppBar(
        title: Text("Lead List", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        // color: Colors.grey.shade100,
        child: Column(
          children: [
            // Action buttons - Filter and Export
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5, // Adding shadow for depth
                      ),
                      onPressed: () {
                        _filterSheet();
                      },
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt, size: 18),
                            SizedBox(width: 8),
                            leadListController.filtered.value
                                ? Text("Filtered List")
                                : Text("Filter"),
                          ],
                        );
                      }),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5, // Adding shadow for depth
                      ),
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
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (leadListController.isLoading.value &&
                    leadListController.currentPage.value == 0) {
                  return Center(child: CircularProgressIndicator());
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        !leadListController.isFetchingMore.value &&
                        leadListController.hasMoreLeads.value) {
                      leadListController.fetchLeads(isInitialFetch: false);
                    }
                    return true;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DataTable(
                              columnSpacing: 30,
                              // headingRowHeight: 50,
                              columns: [
                                DataColumn(
                                    label: Text('Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                  label: GestureDetector(
                                    child: Text('Lead Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      Get.to(LeadDetailPage());
                                    },
                                  ),
                                ),
                                DataColumn(
                                    label: Text('Mobile No.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(label: SizedBox.shrink()),
                                // Arrow column
                              ],
                              rows: leadListController.leads.map((lead) {
                                return DataRow(
                                  cells: [
                                    DataCell(Center(
                                        child: Text(leadListController
                                            .formatDate(lead.vdate)))),
                                    DataCell(
                                      Text(lead.leadName,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    DataCell(Text(lead.mobile)),
                                    DataCell(Icon(Icons.chevron_right),
                                        onTap: () {
                                      Get.to(() => LeadDetailPage(),
                                          arguments: lead.leadId);
                                    }),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        if (leadListController.isFetchingMore.value)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (!leadListController.hasMoreLeads.value)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("No more leads to load")),
                          ),
                      ],
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
          Get.to(CreateLeadPage());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
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
          child: SingleChildScrollView(
            // Added to handle overflow and allow scrolling
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
                    label: "Select Lead Source",
                    placeholder: "Please select  Lead Source",
                    mainList: leadListController.leadSource
                        .map(
                          (element) => CustomSelectItem(
                            id: element.id ?? "",
                            // Extract the productId as id
                            value: element.name ??
                                "", // Extract the productName as value
                          ),
                        )
                        .toList(),
                    onSelect: (val) async {
                      leadListController.leadSourceController.text = val.id;
                      leadListController.showLeadSourceController.text =
                          val.value;
                    },
                    textEditCtlr: leadListController.showLeadSourceController,
                    showLabel: true,
                    onTapField: () {
                      leadListController.leadSourceController.clear();
                      leadListController.showLeadSourceController.clear();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => CustomSelect(
                    label: "Select State",
                    placeholder: "Please select a State",
                    mainList: leadListController.stateList
                        .map(
                          (element) => CustomSelectItem(
                            id: element.id ?? "",
                            value: element.state ?? "",
                          ),
                        )
                        .toList(),
                    onSelect: (val) async {
                      leadListController.stateController.text = val.id;
                      leadListController.showStateController.text = val.value;
                      await leadListController.fetchLeadCity();
                    },
                    textEditCtlr: leadListController.showStateController,
                    showLabel: true,
                    onTapField: () {
                      leadListController.stateController.clear();
                      leadListController.showStateController.clear();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (leadListController.stateText.value.isNotEmpty) {
                    // Reactively observing changes
                    return CustomSelect(
                      label: "Select city",
                      placeholder: "Please select city",
                      mainList: leadListController.cityList
                          .map(
                            (element) => CustomSelectItem(
                              id: element.cityID ?? "",
                              value: element.city ?? "",
                            ),
                          )
                          .toList(),
                      onSelect: (val) async {
                        leadListController.cityController.text = val.id;
                        leadListController.showCityController.text = val.value;
                        await leadListController.fetchLeadArea();
                      },
                      textEditCtlr: leadListController.showCityController,
                      showLabel: true,
                      onTapField: () {
                        leadListController.cityController.clear();
                        leadListController.showCityController.clear();
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                const SizedBox(height: 20),
                Obx(
                  () {
                    // Only show the area field if a city is selected
                    if (leadListController.cityText.value.isNotEmpty) {
                      return CustomSelect(
                        label: "Select area",
                        placeholder: "Please select area",
                        mainList: leadListController.areaList
                            .map(
                              (element) => CustomSelectItem(
                                id: element.areaID ?? "", // Use areaID as id
                                value: element.area ?? "", // Use area as value
                              ),
                            )
                            .toList(),
                        onSelect: (val) async {
                          leadListController.areaController.text = val.id;
                          leadListController.showAreaController.text =
                              val.value;
                        },
                        textEditCtlr: leadListController.showAreaController,
                        showLabel: true,
                        onTapField: () {
                          leadListController.areaController.clear();
                          leadListController.showAreaController.clear();
                        },
                      );
                    } else {
                      // Return an empty widget if no city is selected
                      return SizedBox.shrink();
                    }
                  },
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
                      leadListController.fetchLeads();
                      leadListController.filtered.value = true;
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Apply Filter",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      leadListController.leadSourceController.clear();
                      leadListController.showLeadSourceController.clear();
                      leadListController.productController.clear();
                      leadListController.showProductController.clear();
                      leadListController.stateController.clear();
                      leadListController.showStateController.clear();
                      leadListController.cityController.clear();
                      leadListController.showCityController.clear();
                      leadListController.showAreaController.clear();
                      leadListController.areaController.clear();
                      leadListController.fromDateCtlr.clear();
                      leadListController.toDateCtlr.clear();
                      leadListController.filtered.value = false;
                      leadListController.fetchLeads();

                      // Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Clear Filter",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
