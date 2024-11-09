import 'package:get/get.dart';

class Task {
  String taskType;
  String date;
  String assigneeName;
  RxBool isChecked; // Make isChecked an RxBool

  Task({
    required this.taskType,
    required this.date,
    required this.assigneeName,
    bool? isChecked,
  }) : isChecked = (isChecked ?? false).obs; // Initialize as an observable

  // Method to toggle the checked state
  void toggleChecked() {
    isChecked.value = !isChecked.value; // Update the value correctly
  }

  // Optional: Convert Task to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'taskType': taskType,
      'date': date,
      'assigneeName': assigneeName,
      'isChecked': isChecked.value, // Access value for storage
    };
  }

  // Optional: Create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskType: map['taskType'],
      date: map['date'],
      assigneeName: map['assigneeName'],
      isChecked: map['isChecked'] ?? false, // Assign default value if null
    );
  }
}
