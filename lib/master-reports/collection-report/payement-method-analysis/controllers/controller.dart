import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PaymentMethodAnalysisController extends GetxController {
  var isLoading = true.obs;
  var dateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  var totalTransactions = 0.obs;
  var totalRevenue = 0.0.obs;
  var paymentMethods = <PaymentMethodData>[].obs;
  var selectedTimeFrame = 'Monthly'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethodData();
  }

  void fetchPaymentMethodData() {
    isLoading.value = true;

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // In a real app, you would fetch this data from your API
      paymentMethods.value = [
        PaymentMethodData(
          method: 'Credit Card',
          amount: 28750.00,
          transactions: 143,
          icon: Icons.credit_card,
          color: Colors.blue.shade700,
        ),
        PaymentMethodData(
          method: 'Bank Transfer',
          amount: 18450.00,
          transactions: 62,
          icon: Icons.account_balance,
          color: Colors.green.shade600,
        ),
        PaymentMethodData(
          method: 'Digital Wallet',
          amount: 12380.00,
          transactions: 97,
          icon: Icons.account_balance_wallet,
          color: Colors.purple.shade600,
        ),
        PaymentMethodData(
          method: 'Cash',
          amount: 5200.00,
          transactions: 41,
          icon: Icons.money,
          color: Colors.amber.shade600,
        ),
        PaymentMethodData(
          method: 'Check',
          amount: 3650.00,
          transactions: 16,
          icon: Icons.payments_outlined,
          color: Colors.brown.shade500,
        ),
      ];

      // Calculate totals
      totalTransactions.value =
          paymentMethods.fold(0, (sum, method) => sum + method.transactions);

      totalRevenue.value =
          paymentMethods.fold(0.0, (sum, method) => sum + method.amount);

      isLoading.value = false;
    });
  }

  void onDateRangeSelected(DateTimeRange? range) {
    if (range != null) {
      dateRange.value = range;
      fetchPaymentMethodData();
    }
  }

  void changeTimeFrame(String timeFrame) {
    selectedTimeFrame.value = timeFrame;
    fetchPaymentMethodData();
  }
}

class PaymentMethodData {
  final String method;
  final double amount;
  final int transactions;
  final IconData icon;
  final Color color;

  PaymentMethodData({
    required this.method,
    required this.amount,
    required this.transactions,
    required this.icon,
    required this.color,
  });

  double get percentage =>
      (transactions / 1) * 100; // Placeholder, will be calculated in UI
}
