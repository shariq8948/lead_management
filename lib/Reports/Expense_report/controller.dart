// controller.dart
import 'package:get/get.dart';

class ExpenseReport {
  final String id;
  final String category;
  final double amount;
  final DateTime date;
  final String description;
  final String paymentMethod;
  final String status;

  ExpenseReport({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
    required this.paymentMethod,
    required this.status,
  });
}

class ExpensesController extends GetxController {
  final RxList<ExpenseReport> expenses = <ExpenseReport>[].obs;
  final RxList<ExpenseReport> filteredExpenses = <ExpenseReport>[].obs;

  // Filter observables
  final RxString selectedCategory = ''.obs;
  final RxString selectedPaymentMethod = ''.obs;
  final RxString selectedStatus = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxDouble minAmount = 0.0.obs;
  final RxDouble maxAmount = double.infinity.obs;

  // Computed getters
  double get totalExpenses =>
      filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);

  // New getter for current month expenses
  double get currentMonthExpenses {
    final now = DateTime.now();
    return filteredExpenses
        .where((expense) =>
            expense.date.year == now.year && expense.date.month == now.month)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    loadExpenses();
    // Apply initial filtering
    applyFilters();
  }

  void loadExpenses() {
    // Sample data - replace with actual data loading logic
    expenses.value = [
      ExpenseReport(
        id: '1',
        category: 'Travel',
        amount: 250.0,
        date: DateTime.now(),
        description: 'Client meeting travel expenses',
        paymentMethod: 'Credit Card',
        status: 'Approved',
      ),
      ExpenseReport(
        id: '2',
        category: 'Office Supplies',
        amount: 100.0,
        date: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Printer paper and ink cartridges',
        paymentMethod: 'Cash',
        status: 'Pending',
      ),
      ExpenseReport(
        id: '3',
        category: 'Meals',
        amount: 75.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Team lunch meeting',
        paymentMethod: 'Credit Card',
        status: 'Approved',
      ),
    ];
  }

  void addExpense(ExpenseReport expense) {
    expenses.add(expense);
    applyFilters();
  }

  void deleteExpense(String id) {
    expenses.removeWhere((expense) => expense.id == id);
    applyFilters();
  }

  void updateExpense(ExpenseReport updatedExpense) {
    final index =
        expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      expenses[index] = updatedExpense;
      applyFilters();
    }
  }

  void applyFilters() {
    filteredExpenses.value = expenses.where((expense) {
      // Category filter
      if (selectedCategory.value.isNotEmpty &&
          expense.category != selectedCategory.value) {
        return false;
      }

      // Payment method filter
      if (selectedPaymentMethod.value.isNotEmpty &&
          expense.paymentMethod != selectedPaymentMethod.value) {
        return false;
      }

      // Status filter
      if (selectedStatus.value.isNotEmpty &&
          expense.status != selectedStatus.value) {
        return false;
      }

      // Date range filter
      if (startDate.value != null && expense.date.isBefore(startDate.value!)) {
        return false;
      }
      if (endDate.value != null && expense.date.isAfter(endDate.value!)) {
        return false;
      }

      // Amount range filter
      if (expense.amount < minAmount.value ||
          expense.amount > maxAmount.value) {
        return false;
      }

      return true;
    }).toList();
  }

  void resetFilters() {
    selectedCategory.value = '';
    selectedPaymentMethod.value = '';
    selectedStatus.value = '';
    startDate.value = null;
    endDate.value = null;
    minAmount.value = 0.0;
    maxAmount.value = double.infinity;
    applyFilters();
  }

  // Helper methods for stats and analysis
  Map<String, double> getCategoryTotals() {
    final totals = <String, double>{};
    for (final expense in filteredExpenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  Map<String, double> getMonthlyTotals() {
    final totals = <String, double>{};
    for (final expense in filteredExpenses) {
      final monthKey = '${expense.date.year}-${expense.date.month}';
      totals[monthKey] = (totals[monthKey] ?? 0) + expense.amount;
    }
    return totals;
  }
}
