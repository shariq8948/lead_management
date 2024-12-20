import 'package:flutter/material.dart';

class NotchedRectangleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: CustomPaint(
          size: Size(200, 80), // Adjust the size as needed
          painter: NotchedRectanglePainter(),
        ),
      ),
    );
  }
}

class NotchedRectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;

    final path = Path();

    // Start from the top-left corner of the main rectangle
    path.moveTo(30, 0);

    // Left side with notch
    path.lineTo(15, 0);  // Starting point for the notch
    path.quadraticBezierTo(5, size.height * 0.65, 0, size.height * 0.5);  // Top curve of notch
    path.quadraticBezierTo(5, size.height * 0.75, 18, size.height);  // Bottom curve of notch

    // Bottom edge with rounded corner
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 20);

    // Right edge with rounded corner
    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);

    // Top edge
    path.lineTo(30, 0);

    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void main() {
  runApp(MaterialApp(
    home: NotchedRectangleWidget(),
  ));
}
