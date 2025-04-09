import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/page_wrapper.dart';

class PaymentCollectionStatusController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<PaymentCollection> collections = <PaymentCollection>[].obs;
  final RxInt totalReceived = 0.obs;
  final RxInt totalPending = 0.obs;
  final RxInt totalOverdue = 0.obs;

  // Filter variables
  final RxString selectedStatus = 'All'.obs;
  final RxList<String> statusFilters = ['All', 'Received', 'Pending', 'Overdue'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCollectionData();
  }

  void fetchCollectionData({DateTimeRange? dateRange}) {
    isLoading.value = true;

    // Simulate API call with delay
    Future.delayed(const Duration(seconds: 1), () {
      // Mock data - replace with actual API call
      collections.value = getMockData();
      calculateTotals();
      isLoading.value = false;
    });
  }

  void calculateTotals() {
    int received = 0;
    int pending = 0;
    int overdue = 0;

    for (var collection in collections) {
      if (collection.status == 'Received') {
        received += collection.amount;
      } else if (collection.status == 'Pending') {
        pending += collection.amount;
      } else if (collection.status == 'Overdue') {
        overdue += collection.amount;
      }
    }

    totalReceived.value = received;
    totalPending.value = pending;
    totalOverdue.value = overdue;
  }

  void onDateRangeChanged(DateTimeRange? dateRange) {
    fetchCollectionData(dateRange: dateRange);
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    // Re-fetch or filter existing data
    if (status == 'All') {
      collections.value = getMockData();
    } else {
      collections.value = getMockData().where((c) => c.status == status).toList();
    }
    calculateTotals();
  }

  List<PaymentCollection> getMockData() {
    return [
      PaymentCollection(
        id: '1',
        customerName: 'Acme Corp',
        amount: 25000,
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'Received',
        paymentDate: DateTime.now().subtract(const Duration(days: 7)),
      ),
      PaymentCollection(
        id: '2',
        customerName: 'TechSolutions Inc',
        amount: 18500,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        status: 'Pending',
        paymentDate: null,
      ),
      PaymentCollection(
        id: '3',
        customerName: 'Global Enterprises',
        amount: 32000,
        dueDate: DateTime.now().subtract(const Duration(days: 12)),
        status: 'Overdue',
        paymentDate: null,
      ),
      PaymentCollection(
        id: '4',
        customerName: 'Innovative Systems',
        amount: 15000,
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Received',
        paymentDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      PaymentCollection(
        id: '5',
        customerName: 'DataDrive LLC',
        amount: 28500,
        dueDate: DateTime.now().add(const Duration(days: 5)),
        status: 'Pending',
        paymentDate: null,
      ),
      PaymentCollection(
        id: '6',
        customerName: 'NextGen Solutions',
        amount: 22000,
        dueDate: DateTime.now().subtract(const Duration(days: 15)),
        status: 'Overdue',
        paymentDate: null,
      ),
    ];
  }
}

class PaymentCollection {
  final String id;
  final String customerName;
  final int amount;
  final DateTime dueDate;
  final String status; // 'Received', 'Pending', 'Overdue'
  final DateTime? paymentDate;

  PaymentCollection({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.paymentDate,
  });
}

class PaymentCollectionStatusPage extends StatelessWidget {
  PaymentCollectionStatusPage({Key? key}) : super(key: key);

  final PaymentCollectionStatusController controller = Get.put(PaymentCollectionStatusController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Payment Collection Status',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context),
      onDateRangeSelected: (dateRange) {
        controller.onDateRangeChanged(dateRange);
      },
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryCards(),
        const SizedBox(height: 20),
        _buildChart(),
        const SizedBox(height: 24),
        _buildCollectionList(),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final currencyFormat = NumberFormat("#,##0", "en_US");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collection Summary',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Received',
                '₹${currencyFormat.format(controller.totalReceived.value)}',
                Colors.green.shade50,
                Colors.green,
                Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Pending',
                '₹${currencyFormat.format(controller.totalPending.value)}',
                Colors.amber.shade50,
                Colors.amber.shade700,
                Icons.hourglass_empty,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Overdue',
                '₹${currencyFormat.format(controller.totalOverdue.value)}',
                Colors.red.shade50,
                Colors.red,
                Icons.warning_amber_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total',
                '₹${currencyFormat.format(controller.totalReceived.value + controller.totalPending.value + controller.totalOverdue.value)}',
                Colors.blue.shade50,
                Colors.blue,
                Icons.payments_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final total = controller.totalReceived.value +
        controller.totalPending.value +
        controller.totalOverdue.value;

    if (total == 0) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'No data available',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collection Distribution',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: controller.totalReceived.value.toDouble(),
                        title: '${(controller.totalReceived.value / total * 100).toStringAsFixed(0)}%',
                        color: Colors.green,
                        radius: 60,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      PieChartSectionData(
                        value: controller.totalPending.value.toDouble(),
                        title: '${(controller.totalPending.value / total * 100).toStringAsFixed(0)}%',
                        color: Colors.amber.shade700,
                        radius: 60,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      PieChartSectionData(
                        value: controller.totalOverdue.value.toDouble(),
                        title: '${(controller.totalOverdue.value / total * 100).toStringAsFixed(0)}%',
                        color: Colors.red,
                        radius: 60,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem('Received', Colors.green),
                    const SizedBox(height: 12),
                    _buildLegendItem('Pending', Colors.amber.shade700),
                    const SizedBox(height: 12),
                    _buildLegendItem('Overdue', Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionList() {
    if (controller.collections.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No collection data available',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collection Details',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...controller.collections.map((collection) => _buildCollectionCard(collection)).toList(),
      ],
    );
  }

  Widget _buildCollectionCard(PaymentCollection collection) {
    final currencyFormat = NumberFormat("#,##0", "en_US");
    final dateFormat = DateFormat("dd MMM, yyyy");

    Color statusColor;
    IconData statusIcon;

    switch (collection.status) {
      case 'Received':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Pending':
        statusColor = Colors.amber.shade700;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'Overdue':
        statusColor = Colors.red;
        statusIcon = Icons.warning_amber_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    collection.customerName,
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        collection.status,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${currencyFormat.format(collection.amount)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Date',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(collection.dueDate),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (collection.paymentDate != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Date',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(collection.paymentDate!),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                if (collection.status == 'Overdue')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Days Overdue',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateTime.now().difference(collection.dueDate).inDays}',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Status',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                children: controller.statusFilters.map((status) =>
                    RadioListTile<String>(
                      title: Text(
                        status,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                        ),
                      ),
                      value: status,
                      groupValue: controller.selectedStatus.value,
                      onChanged: (value) {
                        controller.filterByStatus(value!);
                        Navigator.pop(context);
                      },
                    ),
                ).toList(),
              )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}