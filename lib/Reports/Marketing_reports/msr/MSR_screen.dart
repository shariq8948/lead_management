import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads/Reports/Marketing_reports/msr/transactions/screen.dart';
import 'package:leads/utils/constants.dart';

import 'controller.dart';

class MSRReportsScreen extends StatelessWidget {
  final SalesController controller = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshData(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildReportHeader(),
              _buildFilterSection(),
              _buildKPICards(),
              _buildCharts(),
              _buildDetailedStats(),
              _buildRecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: primary3Color,
      title: const Text(
        'Sales Analytics Dashboard',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Implement notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: _exportReport,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showOptionsMenu(context);
          },
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() {
          return DropdownButton<String>(
            value: controller.selectedPeriod.value, // Reactive period value
            items: [
              'This Month',
              'Last Month',
              'Last 3 Months',
              'Last 6 Months',
              'This Year',
              'Custom Range'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue == 'Custom Range') {
                _showDateRangePicker();
              } else {
                controller
                    .updatePeriod(newValue!); // Update period and refresh data
              }
            },
          );
        }),
      ),
    );
  }

  // Show custom date range picker
  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Update the custom date range in the controller
      controller.updateCustomDateRange(picked.start, picked.end);
    }
  }

  // Report Header Widget
  Widget _buildReportHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reactive Date display (for the selected date or custom range)
                  Obx(() {
                    String displayText;

                    if (controller.selectedPeriod.value == 'Custom Range') {
                      // Display the custom date range in dd/MM/yyyy format
                      displayText =
                          '${DateFormat('dd/MM/yyyy').format(controller.customStartDate.value)} - ${DateFormat('dd/MM/yyyy').format(controller.customEndDate.value)}';
                    } else {
                      // For other periods, display in Month Year format
                      displayText = DateFormat('MMMM yyyy')
                          .format(controller.selectedDate.value);
                    }

                    return Text(
                      displayText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  // Last updated time reactive display
                  Obx(() {
                    String displayLastUpdated;
                    if (controller.selectedPeriod.value == 'Custom Range') {
                      displayLastUpdated =
                          'Last updated: ${DateFormat('dd MMM yyyy').format(controller.customStartDate.value)} - ${DateFormat('dd MMM yyyy').format(controller.customEndDate.value)}';
                    } else {
                      displayLastUpdated =
                          'Last updated: ${DateFormat('dd MMM yyyy, HH:mm').format(controller.selectedDate.value)}';
                    }
                    return Text(
                      displayLastUpdated,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    );
                  }),
                ],
              ),
              _buildPeriodSelector(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterColumn(
                  'Region',
                  controller.selectedRegion,
                  ['All', 'North', 'South', 'East', 'West'],
                ),
                const SizedBox(width: 16),
                _buildFilterColumn(
                  'Category',
                  controller.selectedCategory,
                  ['All', 'Electronics', 'Clothing', 'Food', 'Others'],
                ),
                const SizedBox(width: 16),
                _buildFilterColumn(
                  'Sales Type',
                  controller.selectedSalesType,
                  ['All', 'Online', 'In-store', 'Wholesale'],
                ),
                const SizedBox(width: 16),
                _buildFilterColumn(
                  'Status',
                  controller.selectedStatus,
                  ['All', 'Completed', 'Pending', 'Cancelled'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterColumn(
    String title,
    RxString selectedValue,
    List<String> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        _buildFilterChip(title, selectedValue, options),
      ],
    );
  }

  Widget _buildFilterChip(
      String title, RxString selectedValue, List<String> options) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(.2)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withOpacity(.8),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue.value,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedValue.value = value; // Update the selected value.
                }
              },
              hint: Text(
                title,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                ),
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ));
  }

  Widget _buildKPICards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
            children: [
              _buildKPICard(
                'Total Revenue',
                '\$${controller.totalSales.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.blue[700]!,
                '+12.5%',
              ),
              _buildKPICard(
                'Total Orders',
                '${controller.totalOrders}',
                Icons.shopping_cart,
                Colors.green[700]!,
                '+8.3%',
              ),
              _buildKPICard(
                'Average Order',
                '\$${controller.averageOrderValue.toStringAsFixed(2)}',
                Icons.bar_chart,
                Colors.orange[700]!,
                '+5.2%',
              ),
              _buildKPICard(
                'Conversion Rate',
                '3.8%',
                Icons.trending_up,
                Colors.purple[700]!,
                '+2.1%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
      String title, String value, IconData icon, Color color, String trend) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),

          // Title Text
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          // Value Text
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),

          // Trend (Comparison) Text
          Row(
            children: [
              Text(
                trend,
                style: TextStyle(
                  color: trend.contains('+') ? Colors.green : Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow:
                    TextOverflow.ellipsis, // Prevent overflow if text is long
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSalesTrendChart(),
          const SizedBox(height: 24),
          _buildCategoryDistributionChart(),
          const SizedBox(height: 24),
          _buildPerformanceChart(),
        ],
      ),
    );
  }

  Widget _buildSalesTrendChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Sales Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Line Chart Container
          SizedBox(
            height: 350,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}K',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Actual Sales Trend Line
                  LineChartBarData(
                    spots: controller.salesTrend,
                    isCurved: true,
                    color: Colors.teal,
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.teal.withOpacity(0.1),
                    ),
                  ),
                  // Target Sales Trend Line (Dashed)
                  LineChartBarData(
                    spots: controller.targetTrend,
                    isCurved: true,
                    color: Colors.grey[400]!,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),

          // Add the custom Legend
          const SizedBox(height: 16),
          _buildLegendItem('Actual Sales', Colors.blue, '+5.2%'),
          _buildLegendItem('Target Sales', Colors.grey[400]!, '+3.0%'),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detailed Statistics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Implement view all action
                },
                child: const Text('View All'),
              ),
            ],
          ),
          _buildStatsTable(),
        ],
      ),
    );
  }

  Widget _buildStatsTable() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Total Orders', '${controller.totalOrders}', '+8.3%'),
            _buildStatRow(
                'Average Order Value',
                '\$${controller.averageOrderValue.toStringAsFixed(2)}',
                '+5.2%'),
            _buildStatRow('Conversion Rate', '3.8%', '+2.1%'),
            _buildStatRow('Cart Abandonment', '23.8%', '-1.5%'),
            _buildStatRow('Top Product', controller.topProduct.value, ''),
            _buildStatRow('Best Selling Category', 'Electronics', ''),
            _buildStatRow('Repeat Customer Rate', '42.5%', '+3.8%'),
            _buildStatRow('Average Items per Order', '3.2', '+0.3'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, String trend) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (trend.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: trend.startsWith('+')
                        ? Colors.green[50]
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      color: trend.startsWith('+')
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(TransactionsScreen());
                },
                child: const Text('View All'),
              ),
            ],
          ),
          _buildTransactionsList(),
        ],
      ),
    );
  }

  Widget _buildCategoryDistributionChart() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales by Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: controller.categoryDistribution,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem('Electronics', Colors.blue, '35%'),
                        _buildLegendItem('Clothing', Colors.green, '25%'),
                        _buildLegendItem('Home & Garden', Colors.orange, '20%'),
                        _buildLegendItem('Books', Colors.indigo, '15%'),
                        _buildLegendItem('Others', Colors.pink, '5%'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Performance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()}%',
                          const TextStyle(color: Colors.white),
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
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: controller.getPerformanceData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Container(
      height: Get.height * .5,
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,

        itemCount: 15, // Show last 5 transactions
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return _buildTransactionItem(
            orderId: '#ORD-${2024001 + index}',
            customerName: 'Customer ${index + 1}',
            amount: (Random().nextDouble() * 1000).toStringAsFixed(2),
            date: DateTime.now().subtract(Duration(hours: index * 2)),
            status: _getRandomStatus(),
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem({
    required String orderId,
    required String customerName,
    required String amount,
    required DateTime date,
    required String status,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            orderId,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$$amount',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(customerName),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMM dd, yyyy HH:mm').format(date),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: _getStatusColor(status),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _getRandomStatus() {
    final statuses = ['Completed', 'Pending', 'Processing', 'Cancelled'];
    return statuses[Random().nextInt(statuses.length)];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.print),
                title: const Text('Print Report'),
                onTap: () {
                  // Implement print functionality
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Report'),
                onTap: () {
                  // Implement share functionality
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Report Settings'),
                onTap: () {
                  // Implement settings navigation
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportReport() {
    Get.snackbar(
      'Export Report',
      'Sales report downloaded successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
