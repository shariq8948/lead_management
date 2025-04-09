import 'package:flutter/material.dart';

class ReportConstants {
  // Report Section Types
  static const List<String> reportSections = [
    'Sales Performance',
    'Lead Lifecycle',
    'Customer Insights',
    'Team Performance',
    'Quotation Analytics',
    'Financial Reports',
    'Payment Collection',
    'Expense Analysis'
  ];

  // Report Metrics Mapping
  static const Map<String, List<String>> reportMetrics = {
    'Sales Performance': [
      'Revenue Trends',
      'Sales by Category',
      'Comparison to Targets',
      'Order Fulfillment Rates'
    ],
    'Lead Lifecycle': [
      'Conversion Rates',
      'Average Stage Time',
      'Bottleneck Identification',
      'Drop-off Analysis'
    ],
    'Customer Insights': [
      'Acquisition Cost',
      'Lifetime Value',
      'Repeat Purchase Patterns',
      'Customer Segmentation'
    ],
    'Team Performance': [
      'Individual Metrics',
      'Lead Handling Stats',
      'Activity Metrics',
      'Performance vs Targets'
    ],
    'Quotation Analytics': [
      'Quotation to Order Conversion',
      'Average Quotation Time',
      'Lost Quotation Reasons',
      'Discount Analysis'
    ],
    'Financial Reports': [
      'Revenue by Product/Segment/provinence',
      'Projected vs Actual Revenue',
      'Quarterly Comparisons',
      'Seasonal Trends'
    ],
    'Payment Collection': [
      'Payment Status',
      'Aging Receivables',
      'Payment Method Analysis',
      'Outstanding Payments'
    ],
    'Expense Analysis': [
      'Expense Tracking',
      'Expense Approval Status',
      'Marketing Expense ROI',
      'Budget Variance'
    ]
  };

  // Color Palette for Reports
  static const Color primaryColor = Color(0xFF3F51B5);
  static const Color secondaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFFFF4081);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);

  // Icons for Report Sections
  static const Map<String, IconData> sectionIcons = {
    'Sales Performance': Icons.trending_up,
    'Lead Lifecycle': Icons.account_tree_outlined,
    'Customer Insights': Icons.people_alt_outlined,
    'Team Performance': Icons.assessment_outlined,
    'Quotation Analytics': Icons.request_quote_outlined,
    'Financial Reports': Icons.attach_money_outlined,
    'Payment Collection': Icons.payments_outlined,
    'Expense Analysis': Icons.money_off_outlined
  };
}

// Enum for Report Time Ranges
enum ReportTimeRange { daily, weekly, monthly, quarterly, yearly }

// Enum for Report Visualization Types
enum ReportVisualizationType { barChart, lineChart, pieChart, table, heatMap }
