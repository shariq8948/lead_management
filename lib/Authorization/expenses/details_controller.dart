import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseDetailsController extends GetxController {
  final Rx<ExpenseDetails> expenseDetails = ExpenseDetails(
    id: 'EXP001',
    name: 'Muskan Shaikh',
    date: DateTime.now(),
    city: 'Mumbai',
    state: 'Maharashtra',
    area: 'Andheri',
    fromDate: DateTime.now().subtract(const Duration(days: 6)),
    toDate: DateTime.now(),
    expenses: {
      'Hotel': ExpenseItem(proposed: 100.0, checker: 80.0, finalAmount: 90.0),
      'Food': ExpenseItem(proposed: 200.0, checker: 180.0, finalAmount: 190.0),
      'Traveling':
          ExpenseItem(proposed: 300.0, checker: 250.0, finalAmount: 270.0),
      'Local Traveling':
          ExpenseItem(proposed: 150.0, checker: 130.0, finalAmount: 140.0),
    },
    remark: 'No comments'.obs,
    status: 'Pending'.obs,
  ).obs;

  void updateFinalExpense(String category, double value) {
    expenseDetails.value.expenses[category]?.finalAmount = value;
    expenseDetails.refresh();
  }

  void updateRemark(String value) {
    expenseDetails.value.remark.value = value;
  }

  void approveExpense() {
    expenseDetails.value.status.value = 'Approved';
  }

  double get totalProposedExpense {
    return expenseDetails.value.expenses.values
        .map((item) => item.proposed)
        .reduce((a, b) => a + b);
  }

  double get totalCheckerExpense {
    return expenseDetails.value.expenses.values
        .map((item) => item.checker)
        .reduce((a, b) => a + b);
  }

  double get totalFinalExpense {
    return expenseDetails.value.expenses.values
        .map((item) => item.finalAmount)
        .reduce((a, b) => a + b);
  }

  void loadExpenseDetails(ExpenseDetails details) {
    expenseDetails.value = details;
  }
}

// Existing models remain the same
class ExpenseDetails {
  final String id;
  final String name;
  final DateTime date;
  final String city;
  final String state;
  final String area;
  final DateTime fromDate;
  final DateTime toDate;
  final Map<String, ExpenseItem> expenses;
  final RxString remark;
  final RxString status;

  ExpenseDetails({
    required this.id,
    required this.name,
    required this.date,
    required this.city,
    required this.state,
    required this.area,
    required this.fromDate,
    required this.toDate,
    required this.expenses,
    required this.remark,
    required this.status,
  });
}

class ExpenseItem {
  double proposed;
  double checker;
  double finalAmount; // Renamed from 'final'

  ExpenseItem({
    required this.proposed,
    required this.checker,
    required this.finalAmount, // Update constructor
  });
}
