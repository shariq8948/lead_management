import 'package:flutter/material.dart';

class ReportCategory {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  ReportCategory({
    required this.label,
    required this.icon,
    this.onTap,
  });
}
