import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DailyVisitController extends GetxController {
  var selectedDate = DateTime.now().obs;

  final List<VisitData> visitDataList = [
    VisitData(
      customerName: 'John Doe',
      checkInTime: DateTime.now().subtract(Duration(hours: 1)),
      checkOutTime: DateTime.now(),
      address: '123 Main Street, City, Country',
      duration: '1 hour',
      remark: 'Meeting completed successfully',
      audioUrl: 'http://example.com/audio1.mp3',
    ),
    VisitData(
      customerName: 'Jane Smith',
      checkInTime: DateTime.now().subtract(Duration(hours: 2)),
      checkOutTime: DateTime.now().subtract(Duration(minutes: 30)),
      address: '456 Oak Road, City, Country',
      duration: '30 minutes',
      remark: 'Customer requested more details',
      audioUrl: '',
    ),
  ];

  // Sample data for daily visits
  List<VisitDatashort> get dailyVisits => [
        VisitDatashort(DateTime.now().subtract(const Duration(days: 1)), 100),
        VisitDatashort(DateTime.now().subtract(const Duration(days: 2)), 120),
        VisitDatashort(DateTime.now().subtract(const Duration(days: 3)), 95),
        VisitDatashort(DateTime.now().subtract(const Duration(days: 4)), 130),
        VisitDatashort(DateTime.now().subtract(const Duration(days: 5)), 150),
      ];

  // Sample data for visit trends (Line Chart)
  List<FlSpot> getVisitTrendData() {
    return [
      FlSpot(0, 100),
      FlSpot(1, 120),
      FlSpot(2, 110),
      FlSpot(3, 130),
      FlSpot(4, 140),
    ];
  }

  // Function to filter visit data by the selected date
  List<VisitData> getFilteredVisitData() {
    return visitDataList
        .where((visit) =>
            visit.checkInTime.day == selectedDate.value.day &&
            visit.checkInTime.month == selectedDate.value.month &&
            visit.checkInTime.year == selectedDate.value.year)
        .toList();
  }
}

class VisitData {
  final String customerName;
  final DateTime checkInTime;
  final DateTime checkOutTime;
  final String address;
  final String duration;
  final String remark;
  final String audioUrl;

  VisitData({
    required this.customerName,
    required this.checkInTime,
    required this.checkOutTime,
    required this.address,
    required this.duration,
    required this.remark,
    required this.audioUrl,
  });
}

class VisitDatashort {
  final DateTime date;
  final int visits;

  VisitDatashort(this.date, this.visits);
}
