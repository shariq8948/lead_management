import 'package:flutter/material.dart';

import 'constants.dart';

class MyInputTheme {
  TextStyle _buildTextStyle(
      Color color, {
        double size = bodyContentSize,
        FontWeight weight = FontWeight.w500,
      }) {
    return TextStyle(color: color, fontSize: size, fontFamily: "JosefinSans");
  }

  UnderlineInputBorder _buildBorder(Color color) {
    return UnderlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        color: color,
        width: 1.0,
      ),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16),
    isDense: true,
    floatingLabelBehavior: FloatingLabelBehavior.auto,

    // Borders
    enabledBorder: _buildBorder(
      Colors.grey.shade600,
    ),
    focusedBorder: _buildBorder(
      primary1Color,
    ),
    errorBorder: _buildBorder(
      Colors.red,
    ),
    focusedErrorBorder: _buildBorder(
      Colors.red,
    ),
    disabledBorder: _buildBorder(
      Colors.grey.shade400,
    ),

    // TextStyles
    labelStyle: const TextStyle(
      fontSize: 18,
      fontFamily: "JosefinSans",
    ),
    floatingLabelStyle: _buildTextStyle(
      Colors.black,
      size: 18,
      weight: FontWeight.w300,
    ),
    errorStyle: _buildTextStyle(
      Colors.red,
      size: 14,
      weight: FontWeight.w400,
    ),
    helperStyle: _buildTextStyle(
      Colors.black,
      size: 14,
      weight: FontWeight.w300,
    ),
  );
}
