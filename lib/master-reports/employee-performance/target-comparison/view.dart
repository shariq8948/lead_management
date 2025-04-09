import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';
import 'dart:math' as Math;

class PerformanceTargetController extends GetxController {
  final RxString selectedEmployee = "".obs;
  final RxBool isLoading = false.obs;
  final RxList<String> employees = <String>[].obs;
  final RxMap<String, dynamic> performanceData = <String, dynamic>{}.obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxString selectedKpi = "All KPIs".obs;

  final kpiTypes = [
    "All KPIs",
    "Revenue",
    "Conversion Rate",
    "Deal Size",
    "Closing Time"
  ];

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
      loadPerformanceData();
      isLoading.value = false;
    });
  }

  void loadPerformanceData() {
    // Simulate API call to fetch performance data
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      // Generate team performance data for "All Employees"
      if (selectedEmployee.value == "All Employees") {
        performanceData.value = {
          'summary': {
            'total_revenue': 1265000,
            'revenue_target': 1200000,
            'revenue_achievement': 105.4,
            'conversion_rate': 22.4,
            'conversion_target': 25.0,
            'conversion_achievement': 89.6,
            'avg_deal_size': 14850,
            'deal_size_target': 15000,
            'deal_size_achievement': 99.0,
            'avg_closing_days': 32,
            'closing_days_target': 30,
            'closing_achievement': 93.8
          },
          'team_performance': [
            {
              'name': 'John Doe',
              'revenue_achievement': 118.5,
              'conversion_achievement': 95.2,
              'deal_size_achievement': 110.3,
              'closing_achievement': 105.6,
              'overall_performance': 107.4
            },
            {
              'name': 'Jane Smith',
              'revenue_achievement': 103.2,
              'conversion_achievement': 92.8,
              'deal_size_achievement': 98.7,
              'closing_achievement': 97.5,
              'overall_performance': 98.1
            },
            {
              'name': 'Alex Johnson',
              'revenue_achievement': 95.7,
              'conversion_achievement': 85.4,
              'deal_size_achievement': 105.8,
              'closing_achievement': 87.3,
              'overall_performance': 93.6
            },
            {
              'name': 'Sarah Williams',
              'revenue_achievement': 112.3,
              'conversion_achievement': 90.1,
              'deal_size_achievement': 103.2,
              'closing_achievement': 96.4,
              'overall_performance': 100.5
            },
            {
              'name': 'Michael Brown',
              'revenue_achievement': 89.5,
              'conversion_achievement': 82.6,
              'deal_size_achievement': 91.5,
              'closing_achievement': 85.7,
              'overall_performance': 87.3
            }
          ],
          'monthly_progress': [
            {'month': 'Jan', 'achievement': 92.5, 'target': 100},
            {'month': 'Feb', 'achievement': 95.8, 'target': 100},
            {'month': 'Mar', 'achievement': 103.2, 'target': 100},
            {'month': 'Apr', 'achievement': 101.5, 'target': 100},
            {'month': 'May', 'achievement': 98.7, 'target': 100},
            {'month': 'Jun', 'achievement': 105.4, 'target': 100}
          ],
          'product_performance': [
            {'product': 'Product A', 'achievement': 112.5, 'sales': 425000},
            {'product': 'Product B', 'achievement': 98.3, 'sales': 315000},
            {'product': 'Product C', 'achievement': 85.7, 'sales': 186000},
            {'product': 'Product D', 'achievement': 105.2, 'sales': 339000}
          ],
          'improvement_areas': [
            {
              'area': 'Conversion Rate',
              'current': 22.4,
              'target': 25.0,
              'gap': 2.6,
              'potential_impact': 'Additional ${120000} in revenue'
            },
            {
              'area': 'Average Closing Time',
              'current': 32,
              'target': 30,
              'gap': 2,
              'potential_impact': 'Shorter sales cycle by 6.7%'
            }
          ]
        };
      } else {
        // Generate individual employee performance data
        final employeeIndex = employees.indexOf(selectedEmployee.value);

        // Base values
        double revenueAchievement = 85.0 + (employeeIndex * 8.5);
        double conversionAchievement = 80.0 + (employeeIndex * 4.0);
        double dealSizeAchievement = 90.0 + (employeeIndex * 5.0);
        double closingAchievement = 85.0 + (employeeIndex * 5.2);
        double overallPerformance = (revenueAchievement +
                conversionAchievement +
                dealSizeAchievement +
                closingAchievement) /
            4;

        // Add some randomness
        revenueAchievement += (Math.Random().nextDouble() * 10) - 5;
        conversionAchievement += (Math.Random().nextDouble() * 10) - 5;
        dealSizeAchievement += (Math.Random().nextDouble() * 10) - 5;
        closingAchievement += (Math.Random().nextDouble() * 10) - 5;
        overallPerformance = (revenueAchievement +
                conversionAchievement +
                dealSizeAchievement +
                closingAchievement) /
            4;

        // Calculate actual values based on percentages
        final revenue = (250000 * revenueAchievement / 100).round();
        final revenueTarget = 250000;
        final conversionRate = 20.0 + (Math.Random().nextDouble() * 10);
        final conversionTarget = 25.0;
        final dealSize = (15000 * dealSizeAchievement / 100).round();
        final dealSizeTarget = 15000;
        final closingDays = (30 * 100 / closingAchievement).round();
        final closingDaysTarget = 30;

        performanceData.value = {
          'summary': {
            'total_revenue': revenue,
            'revenue_target': revenueTarget,
            'revenue_achievement': revenueAchievement,
            'conversion_rate': conversionRate,
            'conversion_target': conversionTarget,
            'conversion_achievement': conversionAchievement,
            'avg_deal_size': dealSize,
            'deal_size_target': dealSizeTarget,
            'deal_size_achievement': dealSizeAchievement,
            'avg_closing_days': closingDays,
            'closing_days_target': closingDaysTarget,
            'closing_achievement': closingAchievement,
            'overall_performance': overallPerformance
          },
          'deals_closed': [
            {
              'client':
                  'Client ${String.fromCharCode(65 + (Math.Random().nextDouble() * 20).floor())}',
              'amount': (10000 + Math.Random().nextDouble() * 20000).round(),
              'date':
                  '2025-03-${10 + (Math.Random().nextDouble() * 20).floor()}',
              'product':
                  'Product ${String.fromCharCode(65 + (Math.Random().nextDouble() * 4).floor())}'
            },
            {
              'client':
                  'Client ${String.fromCharCode(65 + (Math.Random().nextDouble() * 20).floor())}',
              'amount': (10000 + Math.Random().nextDouble() * 20000).round(),
              'date':
                  '2025-03-${10 + (Math.Random().nextDouble() * 20).floor()}',
              'product':
                  'Product ${String.fromCharCode(65 + (Math.Random().nextDouble() * 4).floor())}'
            },
            {
              'client':
                  'Client ${String.fromCharCode(65 + (Math.Random().nextDouble() * 20).floor())}',
              'amount': (10000 + Math.Random().nextDouble() * 20000).round(),
              'date':
                  '2025-03-${10 + (Math.Random().nextDouble() * 20).floor()}',
              'product':
                  'Product ${String.fromCharCode(65 + (Math.Random().nextDouble() * 4).floor())}'
            },
            {
              'client':
                  'Client ${String.fromCharCode(65 + (Math.Random().nextDouble() * 20).floor())}',
              'amount': (10000 + Math.Random().nextDouble() * 20000).round(),
              'date':
                  '2025-03-${10 + (Math.Random().nextDouble() * 20).floor()}',
              'product':
                  'Product ${String.fromCharCode(65 + (Math.Random().nextDouble() * 4).floor())}'
            }
          ],
          'monthly_progress': [
            {
              'month': 'Jan',
              'achievement': 80.0 + (Math.Random().nextDouble() * 30),
              'target': 100
            },
            {
              'month': 'Feb',
              'achievement': 80.0 + (Math.Random().nextDouble() * 30),
              'target': 100
            },
            {
              'month': 'Mar',
              'achievement': 80.0 + (Math.Random().nextDouble() * 30),
              'target': 100
            },
            {
              'month': 'Apr',
              'achievement': 80.0 + (Math.Random().nextDouble() * 30),
              'target': 100
            },
            {
              'month': 'May',
              'achievement': 80.0 + (Math.Random().nextDouble() * 30),
              'target': 100
            },
            {
              'month': 'Jun',
              'achievement': 80.0 + (Math.Random().nextDouble() * 30),
              'target': 100
            }
          ],
          'product_performance': [
            {
              'product': 'Product A',
              'achievement': 80.0 + (Math.Random().nextDouble() * 40),
              'sales': (50000 + Math.Random().nextDouble() * 100000).round()
            },
            {
              'product': 'Product B',
              'achievement': 80.0 + (Math.Random().nextDouble() * 40),
              'sales': (30000 + Math.Random().nextDouble() * 80000).round()
            },
            {
              'product': 'Product C',
              'achievement': 80.0 + (Math.Random().nextDouble() * 40),
              'sales': (20000 + Math.Random().nextDouble() * 60000).round()
            },
            {
              'product': 'Product D',
              'achievement': 80.0 + (Math.Random().nextDouble() * 40),
              'sales': (40000 + Math.Random().nextDouble() * 80000).round()
            }
          ],
          'improvement_areas': [
            {
              'area':
                  conversionAchievement < 95 ? 'Conversion Rate' : 'Deal Size',
              'current': conversionAchievement < 95 ? conversionRate : dealSize,
              'target': conversionAchievement < 95
                  ? conversionTarget
                  : dealSizeTarget,
              'gap': conversionAchievement < 95
                  ? (conversionTarget - conversionRate)
                  : (dealSizeTarget - dealSize),
              'potential_impact': conversionAchievement < 95
                  ? 'Additional ${(30000 * Math.Random().nextDouble()).round()} in revenue'
                  : 'Increase average deal size by ${(2000 * Math.Random().nextDouble()).round()}'
            },
            {
              'area': closingAchievement < 95
                  ? 'Average Closing Time'
                  : 'Follow-up Rate',
              'current': closingAchievement < 95
                  ? closingDays
                  : (60 + Math.Random().nextDouble() * 20).round(),
              'target': closingAchievement < 95 ? closingDaysTarget : 85,
              'gap': closingAchievement < 95
                  ? (closingDays - closingDaysTarget)
                  : (85 - (60 + Math.Random().nextDouble() * 20).round()),
              'potential_impact': closingAchievement < 95
                  ? 'Shorter sales cycle by ${((closingDays - closingDaysTarget) / closingDays * 100).toStringAsFixed(1)}%'
                  : 'Increase retention rate by ${(5 + Math.Random().nextDouble() * 10).toStringAsFixed(1)}%'
            }
          ]
        };
      }
      isLoading.value = false;
    });
  }

  void onEmployeeSelected(String? employee) {
    if (employee != null && employee != selectedEmployee.value) {
      selectedEmployee.value = employee;
      loadPerformanceData();
    }
  }

  void onKpiSelected(String? type) {
    if (type != null && type != selectedKpi.value) {
      selectedKpi.value = type;
      // No need to reload data, just filter the existing data based on KPI
    }
  }

  void onDateRangeChanged(DateTimeRange? dateRange) {
    selectedDateRange.value = dateRange;
    loadPerformanceData();
  }
}

class PerformanceTargetPage extends StatelessWidget {
  const PerformanceTargetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PerformanceTargetController());
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return ReportPageWrapper(
      title: "Performance Against Target",
      showFilterIcon: true,
      onFilterTap: () {
        CustomFilterModal.show(
          context,
          filterWidgets: [
            _buildFilterSection(
              "KPI Types",
              controller.kpiTypes
                  .map((type) => _buildFilterChip(type,
                          isSelected: type == controller.selectedKpi.value,
                          onSelected: (selected) {
                        if (selected) {
                          controller.onKpiSelected(type);
                          Navigator.pop(context);
                        }
                      }))
                  .toList(),
            ),
            _buildFilterSection(
              "Time Period",
              [
                _buildFilterChip("This Month"),
                _buildFilterChip("Last Quarter", isSelected: true),
                _buildFilterChip("Year to Date"),
                _buildFilterChip("Last 12 Months"),
                _buildFilterChip("Custom Date Range"),
              ],
            ),
            _buildFilterSection(
              "Product Lines",
              [
                _buildFilterChip("All Products", isSelected: true),
                _buildFilterChip("Product A"),
                _buildFilterChip("Product B"),
                _buildFilterChip("Product C"),
                _buildFilterChip("Product D"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.loadPerformanceData();
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

            if (controller.performanceData.isEmpty) {
              return const Center(
                child: Text("No data available"),
              );
            }

            final summary = controller.performanceData['summary'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverallPerformanceCard(summary, controller),
                const SizedBox(height: 24),
                _buildKpiCards(summary, currencyFormat),
                const SizedBox(height: 24),
                controller.selectedEmployee.value == "All Employees"
                    ? _buildTeamPerformanceTable(controller)
                    : _buildDealsClosedTable(controller, currencyFormat),
                const SizedBox(height: 24),
                _buildPerformanceChart(controller),
                const SizedBox(height: 24),
                _buildProductPerformance(controller, currencyFormat),
                const SizedBox(height: 24),
                _buildImprovementAreas(controller, currencyFormat),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmployeeSelector(PerformanceTargetController controller) {
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

  Widget _buildOverallPerformanceCard(
      Map<String, dynamic> summary, PerformanceTargetController controller) {
    final bool isIndividual =
        controller.selectedEmployee.value != "All Employees";
    final double performanceValue = isIndividual
        ? summary['overall_performance']
        : (summary['revenue_achievement'] +
                summary['conversion_achievement'] +
                summary['deal_size_achievement'] +
                summary['closing_achievement']) /
            4;
    final bool isPositive = performanceValue >= 100;
    final Color performanceColor =
        isPositive ? Colors.green.shade600 : Colors.orange.shade700;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade700, Colors.indigo.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.shade200.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overall Performance",
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
                "${performanceValue.toStringAsFixed(1)}%",
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
                    isPositive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: isPositive
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "vs Target",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPositive
                          ? Colors.green.shade300
                          : Colors.orange.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: performanceValue / 100,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              performanceValue >= 100
                  ? Colors.green.shade300
                  : performanceValue >= 90
                      ? Colors.amber.shade300
                      : Colors.red.shade300,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Text(
            isIndividual
                ? "${controller.selectedEmployee.value}'s overall performance against targets"
                : "Team's average performance across all KPIs",
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

  Widget _buildKpiCards(
      Map<String, dynamic> summary, NumberFormat currencyFormat) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                "Revenue",
                currencyFormat.format(summary['total_revenue']),
                Icons.monetization_on_outlined,
                Colors.green,
                summary['revenue_achievement'].toDouble(),
                currencyFormat.format(summary['revenue_target']),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(
                "Conversion Rate",
                "${summary['conversion_rate'].toStringAsFixed(1)}%",
                Icons.assessment_outlined,
                Colors.blue,
                summary['conversion_achievement'].toDouble(),
                "${summary['conversion_target'].toStringAsFixed(1)}%",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                "Avg. Deal Size",
                currencyFormat.format(summary['avg_deal_size']),
                Icons.monetization_on_outlined,
                Colors.purple,
                summary['deal_size_achievement'].toDouble(),
                currencyFormat.format(summary['deal_size_target']),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(
                "Avg. Closing Time",
                "${summary['avg_closing_days']} days",
                Icons.timer_outlined,
                Colors.orange,
                summary['closing_achievement'].toDouble(),
                "${summary['closing_days_target']} days",
                inversed: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon,
      MaterialColor color, double achievement, String target,
      {bool inversed = false}) {
    // For inversed metrics like closing time, lower is better
    final isPositive = inversed ? achievement >= 100 : achievement >= 100;
    final displayAchievement = "${achievement.toStringAsFixed(1)}%";

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color.shade700,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayAchievement,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositive
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Target: $target",
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: achievement / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isPositive ? Colors.green.shade500 : Colors.orange.shade500,
            ),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPerformanceTable(PerformanceTargetController controller) {
    final teamPerformance =
        controller.performanceData['team_performance'] as List;

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
            "Team Performance",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
              dataTextStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              columnSpacing: 24,
              horizontalMargin: 12,
              headingRowHeight: 48,
              dataRowHeight: 56,
              columns: const [
                DataColumn(label: Text('Employee')),
                DataColumn(label: Text('Revenue'), numeric: true),
                DataColumn(label: Text('Conversion'), numeric: true),
                DataColumn(label: Text('Deal Size'), numeric: true),
                DataColumn(label: Text('Time to Close'), numeric: true),
                DataColumn(label: Text('Overall'), numeric: true),
              ],
              rows: teamPerformance.map<DataRow>((employee) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        employee['name'],
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(
                        _buildPerformanceCell(employee['revenue_achievement'])),
                    DataCell(_buildPerformanceCell(
                        employee['conversion_achievement'])),
                    DataCell(_buildPerformanceCell(
                        employee['deal_size_achievement'])),
                    DataCell(
                        _buildPerformanceCell(employee['closing_achievement'])),
                    DataCell(_buildPerformanceCell(
                        employee['overall_performance'],
                        isOverall: true)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCell(double value, {bool isOverall = false}) {
    final bool isPositive = value >= 100;
    final Color textColor =
        isPositive ? Colors.green.shade700 : Colors.orange.shade800;
    final Color bgColor =
        isPositive ? Colors.green.shade50 : Colors.orange.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOverall
            ? (isPositive ? Colors.green.shade100 : Colors.orange.shade100)
            : bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${value.toStringAsFixed(1)}%",
        style: GoogleFonts.montserrat(
          fontWeight: isOverall ? FontWeight.w700 : FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDealsClosedTable(
      PerformanceTargetController controller, NumberFormat currencyFormat) {
    final dealsData = controller.performanceData['deals_closed'] as List;

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
            "Recent Deals Closed",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
              dataTextStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              columnSpacing: 24,
              horizontalMargin: 12,
              headingRowHeight: 48,
              dataRowHeight: 56,
              columns: const [
                DataColumn(label: Text('Client')),
                DataColumn(label: Text('Amount'), numeric: true),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Product')),
              ],
              rows: dealsData.map<DataRow>((deal) {
                final amount = deal['amount'] as int;
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        deal['client'],
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(Text(currencyFormat.format(amount))),
                    DataCell(Text(DateFormat('MMM d, yyyy')
                        .format(DateTime.parse(deal['date'])))),
                    DataCell(Text(deal['product'])),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(PerformanceTargetController controller) {
    final monthlyData = controller.performanceData['monthly_progress'] as List;

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
            "Monthly Performance Trend",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
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
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= monthlyData.length)
                          return const SizedBox();
                        final month = monthlyData[value.toInt()]['month'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            month,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${value.toInt()}%',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.grey.shade700,
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
                maxX: monthlyData.length - 1.0,
                minY: 60,
                maxY: 120,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final monthIndex = touchedSpot.x.toInt();
                        final achievement = touchedSpot.y;
                        return LineTooltipItem(
                          '${monthlyData[monthIndex]['month']}: ${achievement.toStringAsFixed(1)}%',
                          GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Achievement line
                  LineChartBarData(
                    spots: monthlyData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value['achievement'] as double);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue.shade600,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final value = spot.y;
                        Color dotColor = value >= 100
                            ? Colors.green.shade600
                            : Colors.orange.shade600;
                        return FlDotCirclePainter(
                          radius: 5,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: dotColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade100.withOpacity(0.3),
                    ),
                  ),
                  // Target line
                  LineChartBarData(
                    spots: List.generate(
                      monthlyData.length,
                      (index) => FlSpot(index.toDouble(), 100),
                    ),
                    isCurved: false,
                    color: Colors.red.shade400,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Achievement",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Target",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
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

  Widget _buildProductPerformance(
      PerformanceTargetController controller, NumberFormat currencyFormat) {
    final productData =
        controller.performanceData['product_performance'] as List;

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
            "Product Performance",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productData.length,
            itemBuilder: (context, index) {
              final product = productData[index];
              final achievement = product['achievement'] as double;
              final sales = product['sales'] as int;
              final isPositive = achievement >= 100;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['product'],
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              currencyFormat.format(sales),
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPositive
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isPositive
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    color: isPositive
                                        ? Colors.green.shade700
                                        : Colors.orange.shade700,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${achievement.toStringAsFixed(1)}%",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isPositive
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: achievement / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPositive
                            ? Colors.green.shade500
                            : Colors.orange.shade500,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
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

  Widget _buildImprovementAreas(
      PerformanceTargetController controller, NumberFormat currencyFormat) {
    final areas = controller.performanceData['improvement_areas'] as List;

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
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Areas for Improvement",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: areas.length,
            itemBuilder: (context, index) {
              final area = areas[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area['area'],
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMetricItem("Current", area['current']),
                        const SizedBox(width: 16),
                        _buildMetricItem("Target", area['target']),
                        const SizedBox(width: 16),
                        _buildMetricItem("Gap", area['gap'], isGap: true),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.insights,
                            color: Colors.blue.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Potential Impact: ${area['potential_impact']}",
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildMetricItem(String label, dynamic value, {bool isGap = false}) {
    String displayValue;
    if (value is double) {
      displayValue = value.toStringAsFixed(1);
    } else {
      displayValue = value.toString();
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayValue,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isGap ? Colors.red.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 16.0, right: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label,
      {bool isSelected = false, Function(bool)? onSelected}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected ?? (val) {},
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade700,
      labelStyle: GoogleFonts.montserrat(
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade800,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class CustomFilterModal {
  static void show(BuildContext context,
      {required List<Widget> filterWidgets}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filters",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Clear All",
                        style: GoogleFonts.montserrat(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filterWidgets,
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

class ReportPageWrapper extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showFilterIcon;
  final Function()? onFilterTap;
  final Function(DateTimeRange?)? onDateRangeSelected;

  const ReportPageWrapper({
    Key? key,
    required this.title,
    required this.body,
    this.showFilterIcon = false,
    this.onFilterTap,
    this.onDateRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (showFilterIcon)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: onFilterTap,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: body,
          ),
        ),
      ),
    );
  }
}
