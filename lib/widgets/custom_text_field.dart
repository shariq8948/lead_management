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
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
    this.passwordField = false,
    this.showPass = false,
    this.showPassFn,
    this.icon,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.fillColor,
    this.borderRadius = 12.0,
  });

  final String labelText;
  final String hintText;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool secure;
  final bool enabled;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;
  final bool passwordField;
  final bool showPass;
  final Function? showPassFn;
  final Icon? icon;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: textController,
      keyboardType: keyboardType,
      obscureText: passwordField && secure && !showPass,
      enabled: enabled,
      maxLines: maxLines,
      textInputAction: textInputAction,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: "JosefinSans",
      ),
      decoration: InputDecoration(
        labelText: labelText,
        focusColor: Colors.white,
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey.shade500),
        labelStyle: labelStyle ??
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: fillColor ?? Colors.grey.shade100,
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
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
                  showPass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade600,
                ),
              )
            : null,
      ),
    );
  }
}
