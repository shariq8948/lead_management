import 'package:flutter/material.dart';

class ProgressBarCard extends StatelessWidget {
  final String title;
  final double progress; // Progress as a percentage (0-100)

  const ProgressBarCard({
    Key? key,
    required this.title,
    required this.progress,
  }) : super(key: key);

  Gradient _getDynamicGradient(double progress) {
    // Define the start and end colors
    Color startColor = Color(0xFFDB8536); // #DB8536
    Color endColor = Color(0xFFFCB500); // #FCB500 (not including opacity for full color)

    // Calculate the current end color with opacity based on progress
    Color currentEndColor = Color.lerp(endColor.withOpacity(0), endColor.withOpacity(0.82), progress / 100)!;

    return LinearGradient(
      colors: [
        startColor,
        currentEndColor,
      ],
      stops: [0.0, progress / 100], // Control the transition based on progress
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 14),
                  ),
                  child: Text("View All"),
                ),

              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Background container with light grey color
                      Container(
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3), // Light grey for unprogressed part
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // Foreground container with dynamic gradient for the progress section
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                            gradient: _getDynamicGradient(progress),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress / 100, // Show only the percentage of the gradient
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "${progress.toInt()}%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
