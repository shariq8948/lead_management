import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OutstandingPaymentsController extends GetxController {
  var isLoading = true.obs;
  var dateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );
  var totalOutstanding = 0.0.obs;
  var outstandingPayments = <OutstandingPayment>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOutstandingPayments();
  }

  void fetchOutstandingPayments() {
    isLoading.value = true;

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // In a real app, you would fetch this data from your API
      outstandingPayments.value = [
        OutstandingPayment(
          customerName: 'Acme Corporation',
          invoiceNumber: 'INV-2025-0042',
          amount: 5750.00,
          dueDate: DateTime.now().subtract(const Duration(days: 15)),
          overdueDays: 15,
        ),
        OutstandingPayment(
          customerName: 'TechSolutions Inc.',
          invoiceNumber: 'INV-2025-0038',
          amount: 3200.00,
          dueDate: DateTime.now().subtract(const Duration(days: 22)),
          overdueDays: 22,
        ),
        OutstandingPayment(
          customerName: 'Global Enterprises',
          invoiceNumber: 'INV-2025-0035',
          amount: 8900.00,
          dueDate: DateTime.now().subtract(const Duration(days: 5)),
          overdueDays: 5,
        ),
        OutstandingPayment(
          customerName: 'SmartSystems LLC',
          invoiceNumber: 'INV-2025-0031',
          amount: 4250.00,
          dueDate: DateTime.now().subtract(const Duration(days: 45)),
          overdueDays: 45,
        ),
        OutstandingPayment(
          customerName: 'Infinite Solutions',
          invoiceNumber: 'INV-2025-0027',
          amount: 6800.00,
          dueDate: DateTime.now().subtract(const Duration(days: 30)),
          overdueDays: 30,
        ),
      ];

      // Calculate total outstanding amount
      totalOutstanding.value =
          outstandingPayments.fold(0.0, (sum, payment) => sum + payment.amount);

      isLoading.value = false;
    });
  }

  void onDateRangeSelected(DateTimeRange? range) {
    if (range != null) {
      dateRange.value = range;
      fetchOutstandingPayments();
    }
  }

  // Filter by overdue threshold
  void filterByOverdueDays(int days) {
    isLoading.value = true;

    // Simulating API call with filter
    Future.delayed(const Duration(milliseconds: 800), () {
      // In a real app, you would apply this filter on your API call
      outstandingPayments.value = outstandingPayments
          .where((payment) => payment.overdueDays >= days)
          .toList();

      totalOutstanding.value =
          outstandingPayments.fold(0.0, (sum, payment) => sum + payment.amount);

      isLoading.value = false;
    });
  }
}

class OutstandingPayment {
  final String customerName;
  final String invoiceNumber;
  final double amount;
  final DateTime dueDate;
  final int overdueDays;

  OutstandingPayment({
    required this.customerName,
    required this.invoiceNumber,
    required this.amount,
    required this.dueDate,
    required this.overdueDays,
  });
}
