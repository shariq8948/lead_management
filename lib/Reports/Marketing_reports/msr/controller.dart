import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesController extends GetxController {
  var selectedPeriod = 'This Month'.obs; // This will hold the selected period
  var selectedDate = DateTime.now().obs; // Reactive DateTime
  var customStartDate = DateTime.now().obs; // Start date for custom range
  var customEndDate = DateTime.now().obs; // End date for custom range

  // Function to refresh data based on selected period

  // Optionally, add a function to update the period

  final RxDouble totalSales = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble averageOrderValue = 0.0.obs;
  final RxDouble highestSale = 0.0.obs;
  final RxDouble lowestSale = 0.0.obs;
  final RxString topProduct = ''.obs;
  final RxInt pendingShipments = 0.obs;
  final RxList<FlSpot> salesTrend = <FlSpot>[].obs;
  final RxList<PieChartSectionData> categoryDistribution =
      <PieChartSectionData>[].obs;
  final RxList<FlSpot> targetTrend = <FlSpot>[].obs;
  var selectedRegion = 'All'.obs;
  var selectedCategory = 'All'.obs;
  var selectedSalesType = 'All'.obs;
  var selectedStatus = 'All'.obs;
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Function to update the date based on selected period
  void refreshData() async {
    print('Data refreshed for period: $selectedPeriod');
    await Future.delayed(const Duration(seconds: 1));
    loadInitialData();
    updateDateBasedOnPeriod();
  }

  // Function to update the date based on selected period
  void updateDateBasedOnPeriod() {
    switch (selectedPeriod.value) {
      case 'This Month':
        selectedDate.value = DateTime(DateTime.now().year, DateTime.now().month,
            1); // Start of current month
        break;
      case 'Last Month':
        selectedDate.value = DateTime(DateTime.now().year,
            DateTime.now().month - 1, 1); // Start of last month
        break;
      case 'Last 3 Months':
        selectedDate.value = DateTime(DateTime.now().year,
            DateTime.now().month - 3, 1); // Start of 3 months ago
        break;
      case 'Last 6 Months':
        selectedDate.value = DateTime(DateTime.now().year,
            DateTime.now().month - 6, 1); // Start of 6 months ago
        break;
      case 'This Year':
        selectedDate.value =
            DateTime(DateTime.now().year, 1, 1); // Start of this year
        break;
      case 'Custom Range':
        // Don't modify the date for Custom Range, use custom dates instead
        break;
      default:
        selectedDate.value =
            DateTime.now(); // Default to current date if unknown
    }
  }

  // Function to update the selected period
  void updatePeriod(String newPeriod) {
    selectedPeriod.value = newPeriod;
    refreshData();
  }

  // Function to update the custom date range
  void updateCustomDateRange(DateTime startDate, DateTime endDate) {
    customStartDate.value = startDate;
    customEndDate.value = endDate;
    selectedPeriod.value = 'Custom Range'; // Set period to "Custom Range"
    refreshData();
  }

  void loadInitialData() {
    // Sample data - replace with actual API calls
    totalSales.value = 4680;
    totalOrders.value = 2450;
    averageOrderValue.value = totalSales.value / totalOrders.value;
    highestSale.value = 2500.0;
    lowestSale.value = 50.0;
    topProduct.value = 'Premium Headphones';
    pendingShipments.value = 45;

    // Sales trend data
    salesTrend.value = [
      FlSpot(0, 65),
      FlSpot(1, 59),
      FlSpot(2, 80),
      FlSpot(3, 81),
      FlSpot(4, 95),
      FlSpot(5, 87),
    ];

    // Target trend data
    targetTrend.value = [
      FlSpot(0, 70),
      FlSpot(1, 72),
      FlSpot(2, 75),
      FlSpot(3, 78),
      FlSpot(4, 82),
      FlSpot(5, 85),
    ];

    // Category distribution data
    categoryDistribution.value = [
      PieChartSectionData(
        color: const Color(0xFF3B82F6),
        value: 35,
        title: '35%',
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        color: const Color(0xFF10B981),
        value: 25,
        title: '25%',
        radius: 45,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 20,
        title: '20%',
        radius: 45,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        color: const Color(0xFF6366F1),
        value: 15,
        title: '15%',
        radius: 45,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        color: const Color(0xFFEC4899),
        value: 5,
        title: '5%',
        radius: 45,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ];
  }

  // Additional methods for the performance chart
  List<BarChartGroupData> getPerformanceData() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: 20 + Random().nextDouble() * 80,
            color: Colors.blue,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }
}

// Add this widget to the main screen file for the performance chart

// Add these utility methods to help with date formatting and calculations
