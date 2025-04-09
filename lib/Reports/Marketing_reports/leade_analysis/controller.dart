import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LeadAnalysisController extends GetxController {
  // Selected date for the report
  var selectedDate = DateTime.now().obs;

  // Sample data for Lead Overview Summary
  final leadOverviewData = {
    'totalLeads': '1200',
    'conversionRate': '12.5%',
    'leadsClosed': '150',
    'pendingLeads': '200',
  };

  // Sample data for Lead Sources Pie Chart
  List<PieChartSectionData> getLeadSourceData() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 45,
        title: 'Social Media',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 30,
        title: 'Referrals',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 25,
        title: 'Direct',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ];
  }

  // Sample data for Lead Conversion Trend
  List<FlSpot> getLeadConversionData() {
    return [
      FlSpot(0, 50),
      FlSpot(1, 70),
      FlSpot(2, 55),
      FlSpot(3, 80),
      FlSpot(4, 100),
      FlSpot(5, 120),
    ];
  }

  // Sample data for Top Lead Sources
  List<Map<String, dynamic>> getTopLeadSources() {
    return [
      {'name': 'Facebook', 'leads': 320},
      {'name': 'Google Ads', 'leads': 280},
      {'name': 'LinkedIn', 'leads': 200},
      {'name': 'Referral', 'leads': 150},
    ];
  }

  // Sample data for Weekly Lead Comparison (Bar Chart)
  List<BarChartGroupData> getWeeklyComparisonData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 50,
            color: Colors.blue,
            width: 12,
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 60,
            color: Colors.blue,
            width: 12,
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 70,
            color: Colors.blue,
            width: 12,
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: 90,
            color: Colors.blue,
            width: 12,
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
    ];
  }

  // Sample method to format the date for the lead report
  String formatReportDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
