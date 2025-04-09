import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;

  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.tooltip = '',
    this.backgroundColor = Colors.teal,
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      tooltip: tooltip,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.tealAccent.withOpacity(1)),
          borderRadius: BorderRadius.circular(100)),

      elevation: 10, // Adds a shadow for a floating effect
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
