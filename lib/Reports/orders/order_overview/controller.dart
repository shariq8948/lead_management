// import 'dart:math';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// class OrdersReportController extends GetxController {
//   // Existing observable states
//   final selectedDateRange = Rx<DateTimeRange?>(null);
//   final selectedStatus = RxString('All');
//   final searchQuery = RxString('');
//   final currentPage = RxInt(1);
//   final itemsPerPage = 10;
//   final revenueData = RxList<FlSpot>([]);
//   final orderStatusData = RxMap<String, double>();
//   final totalOrders = RxInt(0);
//   final totalRevenue = RxDouble(0.0);
//   final avgOrderValue = RxDouble(0.0);
//   final pendingOrders = RxInt(0);
//   final lastUpdated = Rx<DateTime>(DateTime.now());
//   final orders = RxList<Map<String, dynamic>>([]);
//   final totalOrdersGrowth = RxString('+0%');
//   final totalRevenueGrowth = RxString('+0%');
//   final avgOrderValueGrowth = RxString('+0%');
//   final pendingOrdersGrowth = RxString('+0%');
//
//   // Added loading state
//   final isLoading = RxBool(false);
//
//   void editOrder(Map<String, dynamic> order) async {
//     try {
//       // Show edit dialog
//       final result = await Get.dialog(
//         AlertDialog(
//           title: Text('Edit Order'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Order ID: ${order['orderId']}'),
//                 SizedBox(height: 16),
//                 DropdownButton<String>(
//                   value: order['status'],
//                   items: ['Completed', 'Pending', 'In Progress', 'Cancelled']
//                       .map((status) => DropdownMenuItem(
//                     value: status,
//                     child: Text(status),
//                   ))
//                       .toList(),
//                   onChanged: (newStatus) {
//                     order['status'] = newStatus;
//                     // Trigger update
//                     orders.refresh();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Update order in the list
//                 final index = orders.indexWhere(
//                         (o) => o['orderId'] == order['orderId']);
//                 if (index != -1) {
//                   orders[index] = order;
//                   orders.refresh();
//                   calculateMetrics();
//                 }
//                 Get.back();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to edit order',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//
//
//
//
//   Future<void> printReport() async {
//     try {
//       isLoading.value = true;
//       // Add printing implementation
//       await Future.delayed(Duration(seconds: 1));
//
//       Get.snackbar(
//         'Success',
//         'Report sent to printer',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to print report',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//
//   // Helper method to validate date range

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class OrdersReportController extends GetxController {
  // Observable states
  final selectedDateRange = Rx<DateTimeRange?>(null);
  final selectedStatus = RxString('All');
  final searchQuery = RxString('');
  final currentPage = RxInt(1);
  final itemsPerPage = 10;
  final isLoading = RxBool(false);

  // Charts data
  final revenueData = RxList<FlSpot>([]);
  final orderStatusData = RxMap<String, double>({
    'Completed': 40,
    'In Progress': 30,
    'Cancelled': 15,
    'Pending': 15,
  });

  // Metrics
  final totalOrders = RxInt(0);
  final totalRevenue = RxDouble(0.0);
  final avgOrderValue = RxDouble(0.0);
  final pendingOrders = RxInt(0);
  final lastUpdated = Rx<DateTime>(DateTime.now());
  final orders = RxList<Map<String, dynamic>>([]);

  // Growth metrics
  final totalOrdersGrowth = RxString('+0%');
  final totalRevenueGrowth = RxString('+0%');
  final avgOrderValueGrowth = RxString('+0%');
  final pendingOrdersGrowth = RxString('+0%');

  @override
  void onInit() {
    super.onInit();
    generateMockData();
    setupRevenueChart();
    calculateMetrics();
  }

  void generateMockData() {
    final random = Random();
    final statuses = ['Completed', 'Pending', 'In Progress', 'Cancelled'];

    orders.value = List.generate(100, (index) {
      final amount = (random.nextDouble() * 1000).roundToDouble();
      final status = statuses[random.nextInt(statuses.length)];
      final date = DateTime.now().subtract(Duration(days: random.nextInt(30)));

      return {
        'orderId': '#ORD-${1000 + index}',
        'customerName': 'Customer ${index + 1}',
        'date': DateFormat('MMM dd, yyyy').format(date),
        'amount': amount,
        'rawAmount': amount,
        'status': status,
      };
    });
  }

  bool isDateInRange(String dateStr) {
    if (selectedDateRange.value == null) return true;

    final date = DateFormat('MMM dd, yyyy').parse(dateStr);
    return date.isAfter(selectedDateRange.value!.start) &&
        date.isBefore(selectedDateRange.value!.end.add(Duration(days: 1)));
  }

  Future<void> exportReport({String format = 'pdf'}) async {
    try {
      isLoading.value = true;

      switch (format.toLowerCase()) {
        case 'pdf':
          await _exportToPdf();
          break;
        case 'csv':
          await _exportToCsv();
          break;
        case 'excel':
          await _exportToExcel();
          break;
        default:
          throw 'Unsupported format';
      }

      Get.snackbar(
        'Success',
        'Report exported successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export report',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _exportToPdf() async {
    // Add PDF export implementation using pdf package
    // This is a placeholder for the actual implementation
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> _exportToCsv() async {
    // Add CSV export implementation
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> _exportToExcel() async {
    // Add Excel export implementation
    await Future.delayed(Duration(seconds: 1));
  }

  String getDateRangeText() {
    if (selectedDateRange.value == null) {
      return 'Last 30 Days';
    }

    final start =
        DateFormat('MMM dd, yyyy').format(selectedDateRange.value!.start);
    final end = DateFormat('MMM dd, yyyy').format(selectedDateRange.value!.end);

    return '$start - $end';
  }

  Future<void> printReport() async {
    try {
      isLoading.value = true;
      // Add printing implementation
      await Future.delayed(Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Report sent to printer',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to print report',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void viewOrderDetails(Map<String, dynamic> order) {
    Get.dialog(
      AlertDialog(
        title: Text('Order Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${order['orderId']}'),
              SizedBox(height: 8),
              Text('Customer: ${order['customerName']}'),
              SizedBox(height: 8),
              Text('Date: ${order['date']}'),
              SizedBox(height: 8),
              Text(
                  'Amount: ${NumberFormat.currency(symbol: '\$').format(order['rawAmount'])}'),
              SizedBox(height: 8),
              Text('Status: ${order['status']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void setupRevenueChart() {
    final random = Random();
    revenueData.value = List.generate(12, (index) {
      return FlSpot(index.toDouble(), random.nextDouble() * 5 + 1);
    });
  }

  void calculateMetrics() {
    final random = Random();

    // Calculate actual metrics
    totalOrders.value = orders.length;
    totalRevenue.value =
        orders.fold(0.0, (sum, order) => sum + (order['rawAmount'] as double));
    avgOrderValue.value = totalRevenue.value / totalOrders.value;
    pendingOrders.value =
        orders.where((order) => order['status'] == 'Pending').length;

    // Generate random growth rates
    totalOrdersGrowth.value = _generateGrowthRate(random);
    totalRevenueGrowth.value = _generateGrowthRate(random);
    avgOrderValueGrowth.value = _generateGrowthRate(random);
    pendingOrdersGrowth.value = _generateGrowthRate(random);

    // Update last updated timestamp
    lastUpdated.value = DateTime.now();

    // Calculate order status percentages
    final statusCounts = <String, int>{};
    for (final order in orders) {
      final status = order['status'] as String;
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    orderStatusData.value = statusCounts.map((key, value) {
      return MapEntry(key, (value / orders.length) * 100);
    });
  }

  String _generateGrowthRate(Random random) {
    final isPositive = random.nextBool();
    final value = (random.nextDouble() * 15).toStringAsFixed(1);
    return isPositive ? '+$value%' : '-$value%';
  }

  void refreshData() {
    generateMockData();
    setupRevenueChart();
    calculateMetrics();
    update();
  }

  List<Map<String, dynamic>> getFilteredOrders() {
    return orders.where((order) {
      final matchesStatus = selectedStatus.isEmpty ||
          selectedStatus.value == 'All' ||
          order['status'] == selectedStatus.value;

      final matchesQuery = order['orderId']
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          order['customerName']
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      final matchesDateRange = selectedDateRange.value == null ||
          (DateFormat('MMM dd, yyyy')
                  .parse(order['date'])
                  .isAfter(selectedDateRange.value!.start) &&
              DateFormat('MMM dd, yyyy')
                  .parse(order['date'])
                  .isBefore(selectedDateRange.value!.end));

      return matchesStatus && matchesQuery && matchesDateRange;
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
  }

  void updateStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
  }

  void updateDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
    currentPage.value = 1;
  }

  void nextPage() {
    final totalPages = (getFilteredOrders().length / itemsPerPage).ceil();
    if (currentPage.value < totalPages) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}
