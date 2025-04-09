import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Expense Model
class Expense {
  final String id;
  final String name;
  final DateTime date;
  final String address;
  final double amount;
  final String status;

  Expense({
    required this.id,
    required this.name,
    required this.date,
    required this.address,
    required this.amount,
    this.status = 'Pending',
  });
}

// Expense Controller
class ExpenseController extends GetxController {
  final RxList<Expense> expenses = <Expense>[].obs;
  final RxBool isLoading = false.obs;
  final RxString filterStatus = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  void fetchExpenses() {
    // Simulated data fetch - replace with actual API call
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      expenses.value = List.generate(
        20,
        (index) => Expense(
          id: 'EXP${index + 1}',
          name: 'Muskan Shaikh',
          date: DateTime.now(),
          address: 'RoyalPalm, Goregaon East, Mumbai, Maharashtra',
          amount: 2056.0 + index * 10,
          status: index % 3 == 0 ? 'Approved' : 'Pending',
        ),
      );
      isLoading.value = false;
    });
  }

  List<Expense> get filteredExpenses {
    if (filterStatus.value == 'All') return expenses;
    return expenses.where((exp) => exp.status == filterStatus.value).toList();
  }

  void changeFilter(String status) {
    filterStatus.value = status;
  }
}
