import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';

class CustomerAcquisitionCostReport extends StatelessWidget {
  CustomerAcquisitionCostReport({Key? key}) : super(key: key);

  // Controller for handling the CAC report data and logic
  final CACReportController controller = Get.put(CACReportController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Customer Acquisition Cost',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context),
      onDateRangeSelected: (DateTimeRange? range) {
        if (range != null) {
          controller.updateDateRange(range);
        }
      },
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateFilterInfo(),
            const SizedBox(height: 16),
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildCACTrendChart(),
            const SizedBox(height: 24),
            _buildChannelBreakdown(),
            const SizedBox(height: 24),
            _buildDetailedExpensesTable(),
          ],
        );
      }),
    );
  }

  Widget _buildDateFilterInfo() {
    return Obx(() {
      if (controller.dateRange.value == null) {
        return const SizedBox.shrink();
      }

      final formatter = DateFormat('MMM dd, yyyy');
      final start = formatter.format(controller.dateRange.value!.start);
      final end = formatter.format(controller.dateRange.value!.end);

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Showing data from $start to $end',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                'Average CAC',
                '\$${controller.averageCac.value.toStringAsFixed(2)}',
                Colors.blue.shade50,
                Colors.blue.shade700,
                Icons.attach_money,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _metricCard(
                'New Customers',
                controller.totalNewCustomers.value.toString(),
                Colors.green.shade50,
                Colors.green.shade700,
                Icons.person_add,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                'Total Spent',
                '\$${controller.totalSpent.value.toStringAsFixed(2)}',
                Colors.purple.shade50,
                Colors.purple.shade700,
                Icons.account_balance_wallet,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _metricCard(
                'CAC Change',
                '${controller.cacChange.value >= 0 ? '+' : ''}${controller.cacChange.value.toStringAsFixed(1)}%',
                controller.cacChange.value >= 0
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                controller.cacChange.value >= 0
                    ? Colors.red.shade700
                    : Colors.green.shade700,
                controller.cacChange.value >= 0
                    ? Icons.trending_up
                    : Icons.trending_down,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _metricCard(String title, String value, Color bgColor, Color textColor,
      IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCACTrendChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CAC Trend',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 250,
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
          child: Obx(() {
            if (controller.cacTrend.isEmpty) {
              return Center(
                child: Text(
                  'No data available for the selected date range',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            }

            return LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= controller.cacTrend.length ||
                            value.toInt() < 0) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.cacTrend[value.toInt()].period,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '\$${value.toInt()}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                minX: 0,
                maxX: controller.cacTrend.length - 1.0,
                minY: 0,
                maxY: controller.maxCacValue * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      controller.cacTrend.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        controller.cacTrend[index].cac,
                      ),
                    ),
                    isCurved: true,
                    color: Colors.blue.shade500,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue.shade500,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade200.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildChannelBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Channel Breakdown',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
          child: Obx(() {
            if (controller.channelData.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No channel data available for the selected filters',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: controller.channelData.map((channel) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            channel.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '\$${channel.cac.toStringAsFixed(2)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: channel.cac / controller.maxChannelCac,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          color: _getChannelColor(channel.name),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customers: ${channel.customers}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Spent: \$${channel.totalSpent.toStringAsFixed(2)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }

  Color _getChannelColor(String channel) {
    switch (channel) {
      case 'Social Media':
        return Colors.blue.shade500;
      case 'Search Ads':
        return Colors.red.shade500;
      case 'Email Marketing':
        return Colors.green.shade500;
      case 'Referrals':
        return Colors.purple.shade500;
      case 'Direct':
        return Colors.orange.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  Widget _buildDetailedExpensesTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Expenses',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
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
          child: Obx(() {
            if (controller.detailedExpenses.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No expense data available for the selected filters',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
                headingTextStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                dataTextStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                columns: const [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Channel')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Customers')),
                  DataColumn(label: Text('CAC Impact')),
                ],
                rows: List.generate(
                  controller.detailedExpenses.length,
                  (index) {
                    final expense = controller.detailedExpenses[index];
                    return DataRow(cells: [
                      DataCell(Text(expense.category)),
                      DataCell(Text(expense.channel)),
                      DataCell(Text('\$${expense.amount.toStringAsFixed(2)}')),
                      DataCell(Text(expense.date)),
                      DataCell(Text(expense.attributedCustomers.toString())),
                      DataCell(
                          Text('\$${expense.cacImpact.toStringAsFixed(2)}')),
                    ]);
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        _buildFilterSection(
          'Channels',
          [
            'Social Media',
            'Search Ads',
            'Email Marketing',
            'Referrals',
            'Direct',
            'Other',
          ],
          controller.selectedChannels,
          (value, isSelected) {
            if (isSelected) {
              controller.selectedChannels.add(value);
            } else {
              controller.selectedChannels.remove(value);
            }
            controller.applyFilters();
          },
        ),
        _buildFilterSection(
          'Expense Categories',
          [
            'Advertising',
            'Content Creation',
            'Sales Team',
            'Marketing Tools',
            'Events',
            'Other Operational',
          ],
          controller.selectedCategories,
          (value, isSelected) {
            if (isSelected) {
              controller.selectedCategories.add(value);
            } else {
              controller.selectedCategories.remove(value);
            }
            controller.applyFilters();
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CAC Range',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => RangeSlider(
                    values: controller.cacRangeFilter.value,
                    min: 0,
                    max: 500,
                    divisions: 50,
                    labels: RangeLabels(
                      '\$${controller.cacRangeFilter.value.start.round()}',
                      '\$${controller.cacRangeFilter.value.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      controller.cacRangeFilter.value = values;
                    },
                    onChangeEnd: (RangeValues values) {
                      controller.applyFilters();
                    },
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              controller.resetFilters();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Reset Filters'),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    RxSet<String> selectedValues,
    Function(String, bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              return Obx(() {
                final isSelected = selectedValues.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    onChanged(option, selected);
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue.shade700,
                  labelStyle: GoogleFonts.montserrat(
                    color: isSelected ? Colors.blue.shade700 : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.blue.shade300
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CACReportController extends GetxController {
  var isLoading = true.obs;
  var averageCac = 0.0.obs;
  var totalNewCustomers = 0.obs;
  var totalSpent = 0.0.obs;
  var cacChange = 0.0.obs;
  var selectedChannels = <String>{}.obs;
  var selectedCategories = <String>{}.obs;
  var cacRangeFilter = const RangeValues(0, 500).obs;
  var dateRange = Rx<DateTimeRange?>(null);

  var maxCacValue = 0.0;
  var maxChannelCac = 0.0;

  // Sample data structures
  var cacTrend = <CACTrendPoint>[].obs;
  var channelData = <ChannelCACData>[].obs;
  var detailedExpenses = <ExpenseDetail>[].obs;

  // Original data for filtering
  var _originalCacTrend = <CACTrendPoint>[];
  var _originalChannelData = <ChannelCACData>[];
  var _originalDetailedExpenses = <ExpenseDetail>[];

  // Store expense dates for date filtering
  var _expenseDates = <DateTime>[];

  @override
  void onInit() {
    super.onInit();
    // Load sample data
    _loadSampleData();

    // Set default date range to last 30 days
    final now = DateTime.now();
    dateRange.value = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );

    // Initialize filters with all options
    selectedChannels.addAll([
      'Social Media',
      'Search Ads',
      'Email Marketing',
      'Referrals',
      'Direct',
      'Other',
    ]);

    selectedCategories.addAll([
      'Advertising',
      'Content Creation',
      'Sales Team',
      'Marketing Tools',
      'Events',
      'Other Operational',
    ]);

    // Apply initial date filter
    applyFilters();

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  void updateDateRange(DateTimeRange range) {
    dateRange.value = range;
    applyFilters();
  }

  void _loadSampleData() {
    // Generate full dataset with a wider date range for filtering demonstration
    final now = DateTime.now();

    // Sample CAC trend data - one entry per month for the last 12 months
    _originalCacTrend = [];
    for (int i = 11; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthName = DateFormat('MMM').format(date);
      _originalCacTrend.add(CACTrendPoint(
        period: monthName,
        cac: 100 +
            (i % 3 == 0 ? 10 : 0) +
            (i % 2 == 0 ? 15 : 5) +
            (i % 5 == 0 ? 20 : -5),
        date: date,
      ));
    }

    // Find max CAC value for chart scaling
    maxCacValue =
        _originalCacTrend.map((e) => e.cac).reduce((a, b) => a > b ? a : b);

    // Sample channel data
    _originalChannelData = [
      ChannelCACData(
        name: 'Social Media',
        cac: 110.5,
        customers: 87,
        totalSpent: 9613.5,
      ),
      ChannelCACData(
        name: 'Search Ads',
        cac: 135.8,
        customers: 65,
        totalSpent: 8827.0,
      ),
      ChannelCACData(
        name: 'Email Marketing',
        cac: 75.2,
        customers: 42,
        totalSpent: 3158.4,
      ),
      ChannelCACData(
        name: 'Referrals',
        cac: 45.6,
        customers: 38,
        totalSpent: 1732.8,
      ),
      ChannelCACData(
        name: 'Direct',
        cac: 95.3,
        customers: 27,
        totalSpent: 2573.1,
      ),
    ];

    // Find max channel CAC for progress bars
    maxChannelCac =
        _originalChannelData.map((e) => e.cac).reduce((a, b) => a > b ? a : b);

    // Sample detailed expenses - generate expenses over past 90 days
    _originalDetailedExpenses = [];
    _expenseDates = [];

    // Categories and channels for sample data
    final categories = [
      'Advertising',
      'Content Creation',
      'Sales Team',
      'Marketing Tools',
      'Events',
      'Other Operational'
    ];

    final channels = [
      'Social Media',
      'Search Ads',
      'Email Marketing',
      'Referrals',
      'Direct',
      'Other'
    ];

    // Generate expenses across different dates
    for (int i = 0; i < 90; i += 3) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final categoryIndex = i % categories.length;
      final channelIndex = (i ~/ 3) % channels.length;

      final amount = 500.0 + (i % 7) * 200.0;
      final customers = 10 + (i % 5) * 5;

      _originalDetailedExpenses.add(ExpenseDetail(
        category: categories[categoryIndex],
        channel: channels[channelIndex],
        amount: amount,
        date: dateStr,
        attributedCustomers: customers,
        cacImpact: amount / customers,
        expenseDate: date,
      ));

      _expenseDates.add(date);
    }
  }

  void _calculateSummaryMetrics() {
    // Calculate total customers
    totalNewCustomers.value =
        channelData.fold(0, (sum, item) => sum + item.customers);

    // Calculate total spent
    totalSpent.value =
        channelData.fold(0.0, (sum, item) => sum + item.totalSpent);

    // Calculate average CAC
    averageCac.value = totalNewCustomers.value > 0
        ? totalSpent.value / totalNewCustomers.value
        : 0.0;

    // Calculate CAC change (comparing to previous period)
    // This is a dynamic calculation based on available data
    if (cacTrend.length >= 2) {
      final currentCAC = cacTrend.last.cac;
      final previousCAC = cacTrend[cacTrend.length - 2].cac;
      cacChange.value = ((currentCAC - previousCAC) / previousCAC) * 100;
    } else {
      cacChange.value = 0.0;
    }
  }

  void applyFilters() {
    if (dateRange.value == null) return;

    // Filter CAC trend data by date
    cacTrend.value = _originalCacTrend
        .where((point) =>
            point.date.isAfter(
                dateRange.value!.start.subtract(const Duration(days: 1))) &&
            point.date
                .isBefore(dateRange.value!.end.add(const Duration(days: 1))))
        .toList();

    // Find the max CAC value in the filtered data for chart scaling
    if (cacTrend.isNotEmpty) {
      maxCacValue = cacTrend.map((e) => e.cac).reduce((a, b) => a > b ? a : b);
    } else {
      maxCacValue = 0.0;
    }

    // Filter detailed expenses by date, channels, and categories
    detailedExpenses.value = _originalDetailedExpenses
        .where((expense) =>
            expense.expenseDate.isAfter(
                dateRange.value!.start.subtract(const Duration(days: 1))) &&
            expense.expenseDate
                .isBefore(dateRange.value!.end.add(const Duration(days: 1))) &&
            selectedChannels.contains(expense.channel) &&
            selectedCategories.contains(expense.category) &&
            expense.cacImpact >= cacRangeFilter.value.start &&
            expense.cacImpact <= cacRangeFilter.value.end)
        .toList();

    // Recalculate channel data based on filtered expenses
    final channelMap = <String, ChannelCACData>{};
    for (final expense in detailedExpenses) {
      if (!channelMap.containsKey(expense.channel)) {
        channelMap[expense.channel] = ChannelCACData(
          name: expense.channel,
          cac: 0,
          customers: 0,
          totalSpent: 0,
        );
      }

      channelMap[expense.channel]!.customers += expense.attributedCustomers;
      channelMap[expense.channel]!.totalSpent += expense.amount;
    }

    // Calculate CAC for each channel
    channelMap.forEach((_, data) {
      if (data.customers > 0) {
        data.cac = data.totalSpent / data.customers;
      }
    });

    // Update channel data
    channelData.value = channelMap.values.toList();

    // Find max channel CAC for progress bars
    if (channelData.isNotEmpty) {
      maxChannelCac =
          channelData.map((e) => e.cac).reduce((a, b) => a > b ? a : b);
    } else {
      maxChannelCac = 0.0;
    }

    // Calculate summary metrics
    _calculateSummaryMetrics();
  }

  void resetFilters() {
    // Reset channel filters
    selectedChannels.clear();
    selectedChannels.addAll([
      'Social Media',
      'Search Ads',
      'Email Marketing',
      'Referrals',
      'Direct',
      'Other',
    ]);

    // Reset category filters
    selectedCategories.clear();
    selectedCategories.addAll([
      'Advertising',
      'Content Creation',
      'Sales Team',
      'Marketing Tools',
      'Events',
      'Other Operational',
    ]);

    // Reset CAC range filter
    cacRangeFilter.value = const RangeValues(0, 500);

    // Reapply filters with reset values
    applyFilters();
  }
}

// Data models

class CACTrendPoint {
  final String period;
  final double cac;
  final DateTime date;

  CACTrendPoint({
    required this.period,
    required this.cac,
    required this.date,
  });
}

class ChannelCACData {
  final String name;
  double cac;
  int customers;
  double totalSpent;

  ChannelCACData({
    required this.name,
    required this.cac,
    required this.customers,
    required this.totalSpent,
  });
}

class ExpenseDetail {
  final String category;
  final String channel;
  final double amount;
  final String date;
  final int attributedCustomers;
  final double cacImpact;
  final DateTime expenseDate;

  ExpenseDetail({
    required this.category,
    required this.channel,
    required this.amount,
    required this.date,
    required this.attributedCustomers,
    required this.cacImpact,
    required this.expenseDate,
  });
}
