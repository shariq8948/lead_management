import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.secure = false,
    this.enabled = true,
    this.maxLines = 1,
    this.validator,
    this.passwordField = false,
    this.showPass = false,
    this.showPassFn,
  });

  final String labelText;
  final String hintText;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool secure;
  final bool enabled;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final bool passwordField;
  final bool showPass;
  final Function? showPassFn;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: keyboardType,
      obscureText: passwordField && secure && !showPass,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        suffixIcon: passwordField
            ? GestureDetector(
          onTap: () {
            if (showPassFn != null) {
              showPassFn!();
            }
          },
          child: Icon(
            showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey.shade600,
          ),
        )
            : null,
      ),
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: "JosefinSans",
      ),
    );
  }
}
