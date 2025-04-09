import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomProgressIndicator extends StatefulWidget {
  final double progress; // Progress percentage (0.0 to 1.0)
  final String label; // Description of the progress (e.g., "Tasks Completed")

  const CustomProgressIndicator({
    Key? key,
    required this.progress,
    required this.label,
  }) : super(key: key);

  @override
  _CustomProgressIndicatorState createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${(widget.progress * 100).toInt()}%", // Show progress percentage
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Custom Progress Bar
          Stack(
            children: [
              // Background Bar
              Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
              ),
              // Gradient Progress
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 30,
                width: MediaQuery.of(context).size.width * widget.progress,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.green],
                  ),
                ),
              ),
              // Milestone Icons
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.progress >= 0.25)
                      Icon(Icons.flag, color: Colors.yellow, size: 16),
                    if (widget.progress >= 0.5)
                      Icon(Icons.star, color: Colors.blue, size: 16),
                    if (widget.progress >= 0.75)
                      Icon(Icons.emoji_events, color: Colors.red, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.teal),
            SizedBox(width: 8),
            Text("Progress Details"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You are ${(widget.progress * 100).toInt()}% towards your goal.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 14,
              percent: widget.progress,
              progressColor: Colors.teal,
              backgroundColor: Colors.grey.shade300,
              center: Text(
                "${(widget.progress * 100).toInt()}%",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // This replaces Navigator.pop(context)
            child: Text("Close", style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }
}
