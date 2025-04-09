import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';

// Import your page wrapper

// Controller for managing state
class DiscountAnalysisController extends GetxController {
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
  RxList<DiscountAnalysisData> discountData = <DiscountAnalysisData>[].obs;
  RxDouble overallAverageDiscount = 0.0.obs;
  RxDouble totalRevenue = 0.0.obs;
  RxDouble discountedRevenue = 0.0.obs;
  RxDouble marginImpact = 0.0.obs;

  // Data for charts
  RxList<DiscountBucketData> discountBucketData = <DiscountBucketData>[].obs;
  RxList<DiscountTimeSeriesData> timeSeriesData =
      <DiscountTimeSeriesData>[].obs;
  RxList<ProductDiscountData> topDiscountedProducts =
      <ProductDiscountData>[].obs;

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
    overallAverageDiscount.value = 12.8; // percent
    totalRevenue.value = 485000; // dollars
    discountedRevenue.value = 62000; // dollars
    marginImpact.value = -4.2; // percentage points

    // Generate mock data for table
    discountData.value = [
      DiscountAnalysisData(
        salesRep: 'John Smith',
        category: 'Software',
        averageDiscount: 10.5,
        totalSales: 142000,
        discountedSales: 15000,
        marginImpact: -3.2,
      ),
      DiscountAnalysisData(
        salesRep: 'Maria Rodriguez',
        category: 'Hardware',
        averageDiscount: 8.3,
        totalSales: 98000,
        discountedSales: 8200,
        marginImpact: -2.4,
      ),
      DiscountAnalysisData(
        salesRep: 'David Kim',
        category: 'Services',
        averageDiscount: 15.2,
        totalSales: 165000,
        discountedSales: 25000,
        marginImpact: -5.8,
      ),
      DiscountAnalysisData(
        salesRep: 'Sarah Johnson',
        category: 'Consulting',
        averageDiscount: 18.4,
        totalSales: 80000,
        discountedSales: 14700,
        marginImpact: -6.3,
      ),
    ];

    // Generate mock discount bucket data for chart
    discountBucketData.value = [
      DiscountBucketData(
          range: '0-5%', salesCount: 48, revenuePercentage: 42.0),
      DiscountBucketData(
          range: '5-10%', salesCount: 62, revenuePercentage: 30.5),
      DiscountBucketData(
          range: '10-15%', salesCount: 35, revenuePercentage: 15.3),
      DiscountBucketData(
          range: '15-20%', salesCount: 18, revenuePercentage: 8.2),
      DiscountBucketData(range: '20%+', salesCount: 7, revenuePercentage: 4.0),
    ];

    // Generate mock time series data
    final DateFormat formatter = DateFormat('MMM d');
    final now = DateTime.now();

    timeSeriesData.value = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 30 - (index * 5)));
      return DiscountTimeSeriesData(
        date: formatter.format(date),
        averageDiscount:
            8.0 + (index % 3) * 2.5 + (index % 2 == 0 ? 1.2 : -0.8),
        marginImpact: -3.0 - (index % 3) * 0.8 - (index % 2 == 0 ? 0.4 : -0.2),
      );
    });

    // Generate mock top discounted products
    topDiscountedProducts.value = [
      ProductDiscountData(
        productName: 'Enterprise Software Suite',
        averageDiscount: 22.5,
        totalRevenue: 48000,
        marginImpact: -8.5,
      ),
      ProductDiscountData(
        productName: 'Cloud Storage (1TB)',
        averageDiscount: 18.2,
        totalRevenue: 36000,
        marginImpact: -6.2,
      ),
      ProductDiscountData(
        productName: 'Security Consulting Package',
        averageDiscount: 15.8,
        totalRevenue: 42000,
        marginImpact: -5.3,
      ),
      ProductDiscountData(
        productName: 'Network Hardware Bundle',
        averageDiscount: 14.6,
        totalRevenue: 53000,
        marginImpact: -4.8,
      ),
      ProductDiscountData(
        productName: 'Support Plan (Annual)',
        averageDiscount: 12.3,
        totalRevenue: 29000,
        marginImpact: -3.7,
      ),
    ];

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
class DiscountAnalysisData {
  final String salesRep;
  final String category;
  final double averageDiscount;
  final double totalSales;
  final double discountedSales;
  final double marginImpact;

  DiscountAnalysisData({
    required this.salesRep,
    required this.category,
    required this.averageDiscount,
    required this.totalSales,
    required this.discountedSales,
    required this.marginImpact,
  });
}

class DiscountBucketData {
  final String range;
  final int salesCount;
  final double revenuePercentage;

  DiscountBucketData({
    required this.range,
    required this.salesCount,
    required this.revenuePercentage,
  });
}

class DiscountTimeSeriesData {
  final String date;
  final double averageDiscount;
  final double marginImpact;

  DiscountTimeSeriesData({
    required this.date,
    required this.averageDiscount,
    required this.marginImpact,
  });
}

class ProductDiscountData {
  final String productName;
  final double averageDiscount;
  final double totalRevenue;
  final double marginImpact;

  ProductDiscountData({
    required this.productName,
    required this.averageDiscount,
    required this.totalRevenue,
    required this.marginImpact,
  });
}

// Main Page
class DiscountAnalysisPage extends StatelessWidget {
  const DiscountAnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(DiscountAnalysisController());

    return ReportPageWrapper(
      title: 'Discount Analysis',
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
                  _buildDiscountImpactChart(controller),
                  const SizedBox(height: 24),
                  _buildDiscountDistributionChart(controller),
                  const SizedBox(height: 24),
                  _buildTopDiscountedProducts(controller),
                  const SizedBox(height: 24),
                  _buildDiscountAnalysisTable(controller),
                ],
              ),
      ),
    );
  }

  // Summary metrics cards
  Widget _buildSummaryCards(DiscountAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount Summary',
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
                  'Average Discount',
                  '${controller.overallAverageDiscount.value.toStringAsFixed(1)}%',
                  Colors.blue.shade50,
                  Colors.blue.shade700,
                  Icons.percent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Total Revenue',
                  currencyFormatter.format(controller.totalRevenue.value),
                  Colors.green.shade50,
                  Colors.green.shade700,
                  Icons.attach_money,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Discounted Revenue',
                  currencyFormatter.format(controller.discountedRevenue.value),
                  Colors.orange.shade50,
                  Colors.orange.shade700,
                  Icons.money_off,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Margin Impact',
                  '${controller.marginImpact.value.toStringAsFixed(1)}%',
                  Colors.purple.shade50,
                  Colors.purple.shade700,
                  Icons.trending_down,
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

  // Discount impact time series chart (showing discount % and margin impact over time)
  Widget _buildDiscountImpactChart(DiscountAnalysisController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount & Margin Impact Trend',
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
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              final String prefix = touchedSpot.barIndex == 0
                                  ? 'Discount: '
                                  : 'Margin Impact: ';
                              final String value = touchedSpot.barIndex == 0
                                  ? '${touchedSpot.y.toStringAsFixed(1)}%'
                                  : '${touchedSpot.y.toStringAsFixed(1)}%';
                              return LineTooltipItem(
                                '$prefix$value',
                                GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: touchedSpot.barIndex == 0
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 5,
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
                            interval: 5,
                            getTitlesWidget: (value, _) {
                              return Text(
                                '${value.toInt()}%',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                ),
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      minX: 0,
                      maxX: controller.timeSeriesData.length - 1.0,
                      minY: -10,
                      maxY: 25,
                      lineBarsData: [
                        // Discount percentage line
                        LineChartBarData(
                          spots: controller.timeSeriesData
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.averageDiscount,
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue.shade600,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue.shade600,
                              strokeColor: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.shade100.withOpacity(0.3),
                          ),
                        ),
                        // Margin impact line
                        LineChartBarData(
                          spots: controller.timeSeriesData
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.marginImpact,
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.red.shade500,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 4,
                              color: Colors.red.shade500,
                              strokeColor: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.red.shade100.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Discount %', Colors.blue.shade600),
              const SizedBox(width: 24),
              _buildLegendItem('Margin Impact', Colors.red.shade500),
            ],
          ),
        ],
      ),
    );
  }

  // Legend item
  Widget _buildLegendItem(String label, Color color) {
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
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // Distribution chart for discount ranges
  Widget _buildDiscountDistributionChart(
      DiscountAnalysisController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount Distribution',
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
            child: controller.discountBucketData.isEmpty
                ? const Center(child: Text('No data available'))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 70,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final data =
                                controller.discountBucketData[groupIndex];
                            return BarTooltipItem(
                              '${data.range}\n',
                              GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${data.salesCount} sales\n',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${data.revenuePercentage.toStringAsFixed(1)}% of revenue',
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
                                  value <
                                      controller.discountBucketData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    controller.discountBucketData[value.toInt()]
                                        .range,
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
                      barGroups: controller.discountBucketData
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.salesCount.toDouble(),
                                  color: _getDiscountBarColor(entry.key),
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

  // Get color for discount distribution bars
  Color _getDiscountBarColor(int index) {
    List<Color> colors = [
      Colors.green.shade500,
      Colors.teal.shade500,
      Colors.amber.shade500,
      Colors.orange.shade500,
      Colors.red.shade500,
    ];
    return colors[index % colors.length];
  }

  // Top discounted products widget
  Widget _buildTopDiscountedProducts(DiscountAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Discounted Products',
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
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.topDiscountedProducts.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade200,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final product = controller.topDiscountedProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _getDiscountSeverityColor(
                              product.averageDiscount),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${product.averageDiscount.toStringAsFixed(0)}%',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Revenue: ${currencyFormatter.format(product.totalRevenue)} | Margin Impact: ${product.marginImpact.toStringAsFixed(1)}%',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.warning_amber_rounded,
                        color: product.averageDiscount > 15
                            ? Colors.orange.shade700
                            : Colors.transparent,
                        size: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Get color based on discount severity
  Color _getDiscountSeverityColor(double discount) {
    if (discount < 10) return Colors.green.shade600;
    if (discount < 15) return Colors.teal.shade600;
    if (discount < 20) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  // Discount analysis table by sales rep and category
// Discount analysis table by sales rep and category
  Widget _buildDiscountAnalysisTable(DiscountAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount Analysis by Sales Rep & Category',
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade100),
                headingTextStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 12,
                ),
                dataTextStyle: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
                columns: [
                  const DataColumn(label: Text('Sales Rep')),
                  const DataColumn(label: Text('Product Category')),
                  const DataColumn(label: Text('Avg. Discount')),
                  const DataColumn(label: Text('Total Sales')),
                  const DataColumn(label: Text('Discounted Sales')),
                  const DataColumn(label: Text('Margin Impact')),
                ],
                rows: controller.discountData.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.salesRep)),
                    DataCell(Text(data.category)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getDiscountSeverityColor(
                                  data.averageDiscount),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${data.averageDiscount.toStringAsFixed(1)}%'),
                        ],
                      ),
                    ),
                    DataCell(Text(currencyFormatter.format(data.totalSales))),
                    DataCell(
                        Text(currencyFormatter.format(data.discountedSales))),
                    DataCell(
                      Text(
                        '${data.marginImpact.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: data.marginImpact < -4
                              ? Colors.red.shade700
                              : Colors.grey.shade700,
                          fontWeight: data.marginImpact < -4
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Filter modal
  void _showFilterModal(
      BuildContext context, DiscountAnalysisController controller) {
    // Mock data for filter options
    final salesReps = [
      'All',
      'John Smith',
      'Maria Rodriguez',
      'David Kim',
      'Sarah Johnson'
    ];
    final productCategories = [
      'All',
      'Software',
      'Hardware',
      'Services',
      'Consulting'
    ];
    final clientTypes = [
      'All',
      'Enterprise',
      'Mid-Market',
      'SMB',
      'Government'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Sales Representative',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Wrap(
                  spacing: 8,
                  children: salesReps.map((rep) {
                    return ChoiceChip(
                      label: Text(rep),
                      selected: controller.selectedSalesRep.value == rep,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedSalesRep.value = rep;
                        }
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Colors.blue.shade100,
                      labelStyle: GoogleFonts.montserrat(
                        color: controller.selectedSalesRep.value == rep
                            ? Colors.blue.shade800
                            : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Product Category',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Wrap(
                  spacing: 8,
                  children: productCategories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected:
                          controller.selectedProductCategory.value == category,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedProductCategory.value = category;
                        }
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Colors.blue.shade100,
                      labelStyle: GoogleFonts.montserrat(
                        color:
                            controller.selectedProductCategory.value == category
                                ? Colors.blue.shade800
                                : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Client Type',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Wrap(
                  spacing: 8,
                  children: clientTypes.map((type) {
                    return ChoiceChip(
                      label: Text(type),
                      selected: controller.selectedClientType.value == type,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedClientType.value = type;
                        }
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Colors.blue.shade100,
                      labelStyle: GoogleFonts.montserrat(
                        color: controller.selectedClientType.value == type
                            ? Colors.blue.shade800
                            : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    controller.selectedSalesRep.value = 'All';
                    controller.selectedProductCategory.value = 'All';
                    controller.selectedClientType.value = 'All';
                    controller.applyFilters();
                  },
                  child: Text(
                    'Reset Filters',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
