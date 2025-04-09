import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ExpenseTrackingController extends GetxController {
  var isLoading = true.obs;
  var dateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  var totalExpenses = 0.0.obs;
  var expenseCategories = <ExpenseCategoryData>[].obs;
  var selectedCategory = Rx<ExpenseCategoryData?>(null);
  var expenses = <ExpenseData>[].obs;
  var selectedView = 'Categories'.obs; // 'Categories' or 'Transactions'

  @override
  void onInit() {
    super.onInit();
    fetchExpenseData();
  }

  void fetchExpenseData() {
    isLoading.value = true;

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // In a real app, you would fetch this data from your API
      expenseCategories.value = [
        ExpenseCategoryData(
          name: 'Marketing',
          amount: 12450.00,
          percentage: 26.2,
          color: Colors.blue.shade600,
          icon: Icons.campaign_outlined,
        ),
        ExpenseCategoryData(
          name: 'Operations',
          amount: 9850.00,
          percentage: 20.7,
          color: Colors.green.shade600,
          icon: Icons.business_center_outlined,
        ),
        ExpenseCategoryData(
          name: 'Salaries',
          amount: 18600.00,
          percentage: 39.1,
          color: Colors.purple.shade600,
          icon: Icons.people_outline,
        ),
        ExpenseCategoryData(
          name: 'Office Supplies',
          amount: 2850.00,
          percentage: 6.0,
          color: Colors.orange.shade600,
          icon: Icons.shopping_bag_outlined,
        ),
        ExpenseCategoryData(
          name: 'Travel',
          amount: 3800.00,
          percentage: 8.0,
          color: Colors.teal.shade600,
          icon: Icons.flight_outlined,
        ),
      ];

      expenses.value = [
        ExpenseData(
          description: 'Google Ads Campaign',
          category: 'Marketing',
          amount: 2500.00,
          date: DateTime.now().subtract(const Duration(days: 2)),
          paymentMethod: 'Credit Card',
        ),
        ExpenseData(
          description: 'Staff Salaries - March',
          category: 'Salaries',
          amount: 9300.00,
          date: DateTime.now().subtract(const Duration(days: 3)),
          paymentMethod: 'Bank Transfer',
        ),
        ExpenseData(
          description: 'Office Rent',
          category: 'Operations',
          amount: 3500.00,
          date: DateTime.now().subtract(const Duration(days: 5)),
          paymentMethod: 'Bank Transfer',
        ),
        ExpenseData(
          description: 'Facebook Ads',
          category: 'Marketing',
          amount: 1800.00,
          date: DateTime.now().subtract(const Duration(days: 7)),
          paymentMethod: 'Credit Card',
        ),
        ExpenseData(
          description: 'Business Trip - Client Meeting',
          category: 'Travel',
          amount: 1250.00,
          date: DateTime.now().subtract(const Duration(days: 10)),
          paymentMethod: 'Company Card',
        ),
        ExpenseData(
          description: 'Office Supplies',
          category: 'Office Supplies',
          amount: 850.00,
          date: DateTime.now().subtract(const Duration(days: 12)),
          paymentMethod: 'Credit Card',
        ),
        ExpenseData(
          description: 'Utilities - March',
          category: 'Operations',
          amount: 1200.00,
          date: DateTime.now().subtract(const Duration(days: 15)),
          paymentMethod: 'Bank Transfer',
        ),
        ExpenseData(
          description: 'Contractor Payments',
          category: 'Salaries',
          amount: 4800.00,
          date: DateTime.now().subtract(const Duration(days: 18)),
          paymentMethod: 'Bank Transfer',
        ),
      ];

      // Calculate total expenses
      totalExpenses.value =
          expenseCategories.fold(0.0, (sum, category) => sum + category.amount);

      isLoading.value = false;
    });
  }

  void onDateRangeSelected(DateTimeRange? range) {
    if (range != null) {
      dateRange.value = range;
      fetchExpenseData();
    }
  }

  void selectCategory(ExpenseCategoryData? category) {
    selectedCategory.value = category;
    if (category != null) {
      expenses.value = expenses
          .where((expense) => expense.category == category.name)
          .toList();
    } else {
      fetchExpenseData(); // Reset to show all expenses
    }
  }

  void toggleView(String view) {
    selectedView.value = view;
  }

  void filterByPaymentMethod(String method) {
    expenses.value =
        expenses.where((expense) => expense.paymentMethod == method).toList();
  }

  Color getCategoryColor(String categoryName) {
    final category = expenseCategories.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => ExpenseCategoryData(
        name: categoryName,
        amount: 0,
        percentage: 0,
        color: Colors.grey,
        icon: Icons.category_outlined,
      ),
    );
    return category.color;
  }

  IconData getCategoryIcon(String categoryName) {
    final category = expenseCategories.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => ExpenseCategoryData(
        name: categoryName,
        amount: 0,
        percentage: 0,
        color: Colors.grey,
        icon: Icons.category_outlined,
      ),
    );
    return category.icon;
  }
}

class ExpenseCategoryData {
  final String name;
  final double amount;
  final double percentage;
  final Color color;
  final IconData icon;

  ExpenseCategoryData({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

class ExpenseData {
  final String description;
  final String category;
  final double amount;
  final DateTime date;
  final String paymentMethod;

  ExpenseData({
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });
}
