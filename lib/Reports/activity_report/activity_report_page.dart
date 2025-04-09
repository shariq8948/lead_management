import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:leads/utils/constants.dart';

import 'controller.dart';

class ActivityReportPage extends StatefulWidget {
  @override
  _ActivityReportPageState createState() => _ActivityReportPageState();
}

class _ActivityReportPageState extends State<ActivityReportPage> {
  final ReportController controller = Get.put(ReportController());
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  Future<void> selectDate({required bool isFromDate}) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      if (isFromDate) {
        controller.selectedDateFrom.value = formattedDate;
      } else {
        controller.selectedDateTo.value = formattedDate;
      }
      controller.applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary3Color,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search by name...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  controller.searchQuery.value = value;
                  controller.applyFilters();
                },
              )
            : Text("Activity Report"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  controller.searchQuery.value = "";
                  controller.applyFilters();
                }
              });
            },
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            color: primary3Color,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String>(
                              value: controller.selectedStatus.value,
                              isExpanded: true,
                              underline: SizedBox(),
                              items: ["All", "Pending", "Completed"]
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.selectedStatus.value = value;
                                  controller.applyFilters();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Task Type",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String>(
                              value: controller.selectedTaskType.value,
                              isExpanded: true,
                              underline: SizedBox(),
                              items: ["All", "FollowUp", "Other"]
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          type,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.selectedTaskType.value = value;
                                  controller.applyFilters();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From Date",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            onTap: () => selectDate(isFromDate: true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Obx(() => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.selectedDateFrom.isEmpty
                                            ? "Select From Date"
                                            : controller.selectedDateFrom.value,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      Icon(Icons.calendar_today,
                                          color: Colors.tealAccent),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "To Date",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            onTap: () => selectDate(isFromDate: false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Obx(() => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.selectedDateTo.isEmpty
                                            ? "Select To Date"
                                            : controller.selectedDateTo.value,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      Icon(Icons.calendar_today,
                                          color: Colors.tealAccent),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Data Table Section
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.filteredData.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredData[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: item['taskStatus'] == "Pending"
                                      ? Colors.orange
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['taskStatus'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text("Task Type: ${item['taskType']}"),
                          Text("Task Owner: ${item['taskOwner']}"),
                          Text("Assign To: ${item['assignTo']}"),
                          Text("Task Date: ${item['taskDate']}"),
                          Text("Remark: ${item['remark']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
