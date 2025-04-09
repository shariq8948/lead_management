import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';

class FinancialComparisonController extends GetxController {
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxString selectedComparisonType = 'Monthly'.obs;
  final RxBool isLoading = false.obs;
  final RxList<FinancialData> financialData = <FinancialData>[].obs;
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');

  @override
  void onInit() {
    super.onInit();
    // Set default date range to last 3 months
    final now = DateTime.now();
    selectedDateRange.value = DateTimeRange(
      start: DateTime(now.year, now.month - 3, 1),
      end: DateTime(now.year, now.month, 0),
    );
    fetchFinancialData();
  }

  void updateDateRange(DateTimeRange? range) {
    if (range != null) {
      selectedDateRange.value = range;
      fetchFinancialData();
    }
  }

  void changeComparisonType(String type) {
    selectedComparisonType.value = type;
    fetchFinancialData();
  }

  Future<void> fetchFinancialData() async {
    if (selectedDateRange.value == null) return;

    isLoading.value = true;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Replace with actual API call to get financial data
      financialData.value = await _getMockFinancialData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load financial data');
    } finally {
      isLoading.value = false;
    }
  }

  // Mock data generator - replace with actual API integration
  Future<List<FinancialData>> _getMockFinancialData() async {
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    final baseRevenue = 50000 + random * 500;

    switch (selectedComparisonType.value) {
      case 'Monthly':
        return List.generate(6, (index) {
          final month =
              DateTime.now().subtract(Duration(days: 30 * (5 - index)));
          return FinancialData(
            label: DateFormat('MMM yyyy').format(month),
            currentPeriodRevenue: baseRevenue.toDouble() +
                (index * 5000) +
                (random * 200 * index),
            previousPeriodRevenue:
                baseRevenue * 0.85 + (index * 4000) + (random * 100 * index),
            date: month,
          );
        });

      case 'Quarterly':
        return List.generate(4, (index) {
          final quarter =
              DateTime.now().subtract(Duration(days: 90 * (3 - index)));
          final quarterName = 'Q${(quarter.month / 3).ceil()} ${quarter.year}';
          return FinancialData(
            label: quarterName,
            currentPeriodRevenue: baseRevenue.toDouble() * 3 +
                (index * 15000) +
                (random * 500 * index),
            previousPeriodRevenue:
                baseRevenue * 2.5 + (index * 12000) + (random * 400 * index),
            date: quarter,
          );
        });

      case 'Yearly':
        return List.generate(3, (index) {
          final year =
              DateTime.now().subtract(Duration(days: 365 * (2 - index)));
          return FinancialData(
            label: year.year.toString(),
            currentPeriodRevenue: baseRevenue.toDouble() * 12 +
                (index * 60000) +
                (random * 2000 * index),
            previousPeriodRevenue: baseRevenue.toDouble() * 10 +
                (index * 50000) +
                (random * 1800 * index),
            date: year,
          );
        });

      default:
        return [];
    }
  }
}

class FinancialData {
  final String label;
  final double currentPeriodRevenue;
  final double previousPeriodRevenue;
  final DateTime date;

  FinancialData({
    required this.label,
    required this.currentPeriodRevenue,
    required this.previousPeriodRevenue,
    required this.date,
  });

  double get growthRate =>
      (currentPeriodRevenue - previousPeriodRevenue) /
      previousPeriodRevenue *
      100;
}

class FinancialComparisonReportPage extends StatelessWidget {
  const FinancialComparisonReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinancialComparisonController());

    return ReportPageWrapper(
      title: 'Financial Comparison',
      showFilterIcon: true,
      onFilterTap: () {
        CustomFilterModal.show(
          context,
          filterWidgets: [
            _buildComparisonTypeFilter(controller),
          ],
        );
      },
      onDateRangeSelected: (range) {
        controller.updateDateRange(range);
      },
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.financialData.isEmpty) {
          return const Center(
            child: Text('No financial data available'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildComparisonHeader(controller),
            const SizedBox(height: 24),
            _buildRevenueChart(controller),
            const SizedBox(height: 32),
            _buildComparisonTable(controller),
            const SizedBox(height: 24),
            _buildSummaryCards(controller),
          ],
        );
      }),
    );
  }

  Widget _buildComparisonHeader(FinancialComparisonController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${controller.selectedComparisonType.value} Comparison',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                controller.selectedComparisonType.value,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Compare financial performance across different periods',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChart(FinancialComparisonController controller) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Text(
            'Revenue Trend',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: controller.financialData
                        .map((data) => data.currentPeriodRevenue >
                                data.previousPeriodRevenue
                            ? data.currentPeriodRevenue
                            : data.previousPeriodRevenue)
                        .reduce((a, b) => a > b ? a : b) *
                    1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final data = controller.financialData[groupIndex];
                      String periodText =
                          rodIndex == 0 ? 'Current' : 'Previous';
                      String value = controller.currencyFormatter.format(
                          rodIndex == 0
                              ? data.currentPeriodRevenue
                              : data.previousPeriodRevenue);
                      return BarTooltipItem(
                        '$periodText: $value',
                        const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                        if (value < 0 ||
                            value >= controller.financialData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.financialData[value.toInt()].label,
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
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta, // Using the meta parameter directly
                          child: Text(
                            controller.currencyFormatter
                                .format(value)
                                .replaceAll('.00', 'k'),
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20000,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                barGroups: List.generate(
                  controller.financialData.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: controller
                            .financialData[index].currentPeriodRevenue,
                        color: Colors.blue.shade600,
                        width: 12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: controller
                            .financialData[index].previousPeriodRevenue,
                        color: Colors.blue.shade300,
                        width: 12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Current Period',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Previous Period',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(FinancialComparisonController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Revenue Comparison',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14,
              ),
              dataTextStyle: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: 13,
              ),
              columns: const [
                DataColumn(label: Text('Period')),
                DataColumn(label: Text('Current')),
                DataColumn(label: Text('Previous')),
                DataColumn(label: Text('Growth %')),
              ],
              rows: controller.financialData.map((data) {
                final growthColor = data.growthRate >= 0
                    ? Colors.green.shade600
                    : Colors.red.shade600;

                return DataRow(
                  cells: [
                    DataCell(Text(data.label)),
                    DataCell(Text(controller.currencyFormatter
                        .format(data.currentPeriodRevenue))),
                    DataCell(Text(controller.currencyFormatter
                        .format(data.previousPeriodRevenue))),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            data.growthRate >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: growthColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data.growthRate.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: growthColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(FinancialComparisonController controller) {
    // Calculate summary statistics
    final totalCurrentRevenue = controller.financialData
        .map((data) => data.currentPeriodRevenue)
        .reduce((a, b) => a + b);

    final totalPreviousRevenue = controller.financialData
        .map((data) => data.previousPeriodRevenue)
        .reduce((a, b) => a + b);

    final totalGrowthRate = (totalCurrentRevenue - totalPreviousRevenue) /
        totalPreviousRevenue *
        100;

    final averageGrowthRate = controller.financialData
            .map((data) => data.growthRate)
            .reduce((a, b) => a + b) /
        controller.financialData.length;

    final bestPeriod = controller.financialData
        .reduce((a, b) => a.growthRate > b.growthRate ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Revenue',
                value: controller.currencyFormatter.format(totalCurrentRevenue),
                icon: Icons.attach_money,
                iconColor: Colors.green.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Overall Growth',
                value: '${totalGrowthRate.toStringAsFixed(1)}%',
                icon: totalGrowthRate >= 0
                    ? Icons.trending_up
                    : Icons.trending_down,
                iconColor: totalGrowthRate >= 0
                    ? Colors.green.shade600
                    : Colors.red.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Avg. Growth',
                value: '${averageGrowthRate.toStringAsFixed(1)}%',
                icon: Icons.show_chart,
                iconColor: Colors.blue.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Best Period',
                value:
                    '${bestPeriod.label} (${bestPeriod.growthRate.toStringAsFixed(1)}%)',
                icon: Icons.emoji_events,
                iconColor: Colors.amber.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
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
        ],
      ),
    );
  }

  Widget _buildComparisonTypeFilter(FinancialComparisonController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comparison Type',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
                children: [
                  _buildFilterOption(
                    title: 'Monthly',
                    isSelected:
                        controller.selectedComparisonType.value == 'Monthly',
                    onTap: () {
                      controller.changeComparisonType('Monthly');
                      Navigator.pop(Get.context!);
                    },
                  ),
                  _buildFilterOption(
                    title: 'Quarterly',
                    isSelected:
                        controller.selectedComparisonType.value == 'Quarterly',
                    onTap: () {
                      controller.changeComparisonType('Quarterly');
                      Navigator.pop(Get.context!);
                    },
                  ),
                  _buildFilterOption(
                    title: 'Yearly',
                    isSelected:
                        controller.selectedComparisonType.value == 'Yearly',
                    onTap: () {
                      controller.changeComparisonType('Yearly');
                      Navigator.pop(Get.context!);
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildFilterOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.blue.shade800 : Colors.black87,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.blue.shade600,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
