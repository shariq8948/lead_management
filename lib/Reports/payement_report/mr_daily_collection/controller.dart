import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class CollectionData {
  final String id;
  final String customerName;
  final double amount;
  final String status;
  final String time;
  final String location;
  final String? notes;

  CollectionData({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.time,
    required this.location,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'amount': amount,
        'status': status,
        'time': time,
        'location': location,
        'notes': notes,
      };
}

class CollectionReportController extends GetxController {
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var selectedFilter = 'All'.obs;
  var totalCollection = 0.0.obs;
  var totalPending = 0.0.obs;
  var collections = <CollectionData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCollections();
  }

  Future<void> fetchCollections() async {
    isLoading.value = true;
    try {
      // Simulate API call with your actual API integration
      await Future.delayed(Duration(seconds: 1));
      collections.value = [
        CollectionData(
          id: '1',
          customerName: 'John Doe',
          amount: 5000.0,
          status: 'Collected',
          time: '09:30 AM',
          location: 'Main Street',
          notes: 'Payment received in cash',
        ),
        CollectionData(
          id: '2',
          customerName: 'Jane Smith',
          amount: 3000.0,
          status: 'Pending',
          time: '10:15 AM',
          location: 'Park Avenue',
          notes: 'Will pay by evening',
        ),
        CollectionData(
          id: '3',
          customerName: 'Robert Johnson',
          amount: 7500.0,
          status: 'Collected',
          time: '11:45 AM',
          location: 'Broadway Street',
          notes: 'Payment received via UPI',
        ),
      ];
      _calculateTotals();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch collections',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchCollections();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    // No need to fetch data again as we're filtering locally
  }

  List<CollectionData> get filteredCollections {
    if (selectedFilter.value == 'All') {
      return collections;
    }
    return collections.where((c) => c.status == selectedFilter.value).toList();
  }

  void _calculateTotals() {
    totalCollection.value = collections
        .where((c) => c.status == 'Collected')
        .fold(0.0, (sum, item) => sum + item.amount);

    totalPending.value = collections
        .where((c) => c.status == 'Pending')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<void> markAsCollected(String collectionId) async {
    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      final index = collections.indexWhere((c) => c.id == collectionId);
      if (index != -1) {
        final updatedCollection = CollectionData(
          id: collections[index].id,
          customerName: collections[index].customerName,
          amount: collections[index].amount,
          status: 'Collected',
          time: DateFormat('hh:mm a').format(DateTime.now()),
          location: collections[index].location,
          notes: collections[index].notes,
        );

        collections[index] = updatedCollection;
        collections.refresh();
        _calculateTotals();

        Get.snackbar(
          'Success',
          'Collection marked as collected',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update collection status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> exportCollections() async {
    try {
      // Convert collections to JSON format
      final List<Map<String, dynamic>> jsonData =
          filteredCollections.map((collection) => collection.toJson()).toList();

      // Add summary data
      final Map<String, dynamic> summaryData = {
        'date': DateFormat('yyyy-MM-dd').format(selectedDate.value),
        'totalCollected': totalCollection.value,
        'totalPending': totalPending.value,
        'totalRecords': filteredCollections.length,
        'filter': selectedFilter.value,
      };

      final Map<String, dynamic> exportData = {
        'summary': summaryData,
        'collections': jsonData,
      };

      // Simulate file export
      await Future.delayed(Duration(seconds: 1));
      final String jsonString = json.encode(exportData);

      // Here you would typically save the file or send it to a server
      // For now, we'll just print it to console
      print(jsonString);

      Get.snackbar(
        'Success',
        'Report exported successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export report',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper method to format currency
  String formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 2,
    ).format(amount);
  }

  // Helper method to get collection status color
  Color getStatusColor(String status) {
    return status == 'Collected' ? Colors.green : Colors.orange;
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
