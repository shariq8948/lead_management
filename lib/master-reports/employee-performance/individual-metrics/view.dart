import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/page_wrapper.dart';
import 'dart:math' as math;

class EmployeeConversionRateController extends GetxController {
  final RxString selectedEmployee = "".obs;
  final RxBool isLoading = false.obs;
  final RxList<String> employees = <String>[].obs;
  final RxMap<String, dynamic> conversionData = <String, dynamic>{}.obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  void loadEmployees() {
    // Simulate API call to fetch employees
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      employees.value = [
        "All Employees",
        "John Doe",
        "Jane Smith",
        "Alex Johnson",
        "Sarah Williams",
        "Michael Brown"
      ];
      selectedEmployee.value = employees[0];
      loadConversionData();
      isLoading.value = false;
    });
  }

  void loadConversionData() {
    // Simulate API call to fetch conversion data
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      // Mock data - in a real app, this would come from your API
      if (selectedEmployee.value == "All Employees") {
        conversionData.value = {
          'overall_rate': 32.5,
          'previous_period': 28.7,
          'change': 3.8,
          'monthly_data': [
            {'month': 'Jan', 'rate': 28.0},
            {'month': 'Feb', 'rate': 29.5},
            {'month': 'Mar', 'rate': 31.2},
            {'month': 'Apr', 'rate': 32.5},
            {'month': 'May', 'rate': 33.8},
            {'month': 'Jun', 'rate': 32.5}
          ],
          'recent_conversions': [
            {
              'lead_name': 'Acme Corp',
              'date': '2025-03-28',
              'value': '\$12,500'
            },
            {
              'lead_name': 'Global Tech',
              'date': '2025-03-25',
              'value': '\$8,750'
            },
            {
              'lead_name': 'Smart Solutions',
              'date': '2025-03-22',
              'value': '\$15,200'
            },
          ]
        };
      } else {
        // Generate some random data for individual employees
        final rate = 25.0 + (employees.indexOf(selectedEmployee.value) * 3.5);
        final previousRate = rate - (2.0 + math.Random().nextInt(10));

        conversionData.value = {
          'overall_rate': rate,
          'previous_period': previousRate,
          'change': rate - previousRate,
          'monthly_data': [
            {'month': 'Jan', 'rate': rate - 4.5},
            {'month': 'Feb', 'rate': rate - 3.0},
            {'month': 'Mar', 'rate': rate - 1.3},
            {'month': 'Apr', 'rate': rate},
            {'month': 'May', 'rate': rate + 1.2},
            {'month': 'Jun', 'rate': rate + 0.8}
          ],
          'recent_conversions': [
            {'lead_name': 'Client A', 'date': '2025-03-27', 'value': '\$9,800'},
            {'lead_name': 'Client B', 'date': '2025-03-23', 'value': '\$7,300'},
            {
              'lead_name': 'Client C',
              'date': '2025-03-18',
              'value': '\$11,500'
            },
          ]
        };
      }
      isLoading.value = false;
    });
  }

  void onEmployeeSelected(String? employee) {
    if (employee != null && employee != selectedEmployee.value) {
      selectedEmployee.value = employee;
      loadConversionData();
    }
  }

  void onDateRangeChanged(DateTimeRange? dateRange) {
    selectedDateRange.value = dateRange;
    loadConversionData();
  }
}

class EmployeeConversionRatePage extends StatelessWidget {
  const EmployeeConversionRatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeConversionRateController());

    return ReportPageWrapper(
      title: "Conversion Rate",
      showFilterIcon: true,
      onFilterTap: () {
        CustomFilterModal.show(
          context,
          filterWidgets: [
            _buildFilterSection(
              "Time Period",
              [
                _buildFilterChip("Last 7 Days"),
                _buildFilterChip("Last 30 Days", isSelected: true),
                _buildFilterChip("Last Quarter"),
                _buildFilterChip("Year to Date"),
              ],
            ),
            _buildFilterSection(
              "Conversion Status",
              [
                _buildFilterChip("All Statuses", isSelected: true),
                _buildFilterChip("Initial Contact"),
                _buildFilterChip("Meeting Scheduled"),
                _buildFilterChip("Proposal Sent"),
                _buildFilterChip("Closed Won"),
                _buildFilterChip("Closed Lost"),
              ],
            ),
            _buildFilterSection(
              "Lead Source",
              [
                _buildFilterChip("All Sources", isSelected: true),
                _buildFilterChip("Website"),
                _buildFilterChip("Referral"),
                _buildFilterChip("Social Media"),
                _buildFilterChip("Trade Show"),
                _buildFilterChip("Direct Contact"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.loadConversionData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Apply Filters",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      onDateRangeSelected: controller.onDateRangeChanged,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmployeeSelector(controller),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.conversionData.isEmpty) {
              return const Center(
                child: Text("No data available"),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(controller),
                const SizedBox(height: 24),
                _buildConversionChart(controller),
                const SizedBox(height: 24),
                _buildRecentConversionsTable(controller),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmployeeSelector(EmployeeConversionRateController controller) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedEmployee.value.isEmpty
                ? null
                : controller.selectedEmployee.value,
            hint: const Text("Select Employee"),
            items: controller.employees.map((employee) {
              return DropdownMenuItem<String>(
                value: employee,
                child: Text(
                  employee,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: controller.onEmployeeSelected,
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            dropdownColor: Colors.white,
          ),
        ),
      );
    });
  }

  Widget _buildSummaryCard(EmployeeConversionRateController controller) {
    final data = controller.conversionData;
    final isPositiveChange = data['change'] >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade700, Colors.blue.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Conversion Rate",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${data['overall_rate']}%",
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Icon(
                    isPositiveChange
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: isPositiveChange
                        ? Colors.green.shade300
                        : Colors.red.shade300,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${isPositiveChange ? '+' : ''}${data['change'].toStringAsFixed(1)}%",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPositiveChange
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "vs ${data['previous_period']}% in previous period",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionChart(EmployeeConversionRateController controller) {
    final monthlyData = controller.conversionData['monthly_data'] as List;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Monthly Conversion Trend",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Last 6 Months",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
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
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < monthlyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              monthlyData[value.toInt()]['month'],
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "${value.toInt()}%",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: monthlyData.length - 1.0,
                minY: 0,
                maxY: 50,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                        monthlyData.length,
                        (index) => FlSpot(index.toDouble(),
                            monthlyData[index]['rate'].toDouble())),
                    isCurved: true,
                    color: Colors.blue.shade700,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.blue.shade700,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentConversionsTable(
      EmployeeConversionRateController controller) {
    final recentConversions =
        controller.conversionData['recent_conversions'] as List;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Conversions",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Lead Name",
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Date",
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Value",
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              ...recentConversions.map((conversion) {
                return TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        conversion['lead_name'],
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        _formatDate(conversion['date']),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        conversion['value'],
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              // Navigate to detailed conversion list
              Get.snackbar(
                "Coming Soon",
                "Detailed conversions view will be available in the next update.",
                backgroundColor: Colors.blue.shade50,
                colorText: Colors.blue.shade700,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View All Conversions",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.blue.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> chips) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: chips,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Handle selection in a real app
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade700,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
      ),
      labelStyle: GoogleFonts.montserrat(
        color: isSelected ? Colors.blue.shade700 : Colors.black87,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final month = _getMonthName(date.month);
    return "$month ${date.day}";
  }

  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }
}
