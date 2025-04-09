import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueComparisonController extends GetxController {
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxBool isLoading = false.obs;
  final RxList<RevenueData> revenueData = <RevenueData>[].obs;
  final RxDouble totalProjectedRevenue = 0.0.obs;
  final RxDouble totalActualRevenue = 0.0.obs;
  final RxDouble differencePercentage = 0.0.obs;

  // Filter options
  final RxString selectedTimeFrame = 'Monthly'.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxList<String> categories =
      <String>['All', 'Product A', 'Product B', 'Service A', 'Service B'].obs;
  final RxList<String> timeFrames =
      <String>['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'].obs;

  @override
  void onInit() {
    super.onInit();
    // Set default date range to last 30 days
    final now = DateTime.now();
    selectedDateRange.value = DateTimeRange(
      start: DateTime(now.year, now.month, now.day - 30),
      end: now,
    );
    fetchRevenueData();
  }

  void onDateRangeChanged(DateTimeRange? newRange) {
    if (newRange != null) {
      selectedDateRange.value = newRange;
      fetchRevenueData();
    }
  }

  void applyFilters(String timeFrame, String category) {
    selectedTimeFrame.value = timeFrame;
    selectedCategory.value = category;
    fetchRevenueData();
  }

  Future<void> fetchRevenueData() async {
    isLoading.value = true;

    try {
      // Simulate API call with a delay
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, you would fetch data from your API here
      // For demonstration, we'll generate mock data
      revenueData.value = generateMockData();

      // Calculate totals
      calculateTotals();
    } catch (e) {
      print('Error fetching revenue data: $e');
      // Handle error appropriately
    } finally {
      isLoading.value = false;
    }
  }

  List<RevenueData> generateMockData() {
    if (selectedDateRange.value == null) return [];

    final start = selectedDateRange.value!.start;
    final end = selectedDateRange.value!.end;
    final data = <RevenueData>[];

    // Logic to generate data based on selected timeframe
    if (selectedTimeFrame.value == 'Monthly') {
      // Generate monthly data
      DateTime current = DateTime(start.year, start.month, 1);
      while (current.isBefore(end) || isSameMonth(current, end)) {
        final monthName = DateFormat('MMM yyyy').format(current);

        // Base values that will be adjusted based on category
        double projected = 10000 + (current.month * 1000);
        double actual = projected * (0.8 + (current.month % 3) * 0.1);

        // Adjust based on category
        if (selectedCategory.value != 'All') {
          if (selectedCategory.value == 'Product A') {
            projected *= 0.4;
            actual *= 0.45;
          } else if (selectedCategory.value == 'Product B') {
            projected *= 0.3;
            actual *= 0.25;
          } else if (selectedCategory.value == 'Service A') {
            projected *= 0.2;
            actual *= 0.2;
          } else if (selectedCategory.value == 'Service B') {
            projected *= 0.1;
            actual *= 0.1;
          }
        }

        data.add(RevenueData(
          period: monthName,
          projectedRevenue: projected,
          actualRevenue: actual,
        ));

        current = DateTime(current.year, current.month + 1, 1);
      }
    } else if (selectedTimeFrame.value == 'Quarterly') {
      // Generate quarterly data
      int startQuarter = (start.month - 1) ~/ 3 + 1;
      int startYear = start.year;
      int endQuarter = (end.month - 1) ~/ 3 + 1;
      int endYear = end.year;

      for (int year = startYear; year <= endYear; year++) {
        int firstQuarter = (year == startYear) ? startQuarter : 1;
        int lastQuarter = (year == endYear) ? endQuarter : 4;

        for (int quarter = firstQuarter; quarter <= lastQuarter; quarter++) {
          final quarterName = 'Q$quarter ${year}';

          double projected = 30000 + (quarter * 5000);
          double actual = projected * (0.8 + (quarter * 0.05));

          // Adjust based on category
          if (selectedCategory.value != 'All') {
            if (selectedCategory.value == 'Product A') {
              projected *= 0.4;
              actual *= 0.45;
            } else if (selectedCategory.value == 'Product B') {
              projected *= 0.3;
              actual *= 0.25;
            } else if (selectedCategory.value == 'Service A') {
              projected *= 0.2;
              actual *= 0.2;
            } else if (selectedCategory.value == 'Service B') {
              projected *= 0.1;
              actual *= 0.1;
            }
          }

          data.add(RevenueData(
            period: quarterName,
            projectedRevenue: projected,
            actualRevenue: actual,
          ));
        }
      }
    } else {
      // For other timeframes - simplified to weekly for demo
      DateTime current = start;
      int weekNum = 1;
      while (current.isBefore(end) || isSameDay(current, end)) {
        final weekName = 'Week $weekNum';

        double projected = 2500 + (weekNum * 100);
        double actual = projected * (0.7 + (weekNum % 5) * 0.1);

        // Adjust based on category
        if (selectedCategory.value != 'All') {
          if (selectedCategory.value == 'Product A') {
            projected *= 0.4;
            actual *= 0.45;
          } else if (selectedCategory.value == 'Product B') {
            projected *= 0.3;
            actual *= 0.25;
          } else if (selectedCategory.value == 'Service A') {
            projected *= 0.2;
            actual *= 0.2;
          } else if (selectedCategory.value == 'Service B') {
            projected *= 0.1;
            actual *= 0.1;
          }
        }

        data.add(RevenueData(
          period: weekName,
          projectedRevenue: projected,
          actualRevenue: actual,
        ));

        current = current.add(const Duration(days: 7));
        weekNum++;
      }
    }

    return data;
  }

  void calculateTotals() {
    double projected = 0;
    double actual = 0;

    for (var item in revenueData) {
      projected += item.projectedRevenue;
      actual += item.actualRevenue;
    }

    totalProjectedRevenue.value = projected;
    totalActualRevenue.value = actual;

    // Calculate the percentage difference
    if (projected > 0) {
      differencePercentage.value = ((actual - projected) / projected) * 100;
    } else {
      differencePercentage.value = 0;
    }
  }

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class RevenueData {
  final String period;
  final double projectedRevenue;
  final double actualRevenue;

  RevenueData({
    required this.period,
    required this.projectedRevenue,
    required this.actualRevenue,
  });

  double get difference => actualRevenue - projectedRevenue;

  double get percentageDifference =>
      projectedRevenue > 0 ? (difference / projectedRevenue) * 100 : 0;
}
