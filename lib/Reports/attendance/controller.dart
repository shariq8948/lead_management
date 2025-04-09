import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  final RxList<AttendanceRecord> attendanceRecords = <AttendanceRecord>[].obs;
  final RxList<AttendanceRecord> filteredRecords = <AttendanceRecord>[].obs;
  final Rx<DateTime> startDate =
      DateTime.now().subtract(Duration(days: 30)).obs;
  final Rx<DateTime> endDate = DateTime.now().obs;
  final RxString selectedDepartment = 'All'.obs;
  final RxString sortBy = 'date'.obs;
  final RxString viewMode = 'grid'.obs;
  final RxBool isAscending = true.obs;
  final RxBool isLoading = false.obs;
  final RxDouble averageAttendance = 0.0.obs;
  final RxInt totalLateCount = 0.obs;
  final RxInt totalAbsentCount = 0.obs;
  final RxInt totalEmployees = 0.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceData();
    debounce(searchQuery, (_) => filterRecords(),
        time: Duration(milliseconds: 500)); // Debounced search
    ever(selectedDepartment,
        (_) => filterRecords()); // Watch for department change
  }

  void searchEmployees(String query) {
    searchQuery.value = query.toLowerCase();
  }

  Future<void> fetchAttendanceData() async {
    isLoading.value = true;
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      attendanceRecords.value = [
        AttendanceRecord(
          employeeId: 'EMP001',
          name: 'John Doe',
          department: 'IT',
          date: DateTime.now(),
          checkIn: '09:00',
          checkOut: '17:00',
          status: 'Present',
        ),
        AttendanceRecord(
          employeeId: 'EMP002',
          name: 'Jane Smith',
          department: 'HR',
          date: DateTime.now(),
          checkIn: '09:30',
          checkOut: '17:30',
          status: 'Late',
        ),
        // Add more sample records here
      ];
      filterRecords();
      calculateStatistics();
      totalEmployees.value = attendanceRecords.length;
    } finally {
      isLoading.value = false;
    }
  }

  void filterRecords() {
    // Perform filtering logic here, but only set filteredRecords once
    List<AttendanceRecord> tempRecords = attendanceRecords.where((record) {
      final matchesSearch = searchQuery.isEmpty ||
          record.name.toLowerCase().contains(searchQuery.value) ||
          record.employeeId.toLowerCase().contains(searchQuery.value);

      final matchesDepartment = selectedDepartment.value == 'All' ||
          record.department == selectedDepartment.value;

      final isInDateRange = record.date.isAfter(startDate.value) &&
          record.date.isBefore(endDate.value.add(Duration(days: 1)));

      return matchesSearch && matchesDepartment && isInDateRange;
    }).toList();

    // Update filteredRecords directly with the filtered records before sorting
    filteredRecords.value = tempRecords;

    sortRecords(); // Now call sortRecords directly
  }

  void sortRecords() {
    // Perform sorting directly on filteredRecords
    switch (sortBy.value) {
      case 'date':
        filteredRecords.sort((a, b) => isAscending.value
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date));
        break;
      case 'name':
        filteredRecords.sort((a, b) => isAscending.value
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'status':
        filteredRecords.sort((a, b) => isAscending.value
            ? a.status.compareTo(b.status)
            : b.status.compareTo(a.status));
        break;
    }

    calculateStatistics(); // Recalculate statistics after sorting
  }

  void calculateStatistics() {
    if (filteredRecords.isEmpty) return;

    totalLateCount.value =
        filteredRecords.where((record) => record.status == 'Late').length;

    totalAbsentCount.value =
        filteredRecords.where((record) => record.status == 'Absent').length;

    averageAttendance.value =
        ((filteredRecords.length - totalAbsentCount.value) /
                filteredRecords.length *
                100)
            .roundToDouble();
  }

  List<AttendanceRecord> getFilteredRecords() {
    return filteredRecords;
  }

  void exportToExcel() {
    // Implement Excel export functionality
    Get.snackbar(
      'Export Started',
      'Your report is being generated...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

class AttendanceRecord {
  final String employeeId;
  final String name;
  final String department;
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final String status;

  AttendanceRecord({
    required this.employeeId,
    required this.name,
    required this.department,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });
}
