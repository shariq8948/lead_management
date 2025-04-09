import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';

// Import your page wrapper

// Controller for managing state
class RevenueAnalysisController extends GetxController {
  // Selected date range
  Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  // Filter options
  RxString selectedProduct = 'All'.obs;
  RxString selectedCustomer = 'All'.obs;
  RxString selectedRegion = 'All'.obs;
  RxString selectedTimeFrame = 'Monthly'.obs;

  // Loading state
  RxBool isLoading = false.obs;

  // Data for summary metrics
  RxDouble totalRevenue = 0.0.obs;
  RxDouble growthPercentage = 0.0.obs;
  RxDouble averageOrderValue = 0.0.obs;
  RxInt totalTransactions = 0.obs;

  // Data for charts and tables
  RxList<ProductRevenueData> productRevenue = <ProductRevenueData>[].obs;
  RxList<CustomerRevenueData> customerRevenue = <CustomerRevenueData>[].obs;
  RxList<RegionRevenueData> regionRevenue = <RegionRevenueData>[].obs;
  RxList<TimeSeriesRevenueData> timeSeriesData = <TimeSeriesRevenueData>[].obs;

  // Top performers lists
  RxList<TopPerformerData> topProducts = <TopPerformerData>[].obs;
  RxList<TopPerformerData> topCustomers = <TopPerformerData>[].obs;
  RxList<TopPerformerData> topRegions = <TopPerformerData>[].obs;

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
    totalRevenue.value = 1245000;
    growthPercentage.value = 12.8;
    averageOrderValue.value = 5280;
    totalTransactions.value = 236;

    // Generate mock product revenue data
    productRevenue.value = [
      ProductRevenueData(
        productName: 'Enterprise Software Suite',
        revenue: 425000,
        percentOfTotal: 34.1,
        growth: 15.2,
        revenuePerUnit: 21250,
        unitsSold: 20,
      ),
      ProductRevenueData(
        productName: 'Cloud Storage (1TB)',
        revenue: 328000,
        percentOfTotal: 26.3,
        growth: 22.5,
        revenuePerUnit: 1640,
        unitsSold: 200,
      ),
      ProductRevenueData(
        productName: 'Security Consulting Package',
        revenue: 246000,
        percentOfTotal: 19.8,
        growth: 8.7,
        revenuePerUnit: 41000,
        unitsSold: 6,
      ),
      ProductRevenueData(
        productName: 'Network Hardware Bundle',
        revenue: 152000,
        percentOfTotal: 12.2,
        growth: -3.4,
        revenuePerUnit: 30400,
        unitsSold: 5,
      ),
      ProductRevenueData(
        productName: 'Support Plan (Annual)',
        revenue: 94000,
        percentOfTotal: 7.6,
        growth: 5.6,
        revenuePerUnit: 4700,
        unitsSold: 20,
      ),
    ];
    // Future<void> fetchData() async {
    //   isLoading.value = true;
    //
    //   try {
    //     // Prepare the request parameters with current filters
    //     final Map<String, dynamic> params = {
    //       'startDate': selectedDateRange.value?.start.toIso8601String(),
    //       'endDate': selectedDateRange.value?.end.toIso8601String(),
    //       'product': selectedProduct.value != 'All' ? selectedProduct.value : null,
    //       'customer': selectedCustomer.value != 'All' ? selectedCustomer.value : null,
    //       'region': selectedRegion.value != 'All' ? selectedRegion.value : null,
    //       'timeFrame': selectedTimeFrame.value,
    //     };
    //
    //     // Remove null values
    //     params.removeWhere((key, value) => value == null);
    //
    //     // Make the API call (replace with your actual API service)
    //     final response = await apiService.getRevenueAnalysis(params);
    //
    //     // Update date range
    //     final dateRangeData = response['dateRange'];
    //     selectedDateRange.value = DateTimeRange(
    //       start: DateTime.parse(dateRangeData['start']),
    //       end: DateTime.parse(dateRangeData['end']),
    //     );
    //
    //     // Update summary metrics
    //     final summaryData = response['summaryMetrics'];
    //     totalRevenue.value = summaryData['totalRevenue'];
    //     growthPercentage.value = summaryData['growthPercentage'];
    //     averageOrderValue.value = summaryData['averageOrderValue'];
    //     totalTransactions.value = summaryData['totalTransactions'];
    //
    //     // Update product revenue data
    //     productRevenue.value = (response['productRevenue'] as List)
    //         .map((item) => ProductRevenueData(
    //       productName: item['productName'],
    //       revenue: item['revenue'].toDouble(),
    //       percentOfTotal: item['percentOfTotal'].toDouble(),
    //       growth: item['growth'].toDouble(),
    //       revenuePerUnit: item['revenuePerUnit'].toDouble(),
    //       unitsSold: item['unitsSold'],
    //     ))
    //         .toList();
    //
    //     // Update customer revenue data
    //     customerRevenue.value = (response['customerRevenue'] as List)
    //         .map((item) => CustomerRevenueData(
    //       customerName: item['customerName'],
    //       revenue: item['revenue'].toDouble(),
    //       percentOfTotal: item['percentOfTotal'].toDouble(),
    //       growth: item['growth'].toDouble(),
    //       customerSince: item['customerSince'],
    //       lastPurchase: item['lastPurchase'],
    //     ))
    //         .toList();
    //
    //     // Update region revenue data
    //     regionRevenue.value = (response['regionRevenue'] as List)
    //         .map((item) => RegionRevenueData(
    //       region: item['region'],
    //       revenue: item['revenue'].toDouble(),
    //       percentOfTotal: item['percentOfTotal'].toDouble(),
    //       growth: item['growth'].toDouble(),
    //       customerCount: item['customerCount'],
    //       marketPenetration: item['marketPenetration'].toDouble(),
    //     ))
    //         .toList();
    //
    //     // Update time series data
    //     timeSeriesData.value = (response['timeSeriesData'] as List)
    //         .map((item) => TimeSeriesRevenueData(
    //       period: item['period'],
    //       revenue: item['revenue'].toDouble(),
    //     ))
    //         .toList();
    //
    //     // Update top performers
    //     topProducts.value = (response['topPerformers']['products'] as List)
    //         .map((item) => TopPerformerData(
    //       name: item['name'],
    //       value: item['value'].toDouble(),
    //       growth: item['growth'].toDouble(),
    //       otherStat: item['otherStat'],
    //     ))
    //         .toList();
    //
    //     topCustomers.value = (response['topPerformers']['customers'] as List)
    //         .map((item) => TopPerformerData(
    //       name: item['name'],
    //       value: item['value'].toDouble(),
    //       growth: item['growth'].toDouble(),
    //       otherStat: item['otherStat'],
    //     ))
    //         .toList();
    //
    //     topRegions.value = (response['topPerformers']['regions'] as List)
    //         .map((item) => TopPerformerData(
    //       name: item['name'],
    //       value: item['value'].toDouble(),
    //       growth: item['growth'].toDouble(),
    //       otherStat: item['otherStat'],
    //     ))
    //         .toList();
    //
    //   } catch (e) {
    //     // Handle errors
    //     print('Error fetching revenue data: $e');
    //     // Optionally show an error message to the user
    //     Get.snackbar(
    //       'Error',
    //       'Failed to load revenue data. Please try again.',
    //       snackPosition: SnackPosition.BOTTOM,
    //     );
    //   } finally {
    //     isLoading.value = false;
    //   }
    // }
    // Generate mock customer revenue data
    customerRevenue.value = [
      CustomerRevenueData(
        customerName: 'Acme Corporation',
        revenue: 245000,
        percentOfTotal: 19.7,
        growth: 12.3,
        customerSince: '2018',
        lastPurchase: 'Mar 15, 2025',
      ),
      CustomerRevenueData(
        customerName: 'TechNova Inc.',
        revenue: 198000,
        percentOfTotal: 15.9,
        growth: 8.6,
        customerSince: '2020',
        lastPurchase: 'Mar 28, 2025',
      ),
      CustomerRevenueData(
        customerName: 'Global Systems Ltd.',
        revenue: 187000,
        percentOfTotal: 15.0,
        growth: 22.5,
        customerSince: '2019',
        lastPurchase: 'Mar 10, 2025',
      ),
      CustomerRevenueData(
        customerName: 'Omega Enterprises',
        revenue: 156000,
        percentOfTotal: 12.5,
        growth: -2.8,
        customerSince: '2017',
        lastPurchase: 'Feb 22, 2025',
      ),
      CustomerRevenueData(
        customerName: 'Future Technologies',
        revenue: 124000,
        percentOfTotal: 10.0,
        growth: 15.7,
        customerSince: '2021',
        lastPurchase: 'Mar 05, 2025',
      ),
      CustomerRevenueData(
        customerName: 'Others',
        revenue: 335000,
        percentOfTotal: 26.9,
        growth: 6.2,
        customerSince: 'Various',
        lastPurchase: 'Various',
      ),
    ];

    // Generate mock region revenue data
    regionRevenue.value = [
      RegionRevenueData(
        region: 'North America',
        revenue: 486000,
        percentOfTotal: 39.0,
        growth: 10.5,
        customerCount: 45,
        marketPenetration: 12.5,
      ),
      RegionRevenueData(
        region: 'Europe',
        revenue: 342000,
        percentOfTotal: 27.5,
        growth: 15.8,
        customerCount: 38,
        marketPenetration: 8.2,
      ),
      RegionRevenueData(
        region: 'Asia Pacific',
        revenue: 274000,
        percentOfTotal: 22.0,
        growth: 28.3,
        customerCount: 26,
        marketPenetration: 5.6,
      ),
      RegionRevenueData(
        region: 'Latin America',
        revenue: 86000,
        percentOfTotal: 6.9,
        growth: 7.2,
        customerCount: 15,
        marketPenetration: 3.8,
      ),
      RegionRevenueData(
        region: 'Middle East & Africa',
        revenue: 57000,
        percentOfTotal: 4.6,
        growth: 18.5,
        customerCount: 8,
        marketPenetration: 2.1,
      ),
    ];

    // Generate mock time series data
    final DateFormat monthFormatter = DateFormat('MMM');
    final now = DateTime.now();

    timeSeriesData.value = List.generate(12, (index) {
      final date = DateTime(now.year, now.month - 11 + index);
      return TimeSeriesRevenueData(
        period: monthFormatter.format(date),
        revenue: 800000 +
            (index * 35000) +
            (index % 3 == 0
                ? 50000
                : index % 2 == 0
                    ? -30000
                    : 20000),
      );
    });

    // Generate top performers
    topProducts.value = productRevenue
        .map((p) => TopPerformerData(
              name: p.productName,
              value: p.revenue,
              growth: p.growth,
              otherStat: '${p.unitsSold} units',
            ))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    topCustomers.value = customerRevenue
        .where((c) => c.customerName != 'Others')
        .map((c) => TopPerformerData(
              name: c.customerName,
              value: c.revenue,
              growth: c.growth,
              otherStat: 'Since ${c.customerSince}',
            ))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    topRegions.value = regionRevenue
        .map((r) => TopPerformerData(
              name: r.region,
              value: r.revenue,
              growth: r.growth,
              otherStat: '${r.customerCount} customers',
            ))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    isLoading.value = false;
  }

  // Filter the data based on the selected options
  void applyFilters() {
    fetchData(); // In a real app, you would pass filters to the API
    Get.back(); // Close the filter modal
  }

  // Update date range and refetch data
  void updateDateRange(DateTimeRange? newRange) {
    if (newRange != null) {
      selectedDateRange.value = newRange;
      fetchData();
    }
  }

  // Update time frame and refetch data
  void updateTimeFrame(String timeFrame) {
    selectedTimeFrame.value = timeFrame;
    fetchData();
  }
}

// Data models
class ProductRevenueData {
  final String productName;
  final double revenue;
  final double percentOfTotal;
  final double growth;
  final double revenuePerUnit;
  final int unitsSold;

  ProductRevenueData({
    required this.productName,
    required this.revenue,
    required this.percentOfTotal,
    required this.growth,
    required this.revenuePerUnit,
    required this.unitsSold,
  });
}

class CustomerRevenueData {
  final String customerName;
  final double revenue;
  final double percentOfTotal;
  final double growth;
  final String customerSince;
  final String lastPurchase;

  CustomerRevenueData({
    required this.customerName,
    required this.revenue,
    required this.percentOfTotal,
    required this.growth,
    required this.customerSince,
    required this.lastPurchase,
  });
}

class RegionRevenueData {
  final String region;
  final double revenue;
  final double percentOfTotal;
  final double growth;
  final int customerCount;
  final double marketPenetration;

  RegionRevenueData({
    required this.region,
    required this.revenue,
    required this.percentOfTotal,
    required this.growth,
    required this.customerCount,
    required this.marketPenetration,
  });
}

class TimeSeriesRevenueData {
  final String period;
  final double revenue;

  TimeSeriesRevenueData({
    required this.period,
    required this.revenue,
  });
}

class TopPerformerData {
  final String name;
  final double value;
  final double growth;
  final String otherStat;

  TopPerformerData({
    required this.name,
    required this.value,
    required this.growth,
    required this.otherStat,
  });
}

// Main Page
class RevenueAnalysisPage extends StatelessWidget {
  const RevenueAnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(RevenueAnalysisController());

    return ReportPageWrapper(
      title: 'Revenue Analysis',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context, controller),
      onDateRangeSelected: controller.updateDateRange,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(controller),
                    const SizedBox(height: 24),
                    _buildRevenueTimeSeriesChart(controller),
                    const SizedBox(height: 24),
                    _buildRevenueBreakdownSection(controller),
                    const SizedBox(height: 24),
                    _buildTopPerformersSection(controller),
                    const SizedBox(height: 24),
                    _buildDetailedAnalysisSection(controller),
                  ],
                ),
              ),
      ),
    );
  }

  // Summary metrics cards
  Widget _buildSummaryCards(RevenueAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Summary',
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
                  'Total Revenue',
                  currencyFormatter.format(controller.totalRevenue.value),
                  Colors.blue.shade50,
                  Colors.blue.shade700,
                  Icons.attach_money,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Growth',
                  '${controller.growthPercentage.value >= 0 ? '+' : ''}${controller.growthPercentage.value.toStringAsFixed(1)}%',
                  controller.growthPercentage.value >= 0
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  controller.growthPercentage.value >= 0
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  controller.growthPercentage.value >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Avg. Order Value',
                  currencyFormatter.format(controller.averageOrderValue.value),
                  Colors.purple.shade50,
                  Colors.purple.shade700,
                  Icons.shopping_cart,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Transactions',
                  controller.totalTransactions.value.toString(),
                  Colors.amber.shade50,
                  Colors.amber.shade700,
                  Icons.receipt_long,
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

  // Revenue time series chart
  Widget _buildRevenueTimeSeriesChart(RevenueAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Trend',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              _buildTimeFrameSelector(controller),
            ],
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
                            return touchedSpots.map((touchedSpot) {
                              final data = controller
                                  .timeSeriesData[touchedSpot.x.toInt()];
                              return LineTooltipItem(
                                '${data.period}: ${currencyFormatter.format(data.revenue)}',
                                GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 200000,
                        getDrawingHorizontalLine: (value) {
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
                              final index = value.toInt();
                              if (index >= 0 &&
                                  index < controller.timeSeriesData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    controller.timeSeriesData[index].period,
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
                            interval: 200000,
                            getTitlesWidget: (value, _) {
                              return Text(
                                currencyFormatter.format(value),
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
                      minY: controller.timeSeriesData
                              .map((data) => data.revenue)
                              .reduce(
                                  (min, value) => min < value ? min : value) *
                          0.8,
                      maxY: controller.timeSeriesData
                              .map((data) => data.revenue)
                              .reduce(
                                  (max, value) => max > value ? max : value) *
                          1.2,
                      lineBarsData: [
                        LineChartBarData(
                          spots: controller.timeSeriesData
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.revenue,
                                  ))
                              .toList(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade300,
                              Colors.blue.shade800,
                            ],
                          ),
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
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600.withOpacity(0.3),
                                Colors.blue.shade300.withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
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

  // Time frame selector (Weekly, Monthly, Quarterly)
  Widget _buildTimeFrameSelector(RevenueAnalysisController controller) {
    return Obx(
      () => Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimeFrameOption(controller, 'Weekly'),
            _buildTimeFrameOption(controller, 'Monthly'),
            _buildTimeFrameOption(controller, 'Quarterly'),
          ],
        ),
      ),
    );
  }

  // Individual time frame option button
  Widget _buildTimeFrameOption(
      RevenueAnalysisController controller, String timeFrame) {
    final isSelected = controller.selectedTimeFrame.value == timeFrame;

    return GestureDetector(
      onTap: () => controller.updateTimeFrame(timeFrame),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          timeFrame,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  // Revenue breakdown by product, customer, and region
  Widget _buildRevenueBreakdownSection(RevenueAnalysisController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Breakdown',
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
              child: _buildPieChartCard(
                'By Product',
                _buildProductPieChart(controller),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPieChartCard(
                'By Customer',
                _buildCustomerPieChart(controller),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPieChartCard(
          'By Region',
          _buildRegionPieChart(controller),
        ),
      ],
    );
  }

  // Pie chart card wrapper
  Widget _buildPieChartCard(String title, Widget chart) {
    return Container(
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
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: chart,
          ),
        ],
      ),
    );
  }

  // Product revenue pie chart
  Widget _buildProductPieChart(RevenueAnalysisController controller) {
    return Obx(
      () => controller.productRevenue.isEmpty
          ? const Center(child: Text('No data available'))
          : PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _getProductPieSections(controller),
                pieTouchData: PieTouchData(
                  touchCallback: (_, __) {},
                ),
              ),
            ),
    );
  }

  // Get pie sections for product revenue
  List<PieChartSectionData> _getProductPieSections(
      RevenueAnalysisController controller) {
    final List<Color> colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.purple.shade600,
      Colors.amber.shade600,
      Colors.teal.shade600,
    ];

    return controller.productRevenue.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return PieChartSectionData(
        value: data.percentOfTotal,
        title: '${data.percentOfTotal.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: colors[index % colors.length],
        badgeWidget: _getBadgeWidget(index),
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();
  }

  // Customer revenue pie chart
  Widget _buildCustomerPieChart(RevenueAnalysisController controller) {
    return Obx(
      () => controller.customerRevenue.isEmpty
          ? const Center(child: Text('No data available'))
          : PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _getCustomerPieSections(controller),
                pieTouchData: PieTouchData(
                  touchCallback: (_, __) {},
                ),
              ),
            ),
    );
  }

  // Get pie sections for customer revenue
  List<PieChartSectionData> _getCustomerPieSections(
      RevenueAnalysisController controller) {
    final List<Color> colors = [
      Colors.orange.shade600,
      Colors.red.shade600,
      Colors.indigo.shade600,
      Colors.lime.shade700,
      Colors.cyan.shade700,
      Colors.grey.shade600,
    ];

    return controller.customerRevenue.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return PieChartSectionData(
        value: data.percentOfTotal,
        title: '${data.percentOfTotal.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: colors[index % colors.length],
        badgeWidget: _getBadgeWidget(index),
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();
  }

  // Region revenue pie chart
  Widget _buildRegionPieChart(RevenueAnalysisController controller) {
    return Obx(
      () => controller.regionRevenue.isEmpty
          ? const Center(child: Text('No data available'))
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _getRegionPieSections(controller),
                      pieTouchData: PieTouchData(
                        touchCallback: (_, __) {},
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildRegionLegend(controller),
                ),
              ],
            ),
    );
  }

  // Get pie sections for region revenue
  List<PieChartSectionData> _getRegionPieSections(
      RevenueAnalysisController controller) {
    final List<Color> colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.red.shade600,
      Colors.amber.shade600,
      Colors.purple.shade600,
    ];

    return controller.regionRevenue.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return PieChartSectionData(
        value: data.percentOfTotal,
        title: '',
        radius: 60,
        color: colors[index % colors.length],
      );
    }).toList();
  }

  // Badge widget for legends
  Widget? _getBadgeWidget(int index) {
    return index < 3
        ? Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          )
        : null;
  }

  // Region legend
  Widget _buildRegionLegend(RevenueAnalysisController controller) {
    final List<Color> colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.red.shade600,
      Colors.amber.shade600,
      Colors.purple.shade600,
    ];

    final currencyFormatter =
        NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: controller.regionRevenue.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.region,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${data.percentOfTotal.toStringAsFixed(1)}%',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  currencyFormatter.format(data.revenue),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Top performers section (products, customers, regions)
  Widget _buildTopPerformersSection(RevenueAnalysisController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Performers',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTopPerformerCard(
                'Top Products',
                controller.topProducts,
                Icons.inventory_2,
                Colors.blue.shade100,
                Colors.blue.shade800,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTopPerformerCard(
                'Top Customers',
                controller.topCustomers,
                Icons.people,
                Colors.green.shade100,
                Colors.green.shade800,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTopPerformerCard(
                'Top Regions',
                controller.topRegions,
                Icons.public,
                Colors.purple.shade100,
                Colors.purple.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Top performer card
  Widget _buildTopPerformerCard(
    String title,
    RxList<TopPerformerData> data,
    IconData icon,
    Color bgColor,
    Color accentColor,
  ) {
    final currencyFormatter =
        NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...data
                .take(3)
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                currencyFormatter.format(item.value),
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.otherStat,
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    item.growth >= 0
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: item.growth >= 0
                                        ? Colors.green.shade600
                                        : Colors.red.shade600,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${item.growth.abs().toStringAsFixed(1)}%',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: item.growth >= 0
                                          ? Colors.green.shade600
                                          : Colors.red.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: item.value / data.first.value,
                            backgroundColor: bgColor,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accentColor),
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  // Detailed analysis section
  Widget _buildDetailedAnalysisSection(RevenueAnalysisController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analysis',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade600,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade700,
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Products'),
                    Tab(text: 'Customers'),
                    Tab(text: 'Regions'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: TabBarView(
                  children: [
                    _buildProductTable(controller),
                    _buildCustomerTable(controller),
                    _buildRegionTable(controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Product data table
  Widget _buildProductTable(RevenueAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => controller.productRevenue.isEmpty
          ? const Center(child: Text('No data available'))
          : Container(
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
                child: DataTable(
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  headingRowHeight: 48,
                  dataRowHeight: 56,
                  headingTextStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  dataTextStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                  columns: [
                    const DataColumn(label: Text('Product')),
                    DataColumn(
                        label: Row(
                      children: [
                        const Text('Revenue'),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_downward,
                            size: 14, color: Colors.grey.shade800),
                      ],
                    )),
                    const DataColumn(label: Text('Growth')),
                    const DataColumn(label: Text('Units')),
                    const DataColumn(label: Text('Rev/Unit')),
                  ],
                  rows: controller.productRevenue.map((product) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          product.productName,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        )),
                        DataCell(Text(
                          currencyFormatter.format(product.revenue),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        )),
                        DataCell(Row(
                          children: [
                            Icon(
                              product.growth >= 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14,
                              color: product.growth >= 0
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.growth.abs().toStringAsFixed(1)}%',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: product.growth >= 0
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                              ),
                            ),
                          ],
                        )),
                        DataCell(Text('${product.unitsSold}')),
                        DataCell(Text(
                          currencyFormatter.format(product.revenuePerUnit),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  // Customer data table
  Widget _buildCustomerTable(RevenueAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => controller.customerRevenue.isEmpty
          ? const Center(child: Text('No data available'))
          : Container(
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
                child: DataTable(
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  headingRowHeight: 48,
                  dataRowHeight: 56,
                  headingTextStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  dataTextStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                  columns: [
                    const DataColumn(label: Text('Customer')),
                    DataColumn(
                        label: Row(
                      children: [
                        const Text('Revenue'),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_downward,
                            size: 14, color: Colors.grey.shade800),
                      ],
                    )),
                    const DataColumn(label: Text('Growth')),
                    const DataColumn(label: Text('Since')),
                    const DataColumn(label: Text('Last Purchase')),
                  ],
                  rows: controller.customerRevenue.map((customer) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          customer.customerName,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        )),
                        DataCell(Text(
                          currencyFormatter.format(customer.revenue),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        )),
                        DataCell(Row(
                          children: [
                            Icon(
                              customer.growth >= 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14,
                              color: customer.growth >= 0
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${customer.growth.abs().toStringAsFixed(1)}%',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: customer.growth >= 0
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                              ),
                            ),
                          ],
                        )),
                        DataCell(Text(customer.customerSince)),
                        DataCell(Text(customer.lastPurchase)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  // Region data table
  Widget _buildRegionTable(RevenueAnalysisController controller) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Obx(
      () => controller.regionRevenue.isEmpty
          ? const Center(child: Text('No data available'))
          : Container(
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
                child: DataTable(
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  headingRowHeight: 48,
                  dataRowHeight: 56,
                  headingTextStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  dataTextStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                  columns: [
                    const DataColumn(label: Text('Region')),
                    DataColumn(
                        label: Row(
                      children: [
                        const Text('Revenue'),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_downward,
                            size: 14, color: Colors.grey.shade800),
                      ],
                    )),
                    const DataColumn(label: Text('Growth')),
                    const DataColumn(label: Text('Customers')),
                    const DataColumn(label: Text('Market %')),
                  ],
                  rows: controller.regionRevenue.map((region) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          region.region,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        )),
                        DataCell(Text(
                          currencyFormatter.format(region.revenue),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: Colors.purple.shade700,
                          ),
                        )),
                        DataCell(Row(
                          children: [
                            Icon(
                              region.growth >= 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14,
                              color: region.growth >= 0
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${region.growth.abs().toStringAsFixed(1)}%',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: region.growth >= 0
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                              ),
                            ),
                          ],
                        )),
                        DataCell(Text('${region.customerCount}')),
                        DataCell(Text(
                            '${region.marketPenetration.toStringAsFixed(1)}%')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  // Filter modal
  void _showFilterModal(
      BuildContext context, RevenueAnalysisController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Wrap(
          children: [
            Column(
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
                  'Product',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterDropdown(
                  controller.selectedProduct,
                  [
                    'All',
                    'Enterprise Software Suite',
                    'Cloud Storage (1TB)',
                    'Security Consulting Package',
                    'Network Hardware Bundle',
                    'Support Plan (Annual)'
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Customer',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterDropdown(
                  controller.selectedCustomer,
                  [
                    'All',
                    'Acme Corporation',
                    'TechNova Inc.',
                    'Global Systems Ltd.',
                    'Omega Enterprises',
                    'Future Technologies'
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Region',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterDropdown(
                  controller.selectedRegion,
                  [
                    'All',
                    'North America',
                    'Europe',
                    'Asia Pacific',
                    'Latin America',
                    'Middle East & Africa'
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Filter dropdown
  Widget _buildFilterDropdown(RxString selectedValue, List<String> options) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          value: selectedValue.value,
          isExpanded: true,
          underline: const SizedBox(),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              selectedValue.value = newValue;
            }
          },
        ),
      ),
    );
  }
}
