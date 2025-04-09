import 'package:flutter/material.dart';

// Custom Save Button Widget
class CustomSaveButton extends StatelessWidget {
  final String buttonText; // Text displayed on the button
  final VoidCallback onPressed; // Action to be performed on button press
  final Color? buttonColor; // Color of the button (default is teal)
  final TextStyle? textStyle; // Custom text style (optional)

  CustomSaveButton({
    required this.buttonText,
    required this.onPressed,
    this.buttonColor = Colors.teal, // Default to teal color
    this.textStyle, // Optional, allows passing custom text style
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make the button take full width
      child: ElevatedButton(
        onPressed: onPressed, // Action when button is pressed
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Background color of the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 16), // Padding inside button
        ),
        child: Text(
          buttonText,
          style: textStyle ??
              TextStyle(
                color: Colors.white, // Default text color is white
                fontSize: 16, // Default text size
                fontWeight: FontWeight.bold, // Bold text
              ),
        ),
      ),
    );
  }
}
