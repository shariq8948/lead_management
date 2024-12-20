import 'package:get/get.dart';

import '../data/models/taskModel.dart';

class AllTaskController extends GetxController{
  RxList<Task> tasks = <Task>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Initialize your tasks here
    tasks.addAll([
      Task(taskType: "Call", date: "2024-10-28", assigneeName: "Alice"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Call", date: "2024-10-28", assigneeName: "Alice"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Call", date: "2024-10-28", assigneeName: "Alice"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Call", date: "2024-10-28", assigneeName: "Alice"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Call", date: "2024-10-28", assigneeName: "Alice"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "Meeting", date: "2024-10-29", assigneeName: "Bob"),
      Task(taskType: "new", date: "2024-10-29", assigneeName: "Bob"),
    ]);
  }
  void onCheckboxChanged(int index, bool? newValue) {
    // Update the isChecked state of the specified task

    print(newValue);
    tasks[index].isChecked.value = newValue ?? false; // Use .value to update
    print(    tasks[index].isChecked.value
    );
    // Notify the UI to refresh (this is automatic with Obx)
    // No need for refresh here; GetX handles the reactivity
  }

}