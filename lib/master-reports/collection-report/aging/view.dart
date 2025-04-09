import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/page_wrapper.dart';

class PaymentAgingController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<PaymentAging> agingPayments = <PaymentAging>[].obs;

  // Aging buckets in days
  final List<AgingBucket> agingBuckets = [
    AgingBucket(name: 'Current', minDays: 0, maxDays: 0, color: Colors.green),
    AgingBucket(
        name: '1-30 Days',
        minDays: 1,
        maxDays: 30,
        color: Colors.amber.shade600),
    AgingBucket(
        name: '31-60 Days', minDays: 31, maxDays: 60, color: Colors.orange),
    AgingBucket(
        name: '61-90 Days', minDays: 61, maxDays: 90, color: Colors.deepOrange),
    AgingBucket(name: '90+ Days', minDays: 91, maxDays: 999, color: Colors.red)
  ];

  // Summary amounts by bucket
  final RxMap<String, int> bucketTotals = <String, int>{}.obs;
  final RxInt totalAmount = 0.obs;

  // Filter variables
  final RxString selectedBucket = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgingData();
  }

  void fetchAgingData({DateTimeRange? dateRange}) {
    isLoading.value = true;

    // Simulate API call with delay
    Future.delayed(const Duration(seconds: 1), () {
      // Mock data - replace with actual API call
      agingPayments.value = getMockData();
      calculateBucketTotals();
      isLoading.value = false;
    });
  }

  void calculateBucketTotals() {
    Map<String, int> totals = {};
    int total = 0;

    // Initialize all buckets with zero
    for (var bucket in agingBuckets) {
      totals[bucket.name] = 0;
    }

    // Calculate totals for each bucket
    for (var payment in agingPayments) {
      final daysOverdue = payment.daysOverdue;

      for (var bucket in agingBuckets) {
        if (daysOverdue >= bucket.minDays && daysOverdue <= bucket.maxDays) {
          totals[bucket.name] = (totals[bucket.name] ?? 0) + payment.amount;
          total += payment.amount;
          break;
        }
      }
    }

    bucketTotals.value = totals;
    totalAmount.value = total;
  }

  void onDateRangeChanged(DateTimeRange? dateRange) {
    fetchAgingData(dateRange: dateRange);
  }

  void filterByBucket(String bucket) {
    selectedBucket.value = bucket;
    if (bucket == 'All') {
      agingPayments.value = getMockData();
    } else {
      final selectedBucketObj =
          agingBuckets.firstWhere((b) => b.name == bucket);
      agingPayments.value = getMockData().where((payment) {
        final days = payment.daysOverdue;
        return days >= selectedBucketObj.minDays &&
            days <= selectedBucketObj.maxDays;
      }).toList();
    }
  }

  Color getBucketColor(int daysOverdue) {
    for (var bucket in agingBuckets) {
      if (daysOverdue >= bucket.minDays && daysOverdue <= bucket.maxDays) {
        return bucket.color;
      }
    }
    return Colors.grey;
  }

  String getBucketName(int daysOverdue) {
    for (var bucket in agingBuckets) {
      if (daysOverdue >= bucket.minDays && daysOverdue <= bucket.maxDays) {
        return bucket.name;
      }
    }
    return 'Unknown';
  }

  List<PaymentAging> getMockData() {
    return [
      PaymentAging(
        id: '1',
        customerName: 'TechSolutions Inc',
        amount: 12500,
        invoiceDate: DateTime.now().subtract(const Duration(days: 15)),
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        invoiceNumber: 'INV-2023-001',
      ),
      PaymentAging(
        id: '2',
        customerName: 'Acme Corp',
        amount: 8750,
        invoiceDate: DateTime.now().subtract(const Duration(days: 75)),
        dueDate: DateTime.now().subtract(const Duration(days: 45)),
        invoiceNumber: 'INV-2023-002',
      ),
      PaymentAging(
        id: '3',
        customerName: 'Global Enterprises',
        amount: 21000,
        invoiceDate: DateTime.now().subtract(const Duration(days: 120)),
        dueDate: DateTime.now().subtract(const Duration(days: 100)),
        invoiceNumber: 'INV-2023-003',
      ),
      PaymentAging(
        id: '4',
        customerName: 'NextGen Solutions',
        amount: 5500,
        invoiceDate: DateTime.now().subtract(const Duration(days: 50)),
        dueDate: DateTime.now().subtract(const Duration(days: 35)),
        invoiceNumber: 'INV-2023-004',
      ),
      PaymentAging(
        id: '5',
        customerName: 'DataDrive LLC',
        amount: 15800,
        invoiceDate: DateTime.now().subtract(const Duration(days: 0)),
        dueDate: DateTime.now().add(const Duration(days: 15)),
        invoiceNumber: 'INV-2023-005',
      ),
      PaymentAging(
        id: '6',
        customerName: 'Innovative Systems',
        amount: 9250,
        invoiceDate: DateTime.now().subtract(const Duration(days: 95)),
        dueDate: DateTime.now().subtract(const Duration(days: 65)),
        invoiceNumber: 'INV-2023-006',
      ),
    ];
  }
}

class AgingBucket {
  final String name;
  final int minDays;
  final int maxDays;
  final Color color;

  AgingBucket(
      {required this.name,
      required this.minDays,
      required this.maxDays,
      required this.color});
}

class PaymentAging {
  final String id;
  final String customerName;
  final int amount;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final String invoiceNumber;

  PaymentAging({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.invoiceDate,
    required this.dueDate,
    required this.invoiceNumber,
  });

  int get daysOverdue {
    if (DateTime.now().isBefore(dueDate)) {
      return 0; // Not overdue yet
    }
    return DateTime.now().difference(dueDate).inDays;
  }
}

class PaymentAgingPage extends StatelessWidget {
  PaymentAgingPage({Key? key}) : super(key: key);

  final PaymentAgingController controller = Get.put(PaymentAgingController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Aging of Payments',
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
        _buildAgingSummary(),
        const SizedBox(height: 24),
        _buildAgingChart(),
        const SizedBox(height: 24),
        _buildAgingList(),
      ],
    );
  }

  Widget _buildAgingSummary() {
    final currencyFormat = NumberFormat("#,##0", "en_US");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Aging Summary',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Aging Period',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Amount',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ...controller.agingBuckets.map((bucket) {
                  final amount = controller.bucketTotals[bucket.name] ?? 0;
                  final percentage = controller.totalAmount.value > 0
                      ? (amount / controller.totalAmount.value * 100)
                          .toStringAsFixed(1)
                      : '0.0';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: bucket.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              bucket.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '₹${currencyFormat.format(amount)} ',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: '($percentage%)',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${currencyFormat.format(controller.totalAmount.value)}',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgingChart() {
    if (controller.totalAmount.value == 0) {
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
          'Aging Distribution',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: controller.bucketTotals.values
                      .fold(0, (max, value) => value > max ? value : max) *
                  1.2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final bucket = controller.agingBuckets[groupIndex];
                    final amount = controller.bucketTotals[bucket.name] ?? 0;
                    final currencyFormat = NumberFormat("#,##0", "en_US");
                    return BarTooltipItem(
                      '${bucket.name}\n₹${currencyFormat.format(amount)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 &&
                          index < controller.agingBuckets.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.agingBuckets[index].name,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final amount = value.toInt();
                      final currencyFormat = NumberFormat.compact();
                      return Text(
                        '₹${currencyFormat.format(amount)}',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: Colors.grey.shade700,
                        ),
                      );
                    },
                    reservedSize: 40,
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                horizontalInterval: controller.bucketTotals.values
                        .fold(0, (max, value) => value > max ? value : max) /
                    5,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  );
                },
              ),
              barGroups: List.generate(
                controller.agingBuckets.length,
                (index) {
                  final bucket = controller.agingBuckets[index];
                  final amount = controller.bucketTotals[bucket.name] ?? 0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: amount.toDouble(),
                        color: bucket.color,
                        width: 30,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgingList() {
    if (controller.agingPayments.isEmpty) {
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
              'No aging payments data available',
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
          'Payment Details',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...controller.agingPayments
            .map((payment) => _buildPaymentCard(payment))
            .toList(),
      ],
    );
  }

  Widget _buildPaymentCard(PaymentAging payment) {
    final currencyFormat = NumberFormat("#,##0", "en_US");
    final dateFormat = DateFormat("dd MMM, yyyy");

    final bucketName = controller.getBucketName(payment.daysOverdue);
    final bucketColor = controller.getBucketColor(payment.daysOverdue);

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
                    payment.customerName,
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bucketColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        payment.daysOverdue > 0
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle,
                        size: 14,
                        color: bucketColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bucketName,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: bucketColor,
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
                      'Invoice No.',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.invoiceNumber,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
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
                      '₹${currencyFormat.format(payment.amount)}',
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
                      dateFormat.format(payment.dueDate),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (payment.daysOverdue > 0)
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
                        '${payment.daysOverdue}',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: bucketColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 35,
              child: Row(
                children: [
                  _buildActionButton(
                    icon: Icons.email_outlined,
                    label: 'Send Reminder',
                    onPressed: () {
                      // Send reminder logic
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.call_outlined,
                    label: 'Call',
                    onPressed: () {
                      // Call customer logic
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.receipt_long_outlined,
                    label: 'View Invoice',
                    onPressed: () {
                      // View invoice logic
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black87,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    final List<String> bucketNames = [
      'All',
      ...controller.agingBuckets.map((b) => b.name)
    ];

    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Aging Period',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                    children: bucketNames
                        .map(
                          (bucket) => RadioListTile<String>(
                            title: Text(
                              bucket,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                              ),
                            ),
                            value: bucket,
                            groupValue: controller.selectedBucket.value,
                            onChanged: (value) {
                              controller.filterByBucket(value!);
                              Navigator.pop(context);
                            },
                          ),
                        )
                        .toList(),
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
