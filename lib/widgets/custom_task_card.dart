import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomTaskCard extends StatelessWidget {
  final String taskType;
  final String date;
  final String assigneeName;
  final VoidCallback onNameTap;
  final ValueChanged<bool?>? onCheckboxChanged; // Optional
  final RxBool? isChecked; // Optional

  const CustomTaskCard({
    Key? key,
    required this.taskType,
    required this.date,
    required this.assigneeName,
    required this.onNameTap,
    this.onCheckboxChanged,
    this.isChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Badge
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 18,
              child: SvgPicture.asset(
                _getBadgeIcon(taskType),
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Date
            SizedBox(
              width: 80,
              child: Text(
                date,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 12),

            // Task Type
            Expanded(
              child: Text(
                taskType,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),

            const SizedBox(width: 12),

            // Assignee Name
            Expanded(
              child: GestureDetector(
                onTap: onNameTap,
                child: Text(
                  assigneeName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Checkbox (only if required)
            if (isChecked != null && onCheckboxChanged != null)
              Obx(() => Checkbox(
                    value: isChecked!.value,
                    onChanged: onCheckboxChanged,
                  )),
          ],
        ),
      ),
    );
  }

  String _getBadgeIcon(String type) {
    switch (type) {
      case 'CallActivity':
        return "assets/icons/call.svg";
      case 'FollowUp':
        return "assets/icons/followup.svg";
      case 'Meeting':
        return "assets/icons/meeting.svg";
      case 'MyTodo':
        return "assets/icons/todo.svg";
      default:
        return "assets/icons/todo.svg";
    }
  }
}
