import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads/master-reports/customers/lifetime-value/views/transaction_details.dart';
import 'dart:math' as math;
import '../../../widgets/page_wrapper.dart';
// transaction_controller.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'all_customers.dart';

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

// all_transactions_page.dart

class AllTransactionsPage extends StatelessWidget {
  final Customer customer;

  const AllTransactionsPage({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller with the customer data
    final TransactionController controller =
        Get.put(TransactionController(customer: customer));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Transactions',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) => controller.setSearch(value),
                    decoration: InputDecoration(
                      hintText: 'Search transactions',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.filters.length,
                    itemBuilder: (context, index) {
                      final filter = controller.filters[index];
                      return Obx(() => _buildFilterChip(filter, controller));
                    },
                  ),
                ),
              ],
            ),
          ),

          // Transactions summary card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildTransactionsSummary(controller),
          ),

          const SizedBox(height: 16),

          // Transactions list
          Expanded(
            child: Obx(() => controller.filteredTransactions.isEmpty
                ? _buildEmptyState()
                : _buildTransactionsList(controller)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, TransactionController controller) {
    final isSelected = controller.selectedFilter.value == filter;

    return GestureDetector(
      onTap: () => controller.setFilter(filter),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          filter,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsSummary(TransactionController controller) {
    return Obx(() {
      // Calculate total amount of filtered transactions
      final totalAmount = controller.filteredTransactions.fold<double>(
        0,
        (total, transaction) => total + (transaction['amount'] as double),
      );

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total ${controller.selectedFilter.value} Transactions',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.currencyFormat.format(totalAmount),
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${controller.filteredTransactions.length} Transactions',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Found',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(TransactionController controller) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredTransactions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final transaction = controller.filteredTransactions[index];
        final date = transaction['date'] as DateTime;
        final amount = transaction['amount'] as double;
        final product = transaction['product'] as String;
        final status = transaction['status'] as String;

        return GestureDetector(
          onTap: () {
            // Navigate to transaction detail page
            Get.to(() => TransactionDetailPage(
                  transaction: transaction,
                  customer: controller.customer,
                ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Transaction icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_outlined,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMM, yyyy').format(date),
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: controller
                                  .getTransactionStatusColor(status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: controller
                                    .getTransactionStatusColor(status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Amount
                Text(
                  controller.currencyFormat.format(amount),
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
