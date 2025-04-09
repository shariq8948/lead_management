import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/model.dart';

class MonthlyTargetComparisonController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<MonthlyTargetData> monthlyData = <MonthlyTargetData>[].obs;
  final Rx<DateTimeRange> selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 365)),
    end: DateTime.now(),
  ).obs;

  final RxString selectedView = 'chart'.obs; // 'chart' or 'table'
  final RxBool showOnlyDeficit = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void setDateRange(DateTimeRange? range) {
    if (range != null) {
      selectedDateRange.value = range;
      fetchData();
    }
  }

  void toggleView() {
    selectedView.value = selectedView.value == 'chart' ? 'table' : 'chart';
  }

  void toggleDeficitFilter() {
    showOnlyDeficit.value = !showOnlyDeficit.value;
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Generate sample data
      final List<MonthlyTargetData> data = [];

      final DateTime startDate = selectedDateRange.value.start;
      final DateTime endDate = selectedDateRange.value.end;

      DateTime currentDate = DateTime(startDate.year, startDate.month, 1);

      while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
        // Generate realistic random data
        final double target = 50000 +
            (currentDate.month * 5000) +
            (Random().nextDouble() * 10000);
        final double actual = target * (0.7 + (Random().nextDouble() * 0.6));

        data.add(MonthlyTargetData(
          month: DateTime(currentDate.year, currentDate.month),
          target: target,
          actual: actual,
        ));

        // Move to next month
        currentDate = DateTime(
          currentDate.month < 12 ? currentDate.year : currentDate.year + 1,
          currentDate.month < 12 ? currentDate.month + 1 : 1,
        );
      }

      monthlyData.value = data;
    } catch (e) {
      // Handle error
      Get.snackbar(
        'Error',
        'Failed to load monthly comparison data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<MonthlyTargetData> get filteredData {
    if (showOnlyDeficit.value) {
      return monthlyData.where((data) => data.actual < data.target).toList();
    }
    return monthlyData;
  }

  double get maxValue {
    if (monthlyData.isEmpty) return 0;
    final targetMax = monthlyData.map((e) => e.target).reduce(max);
    final actualMax = monthlyData.map((e) => e.actual).reduce(max);
    return max(targetMax, actualMax) * 1.1; // Add 10% margin
  }

  double max(double a, double b) => a > b ? a : b;

  String get performanceSummary {
    if (monthlyData.isEmpty) return "No data available";

    final totalTarget =
        monthlyData.fold<double>(0, (sum, item) => sum + item.target);
    final totalActual =
        monthlyData.fold<double>(0, (sum, item) => sum + item.actual);
    final percentAchieved = (totalActual / totalTarget) * 100;

    final deficitMonths =
        monthlyData.where((data) => data.actual < data.target).length;
    final surplusMonths =
        monthlyData.where((data) => data.actual >= data.target).length;

    return "Overall: ${percentAchieved.toStringAsFixed(1)}% of targets achieved\n$surplusMonths months exceeded targets, $deficitMonths months below target";
  }
}
