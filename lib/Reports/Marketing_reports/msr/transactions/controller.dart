import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

enum TransactionStatus { completed, pending, processing, cancelled }

enum SortOption {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
}

class Transaction {
  final String orderId;
  final String customerName;
  final double amount;
  final DateTime date;
  final String status;
  final String paymentMethod;
  final String shippingAddress;
  final List<OrderItem> items;

  Transaction({
    required this.orderId,
    required this.customerName,
    required this.amount,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class TransactionsController extends GetxController {
  // State variables
  final searchController = TextEditingController();
  final selectedStatus = Rx<TransactionStatus?>(null);
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final sortOption = Rx<SortOption>(SortOption.dateDesc);
  final isLoading = false.obs;
  final transactions = <Transaction>[].obs;
  final filteredTransactions = <Transaction>[].obs;

  // Pagination variables
  final int pageSize = 20;
  final currentPage = 0.obs;
  final hasMoreData = true.obs;

  // Advanced filters
  final selectedPaymentMethods = <String>[].obs;
  final minAmount = Rx<double?>(null);
  final maxAmount = Rx<double?>(null);

  // Search debouncer
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(onSearchChanged);
    fetchInitialTransactions();
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // Fetch initial data
  Future<void> fetchInitialTransactions() async {
    try {
      isLoading.value = true;
      currentPage.value = 0;
      final result = await _fetchTransactionsFromApi(0);
      transactions.assignAll(result);
      applyFilters();
    } catch (e) {
      _handleError('Failed to fetch transactions', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Load more data (pagination)
  Future<void> loadMoreTransactions() async {
    if (!hasMoreData.value || isLoading.value) return;

    try {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      final result = await _fetchTransactionsFromApi(nextPage);

      if (result.isEmpty) {
        hasMoreData.value = false;
      } else {
        currentPage.value = nextPage;
        transactions.addAll(result);
        applyFilters();
      }
    } catch (e) {
      _handleError('Failed to load more transactions', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshTransactions() async {
    try {
      hasMoreData.value = true;
      await fetchInitialTransactions();
    } catch (e) {
      _handleError('Failed to refresh transactions', e);
    }
  }

  // Search functionality
  void onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      applyFilters();
    });
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    applyFilters();
  }

  // Update filters
  void updateStatusFilter(TransactionStatus? status) {
    selectedStatus.value = status;
    applyFilters();
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    if (start != null && end != null && start.isAfter(end)) {
      Get.snackbar(
        'Invalid Date Range',
        'Start date cannot be after end date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    startDate.value = start;
    endDate.value = end;
    applyFilters();
  }

  void updateSortOption(SortOption option) {
    sortOption.value = option;
    applyFilters();
  }

  void updatePaymentMethodFilters(List<String> methods) {
    selectedPaymentMethods.value = methods;
    applyFilters();
  }

  void updateAmountRange(double? min, double? max) {
    if (min != null && max != null && min > max) {
      Get.snackbar(
        'Invalid Amount Range',
        'Minimum amount cannot be greater than maximum amount',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    minAmount.value = min;
    maxAmount.value = max;
    applyFilters();
  }

  // Apply all filters
  void applyFilters() {
    final searchTerm = searchController.text.toLowerCase();

    // Filter the transactions based on the selected filters
    final filtered = transactions.where((transaction) {
      // Status filter
      if (selectedStatus.value != null &&
          transaction.status.toLowerCase() !=
              selectedStatus.value.toString().split('.').last) {
        return false;
      }

      // Date range filter
      if (startDate.value != null &&
          transaction.date.isBefore(startDate.value!)) {
        return false;
      }
      if (endDate.value != null &&
          transaction.date
              .isAfter(endDate.value!.add(const Duration(days: 1)))) {
        return false;
      }

      // Amount range filter (minAmount and maxAmount)
      if (minAmount.value != null && transaction.amount < minAmount.value!) {
        return false;
      }
      if (maxAmount.value != null && transaction.amount > maxAmount.value!) {
        return false;
      }

      // Payment method filter
      if (selectedPaymentMethods.isNotEmpty &&
          !selectedPaymentMethods.contains(transaction.paymentMethod)) {
        return false;
      }

      // Search filter (search by orderId, customerName, or status)
      if (searchTerm.isNotEmpty) {
        return transaction.orderId.toLowerCase().contains(searchTerm) ||
            transaction.customerName.toLowerCase().contains(searchTerm) ||
            transaction.status.toLowerCase().contains(searchTerm);
      }

      return true;
    }).toList();

    // Apply sorting based on selected sort option
    filtered.sort((a, b) {
      switch (sortOption.value) {
        case SortOption.dateDesc:
          return b.date.compareTo(a.date);
        case SortOption.dateAsc:
          return a.date.compareTo(b.date);
        case SortOption.amountDesc:
          return b.amount.compareTo(a.amount);
        case SortOption.amountAsc:
          return a.amount.compareTo(b.amount);
      }
    });

    // Update the filtered transactions list
    filteredTransactions.assignAll(filtered);
  }

  // Export functionality
  Future<void> exportTransactions() async {
    try {
      isLoading.value = true;

      // Prepare CSV data
      List<List<dynamic>> csvData = [
        // Header row
        [
          'Order ID',
          'Customer Name',
          'Amount',
          'Date',
          'Status',
          'Payment Method',
          'Shipping Address'
        ]
      ];

      // Add transaction data
      for (var transaction in filteredTransactions) {
        csvData.add([
          transaction.orderId,
          transaction.customerName,
          transaction.amount,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.date),
          transaction.status,
          transaction.paymentMethod,
          transaction.shippingAddress,
        ]);
      }

      // Convert to CSV
      String csv = const ListToCsvConverter().convert(csvData);

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csv);

      await Share.shareXFiles(
        file.path as List<XFile>,
        text: 'Transactions Export',
        subject: fileName,
      );
    } catch (e) {
      _handleError('Failed to export transactions', e);
    } finally {
      isLoading.value = false;
    }
  }

  // API calls

  Future<List<Transaction>> _fetchTransactionsFromApi(int page) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate a list of mock transactions with varied data
    List<Transaction> transactions = [];

    // Randomly generate different statuses
    List<String> statuses = ['completed', 'pending', 'processing', 'cancelled'];

    // Randomly generate different payment methods
    List<String> paymentMethods = [
      'Credit Card',
      'PayPal',
      'Debit Card',
      'Bank Transfer'
    ];

    Random random = Random();

    for (int i = 0; i < 100; i++) {
      // Adjust to get 400-500 transactions
      transactions.add(
        Transaction(
          orderId: 'ORD-${1000 + page * 100 + i}',
          customerName: _getRandomCustomerName(),
          amount: _getRandomAmount(),
          date: DateTime.now().subtract(Duration(days: random.nextInt(365))),
          status: statuses[random.nextInt(statuses.length)],
          paymentMethod: paymentMethods[random.nextInt(paymentMethods.length)],
          shippingAddress: _getRandomAddress(),
          items: _generateRandomItems(),
        ),
      );
    }

    return transactions;
  }

  String _getRandomCustomerName() {
    List<String> names = [
      'John Doe',
      'Jane Smith',
      'Robert Brown',
      'Emily Davis',
      'Michael Wilson',
      'Sarah Johnson',
      'David Martinez',
      'Jessica Lee',
      'William Garcia',
      'Sophia Clark'
    ];
    return names[Random().nextInt(names.length)];
  }

  double _getRandomAmount() {
    Random random = Random();
    return random.nextDouble() * 100 + 10; // Random amount between 10 and 110
  }

  List<OrderItem> _generateRandomItems() {
    Random random = Random();
    int itemCount = random.nextInt(3) +
        1; // Randomly select between 1 to 3 items per transaction
    List<OrderItem> items = [];

    for (int i = 0; i < itemCount; i++) {
      items.add(
        OrderItem(
          name: _getRandomProductName(),
          quantity: random.nextInt(3) + 1, // Random quantity between 1 and 3
          price:
              _getRandomAmount(), // Use the double value returned from _getRandomAmount
        ),
      );
    }

    return items;
  }

  String _getRandomAddress() {
    List<String> streets = [
      'Main St',
      'Oak St',
      'Pine St',
      'Maple St',
      'Birch St'
    ];
    List<String> cities = ['City', 'Town', 'Village', 'Metropolis', 'Uptown'];
    List<String> countries = [
      'Country',
      'State',
      'Region',
      'Nation',
      'Kingdom'
    ];
    return '${Random().nextInt(1000)} ${streets[Random().nextInt(streets.length)]}, ${cities[Random().nextInt(cities.length)]}, ${countries[Random().nextInt(countries.length)]}';
  }

  String _getRandomProductName() {
    List<String> productNames = [
      'Product 1',
      'Product 2',
      'Product 3',
      'Product 4',
      'Product 5',
      'Product 6',
      'Product 7',
      'Product 8',
      'Product 9',
      'Product 10'
    ];
    return productNames[Random().nextInt(productNames.length)];
  }

  // Error handling
  void _handleError(String message, dynamic error) {
    print('Error: $error'); // For debugging
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
      duration: const Duration(seconds: 3),
    );
  }

  // Helper methods
  String getStatusString(TransactionStatus status) {
    return status.toString().split('.').last;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
