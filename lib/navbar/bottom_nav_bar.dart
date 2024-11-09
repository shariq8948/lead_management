import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Custom shape as background
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: BottomAppBarPainter(),
          ),
        ),
        // Bottom app bar content with icons
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomAppBar(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.black, size: 30),
                  onPressed: () {},
                ),
                SizedBox(width: 30), // Space for the FAB
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        // Center-aligned Floating Action Button
        // Positioned(
        //   bottom: 35,
        //   child: FloatingActionButton(
        //     onPressed: () {},
        //     backgroundColor: Colors.teal,
        //     child: Icon(Icons.add),
        //   ),
        // ),
      ],
    );
  }
}

class BottomAppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFFE1FFED);

    final path = Path();
    // Start from the left side
    path.moveTo(0, 20);
    path.lineTo(size.width * 0.2, 20);

    // Curve up to create the left side of the FAB notch
    path.quadraticBezierTo(
        size.width * 0.1, 20,
        size.width * 0.35, 0
    );

    // Top of the FAB notch
    path.arcToPoint(
      Offset(size.width * 0.65, 0),
      radius: Radius.circular(10),
      clockwise: false,
    );

    // Right side of the FAB notch
    path.quadraticBezierTo(
      size.width * 0.8, 20,
      size.width * 0.8, 20,
    );

    // Continue to the right side
    path.lineTo(size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
