import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTaskCard extends StatelessWidget {
  final String taskType;
  final String date;
  final String assigneeName;
  final RxBool isChecked; // Change to RxBool
  final VoidCallback onNameTap;
  final ValueChanged<bool?> onCheckboxChanged;

  const CustomTaskCard({
    Key? key,
    required this.taskType,
    required this.date,
    required this.assigneeName,
    required this.isChecked,
    required this.onNameTap,
    required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: taskType == "Call" ? Colors.blue : Colors.orange,
            radius: 15,
            child: Icon(
              taskType == "Call" ? Icons.call : Icons.group,
              color: Colors.white,
              size: 18,
            ),
          ),
          SizedBox(width: 24),
          Text(
            date,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          SizedBox(width: 24),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  taskType,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: onNameTap,
                child: Text(
                  assigneeName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Obx(() => Checkbox( // Wrap Checkbox in Obx
            value: isChecked.value,
            onChanged: onCheckboxChanged,
          )),
        ],
      ),
    );
  }
}
