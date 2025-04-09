import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting

class ReportController extends GetxController {
  // Example data (Replace with your data model and API integration)
  var reportData = [
    {
      "taskDate": "02-01-2025", // Date in dd-MM-yyyy format
      "name": "John Doe",
      "taskType": "FollowUp",
      "taskOwner": "HO",
      "assignTo": "BM",
      "taskStatus": "Pending",
      "remark": "Check"
    },
    {
      "taskDate": "09-01-2025", // Date in dd-MM-yyyy format
      "name": "John Doe",
      "taskType": "FollowUp",
      "taskOwner": "HO",
      "assignTo": "BM",
      "taskStatus": "Pending",
      "remark": "Check"
    },
    {
      "taskDate": "02-01-2025",
      "name": "Jane Smith",
      "taskType": "FollowUp",
      "taskOwner": "HO",
      "assignTo": "HO",
      "taskStatus": "Completed",
      "remark": "Test"
    },
    {
      "taskDate": "03-01-2025",
      "name": "Jane Doe",
      "taskType": "Other",
      "taskOwner": "BM",
      "assignTo": "HO",
      "taskStatus": "Pending",
      "remark": "Pending Review"
    },
    {
      "taskDate": "05-01-2025",
      "name": "Jake Peralta",
      "taskType": "FollowUp",
      "taskOwner": "HO",
      "assignTo": "BM",
      "taskStatus": "Completed",
      "remark": "Confirmed"
    },
  ].obs;

  // Search query
  var searchQuery = "".obs;

  // Date filters
  var selectedDateFrom = "".obs; // From Date
  var selectedDateTo = "".obs; // To Date

  // Filters
  var selectedStatus = "All".obs; // "All", "Pending", "Completed"
  var selectedTaskType = "All".obs; // "All", "FollowUp", "Other"

  // Filtered data to be displayed
  var filteredData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    applyFilters(); // Apply filters initially to populate filteredData
  }

  void applyFilters() {
    // Start with the original report data
    var tempData = reportData.toList();

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      tempData = tempData
          .where((item) => item['name']
              .toString()
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
      print("Filtered by search query: $tempData");
    }

    // Filter by task status
    if (selectedStatus.value != "All") {
      tempData = tempData
          .where((item) => item['taskStatus'] == selectedStatus.value)
          .toList();
      print("Filtered by task status ($selectedStatus): $tempData");
    }

    // Filter by task type
    if (selectedTaskType.value != "All") {
      tempData = tempData
          .where((item) => item['taskType'] == selectedTaskType.value)
          .toList();
      print("Filtered by task type ($selectedTaskType): $tempData");
    }

    // Filter by date range
    if (selectedDateFrom.value.isNotEmpty && selectedDateTo.value.isNotEmpty) {
      try {
        print(
            "Selected fromDate: ${selectedDateFrom.value}, toDate: ${selectedDateTo.value}");

        // Parse the selected dates only if they are not empty
        DateTime fromDate = DateFormat('yyyy-MM-dd')
            .parse(selectedDateFrom.value); // Updated format
        DateTime toDate = DateFormat('yyyy-MM-dd')
            .parse(selectedDateTo.value); // Updated format
        print("Parsed fromDate: $fromDate, toDate: $toDate");

        tempData = tempData.where((item) {
          // Parse taskDate with the correct format
          DateTime taskDate = DateFormat('yyyy-MM-dd')
              .parse(item['taskDate']!); // Updated format
          print("Item taskDate: $taskDate");

          // Normalize the date comparison by resetting time to midnight for both
          taskDate = DateTime(taskDate.year, taskDate.month, taskDate.day);
          fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
          toDate = DateTime(toDate.year, toDate.month, toDate.day);

          // Debugging date comparison logic
          print(
              "Comparing taskDate: $taskDate with fromDate: $fromDate and toDate: $toDate");

          // Ensure taskDate is within the fromDate and toDate inclusive
          return taskDate.isAfter(fromDate.subtract(Duration(days: 1))) &&
              taskDate.isBefore(toDate.add(Duration(days: 1)));
        }).toList();

        print("Filtered by date range: $tempData");
      } catch (e) {
        // Handle date parsing errors if any
        print("Date parsing error: $e");
      }
    } else {
      print("Skipping date filter due to empty dates");
    }

    // Update the filtered data
    filteredData.value = tempData;
    print("Final filtered data: $filteredData");
  }
}
