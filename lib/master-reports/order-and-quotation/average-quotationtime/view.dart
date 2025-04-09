import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Import your page wrapper

import '../../widgets/page_wrapper.dart';

// Controller for managing state
class QuotationOrderTimeController extends GetxController {
  // Selected date range
  Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  // Filter options
  RxString selectedSalesRep = 'All'.obs;
  RxString selectedProductCategory = 'All'.obs;
  RxString selectedClientType = 'All'.obs;

  // Loading state
  RxBool isLoading = false.obs;

  // Data for the report
  RxList<QuotationOrderTimeData> conversionTimeData =
      <QuotationOrderTimeData>[].obs;
  RxDouble overallAverageTime = 0.0.obs;
  RxDouble fastestTime = 0.0.obs;
  RxDouble slowestTime = 0.0.obs;
  RxInt totalConversions = 0.obs;

  // Data for chart
  RxList<TimeDistributionData> distributionData = <TimeDistributionData>[].obs;
  RxList<TimeSeriesData> timeSeriesData = <TimeSeriesData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Fetch data based on the selected date range and filters
  Future<void> fetchData() async {
    isLoading.value = true;

    await Future.delayed(
        const Duration(milliseconds: 1000)); // Simulate API call

    // Mock data - Replace with actual API calls
    overallAverageTime.value = 4.8; // days
    fastestTime.value = 1.2; // days
    slowestTime.value = 14.5; // days
    totalConversions.value = 87;

    // Generate mock data for table
    conversionTimeData.value = [
      QuotationOrderTimeData(
        salesRep: 'John Smith',
        category: 'Software',
        averageTime: 3.8,
        conversions: 27,
        fastestTime: 1.2,
        slowestTime: 8.5,
      ),
      QuotationOrderTimeData(
        salesRep: 'Maria Rodriguez',
        category: 'Hardware',
        averageTime: 5.2,
        conversions: 19,
        fastestTime: 2.0,
        slowestTime: 11.3,
      ),
      QuotationOrderTimeData(
        salesRep: 'David Kim',
        category: 'Services',
        averageTime: 4.5,
        conversions: 30,
        fastestTime: 1.5,
        slowestTime: 9.7,
      ),
      QuotationOrderTimeData(
        salesRep: 'Sarah Johnson',
        category: 'Consulting',
        averageTime: 6.4,
        conversions: 11,
        fastestTime: 2.8,
        slowestTime: 14.5,
      ),
    ];

    // Generate mock distribution data for chart
    distributionData.value = [
      TimeDistributionData(range: '1-2 days', count: 15),
      TimeDistributionData(range: '3-5 days', count: 32),
      TimeDistributionData(range: '6-10 days', count: 28),
      TimeDistributionData(range: '11-15 days', count: 9),
      TimeDistributionData(range: '16+ days', count: 3),
    ];

    // Generate mock time series data
    final DateFormat formatter = DateFormat('MMM d');
    final now = DateTime.now();

    timeSeriesData.value = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 30 - (index * 5)));
      return TimeSeriesData(
        date: formatter.format(date),
        averageTime: 3.0 + (index % 3) * 1.2 + (index % 2 == 0 ? 0.8 : -0.4),
      );
    });

    isLoading.value = false;
  }

  // Filter the data based on the selected options
  void applyFilters() {
    fetchData(); // Refresh data with new filters
    Get.back(); // Close the filter modal
  }

  // Update date range and refetch data
  void updateDateRange(DateTimeRange? newRange) {
    if (newRange != null) {
      selectedDateRange.value = newRange;
      fetchData();
    }
  }
}

// Data models
class QuotationOrderTimeData {
  final String salesRep;
  final String category;
  final double averageTime;
  final int conversions;
  final double fastestTime;
  final double slowestTime;

  QuotationOrderTimeData({
    required this.salesRep,
    required this.category,
    required this.averageTime,
    required this.conversions,
    required this.fastestTime,
    required this.slowestTime,
  });
}

class TimeDistributionData {
  final String range;
  final int count;

  TimeDistributionData({
    required this.range,
    required this.count,
  });
}

class TimeSeriesData {
  final String date;
  final double averageTime;

  TimeSeriesData({
    required this.date,
    required this.averageTime,
  });
}

// Main Page
class QuotationOrderTimePage extends StatelessWidget {
  const QuotationOrderTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(QuotationOrderTimeController());

    return ReportPageWrapper(
      title: 'Quotation to Order Time',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context, controller),
      onDateRangeSelected: controller.updateDateRange,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(controller),
                  const SizedBox(height: 24),
                  _buildTimeSeriesChart(controller),
                  const SizedBox(height: 24),
                  _buildTimeDistributionChart(controller),
                  const SizedBox(height: 24),
                  _buildConversionTimeTable(controller),
                ],
              ),
      ),
    );
  }

  // Summary metrics cards
  Widget _buildSummaryCards(QuotationOrderTimeController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Time Summary',
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
                child: _buildMetricCard(
                  'Average Time',
                  '${controller.overallAverageTime.value.toStringAsFixed(1)} days',
                  Colors.blue.shade50,
                  Colors.blue.shade700,
                  Icons.timelapse,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Fastest Conversion',
                  '${controller.fastestTime.value.toStringAsFixed(1)} days',
                  Colors.green.shade50,
                  Colors.green.shade700,
                  Icons.speed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Slowest Conversion',
                  '${controller.slowestTime.value.toStringAsFixed(1)} days',
                  Colors.orange.shade50,
                  Colors.orange.shade700,
                  Icons.hourglass_bottom,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Total Conversions',
                  controller.totalConversions.toString(),
                  Colors.purple.shade50,
                  Colors.purple.shade700,
                  Icons.check_circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Individual metric card
  Widget _buildMetricCard(
    String title,
    String value,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
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
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  // Time series chart
  Widget _buildTimeSeriesChart(QuotationOrderTimeController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Average Conversion Time Trend',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
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
            child: controller.timeSeriesData.isEmpty
                ? const Center(child: Text('No data available'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 2,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade100,
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade100,
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
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              if (value >= 0 &&
                                  value < controller.timeSeriesData.length) {
                                return Text(
                                  controller.timeSeriesData[value.toInt()].date,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
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
                            interval: 2,
                            getTitlesWidget: (value, _) {
                              return Text(
                                '${value.toInt()} days',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                ),
                              );
                            },
                            reservedSize: 50,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      minX: 0,
                      maxX: controller.timeSeriesData.length - 1.0,
                      minY: 0,
                      maxY: 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: controller.timeSeriesData
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.averageTime,
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.teal.shade700,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 4,
                              color: Colors.teal.shade700,
                              strokeColor: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.teal.shade100.withOpacity(0.3),
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

  // Distribution chart
  Widget _buildTimeDistributionChart(QuotationOrderTimeController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Time Distribution',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
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
            child: controller.distributionData.isEmpty
                ? const Center(child: Text('No data available'))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 35,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${controller.distributionData[groupIndex].range}\n',
                              GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${rod.toY.toInt()} conversions',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 12,
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
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, _) {
                              if (value >= 0 &&
                                  value < controller.distributionData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    controller
                                        .distributionData[value.toInt()].range,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10,
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
                            interval: 10,
                            getTitlesWidget: (value, _) {
                              return Text(
                                value.toInt().toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade100,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: controller.distributionData
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.count.toDouble(),
                                  color: _getBarColor(entry.key),
                                  width: 22,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Get color for distribution bars
  Color _getBarColor(int index) {
    List<Color> colors = [
      Colors.green.shade500,
      Colors.teal.shade500,
      Colors.amber.shade500,
      Colors.orange.shade500,
      Colors.red.shade500,
    ];
    return colors[index % colors.length];
  }

  // Conversion time table by sales rep and category
  Widget _buildConversionTimeTable(QuotationOrderTimeController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Time by Sales Rep & Category',
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      MaterialStateProperty.all(Colors.grey.shade50),
                  dataRowHeight: 60,
                  headingRowHeight: 50,
                  horizontalMargin: 16,
                  columnSpacing: 16,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Sales Rep',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Category',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Avg. Time',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Fastest',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Slowest',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Conversions',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],
                  rows: controller.conversionTimeData
                      .map(
                        (data) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                data.salesRep,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.category,
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: FractionallySizedBox(
                                      widthFactor: data.averageTime /
                                          15, // Assuming 15 days is the max
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color:
                                              _getTimeColor(data.averageTime),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${data.averageTime.toStringAsFixed(1)} days',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                '${data.fastestTime.toStringAsFixed(1)} days',
                                style: GoogleFonts.montserrat(
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${data.slowestTime.toStringAsFixed(1)} days',
                                style: GoogleFonts.montserrat(
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.conversions.toString(),
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Get color based on average time
  Color _getTimeColor(double time) {
    if (time < 3) return Colors.green.shade500;
    if (time < 6) return Colors.teal.shade500;
    if (time < 9) return Colors.amber.shade500;
    return Colors.orange.shade500;
  }

  // Filter modal
  void _showFilterModal(
      BuildContext context, QuotationOrderTimeController controller) {
    // Get sales reps
    final salesReps = [
      'All',
      'John Smith',
      'Maria Rodriguez',
      'David Kim',
      'Sarah Johnson'
    ];

    // Get product categories
    final productCategories = [
      'All',
      'Software',
      'Hardware',
      'Services',
      'Consulting'
    ];

    // Get client types
    final clientTypes = ['All', 'Enterprise', 'SMB', 'Startup', 'Government'];

    // Create filter widgets
    final List<Widget> filterWidgets = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Representative',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedSalesRep.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(8),
                    items: salesReps.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedSalesRep.value = newValue;
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Category',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedProductCategory.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(8),
                    items: productCategories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedProductCategory.value = newValue;
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Type',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedClientType.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(8),
                    items: clientTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedClientType.value = newValue;
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Reset filters
                  controller.selectedSalesRep.value = 'All';
                  controller.selectedProductCategory.value = 'All';
                  controller.selectedClientType.value = 'All';
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade800,
                  elevation: 0,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Reset',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Options',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey.shade700),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            ...filterWidgets,
          ],
        ),
      ),
    );
  }
}
