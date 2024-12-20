import 'package:flutter/material.dart';
class CustomField2 extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextEditingController editingController;
  final bool showLabel;
  final Function(String?) onChange;
  final double fieldHeight;
  final EdgeInsetsGeometry contentPadding;

  CustomField2({
    required this.hintText,
    required this.labelText,
    required this.inputAction,
    required this.inputType,
    required this.editingController,
    required this.showLabel,
    required this.onChange,
    required this.fieldHeight,
    required this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fieldHeight, // Set the height of the field
      child: TextField(
        controller: editingController,
        keyboardType: inputType,
        textInputAction: inputAction,
        decoration: InputDecoration(
          labelText: showLabel ? labelText : null,
          hintText: hintText,
          contentPadding: contentPadding, // Adjust the padding
        ),
        onChanged: onChange,
      ),
    );
  }
}
