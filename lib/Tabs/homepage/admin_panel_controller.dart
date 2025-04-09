import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPanelController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("initialized admin panel");
  }

  var leadsData = [
    {
      'label': 'Hot Leads',
      'value': 20,
      'color': const Color(0xFFFF0000)
    }, // Red
    {
      'label': 'Warm Leads',
      'value': 6,
      'color': const Color(0xFFFFA500)
    }, // Orange
    {
      'label': 'Cold Leads',
      'value': 4,
      'color': const Color(0xFF00BFFF)
    }, // Blue
  ].obs;
  final leadSourceData = [
    {'source': 'Website', 'count': 45},
    {'source': 'Referral', 'count': 30},
    {'source': 'Social Media', 'count': 25},
    {'source': 'Insta Mart', 'count': 25},
    {'source': 'Just Dial', 'count': 25},
    // Add more sources as needed
  ];

  final monthlyTrendsData = [
    {'month': 'Jan', 'newLeads': 50, 'conversions': 20},
    {'month': 'Feb', 'newLeads': 65, 'conversions': 25},
    {'month': 'Mar', 'newLeads': 60, 'conversions': 30},
    // Add more months as needed
  ];
  var conversionData = [
    {'label': 'New', 'value': 20, 'color': const Color(0xFF8A2BE2)}, // Purple
    {
      'label': 'Connected',
      'value': 51,
      'color': const Color(0xFF7CFC00)
    }, // Green
    {
      'label': 'Opportunity',
      'value': 82,
      'color': const Color(0xFFADD8E6)
    }, // Light Blue
    {
      'label': 'Negotiation',
      'value': 58,
      'color': const Color(0xFFFFA500)
    }, // Orange
    {
      'label': 'Disqualified',
      'value': 32,
      'color': const Color(0xFFFF4500)
    }, // Red
    {
      'label': 'Qualified',
      'value': 30,
      'color': const Color(0xFF32CD32)
    }, // Lime Green
  ].obs;
  final List<Map<String, dynamic>> topSalesmanLeads = [
    {'name': 'John Doe', 'amount': '450,000'},
    {'name': 'Jane Smith', 'amount': '380,000'},
    {'name': 'Mike Johnson', 'amount': '325,000'},
    {'name': 'Sarah Williams', 'amount': '290,000'},
    {'name': 'Robert Brown', 'amount': '275,000'},
  ];

  final List<Map<String, dynamic>> topSalesmen = [
    {
      'name': 'John Doe',
      'deals': 45,
      'amount': '1.2M',
      'avatar': 'https://placeholder.com/50'
    },
    {
      'name': 'Jane Smith',
      'deals': 42,
      'amount': '1.1M',
      'avatar': 'https://placeholder.com/50'
    },
    {
      'name': 'Mike Johnson',
      'deals': 38,
      'amount': '950K',
      'avatar': 'https://placeholder.com/50'
    },
    {
      'name': 'Sarah Williams',
      'deals': 35,
      'amount': '820K',
      'avatar': 'https://placeholder.com/50'
    },
    {
      'name': 'Robert Brown',
      'deals': 32,
      'amount': '780K',
      'avatar': 'https://placeholder.com/50'
    },
  ];

  final List<Map<String, dynamic>> stateSales = [
    {'state': 'Maharashtra', 'sales': 45.2, 'color': Colors.blue},
    {'state': 'Gujarat', 'sales': 38.5, 'color': Colors.blue},
    {'state': 'Karnataka', 'sales': 35.8, 'color': Colors.blue},
    {'state': 'Tamil Nadu', 'sales': 32.4, 'color': Colors.blue},
    {'state': 'Delhi', 'sales': 28.9, 'color': Colors.blue},
  ];

  final List<Map<String, dynamic>> topProducts = [
    {'name': 'Product A', 'units': 1200, 'revenue': '580K'},
    {'name': 'Product B', 'units': 950, 'revenue': '475K'},
    {'name': 'Product C', 'units': 850, 'revenue': '425K'},
    {'name': 'Product D', 'units': 720, 'revenue': '360K'},
    {'name': 'Product E', 'units': 680, 'revenue': '340K'},
  ];
}
