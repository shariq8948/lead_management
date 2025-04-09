import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads/master-reports/customers/lifetime-value/views/all_customers.dart';

import 'dart:math' as math;

import '../../../widgets/page_wrapper.dart';

// Import your existing page wrapper

// Controller for the Sales Estimation page
class SalesEstimationController extends GetxController {
  // Date range selection
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  // Sales data
  final RxList<Map<String, dynamic>> salesData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> topCustomers =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> projectedSales =
      <Map<String, dynamic>>[].obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble projectedRevenue = 0.0.obs;
  final RxDouble growthRate = 0.0.obs;
  final RxBool isLoading = false.obs;

  // Filter options
  final RxString selectedProductCategory = 'All'.obs;
  final RxString selectedLeadSource = 'All'.obs;
  final RxList<String> productCategories =
      <String>['All', 'Software', 'Hardware', 'Services', 'Consulting'].obs;
  final RxList<String> leadSources = <String>[
    'All',
    'Website',
    'Referral',
    'Direct',
    'Social Media',
    'Email Campaign'
  ].obs;

  // Format currency (Indian Rupee)
  final currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    loadSalesData();
  }

  // Update data when date range changes
  void updateDateRange(DateTimeRange? range) {
    if (range != null) {
      selectedDateRange.value = range;
      loadSalesData();
    }
  }

  // Update filters
  void updateProductCategory(String category) {
    selectedProductCategory.value = category;
    loadSalesData();
  }

  void updateLeadSource(String source) {
    selectedLeadSource.value = source;
    loadSalesData();
  }

  // Load sales data (simulated data for now)
  Future<void> loadSalesData() async {
    isLoading.value = true;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, you would call your API here with the date range and filters
      // For now, we'll generate dummy data
      _generateDummyData();

      // Calculate projected revenue (simple projection for demo)
      _calculateProjections();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load sales data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Generate dummy data for demonstration
  void _generateDummyData() {
    // Random generator with seed for consistent results during demo
    final random = math.Random(42);

    // Clear previous data
    salesData.clear();
    topCustomers.clear();

    // Calculate date differences
    final days = selectedDateRange.value!.end
        .difference(selectedDateRange.value!.start)
        .inDays;

    // Generate daily sales data
    for (int i = 0; i <= days; i++) {
      final date = selectedDateRange.value!.start.add(Duration(days: i));
      final baseAmount = 20000 + random.nextInt(30000);

      // Add some variance based on filters
      double multiplier = 1.0;
      if (selectedProductCategory.value != 'All') {
        multiplier += 0.2 + random.nextDouble() * 0.3;
      }
      if (selectedLeadSource.value != 'All') {
        multiplier += 0.1 + random.nextDouble() * 0.2;
      }

      final amount = (baseAmount * multiplier).round();

      salesData.add({
        'date': date,
        'amount': amount,
        'leads': 5 + random.nextInt(10),
        'conversion': 0.3 + random.nextDouble() * 0.4,
      });
    }

    // Generate top customers
    final customerNames = [
      'Reliance Industries',
      'Tata Consultancy',
      'Infosys Limited',
      'HCL Technologies',
      'Wipro Limited',
      'Bharti Airtel',
      'Tech Mahindra',
      'Larsen & Toubro',
    ];

    for (int i = 0; i < 5; i++) {
      final revenue = 100000 + random.nextInt(900000);
      final growthPercent = -10 + random.nextInt(40);

      topCustomers.add({
        'name': customerNames[i],
        'revenue': revenue,
        'growth': growthPercent,
        'deals': 2 + random.nextInt(8),
      });
      // topCustomers.add(Customer(id: "1",
      //     name: customerNames[i],
      //     email: customerNames[i],
      //     phone: customerNames[i]+customerNames[i],
      //     industry: "industry",
      //     leadSource: "leadSource",
      //     lifetimeSales: 580000,
      //     totalDeals: totalDeals,
      //     acquisitionDate: acquisitionDate,
      //     status: status,
      //     transactions: transactions,
      //     assignedTo: assignedTo)
      // )
    }

    // Calculate total revenue
    totalRevenue.value =
        salesData.fold(0, (sum, item) => sum + (item['amount'] as int));
  }

  // Calculate projections
  void _calculateProjections() {
    final random = math.Random(42);

    // Clear previous projections
    projectedSales.clear();

    // Get the last date in the current range
    final lastDate = selectedDateRange.value!.end;

    // Project for the next 6 months
    for (int i = 1; i <= 6; i++) {
      final projectedDate = DateTime(lastDate.year, lastDate.month + i, 1);

      // Base projection on current total with some growth
      final baseGrowth =
          0.03 + random.nextDouble() * 0.04; // 3-7% monthly growth
      double growthMultiplier = 1.0 + (baseGrowth * i);

      // Add some variance based on filters
      if (selectedProductCategory.value != 'All') {
        growthMultiplier += 0.01 * i;
      }
      if (selectedLeadSource.value != 'All') {
        growthMultiplier += 0.005 * i;
      }

      final projectedAmount =
          (totalRevenue.value / salesData.length * growthMultiplier).round();

      projectedSales.add({
        'date': projectedDate,
        'amount': projectedAmount,
      });
    }

    // Calculate total projected revenue
    projectedRevenue.value =
        projectedSales.fold(0, (sum, item) => sum + (item['amount'] as num));

    // Calculate growth rate (comparing current to projected)
    if (totalRevenue.value > 0) {
      growthRate.value =
          (projectedRevenue.value / totalRevenue.value - 1) * 100;
    } else {
      growthRate.value = 0;
    }
  }
}

// The actual Sales Estimation page
class SalesEstimationPage extends StatelessWidget {
  const SalesEstimationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(SalesEstimationController());

    return ReportPageWrapper(
      title: 'Sales Estimation',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context, controller),
      onDateRangeSelected: (range) => controller.updateDateRange(range),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(controller),
            const SizedBox(height: 24),
            _buildRevenueChart(controller),
            const SizedBox(height: 24),
            _buildProjectionSection(controller),
            const SizedBox(height: 24),
            _buildTopCustomersSection(controller),
          ],
        );
      }),
    );
  }

  // Summary cards showing key metrics
  Widget _buildSummaryCards(SalesEstimationController controller) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSummaryCard(
          title: 'Current Revenue',
          value:
              controller.currencyFormat.format(controller.totalRevenue.value),
          icon: Icons.currency_rupee_rounded,
          color: Colors.blue.shade700,
        ),
        _buildSummaryCard(
          title: 'Projected Revenue',
          value: controller.currencyFormat
              .format(controller.projectedRevenue.value),
          icon: Icons.trending_up_rounded,
          color: Colors.green.shade700,
        ),
        _buildSummaryCard(
          title: 'Growth Rate',
          value: '${controller.growthRate.value.toStringAsFixed(1)}%',
          icon: Icons.show_chart_rounded,
          color: Colors.purple.shade700,
        ),
        _buildSummaryCard(
          title: 'Lead to Sale',
          value:
              '${(controller.salesData.isNotEmpty ? controller.salesData.map((e) => e['conversion'] as double).reduce((a, b) => a + b) / controller.salesData.length * 100 : 0).toStringAsFixed(1)}%',
          icon: Icons.people_alt_rounded,
          color: Colors.orange.shade700,
        ),
      ],
    );
  }

  // Individual summary card
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Revenue chart
  Widget _buildRevenueChart(SalesEstimationController controller) {
    // Skip if no data
    if (controller.salesData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Extract data for the chart
    final spots = controller.salesData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value['amount'] / 1000, // Convert to thousands for better display
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Trend',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Past ${controller.salesData.length} days',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                ),
                titlesData: FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval:
                          (controller.salesData.length / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= controller.salesData.length ||
                            value.toInt() < 0) {
                          return const SizedBox.shrink();
                        }
                        final date = controller.salesData[value.toInt()]['date']
                            as DateTime;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd/MM').format(date),
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${value.toInt()}K',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blue.shade600,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade200.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Projection section
  Widget _buildProjectionSection(SalesEstimationController controller) {
    if (controller.projectedSales.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Projection',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Next 6 months forecast',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.projectedSales.length,
            itemBuilder: (context, index) {
              final item = controller.projectedSales[index];
              final date = item['date'] as DateTime;
              final amount = item['amount'] as num;

              // Calculate percent increase from current revenue
              final percentIncrease = controller.totalRevenue.value > 0
                  ? (amount /
                              (controller.totalRevenue.value /
                                  controller.salesData.length) -
                          1) *
                      100
                  : 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        DateFormat('MMMM yyyy').format(date),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        controller.currencyFormat.format(amount),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '+${percentIncrease.toStringAsFixed(1)}%',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Top customers section
  Widget _buildTopCustomersSection(SalesEstimationController controller) {
    if (controller.topCustomers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Revenue Customers',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(AllCustomersPage());
                },
                child: Text(
                  'View all',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.topCustomers.length,
            itemBuilder: (context, index) {
              final customer = controller.topCustomers[index];

              return GestureDetector(
                onTap: () {
                  // Get.to(CustomerDetailPage(customer: customer));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          customer['name'].toString().substring(0, 1),
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer['name'],
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${customer['deals']} deals',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            controller.currencyFormat
                                .format(customer['revenue']),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            customer['growth'] >= 0
                                ? '+${customer['growth']}%'
                                : '${customer['growth']}%',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: customer['growth'] >= 0
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Filter modal
  void _showFilterModal(
      BuildContext context, SalesEstimationController controller) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Category',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.productCategories.map((category) {
                    final isSelected =
                        controller.selectedProductCategory.value == category;
                    return GestureDetector(
                      onTap: () => controller.updateProductCategory(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade600
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue.shade600
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Lead Source',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.leadSources.map((source) {
                    final isSelected =
                        controller.selectedLeadSource.value == source;
                    return GestureDetector(
                      onTap: () => controller.updateLeadSource(source),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade600
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue.shade600
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          source,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.loadSalesData();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
