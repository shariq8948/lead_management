import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';

// Model class for Order
class OrderList {
  final String id;
  final String iCode;
  final String iName;
  final String category;
  final String company;
  final String unit;
  final String rate;

  OrderList({
    required this.id,
    required this.iCode,
    required this.iName,
    required this.category,
    required this.company,
    required this.unit,
    required this.rate,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      id: json['id'] ?? '',
      iCode: json['iCode'] ?? '',
      iName: json['iName'] ?? '',
      category: json['category'] ?? '',
      company: json['company'] ?? '',
      unit: json['unit'] ?? '',
      rate: json['rate'] ?? '0',
    );
  }
}

// Controller class for Orders
class OrdersController extends GetxController {
  final RxList<OrderList> orders = <OrderList>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString categorySearchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxList<String> categories = <String>['All'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      isLoading.value = true;

      // Get the raw list data from API
      final List<dynamic> rawData =
          await ApiClient().getOrderList(ApiEndpoints.orderlist);

      // Convert each item in the raw list to OrderList objects
      orders.value = rawData.map((item) => OrderList.fromJson(item)).toList();

      // Extract unique categories
      final Set<String> uniqueCategories = {'All'};
      for (var order in orders) {
        if (order.category.isNotEmpty) {
          uniqueCategories.add(order.category);
        }
      }
      categories.value = uniqueCategories.toList();
    } catch (e) {
      print('Error fetching orders: $e');
      orders.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderList> get filteredOrders {
    return orders.where((order) {
      final matchesSearch = order.iName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          order.iCode.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          order.company
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          order.id.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesCategory = selectedCategory.value == 'All' ||
          order.category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get filteredCategories {
    if (categorySearchQuery.isEmpty) {
      return categories;
    }

    return categories
        .where((category) => category
            .toLowerCase()
            .contains(categorySearchQuery.value.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setCategorySearchQuery(String query) {
    categorySearchQuery.value = query;
    // Make sure filtered categories still contains the selected category
    if (selectedCategory.value != 'All' &&
        !filteredCategories.contains(selectedCategory.value)) {
      // Reset to 'All' if selected category is filtered out
      selectedCategory.value = 'All';
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }
}
