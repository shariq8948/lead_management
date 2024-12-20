import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomTaskCard extends StatelessWidget {
  final String taskType;
  final String date;
  final String assigneeName;
  final VoidCallback onNameTap;
  final ValueChanged<bool?>? onCheckboxChanged; // Make this optional
  final RxBool? isChecked; // Make this optional

  const CustomTaskCard({
    Key? key,
    required this.taskType,
    required this.date,
    required this.assigneeName,
    required this.onNameTap,
    this.onCheckboxChanged, // Mark as optional
    this.isChecked, // Mark as optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 15,
                child: SvgPicture.asset(
                  _getBadgeIcon(taskType), // Path to your SVG file
                  fit: BoxFit.contain,
                  width: 20, // Adjust the size as needed
                  height: 20,
                ),
              ),
            ),            SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: Text(
                date,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: Text(
                taskType,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: onNameTap,
              child: Container(
                constraints: BoxConstraints(maxWidth: 100),
                child: Text(
                  assigneeName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Spacer(),
            if (isChecked != null && onCheckboxChanged != null) // Conditional rendering
              Obx(() => Expanded(
                child: Checkbox(
                  value: isChecked!.value, // Use non-null assertion here
                  onChanged: onCheckboxChanged,
                ),
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
        return "assets/icons/meeting.svg";
      default:
        return "assets/icons/todo.svg";
    }
  }
  Color _getBadgeColor(String leadType) {
    switch (leadType.toLowerCase()) {
      case 'CallActivity':
        return Colors.blue;
      case 'FollowUp':
        return Colors.orange;
      case 'Meeting':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


}
