import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;
  final String priority;
  final String leadName;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
    required this.leadName,
  });
}

// task_controller.dart

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> toDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    try {
      // Simulate API call with delay
      await Future.delayed(Duration(seconds: 1));

      // Replace this with your actual API call
      tasks.value = [
        Task(
          id: '1',
          title: 'Follow up with client',
          description: 'Call regarding proposal discussion',
          dueDate: DateTime.now(),
          status: 'pending',
          priority: 'high',
          leadName: 'John Doe',
        ),
        // Add more sample tasks
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tasks');
    } finally {
      isLoading.value = false;
    }
  }

  List<Task> get filteredTasks {
    return tasks.where((task) {
      bool dateFilter = true;
      if (fromDate.value != null) {
        dateFilter = dateFilter && task.dueDate.isAfter(fromDate.value!);
      }
      if (toDate.value != null) {
        dateFilter = dateFilter &&
            task.dueDate.isBefore(toDate.value!.add(Duration(days: 1)));
      }

      switch (selectedFilter.value) {
        case 'pending':
          return dateFilter && task.status == 'pending';
        case 'completed':
          return dateFilter && task.status == 'completed';
        default:
          return dateFilter;
      }
    }).toList();
  }

  void updateDateRange(DateTime? from, DateTime? to) {
    fromDate.value = from;
    toDate.value = to;
  }
}
