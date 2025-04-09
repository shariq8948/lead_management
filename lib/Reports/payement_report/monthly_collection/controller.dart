import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthlyCollectionController extends GetxController {
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  List<DayCollection> dailyCollections = [
    DayCollection(date: DateTime(2025, 1, 1), amount: 2000),
    DayCollection(date: DateTime(2025, 1, 2), amount: 1500),
    DayCollection(date: DateTime(2025, 1, 3), amount: 1800),
    DayCollection(date: DateTime(2025, 1, 4), amount: 2500),
    DayCollection(date: DateTime(2025, 1, 5), amount: 1700),
    DayCollection(date: DateTime(2025, 1, 6), amount: 3000),
    DayCollection(date: DateTime(2025, 1, 7), amount: 2200),
  ];
  List<FlSpot> getDailyCollectionData() {
    // Replace with actual data
    return [
      FlSpot(1, 2000),
      FlSpot(2, 2200),
      FlSpot(3, 1800),
      FlSpot(4, 2600),
      FlSpot(5, 2100),
      FlSpot(6, 2400),
      FlSpot(7, 2000),
    ];
  }

  List<PieChartSectionData> getPaymentMethodData() {
    // Replace with actual data
    return [
      PieChartSectionData(
        value: 45,
        color: Colors.blue,
        title: '45%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 30,
        color: Colors.green,
        title: '30%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 25,
        color: Colors.purple,
        title: '25%',
        radius: 50,
      ),
    ];
  }

  List<BarChartGroupData> getWeeklyComparisonData() {
    // Replace with actual data
    return [
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(
          toY: 2000,
          color: Colors.blue,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 2, barRods: [
        BarChartRodData(
          toY: 2200,
          color: Colors.blue,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 3, barRods: [
        BarChartRodData(
          toY: 1800,
          color: Colors.blue,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 4, barRods: [
        BarChartRodData(
          toY: 2600,
          color: Colors.blue,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 5, barRods: [
        BarChartRodData(
          toY: 2100,
          color: Colors.blue,
          width: 20,
        ),
      ]),
    ];
  }
}

class DayCollection {
  final DateTime date;
  final double amount;

  DayCollection({required this.date, required this.amount});
}
