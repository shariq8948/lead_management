import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  // Observable variables
  var selectedMonth = DateTime.now().obs;
  var isLoading = false.obs;

  // Filter states
  var showPresent = true.obs;
  var showAbsent = true.obs;
  var showLate = true.obs;

  // Sample attendance data
  final RxList<Map<String, Object?>> attendanceData = <Map<String, Object?>>[
    {
      "date": "2025-01-01",
      "status": "Present",
      "checkIns": [
        {
          "time": "09:00",
          "timestamp": "2025-01-01T09:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        },
      ],
      "checkOuts": [
        {
          "time": "17:00",
          "timestamp": "2025-01-01T17:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-02",
      "status": "Absent",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-03",
      "status": "Present",
      "checkIns": [
        {
          "time": "08:45",
          "timestamp": "2025-01-03T08:45:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "16:45",
          "timestamp": "2025-01-03T16:45:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-04",
      "status": "Leave",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-05",
      "status": "Half-Day",
      "checkIns": [
        {
          "time": "10:00",
          "timestamp": "2025-01-05T10:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "14:00",
          "timestamp": "2025-01-05T14:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-06",
      "status": "Present",
      "checkIns": [
        {
          "time": "09:30",
          "timestamp": "2025-01-06T09:30:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "17:30",
          "timestamp": "2025-01-06T17:30:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-07",
      "status": "Absent",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-08",
      "status": "Present",
      "checkIns": [
        {
          "time": "08:50",
          "timestamp": "2025-01-08T08:50:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "17:10",
          "timestamp": "2025-01-08T17:10:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-09",
      "status": "Leave",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-10",
      "status": "Present",
      "checkIns": [
        {
          "time": "09:00",
          "timestamp": "2025-01-10T09:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "18:00",
          "timestamp": "2025-01-10T18:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-11",
      "status": "Half-Day",
      "checkIns": [
        {
          "time": "10:00",
          "timestamp": "2025-01-11T10:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "13:00",
          "timestamp": "2025-01-11T13:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-12",
      "status": "Present",
      "checkIns": [
        {
          "time": "09:15",
          "timestamp": "2025-01-12T09:15:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "16:30",
          "timestamp": "2025-01-12T16:30:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-13",
      "status": "Absent",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-14",
      "status": "Present",
      "checkIns": [
        {
          "time": "08:45",
          "timestamp": "2025-01-14T08:45:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "17:45",
          "timestamp": "2025-01-14T17:45:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-15",
      "status": "Leave",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-16",
      "status": "Half-Day",
      "checkIns": [
        {
          "time": "09:00",
          "timestamp": "2025-01-16T09:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "13:00",
          "timestamp": "2025-01-16T13:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-17",
      "status": "Present",
      "checkIns": [
        {
          "time": "09:30",
          "timestamp": "2025-01-17T09:30:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "17:30",
          "timestamp": "2025-01-17T17:30:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-18",
      "status": "Absent",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-19",
      "status": "Leave",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-20",
      "status": "Half-Day",
      "checkIns": [
        {
          "time": "09:00",
          "timestamp": "2025-01-20T09:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "12:30",
          "timestamp": "2025-01-20T12:30:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-21",
      "status": "Present",
      "checkIns": [
        {
          "time": "09:15",
          "timestamp": "2025-01-21T09:15:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "16:45",
          "timestamp": "2025-01-21T16:45:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-22",
      "status": "Absent",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-23",
      "status": "Leave",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-24",
      "status": "Present",
      "checkIns": [
        {
          "time": "09:00",
          "timestamp": "2025-01-24T09:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "17:30",
          "timestamp": "2025-01-24T17:30:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-25",
      "status": "Half-Day",
      "checkIns": [
        {
          "time": "10:00",
          "timestamp": "2025-01-25T10:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "14:00",
          "timestamp": "2025-01-25T14:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-26",
      "status": "Late",
      "checkIns": [
        {
          "time": "11:00",
          "timestamp": "2025-01-26T09:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/150"
        }
      ],
      "checkOuts": [
        {
          "time": "17:00",
          "timestamp": "2025-01-26T17:00:00",
          "location": "Main Office",
          "image": "https://i.pravatar.cc/151"
        }
      ],
      "notes": "Optional notes"
    },
    {
      "date": "2025-01-27",
      "status": "Absent",
      "checkIns": [],
      "checkOuts": [],
      "notes": "Optional notes"
    }
  ].obs;

  // Filtered data based on selected month and filters
  List<Map<String, Object?>> get filteredData {
    return attendanceData.where((entry) {
      final String? date = entry["date"] as String?;
      final String? status = entry["status"] as String?;

      // First filter by month
      bool isInSelectedMonth = date != null &&
          DateFormat("yyyy-MM").format(DateTime.parse(date)) ==
              DateFormat("yyyy-MM").format(selectedMonth.value);

      // Then apply status filters
      bool matchesStatusFilter = (status == "Present" && showPresent.value) ||
          (status == "Absent" && showAbsent.value) ||
          (status == "Late" && showLate.value);

      return isInSelectedMonth && matchesStatusFilter;
    }).toList();
  }

  // Statistics getters
  int get presentCount {
    return attendanceData.where((entry) {
      final date = entry["date"] as String?;
      final status = entry["status"] as String?;
      if (date == null || status == null) return false;

      return DateFormat("yyyy-MM").format(DateTime.parse(date)) ==
              DateFormat("yyyy-MM").format(selectedMonth.value) &&
          status == "Present";
    }).length;
  }

  int get absentCount {
    return attendanceData.where((entry) {
      final date = entry["date"] as String?;
      final status = entry["status"] as String?;
      if (date == null || status == null) return false;

      return DateFormat("yyyy-MM").format(DateTime.parse(date)) ==
              DateFormat("yyyy-MM").format(selectedMonth.value) &&
          status == "Absent";
    }).length;
  }

  int get lateCount {
    return attendanceData.where((entry) {
      final date = entry["date"] as String?;
      final status = entry["status"] as String?;
      if (date == null || status == null) return false;

      return DateFormat("yyyy-MM").format(DateTime.parse(date)) ==
              DateFormat("yyyy-MM").format(selectedMonth.value) &&
          status == "Late";
    }).length;
  }

  double get attendancePercentage {
    final totalDays = filteredData.length;
    if (totalDays == 0) return 0.0;
    return (presentCount / totalDays) * 100;
  }

  int get currentStreak {
    int streak = 0;
    final sortedData = List<Map<String, dynamic>>.from(attendanceData)
      ..sort((a, b) {
        final dateA = a["date"] as String?;
        final dateB = b["date"] as String?;
        if (dateA == null || dateB == null) return 0;
        return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
      });

    for (var record in sortedData) {
      final status = record["status"] as String?;
      if (status == "Present") {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  // Filter toggles
  void togglePresent(bool value) {
    showPresent.value = value;
    update();
  }

  void toggleAbsent(bool value) {
    showAbsent.value = value;
    update();
  }

  void toggleLate(bool value) {
    showLate.value = value;
    update();
  }

  // Update selected month
  void updateSelectedMonth(DateTime date) {
    selectedMonth.value = date;
    fetchAttendanceData();
  }

  // Log attendance view - can be used for analytics
  void logAttendanceView(String date) {
    print('Viewing attendance details for: $date');
  }

  // Fetch attendance data
  Future<void> fetchAttendanceData() async {
    isLoading.value = true;
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      // In a real app, you'd fetch data from an API here
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch attendance data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceData();
  }
}
