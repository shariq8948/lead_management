import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/page_wrapper.dart';

// Model to hold budget variance data
class BudgetItem {
  final String category;
  final double budgeted;
  final double actual;
  final String period;

  BudgetItem({
    required this.category,
    required this.budgeted,
    required this.actual,
    required this.period,
  });

  double get variance => budgeted - actual;
  double get variancePercentage => (variance / budgeted) * 100;
  bool get isOverBudget => actual > budgeted;
  Color get varianceColor => isOverBudget ? Colors.red : Colors.green;
}

// Controller using GetX
class BudgetVarianceController extends GetxController {
  final RxList<BudgetItem> budgetItems = <BudgetItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategoryFilter = 'All'.obs;
  final RxBool showOnlyOverBudget = false.obs;
  final RxDouble totalBudgeted = 0.0.obs;
  final RxDouble totalActual = 0.0.obs;

  // For date range
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize with default date range (current month)
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    selectedDateRange.value = DateTimeRange(start: start, end: end);

    // Load initial data
    fetchBudgetData();
  }

  // Method to fetch budget data
  Future<void> fetchBudgetData() async {
    isLoading.value = true;

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data - replace with your actual API call
      final List<BudgetItem> fetchedData = [
        BudgetItem(
            category: 'Marketing',
            budgeted: 5000,
            actual: 5600,
            period: 'April 2025'),
        BudgetItem(
            category: 'Sales',
            budgeted: 8000,
            actual: 7200,
            period: 'April 2025'),
        BudgetItem(
            category: 'IT', budgeted: 3500, actual: 4200, period: 'April 2025'),
        BudgetItem(
            category: 'HR', budgeted: 2000, actual: 1800, period: 'April 2025'),
        BudgetItem(
            category: 'Operations',
            budgeted: 12000,
            actual: 11500,
            period: 'April 2025'),
        BudgetItem(
            category: 'Legal',
            budgeted: 1500,
            actual: 2100,
            period: 'April 2025'),
      ];

      budgetItems.value = fetchedData;

      // Calculate totals
      _calculateTotals();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load budget data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateTotals() {
    totalBudgeted.value =
        budgetItems.fold(0, (sum, item) => sum + item.budgeted);
    totalActual.value = budgetItems.fold(0, (sum, item) => sum + item.actual);
  }

  // Filter methods
  List<BudgetItem> get filteredItems {
    return budgetItems.where((item) {
      bool categoryMatch = selectedCategoryFilter.value == 'All' ||
          item.category == selectedCategoryFilter.value;
      bool budgetStatusMatch = !showOnlyOverBudget.value || item.isOverBudget;
      return categoryMatch && budgetStatusMatch;
    }).toList();
  }

  List<String> get categories {
    final Set<String> cats = budgetItems.map((item) => item.category).toSet();
    return ['All', ...cats];
  }

  // Method to handle date range changes
  void onDateRangeChanged(DateTimeRange? dateRange) {
    if (dateRange != null) {
      selectedDateRange.value = dateRange;
      fetchBudgetData(); // Reload data with new date range
    }
  }

  // Toggle showing only over budget items
  void toggleOverBudgetFilter(bool value) {
    showOnlyOverBudget.value = value;
  }

  // Set category filter
  void setCategoryFilter(String category) {
    selectedCategoryFilter.value = category;
  }
}

// Budget Variance Report Page
class BudgetVarianceReportPage extends StatelessWidget {
  BudgetVarianceReportPage({Key? key}) : super(key: key);

  final BudgetVarianceController controller =
      Get.put(BudgetVarianceController());
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Budget Variance',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context),
      onDateRangeSelected: controller.onDateRangeChanged,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildVarianceChart(),
            const SizedBox(height: 20),
            _buildVarianceList(),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    double varianceAmount =
        controller.totalBudgeted.value - controller.totalActual.value;
    double variancePercentage = controller.totalBudgeted.value > 0
        ? (varianceAmount / controller.totalBudgeted.value) * 100
        : 0;
    bool isOverBudget = varianceAmount < 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOverBudget
              ? [Colors.red.shade50, Colors.red.shade100]
              : [Colors.green.shade50, Colors.green.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
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
            'Budget Summary',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Budgeted',
                  currencyFormat.format(controller.totalBudgeted.value),
                  Colors.blue.shade700,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Actual',
                  currencyFormat.format(controller.totalActual.value),
                  Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Variance',
                  '${varianceAmount < 0 ? "-" : ""}${currencyFormat.format(varianceAmount.abs())}',
                  isOverBudget ? Colors.red.shade700 : Colors.green.shade700,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Variance %',
                  '${variancePercentage.toStringAsFixed(1)}%',
                  isOverBudget ? Colors.red.shade700 : Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildVarianceChart() {
    final items = controller.filteredItems;

    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget vs. Actual',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: items.isEmpty
                    ? 10000
                    : items
                            .map((e) =>
                                e.budgeted > e.actual ? e.budgeted : e.actual)
                            .reduce((a, b) => a > b ? a : b) *
                        1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = items[groupIndex];
                      return BarTooltipItem(
                        '${item.category}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: rodIndex == 0
                                ? 'Budget: ${currencyFormat.format(item.budgeted)}\n'
                                : 'Actual: ${currencyFormat.format(item.actual)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
                        if (value.toInt() >= items.length ||
                            value.toInt() < 0) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            items[value.toInt()].category.split(' ')[0],
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          currencyFormat.format(value).toString(),
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: items.isEmpty
                    ? []
                    : List.generate(items.length, (index) {
                        final item = items[index];
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: item.budgeted,
                              color: Colors.blue.shade300,
                              width: 12,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                            BarChartRodData(
                              toY: item.actual,
                              color: item.isOverBudget
                                  ? Colors.red.shade400
                                  : Colors.green.shade400,
                              width: 12,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Budget', Colors.blue.shade300),
              const SizedBox(width: 24),
              _buildLegendItem('Actual', Colors.green.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildVarianceList() {
    final items = controller.filteredItems;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
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
              'Budget Details',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No data available for selected filters',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(
                    item.category,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Budget: ${currencyFormat.format(item.budgeted)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Actual: ${currencyFormat.format(item.actual)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.variancePercentage >= 0
                            ? '+${item.variancePercentage.toStringAsFixed(1)}%'
                            : '${item.variancePercentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          color: item.varianceColor,
                        ),
                      ),
                      Text(
                        currencyFormat.format(item.variance),
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: item.varianceColor,
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

  void _showFilterModal(BuildContext context) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.categories.map((category) {
                      final isSelected =
                          controller.selectedCategoryFilter.value == category;
                      return InkWell(
                        onTap: () => controller.setCategoryFilter(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade100
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue.shade400
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            category,
                            style: GoogleFonts.montserrat(
                              color: isSelected
                                  ? Colors.blue.shade700
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Obx(() => SwitchListTile(
                title: Text(
                  'Show Only Over Budget Items',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: controller.showOnlyOverBudget.value,
                activeColor: Colors.red.shade400,
                onChanged: controller.toggleOverBudgetFilter,
              )),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade500,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Apply Filters',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
