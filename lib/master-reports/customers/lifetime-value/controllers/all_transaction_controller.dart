// transaction_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../views/all_customers.dart';

class TransactionController extends GetxController {
  final Customer customer;

  TransactionController({required this.customer});

  final RxString selectedFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> filteredTransactions =
      <Map<String, dynamic>>[].obs;
  final List<String> filters = ['All', 'Completed', 'Pending', 'Processing'];

  final currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    filteredTransactions.assignAll(customer.transactions);

    // Sort transactions by date (newest first)
    _sortTransactions();

    // Add reaction to filter changes
    ever(selectedFilter, (_) => filterTransactions());
    ever(searchQuery, (_) => filterTransactions());
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void filterTransactions() {
    if (selectedFilter.value == 'All') {
      filteredTransactions.assignAll(customer.transactions
          .where((transaction) => (transaction['product'] as String)
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList());
    } else {
      filteredTransactions.assignAll(customer.transactions
          .where((transaction) =>
              transaction['status'] == selectedFilter.value &&
              (transaction['product'] as String)
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList());
    }

    _sortTransactions();
  }

  void _sortTransactions() {
    filteredTransactions.sort((a, b) {
      final aDate = a['date'] as DateTime;
      final bDate = b['date'] as DateTime;
      return bDate.compareTo(aDate);
    });
  }

  Color getTransactionStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green.shade700;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Processing':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
