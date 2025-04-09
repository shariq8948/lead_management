import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';

// Import your page wrapper

// Controller for managing state
class QuotationOrderConversionController extends GetxController {
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
  RxList<QuotationOrderData> conversionData = <QuotationOrderData>[].obs;
  RxDouble overallConversionRate = 0.0.obs;
  RxInt totalQuotations = 0.obs;
  RxInt totalOrders = 0.obs;
  RxDouble averageOrderValue = 0.0.obs;

  // Data for chart
  RxList<ConversionTrendData> trendData = <ConversionTrendData>[].obs;

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
    totalQuotations.value = 156;
    totalOrders.value = 87;
    overallConversionRate.value = 55.8;
    averageOrderValue.value = 2750.50;

    // Generate mock data for table
    conversionData.value = [
      QuotationOrderData(
        salesRep: 'John Smith',
        quotations: 42,
        orders: 27,
        conversionRate: 64.3,
        totalValue: 74250.00,
      ),
      QuotationOrderData(
        salesRep: 'Maria Rodriguez',
        quotations: 38,
        orders: 19,
        conversionRate: 50.0,
        totalValue: 52100.00,
      ),
      QuotationOrderData(
        salesRep: 'David Kim',
        quotations: 51,
        orders: 30,
        conversionRate: 58.8,
        totalValue: 81750.00,
      ),
      QuotationOrderData(
        salesRep: 'Sarah Johnson',
        quotations: 25,
        orders: 11,
        conversionRate: 44.0,
        totalValue: 31900.00,
      ),
    ];

    // Generate mock trend data for chart
    final DateFormat formatter = DateFormat('MMM d');
    final now = DateTime.now();

    trendData.value = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 30 - (index * 5)));
      return ConversionTrendData(
        date: formatter.format(date),
        conversionRate: 40 + (index * 3) + (index % 2 == 0 ? 5 : -2),
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
class QuotationOrderData {
  final String salesRep;
  final int quotations;
  final int orders;
  final double conversionRate;
  final double totalValue;

  QuotationOrderData({
    required this.salesRep,
    required this.quotations,
    required this.orders,
    required this.conversionRate,
    required this.totalValue,
  });
}

class ConversionTrendData {
  final String date;
  final double conversionRate;

  ConversionTrendData({
    required this.date,
    required this.conversionRate,
  });
}

// Main Page
class QuotationOrderConversionPage extends StatelessWidget {
  const QuotationOrderConversionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(QuotationOrderConversionController());

    return ReportPageWrapper(
      title: 'Quotation to Order',
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
                  _buildConversionRateChart(controller),
                  const SizedBox(height: 24),
                  _buildConversionTable(controller),
                ],
              ),
      ),
    );
  }

  // Summary metrics cards
  Widget _buildSummaryCards(QuotationOrderConversionController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Summary',
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
                  'Conversion Rate',
                  '${controller.overallConversionRate.value.toStringAsFixed(1)}%',
                  Colors.blue.shade50,
                  Colors.blue.shade700,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Total Quotations',
                  controller.totalQuotations.toString(),
                  Colors.purple.shade50,
                  Colors.purple.shade700,
                  Icons.description,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Confirmed Orders',
                  controller.totalOrders.toString(),
                  Colors.green.shade50,
                  Colors.green.shade700,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Avg. Order Value',
                  '\$${NumberFormat('#,##0.00').format(controller.averageOrderValue.value)}',
                  Colors.amber.shade50,
                  Colors.amber.shade700,
                  Icons.attach_money,
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

  // Conversion rate trend chart
  Widget _buildConversionRateChart(
      QuotationOrderConversionController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Rate Trend',
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
            child: controller.trendData.isEmpty
                ? const Center(child: Text('No data available'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 20,
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
                                  value < controller.trendData.length) {
                                return Text(
                                  controller.trendData[value.toInt()].date,
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
                            interval: 20,
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
                      maxX: controller.trendData.length - 1.0,
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: controller.trendData
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.conversionRate,
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue.shade700,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue.shade700,
                              strokeColor: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.shade100.withOpacity(0.3),
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

  // Conversion table by sales rep
  Widget _buildConversionTable(QuotationOrderConversionController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Rep Performance',
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
                        'Quotations',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Orders',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Conversion',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Value (\$)',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],
                  rows: controller.conversionData
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
                                data.quotations.toString(),
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.orders.toString(),
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
                                    width: 50,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: FractionallySizedBox(
                                      widthFactor: data.conversionRate / 100,
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: _getConversionColor(
                                              data.conversionRate),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${data.conversionRate}%',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                NumberFormat('#,##0.00')
                                    .format(data.totalValue),
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

  // Get color based on conversion rate
  Color _getConversionColor(double rate) {
    if (rate >= 60) return Colors.green.shade500;
    if (rate >= 40) return Colors.amber.shade500;
    return Colors.red.shade500;
  }

  // Filter modal
  void _showFilterModal(
      BuildContext context, QuotationOrderConversionController controller) {
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
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: controller.applyFilters,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 48),
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
    ];

    CustomFilterModal.show(
      context,
      filterWidgets: filterWidgets,
    );
  }
}
