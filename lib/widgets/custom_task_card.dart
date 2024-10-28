import 'package:flutter/material.dart';
class CustomTaskCard extends StatelessWidget {
  final String taskType;
  final String date;
  final String assigneeName;
  final bool isChecked;
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

          // Date Text
          Text(
            date,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          SizedBox(width: 24),

          // Task Type (Fixed Position) and Assignee Name
          Row(
            children: [
              // Fixed width for Task Type
              SizedBox(
                width: 80, // Adjust width as needed
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

              // Assignee Name
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

          // Checkbox for task completion
          Spacer(),
          Checkbox(
            value: isChecked,
            onChanged: onCheckboxChanged,
          ),
        ],
      ),
    );
  }
}
