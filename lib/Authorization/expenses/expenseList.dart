import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller.dart';
import 'expenseDetails.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.put(ExpenseController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // TODO: Implement add expense functionality
            },
          ),
        ],
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Color(0xFF6A11CB),
        //       Color(0xFF2575FC),
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        child: Column(
          children: [
            _buildFilterSection(controller),
            Expanded(
              child: _buildExpenseList(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(ExpenseController controller) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _filterChip(controller, 'All'),
          _filterChip(controller, 'Pending'),
          _filterChip(controller, 'Approved'),
        ],
      ),
    );
  }

  Widget _filterChip(ExpenseController controller, String status) {
    return Obx(() => ChoiceChip(
          label: Text(status),
          selected: controller.filterStatus.value == status,
          onSelected: (_) => controller.changeFilter(status),
          selectedColor: Colors.white,
          backgroundColor: Colors.white24,
          labelStyle: TextStyle(
            color: controller.filterStatus.value == status
                ? Colors.deepPurple
                : Colors.grey,
          ),
        ));
  }

  Widget _buildExpenseList(ExpenseController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: controller.filteredExpenses.length,
        itemBuilder: (context, index) {
          final expense = controller.filteredExpenses[index];
          return _expenseCard(expense, context);
        },
      );
    });
  }

  Widget _expenseCard(Expense expense, BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to Expense Details Page
          Get.to(() => ExpenseDetailsPage());
        },
        borderRadius: BorderRadius.circular(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardHeader(expense),
                _cardBody(expense),
                _cardFooter(expense, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardHeader(Expense expense) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            expense.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Colors.deepOrange,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd/MM/yyyy').format(expense.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardBody(Expense expense) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Text(
        expense.address,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _cardFooter(Expense expense, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.currency_rupee,
                color: Colors.deepPurple,
                size: 18,
              ),
              Text(
                expense.amount.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: expense.status == 'Approved'
                  ? Colors.green.shade100
                  : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              expense.status,
              style: TextStyle(
                color: expense.status == 'Approved'
                    ? Colors.green.shade800
                    : Colors.orange.shade800,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
