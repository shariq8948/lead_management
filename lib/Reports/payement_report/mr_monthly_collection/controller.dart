import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Collection {
  final String customerName;
  final String location;
  final String time;
  final int amount;
  final String status;

  Collection({
    required this.customerName,
    required this.location,
    required this.time,
    required this.amount,
    required this.status,
  });
}

class CollectionReportController extends GetxController {
  // State variables
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;

  // Collections data
  var collections = <Collection>[].obs;
  var totalCollection = 0.obs;
  var totalPending = 0.obs;

  // Getter for filtered collections based on the selected month and year
  List<Collection> get filteredCollections {
    final month = selectedDate.value.month;
    final year = selectedDate.value.year;
    return collections
        .where((collection) =>
            DateFormat('MM/yyyy').format(DateTime(year, month)) ==
            DateFormat('MM/yyyy').format(DateTime(year, month)))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCollections(); // Fetch initial data
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchCollections();
  }

  Future<void> fetchCollections() async {
    isLoading.value = true;

    // Simulate a network call or database fetch with a delay
    await Future.delayed(Duration(seconds: 2));

    // Example data (you can replace this with an API call or database query)
    collections.assignAll([
      Collection(
        customerName: 'John Doe',
        location: 'New York',
        time: '10:30 AM',
        amount: 1500,
        status: 'Collected',
      ),
      Collection(
        customerName: 'Jane Smith',
        location: 'San Francisco',
        time: '2:15 PM',
        amount: 2000,
        status: 'Pending',
      ),
      Collection(
        customerName: 'Sam Wilson',
        location: 'Los Angeles',
        time: '11:00 AM',
        amount: 1800,
        status: 'Collected',
      ),
    ]);

    // Calculate total collections and pending amounts
    totalCollection.value = collections
        .where((c) => c.status == 'Collected')
        .fold(0, (sum, c) => sum + c.amount);

    totalPending.value = collections
        .where((c) => c.status == 'Pending')
        .fold(0, (sum, c) => sum + c.amount);

    isLoading.value = false;
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    // Handle filter dialog (not implemented in detail)
  }

  void _exportData() {
    // Handle data export (e.g., to Excel, CSV, etc.)
  }

  void _showCollectionDetails(Collection collection) {
    // Navigate to a detailed page or show a dialog with collection details
  }
}
