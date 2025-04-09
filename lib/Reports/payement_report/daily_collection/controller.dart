import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class DailyCollectionController extends GetxController {
  // Date range
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;

  // Loading state
  var isLoading = false.obs;

  // Collection data
  var collections = <CollectionItem>[].obs;
  var filteredCollections = <CollectionItem>[].obs;
  var totalCollection = 0.0.obs;

  // Payment method totals
  var cardTotal = 0.0.obs;
  var cashTotal = 0.0.obs;
  var upiTotal = 0.0.obs;

  // Search and sort
  var searchQuery = ''.obs;
  var sortField = 'name'.obs;
  var isAscending = true.obs;

  // Filter options
  var selectedEmployee = ''.obs;
  var selectedPaymentMethod = ''.obs;
  var selectedStatus = ''.obs;

  // Filter lists
  final employees = [
    'John Doe',
    'Jane Smith',
    'Bob Johnson',
    'Alice Williams',
    'David Brown'
  ].obs;
  final paymentMethods = ['All', 'Cash', 'Card', 'UPI'].obs;
  final statuses = ['All', 'Pending', 'Completed'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCollections();
  }

  void setDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    fetchCollections();
  }

  void resetDateRange() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    fetchCollections();
  }

  void setSelectedEmployee(String? employee) {
    selectedEmployee.value = employee ?? '';
    updateFilteredCollections();
  }

  void setSelectedPaymentMethod(String? method) {
    selectedPaymentMethod.value = method ?? '';
    updateFilteredCollections();
  }

  void setSelectedStatus(String? status) {
    selectedStatus.value = status ?? '';
    updateFilteredCollections();
  }

  void resetFilters() {
    selectedEmployee.value = '';
    selectedPaymentMethod.value = '';
    selectedStatus.value = '';
    searchQuery.value = '';
    updateFilteredCollections();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    updateFilteredCollections();
  }

  void setSortField(String field) {
    if (sortField.value == field) {
      isAscending.toggle();
    } else {
      sortField.value = field;
      isAscending.value = true;
    }
    updateFilteredCollections();
  }

  Future<void> exportReport(String format) async {
    try {
      isLoading.value = true;
      final Directory directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      String filePath = '';

      if (format == 'CSV') {
        filePath = '${directory.path}/collection_report_$timestamp.csv';
        await _exportToCSV(filePath);
      } else if (format == 'PDF') {
        filePath = '${directory.path}/collection_report_$timestamp.pdf';
        await _exportToPDF(filePath);
      } else if (format == 'Excel') {
        filePath = '${directory.path}/collection_report_$timestamp.xlsx';
        await _exportToExcel(filePath);
      }

      // Share the file
      await Share.shareXFiles([XFile(filePath)], text: 'Collection Report');

      Get.snackbar(
        'Success',
        'Report exported and shared successfully as $format',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export report: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _exportToCSV(String filePath) async {
    final StringBuffer csvData = StringBuffer();

    // Add headers
    csvData.writeln(
        'Customer Name,Collector,Amount,Time,Status,Payment Method,Transaction ID,Notes');

    // Add rows
    for (var item in filteredCollections) {
      csvData.writeln(
          '${item.customerName},${item.collectorName},${item.amount},${item.time},${item.status},${item.paymentMethod},${item.transactionId},${item.notes}');
    }

    final File file = File(filePath);
    await file.writeAsString(csvData.toString());
  }

  Future<void> _exportToExcel(String filePath) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Collection Report'];

    // Add headers
    sheetObject.appendRow([
      TextCellValue('Customer Name'),
      TextCellValue('Collector'),
      TextCellValue('Amount'),
      TextCellValue('Time'),
      TextCellValue('Status'),
      TextCellValue('Payment Method'),
      TextCellValue('Transaction ID'),
      TextCellValue('Notes')
    ]);

    // Add data rows
    for (var item in filteredCollections) {
      sheetObject.appendRow([
        TextCellValue(item.customerName),
        TextCellValue(item.collectorName),
        TextCellValue(
            item.amount.toString()), // Ensure numbers are converted to string
        TextCellValue(item.time),
        TextCellValue(item.status),
        TextCellValue(item.paymentMethod),
        TextCellValue(item.transactionId), // Handle potential null values
        TextCellValue(item.notes) // Handle potential null values
      ]);
    }

    // Save file
    final List<int> bytes = excel.encode()!;
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
  }

  Future<void> _exportToPDF(String filePath) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Collection Report",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: [
                  'Customer Name',
                  'Collector',
                  'Amount',
                  'Time',
                  'Status',
                  'Payment Method'
                ],
                data: filteredCollections
                    .map((item) => [
                          item.customerName,
                          item.collectorName,
                          item.amount,
                          item.time,
                          item.status,
                          item.paymentMethod
                        ])
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }

  void updateFilteredCollections() {
    var filtered = collections.where((item) {
      // Apply search filter
      bool matchesSearch = item.customerName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          item.amount.toString().contains(searchQuery.value) ||
          item.paymentMethod
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          item.collectorName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      // Apply employee filter
      bool matchesEmployee = selectedEmployee.value.isEmpty ||
          item.collectorName == selectedEmployee.value;

      // Apply payment method filter
      bool matchesPaymentMethod = selectedPaymentMethod.value.isEmpty ||
          selectedPaymentMethod.value == 'All' ||
          item.paymentMethod == selectedPaymentMethod.value;

      // Apply status filter
      bool matchesStatus = selectedStatus.value.isEmpty ||
          selectedStatus.value == 'All' ||
          item.status == selectedStatus.value;

      return matchesSearch &&
          matchesEmployee &&
          matchesPaymentMethod &&
          matchesStatus;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int comparison;
      switch (sortField.value) {
        case 'name':
          comparison = a.customerName.compareTo(b.customerName);
          break;
        case 'amount':
          comparison = a.amount.compareTo(b.amount);
          break;
        case 'time':
          comparison = _compareTime(a.time, b.time);
          break;
        case 'collector':
          comparison = a.collectorName.compareTo(b.collectorName);
          break;
        default:
          comparison = 0;
      }
      return isAscending.value ? comparison : -comparison;
    });

    filteredCollections.value = filtered;
    calculateTotals();
  }

  int _compareTime(String time1, String time2) {
    // Convert time strings to DateTime for proper comparison
    final format = DateFormat('hh:mm a');
    try {
      final dateTime1 = format.parse(time1);
      final dateTime2 = format.parse(time2);
      return dateTime1.compareTo(dateTime2);
    } catch (e) {
      return 0;
    }
  }

  void calculateTotals() {
    // Calculate total collection
    totalCollection.value = filteredCollections.fold(
      0,
      (sum, item) => sum + item.amount,
    );

    // Calculate payment method totals
    cardTotal.value = filteredCollections
        .where((item) => item.paymentMethod == 'Card')
        .fold(0, (sum, item) => sum + item.amount);

    cashTotal.value = filteredCollections
        .where((item) => item.paymentMethod == 'Cash')
        .fold(0, (sum, item) => sum + item.amount);

    upiTotal.value = filteredCollections
        .where((item) => item.paymentMethod == 'UPI')
        .fold(0, (sum, item) => sum + item.amount);
  }

  void fetchCollections() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      collections.value = [
        CollectionItem(
          customerName: "John Doe",
          collectorName: "Jane Smith",
          amount: 5000.00,
          time: "10:30 AM",
          status: "Completed",
          paymentMethod: "Card",
          transactionId: "TRX001",
          notes: "Regular payment",
          date: DateTime.now(),
        ),
        CollectionItem(
          customerName: "Alice Smith",
          collectorName: "Bob Johnson",
          amount: 3500.50,
          time: "09:15 AM",
          status: "Pending",
          paymentMethod: "UPI",
          transactionId: "TRX002",
          notes: "Partial payment",
          date: DateTime.now(),
        ),
        CollectionItem(
          customerName: "Bob Johnson",
          collectorName: "Alice Williams",
          amount: 12000.00,
          time: "11:45 AM",
          status: "Completed",
          paymentMethod: "Cash",
          transactionId: "TRX003",
          notes: "Full payment",
          date: DateTime.now(),
        ),
        CollectionItem(
          customerName: "Emily Brown",
          collectorName: "David Brown",
          amount: 8750.75,
          time: "02:20 PM",
          status: "Completed",
          paymentMethod: "Card",
          transactionId: "TRX004",
          notes: "Monthly subscription",
          date: DateTime.now(),
        ),
        CollectionItem(
          customerName: "David Wilson",
          collectorName: "Jane Smith",
          amount: 2300.00,
          time: "03:45 PM",
          status: "Pending",
          paymentMethod: "UPI",
          transactionId: "TRX005",
          notes: "Advance payment",
          date: DateTime.now(),
        ),
        // Add more mock data as needed
      ];
      updateFilteredCollections();
      isLoading.value = false;
    });
  }
}

class CollectionItem {
  final String customerName;
  final String collectorName;
  final double amount;
  final String time;
  final String status;
  final String paymentMethod;
  final String transactionId;
  final String notes;
  final DateTime date;

  CollectionItem({
    required this.customerName,
    required this.collectorName,
    required this.amount,
    required this.time,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
    required this.notes,
    required this.date,
  });
}
