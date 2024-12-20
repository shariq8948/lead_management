import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/alltasks/all_task_controller.dart';

class AllTaskPage extends StatelessWidget {
  AllTaskPage({super.key});
  final AllTaskController controller = Get.put(AllTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("All tasks")),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.centerLeft,
            begin: Alignment.centerRight,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        child: Column(
          children: [
            // Filter and Export buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  // Filter button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Filter",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  // Export button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Assign to",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Task List
            // Expanded(child: buildTaskList("Today")),
          ],
        ),
      ),
    );
  }

  Widget buildTaskList(String tabType) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.only(top: 0, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
        ],
      ),
    );
  }
}
