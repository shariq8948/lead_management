import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';

// Import your report page wrapper

class ROIAnalysisController extends GetxController {
  final dateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  final isLoading = true.obs;
  final selectedMarketingChannel = 'All Channels'.obs;
  final selectedView = 'Monthly'.obs;

  final marketingChannels = <String>[
    'All Channels',
    'Digital Ads',
    'Email Marketing',
    'Social Media',
    'Events',
    'Content Marketing',
  ].obs;

  final viewOptions = <String>['Monthly', 'Quarterly', 'Yearly'].obs;

  // ROI Data
  final roiData = <Map<String, dynamic>>[].obs;
  final channelROIData = <Map<String, dynamic>>[].obs;
  final expenseData = <Map<String, dynamic>>[].obs;
  final revenueData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchROIData();
  }

  void setDateRange(DateTimeRange? range) {
    if (range != null) {
      dateRange.value = range;
      fetchROIData();
    }
  }

  void setMarketingChannel(String channel) {
    selectedMarketingChannel.value = channel;
    filterDataByChannel();
  }

  void setViewOption(String view) {
    selectedView.value = view;
    fetchROIData();
  }

  void filterDataByChannel() {
    // This would typically filter the existing data or fetch new data
    fetchROIData();
  }

  Future<void> fetchROIData() async {
    isLoading.value = true;

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    // Example data - In a real app, this would come from your API
    final now = DateTime.now();

    // Sample ROI trend data (monthly for the last 6 months)
    roiData.value = List.generate(6, (index) {
      final month = now.subtract(Duration(days: 30 * (5 - index)));
      final monthName = DateFormat('MMM').format(month);
      double roi;

      if (selectedMarketingChannel.value == 'All Channels') {
        roi = index == 0
            ? 2.1
            : index == 1
                ? 2.4
                : index == 2
                    ? 2.8
                    : index == 3
                        ? 3.2
                        : index == 4
                            ? 3.5
                            : 3.8;
      } else if (selectedMarketingChannel.value == 'Digital Ads') {
        roi = index == 0
            ? 3.2
            : index == 1
                ? 3.4
                : index == 2
                    ? 3.3
                    : index == 3
                        ? 3.7
                        : index == 4
                            ? 4.0
                            : 4.2;
      } else {
        // Random ROI for other channels
        roi = 1.5 + (index * 0.4) + (index % 2 == 0 ? 0.3 : -0.1);
      }

      return {
        'month': monthName,
        'roi': roi,
      };
    });

    // Channel comparison data
    channelROIData.value = [
      {'channel': 'Digital Ads', 'roi': 4.2},
      {'channel': 'Email Marketing', 'roi': 3.8},
      {'channel': 'Social Media', 'roi': 2.5},
      {'channel': 'Events', 'roi': 1.7},
      {'channel': 'Content Marketing', 'roi': 3.1},
    ];

    // Generate expense and revenue data
    expenseData.value = List.generate(6, (index) {
      final month = now.subtract(Duration(days: 30 * (5 - index)));
      final monthName = DateFormat('MMM').format(month);

      // Base expense
      double expense = 5000 + (index * 500);
      // Add some variance
      if (index % 2 == 0) expense += 800;

      return {
        'month': monthName,
        'expense': expense,
      };
    });

    revenueData.value = List.generate(6, (index) {
      final month = now.subtract(Duration(days: 30 * (5 - index)));
      final monthName = DateFormat('MMM').format(month);

      // Calculate revenue from expense and ROI
      final expense = expenseData[index]['expense'] as double;
      final roi = roiData[index]['roi'] as double;
      final revenue = expense * roi;

      return {
        'month': monthName,
        'revenue': revenue,
      };
    });

    isLoading.value = false;
  }
}

class ROIAnalysisPage extends StatelessWidget {
  const ROIAnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(ROIAnalysisController());

    return ReportPageWrapper(
      title: 'ROI Analysis',
      showFilterIcon: true,
      onFilterTap: () => _showFilters(context, controller),
      onDateRangeSelected: (range) => controller.setDateRange(range),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(controller),
            const SizedBox(height: 20),
            _buildROITrendChart(controller),
            const SizedBox(height: 20),
            _buildChannelComparisonChart(controller),
            const SizedBox(height: 20),
            _buildExpenseVsRevenueChart(controller),
            const SizedBox(height: 20),
            _buildRecommendations(),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard(ROIAnalysisController controller) {
    // Calculate average ROI
    final avgROI = controller.roiData.isEmpty
        ? 0.0
        : controller.roiData
                .map((e) => e['roi'] as double)
                .reduce((a, b) => a + b) /
            controller.roiData.length;

    // Calculate total revenue
    final totalRevenue = controller.revenueData.isEmpty
        ? 0.0
        : controller.revenueData
            .map((e) => e['revenue'] as double)
            .reduce((a, b) => a + b);

    // Calculate total expense
    final totalExpense = controller.expenseData.isEmpty
        ? 0.0
        : controller.expenseData
            .map((e) => e['expense'] as double)
            .reduce((a, b) => a + b);

    // Best performing channel
    final bestChannel = controller.channelROIData.isEmpty
        ? null
        : controller.channelROIData.reduce(
            (a, b) => (a['roi'] as double) > (b['roi'] as double) ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
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
                child: _buildSummaryItem(
                  title: 'Average ROI',
                  value: '${avgROI.toStringAsFixed(1)}x',
                  iconData: Icons.trending_up,
                  iconColor: Colors.green,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  title: 'Total Revenue',
                  value:
                      '\$${NumberFormat('#,##0').format(totalRevenue.round())}',
                  iconData: Icons.attach_money,
                  iconColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  title: 'Total Expense',
                  value:
                      '\$${NumberFormat('#,##0').format(totalExpense.round())}',
                  iconData: Icons.account_balance_wallet,
                  iconColor: Colors.orange,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  title: 'Best Channel',
                  value: bestChannel != null
                      ? bestChannel['channel'] as String
                      : 'N/A',
                  iconData: Icons.star,
                  iconColor: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String value,
    required IconData iconData,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildROITrendChart(ROIAnalysisController controller) {
    return _buildChartCard(
      title: 'ROI Trend',
      subtitle: controller.selectedMarketingChannel.value,
      height: 250,
      chart: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${value.toInt()}x',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  );
                },
                interval: 1,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() >= controller.roiData.length ||
                      value.toInt() < 0) {
                    return const SizedBox();
                  }
                  return Text(
                    controller.roiData[value.toInt()]['month'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: (controller.roiData.length - 1).toDouble(),
          minY: 0,
          maxY: 5,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                controller.roiData.length,
                (index) => FlSpot(
                  index.toDouble(),
                  controller.roiData[index]['roi'],
                ),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelComparisonChart(ROIAnalysisController controller) {
    return _buildChartCard(
      title: 'Channel ROI Comparison',
      subtitle: 'Last 30 Days',
      height: 250,
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${value.toInt()}x',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  );
                },
                interval: 1,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() >= controller.channelROIData.length ||
                      value.toInt() < 0) {
                    return const SizedBox();
                  }
                  final channelName = (controller.channelROIData[value.toInt()]
                      ['channel'] as String);
                  final shortName = channelName.split(' ')[0];
                  return Text(
                    shortName,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          barGroups: List.generate(
            controller.channelROIData.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: controller.channelROIData[index]['roi'],
                  color: _getBarColor(index),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          maxY: 5,
        ),
      ),
    );
  }

  Color _getBarColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.purple,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }

  Widget _buildExpenseVsRevenueChart(ROIAnalysisController controller) {
    return _buildChartCard(
      title: 'Expense vs Revenue',
      subtitle: controller.selectedMarketingChannel.value,
      height: 250,
      chart: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '\$${(value / 1000).toInt()}K',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  );
                },
                interval: 5000,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() >= controller.expenseData.length ||
                      value.toInt() < 0) {
                    return const SizedBox();
                  }
                  return Text(
                    controller.expenseData[value.toInt()]['month'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          barGroups: List.generate(
            controller.expenseData.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: controller.expenseData[index]['expense'],
                  color: Colors.orange,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                BarChartRodData(
                  toY: controller.revenueData[index]['revenue'],
                  color: Colors.green,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          maxY: 25000,
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget chart,
    required double height,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
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
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: height,
            child: chart,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recommendations',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            title: 'Increase Digital Ad Investment',
            description:
                'Digital ads show the best ROI at 4.2x. Consider reallocating funds from Events.',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            title: 'Optimize Email Marketing',
            description:
                'Email marketing is performing well. Test new templates to improve conversion.',
            icon: Icons.email_outlined,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            title: 'Review Events Strategy',
            description:
                'Events have the lowest ROI. Consider virtual events to reduce costs.',
            icon: Icons.event_note,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilters(BuildContext context, ROIAnalysisController controller) {
    final channelItems = controller.marketingChannels.map((channel) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Obx(() => ListTile(
              title: Text(
                channel,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: controller.selectedMarketingChannel.value == channel
                  ? Icon(Icons.check_circle, color: Colors.blue)
                  : null,
              onTap: () {
                controller.setMarketingChannel(channel);
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tileColor: controller.selectedMarketingChannel.value == channel
                  ? Colors.blue.withOpacity(0.1)
                  : null,
            )),
      );
    }).toList();

    final viewItems = controller.viewOptions.map((view) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Obx(() => ListTile(
              title: Text(
                view,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: controller.selectedView.value == view
                  ? Icon(Icons.check_circle, color: Colors.blue)
                  : null,
              onTap: () {
                controller.setViewOption(view);
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tileColor: controller.selectedView.value == view
                  ? Colors.blue.withOpacity(0.1)
                  : null,
            )),
      );
    }).toList();

    final filterWidgets = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          'Marketing Channel',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      ...channelItems,
      const Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          'View',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      ...viewItems,
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Text(
            'Apply Filters',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];

    CustomFilterModal.show(context, filterWidgets: filterWidgets);
  }
}
