import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MonthlyVisitController extends GetxController {
  // Observable variables
  var selectedMonth = DateTime.now().obs; // Current month
  var totalVisits = 0.obs;
  var uniqueVisitors = 0.obs;
  var averageDuration = ''.obs;
  var newVisitors = 0.obs;

  var monthlyVisitData = <MonthlyVisitData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyVisitData(); // Initial data fetch
  }

  void setSelectedMonth(DateTime month) {
    selectedMonth.value = month;
    fetchMonthlyVisitData();
  }

  void fetchMonthlyVisitData() {
    // Simulating fetching data for the selected month
    final monthName = DateFormat('MMMM yyyy').format(selectedMonth.value);
    print('Fetching data for $monthName...');

    // Simulated data
    monthlyVisitData.value = List.generate(5, (index) {
      return MonthlyVisitData(
        address: 'Location ${index + 1}',
        customerName: 'Customer ${index + 1}',
        visitCount: (10 + index * 5),
        totalDuration: '${(2 + index)} hrs ${(15 + index)} mins',
        remark: 'Remark for Location ${index + 1}',
      );
    });

    // Updating summary data
    totalVisits.value =
        monthlyVisitData.map((e) => e.visitCount).reduce((a, b) => a + b);
    uniqueVisitors.value = monthlyVisitData.length;
    averageDuration.value = '3 hrs 25 mins'; // Example static value
    newVisitors.value = 8; // Example static value
  }
}

// Data model for a single visit
class MonthlyVisitData {
  final String address;
  final String customerName;
  final int visitCount;
  final String totalDuration;
  final String remark;

  MonthlyVisitData({
    required this.address,
    required this.customerName,
    required this.visitCount,
    required this.totalDuration,
    required this.remark,
  });
}
