// lib/controllers/dropoff_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/model.dart';

class DropoffController extends GetxController {
  final DropoffApiService apiService = DropoffApiService();

  // Observable properties
  final RxList<DropoffModel> dropoffStages = <DropoffModel>[].obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final Rx<TimeFrame?> timeframe = Rx<TimeFrame?>(null);
  final Rx<DropoffSummary?> summary = Rx<DropoffSummary?>(null);
  final RxList<Insight> insights = <Insight>[].obs;
  final RxList<TrendData> trendData = <TrendData>[].obs;
  final RxList<Recommendation> recommendations = <Recommendation>[].obs;

  // Filter properties
  final RxMap<String, dynamic> filters = <String, dynamic>{}.obs;

  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set default date range to last 30 days
    final now = DateTime.now();
    selectedDateRange.value = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
    fetchDropoffData();
  }

  Future<void> fetchDropoffData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.fetchDropoffData(
        dateRange: selectedDateRange.value,
        filters: filters,
      );

      if (response.success) {
        dropoffStages.value = response.data.stages;
        timeframe.value = response.data.timeframe;
        summary.value = response.data.summary;
        insights.value = response.data.insights;
        trendData.value = response.data.trendData;
        recommendations.value = response.data.recommendations;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load dropoff data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTimeRange? dateRange) {
    if (dateRange != null && dateRange != selectedDateRange.value) {
      selectedDateRange.value = dateRange;
      fetchDropoffData();
    }
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    filters.addAll(newFilters);
    fetchDropoffData();
  }

  void clearFilters() {
    filters.clear();
    fetchDropoffData();
  }

  // Helper methods for UI
  int get totalInitialLeads {
    return summary.value?.totalLeads ?? 0;
  }

  int get totalDroppedLeads {
    return summary.value?.droppedLeads ?? 0;
  }

  double get dropoffRate {
    return summary.value?.dropoffRate ?? 0.0;
  }

  double get conversionProgress {
    return summary.value?.conversionProgress ?? 0.0;
  }

  int get finalConvertedLeads {
    return totalInitialLeads - totalDroppedLeads;
  }

  double get overallConversionRate {
    if (totalInitialLeads == 0) return 0.0;
    return (finalConvertedLeads / totalInitialLeads) * 100;
  }

  // Helper methods for chart data
  List<ChartData> getChartData() {
    return trendData
        .map((data) => ChartData(data.stage, data.dropoffRate))
        .toList();
  }
}

// Class needed for the chart in the UI
class ChartData {
  final String stage;
  final double dropoffRate;

  ChartData(this.stage, this.dropoffRate);
}
