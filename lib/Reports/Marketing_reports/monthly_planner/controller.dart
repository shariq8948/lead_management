import 'package:get/get.dart';

class Employee {
  final String id;
  final String name;
  final String department;
  final List<Task> tasks;

  Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.tasks,
  });
}

class Task {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String priority;

  Task({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.priority,
  });
}

class MonthlyPlannerController extends GetxController {
  final employees = <Employee>[].obs;
  final filteredEmployees = <Employee>[].obs;
  final selectedDate = DateTime.now().obs;
  final searchQuery = ''.obs;
  final selectedDepartment = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  void fetchEmployees() {
    // Simulate API call
    isLoading.value = true;
    Future.delayed(Duration(seconds: 2), () {
      employees.value = [
        Employee(
          id: '1',
          name: 'John Doe',
          department: 'Sales',
          tasks: [
            Task(
              id: '1',
              title: 'Client Meeting',
              startDate: DateTime.now(),
              endDate: DateTime.now().add(Duration(hours: 2)),
              status: 'Pending',
              priority: 'High',
            ),
          ],
        ),
        // Add more sample employees
      ];
      filteredEmployees.value = employees;
      isLoading.value = false;
    });
  }

  void searchEmployees(String query) {
    searchQuery.value = query;
    filterEmployees();
  }

  void filterByDepartment(String department) {
    selectedDepartment.value = department;
    filterEmployees();
  }

  void filterEmployees() {
    filteredEmployees.value = employees.where((employee) {
      bool matchesSearch =
          employee.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesDepartment = selectedDepartment.isEmpty ||
          employee.department == selectedDepartment.value;
      return matchesSearch && matchesDepartment;
    }).toList();
  }

  void changeMonth(int months) {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + months,
      selectedDate.value.day,
    );
  }
}
