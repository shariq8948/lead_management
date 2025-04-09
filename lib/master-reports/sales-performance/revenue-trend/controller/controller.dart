import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';

class RevenueTrendsController extends GetxController {
  final isLoading = true.obs;
  final selectedPeriod = RevenuePeriod.monthly.obs;
  final dateRange = Rx<DateTimeRange?>(null);

  final revenueData = <RevenueDataPoint>[].obs;
  final totalRevenue = 0.0.obs;
  final revenueChangePercentage = 0.0.obs;

  final highestRevenue = 0.0.obs;
  final highestRevenueDate = ''.obs;
  final lowestRevenue = 0.0.obs;
  final lowestRevenueDate = ''.obs;
  final averageRevenue = 0.0.obs;

  // Filter-related variables
  final revenueSources = <String>[
    'In-App Purchases',
    'Subscriptions',
    'Ads',
    'One-time Purchases'
  ];
  final selectedSources = <String>[].obs;
  final sortOption = SortOption.dateDesc.obs;

  @override
  void onInit() {
    super.onInit();
    var res = ApiClient().postg(ApiEndpoints.categorySales, data: {
      "Fromdate": "2022-01-01",
      "Uptodate": "2025-03-31",
      "UserId": 3,
      "Syscompanyid": 3,
      "Sysbranchid": 3,
      "filtertype": "S"
    });
    print(res);
    // Initialize with default date range (last 30 days)
    final now = DateTime.now();
    dateRange.value = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );

    // Initialize selected sources with all available sources
    selectedSources.value = List.from(revenueSources);

    // Load initial data
    loadRevenueData();
  }

  void updatePeriod(RevenuePeriod period) {
    selectedPeriod.value = period;
    loadRevenueData();
  }

  void updateDateRange(DateTimeRange range) {
    dateRange.value = range;
    loadRevenueData();
  }

  void toggleSource(String source, bool isSelected) {
    if (isSelected && !selectedSources.contains(source)) {
      selectedSources.add(source);
    } else if (!isSelected && selectedSources.contains(source)) {
      selectedSources.remove(source);
    }
  }

  void setSortOption(SortOption option) {
    sortOption.value = option;
  }

  void resetFilters() {
    selectedSources.value = List.from(revenueSources);
    sortOption.value = SortOption.dateDesc;
  }

  void applyFilters() {
    loadRevenueData();
  }

  // In a real app, this would fetch data from an API or database
  void loadRevenueData() {
    isLoading.value = true;

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // Generate mock data based on the current filters and date range
      _generateMockData();

      // Calculate statistics
      _calculateStatistics();

      isLoading.value = false;
    });
  }

  void _generateMockData() {
    if (dateRange.value == null) return;

    final start = dateRange.value!.start;
    final end = dateRange.value!.end;
    final random = DateTime.now()
        .millisecondsSinceEpoch; // Seed for reproducible random values

    revenueData.clear();

    switch (selectedPeriod.value) {
      case RevenuePeriod.daily:
        // Daily data points
        for (var day = 0; day <= end.difference(start).inDays; day++) {
          final date = start.add(Duration(days: day));
          revenueData.add(_createDataPoint(date, day, random));
        }
        break;

      case RevenuePeriod.weekly:
        // Weekly data points
        for (var week = 0; week * 7 <= end.difference(start).inDays; week++) {
          final date = start.add(Duration(days: week * 7));
          revenueData.add(_createDataPoint(date, week, random, isWeekly: true));
        }
        break;

      case RevenuePeriod.monthly:
        // Monthly data points
        var month = start.month;
        var year = start.year;

        while (DateTime(year, month).isBefore(end) ||
            (year == end.year && month == end.month)) {
          final date = DateTime(year, month);
          final monthIndex = (year - start.year) * 12 + (month - start.month);
          revenueData
              .add(_createDataPoint(date, monthIndex, random, isMonthly: true));

          month++;
          if (month > 12) {
            month = 1;
            year++;
          }
        }
        break;

      case RevenuePeriod.quarterly:
        // Quarterly data points
        var quarter = (start.month - 1) ~/ 3;
        var year = start.year;

        while (DateTime(year, quarter * 3 + 1).isBefore(end) ||
            (year == end.year && quarter == (end.month - 1) ~/ 3)) {
          final date = DateTime(year, quarter * 3 + 1);
          final quarterIndex =
              (year - start.year) * 4 + (quarter - (start.month - 1) ~/ 3);
          revenueData.add(
              _createDataPoint(date, quarterIndex, random, isQuarterly: true));

          quarter++;
          if (quarter >= 4) {
            quarter = 0;
            year++;
          }
        }
        break;

      case RevenuePeriod.yearly:
        // Yearly data points
        for (var year = start.year; year <= end.year; year++) {
          final date = DateTime(year);
          revenueData.add(_createDataPoint(date, year - start.year, random,
              isYearly: true));
        }
        break;
    }

    // Apply sorting
    _applySorting();
  }

  RevenueDataPoint _createDataPoint(
    DateTime date,
    int index,
    int seed, {
    bool isWeekly = false,
    bool isMonthly = false,
    bool isQuarterly = false,
    bool isYearly = false,
  }) {
    // Use deterministic random values based on date and seed
    final baseValue = ((date.day + date.month + date.year) * seed) % 1000;
    double value = 1000 + (baseValue / 10);

    // Add some variance based on filters
    if (selectedSources.length < revenueSources.length) {
      value = value * selectedSources.length / revenueSources.length;
    }

    // Add a trend based on the period
    if (isWeekly) {
      value += index * 50;
    } else if (isMonthly) {
      value += index * 120;
    } else if (isQuarterly) {
      value += index * 250;
    } else if (isYearly) {
      value += index * 800;
    } else {
      // Daily
      value += index * 10;
    }

    // Add seasonal variance
    if (date.month == 11 || date.month == 12) {
      // Holiday season
      value *= 1.2;
    } else if (date.month == 1 || date.month == 2) {
      // Post-holiday
      value *= 0.9;
    }

    // Format the label based on period
    String label;
    if (isYearly) {
      label = DateFormat('yyyy').format(date);
    } else if (isQuarterly) {
      final quarterName = 'Q${(date.month - 1) ~/ 3 + 1}';
      label = '$quarterName ${DateFormat('yyyy').format(date)}';
    } else if (isMonthly) {
      label = DateFormat('MMM yyyy').format(date);
    } else if (isWeekly) {
      final endDate = date.add(const Duration(days: 6));
      label =
          '${DateFormat('MMMd').format(date)}-${DateFormat('d').format(endDate)}';
    } else {
      label = DateFormat('MMMd').format(date);
    }

    return RevenueDataPoint(
      date: date,
      value: value,
      label: label,
    );
  }

  void _applySorting() {
    switch (sortOption.value) {
      case SortOption.dateAsc:
        revenueData.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.dateDesc:
        revenueData.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.revenueAsc:
        revenueData.sort((a, b) => a.value.compareTo(b.value));
        break;
      case SortOption.revenueDesc:
        revenueData.sort((a, b) => b.value.compareTo(a.value));
        break;
    }

    // If sorted by revenue, we need to update the chart x-axis
    if (sortOption.value == SortOption.revenueAsc ||
        sortOption.value == SortOption.revenueDesc) {
      // We only need to update labels for readability
      // The chart will use indexes for x-axis
    }
  }

  void _calculateStatistics() {
    if (revenueData.isEmpty) {
      totalRevenue.value = 0;
      revenueChangePercentage.value = 0;
      highestRevenue.value = 0;
      lowestRevenue.value = 0;
      averageRevenue.value = 0;
      return;
    }

    // Calculate total revenue
    totalRevenue.value = revenueData.fold(0, (sum, data) => sum + data.value);
    var highestPoint = revenueData
        .reduce((curr, next) => curr.value > next.value ? curr : next);
    var lowestPoint = revenueData
        .reduce((curr, next) => curr.value < next.value ? curr : next);

    highestRevenue.value = highestPoint.value;
    highestRevenueDate.value = highestPoint.label;
    lowestRevenue.value = lowestPoint.value;
    lowestRevenueDate.value = lowestPoint.label;

    // Calculate average revenue
    averageRevenue.value = totalRevenue.value / revenueData.length;

    // Calculate revenue change percentage
    if (revenueData.length > 1) {
      // If sorted by date in descending order, compare first and second
      // If sorted by date in ascending order, compare last and second to last
      double currentValue, previousValue;

      if (sortOption.value == SortOption.dateDesc) {
        currentValue = revenueData[0].value;
        previousValue = revenueData[1].value;
      } else if (sortOption.value == SortOption.dateAsc) {
        currentValue = revenueData.last.value;
        previousValue = revenueData[revenueData.length - 2].value;
      } else {
        // For other sort options, compare the newest date points
        var sortedByDate = List<RevenueDataPoint>.from(revenueData)
          ..sort((a, b) => b.date.compareTo(a.date));
        currentValue = sortedByDate[0].value;
        previousValue = sortedByDate[1].value;
      }

      revenueChangePercentage.value =
          ((currentValue - previousValue) / previousValue * 100)
              .roundToDouble();
    } else {
      revenueChangePercentage.value = 0;
    }
  }

  double getMaxRevenue() {
    if (revenueData.isEmpty) return 1000;
    return revenueData
        .map((data) => data.value)
        .reduce((value, element) => value > element ? value : element);
  }

  double getChartYInterval() {
    final maxValue = getMaxRevenue();
    if (maxValue <= 1000) return 200;
    if (maxValue <= 5000) return 1000;
    if (maxValue <= 10000) return 2000;
    return 5000;
  }

  String getFormattedDateRange() {
    if (dateRange.value == null) return '';

    final start = dateRange.value!.start;
    final end = dateRange.value!.end;

    return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d').format(end)}';
  }
}

// Models
enum RevenuePeriod {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly;

  String get displayName {
    switch (this) {
      case RevenuePeriod.daily:
        return 'Daily';
      case RevenuePeriod.weekly:
        return 'Weekly';
      case RevenuePeriod.monthly:
        return 'Monthly';
      case RevenuePeriod.quarterly:
        return 'Quarterly';
      case RevenuePeriod.yearly:
        return 'Yearly';
    }
  }
}

enum SortOption {
  dateAsc,
  dateDesc,
  revenueAsc,
  revenueDesc,
}

class RevenueDataPoint {
  final DateTime date;
  final double value;
  final String label;

  RevenueDataPoint({
    required this.date,
    required this.value,
    required this.label,
  });
}
