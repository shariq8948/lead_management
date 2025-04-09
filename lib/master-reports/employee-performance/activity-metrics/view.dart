import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';
import 'dart:math' as math;

class ActivityMetricsController extends GetxController {
  final RxString selectedEmployee = "".obs;
  final RxBool isLoading = false.obs;
  final RxList<String> employees = <String>[].obs;
  final RxMap<String, dynamic> activityData = <String, dynamic>{}.obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxString selectedActivityType = "All Activities".obs;

  final activityTypes = [
    "All Activities",
    "Emails",
    "Calls",
    "Meetings",
    "Follow-ups"
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
      loadActivityData();
      isLoading.value = false;
    });
  }

  void loadActivityData() {
    // Simulate API call to fetch activity data
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      // Mock data - in a real app, this would come from your API
      if (selectedEmployee.value == "All Employees") {
        activityData.value = {
          'summary': {
            'total_activities': 284,
            'emails': 128,
            'calls': 75,
            'meetings': 42,
            'followups': 39,
            'previous_total': 256,
            'change_percentage': 10.9
          },
          'activity_by_day': [
            {
              'date': '2025-03-26',
              'emails': 28,
              'calls': 15,
              'meetings': 8,
              'followups': 7
            },
            {
              'date': '2025-03-27',
              'emails': 24,
              'calls': 17,
              'meetings': 9,
              'followups': 6
            },
            {
              'date': '2025-03-28',
              'emails': 22,
              'calls': 12,
              'meetings': 5,
              'followups': 8
            },
            {
              'date': '2025-03-29',
              'emails': 16,
              'calls': 8,
              'meetings': 4,
              'followups': 5
            },
            {
              'date': '2025-03-30',
              'emails': 18,
              'calls': 11,
              'meetings': 7,
              'followups': 6
            },
            {
              'date': '2025-03-31',
              'emails': 20,
              'calls': 12,
              'meetings': 9,
              'followups': 7
            }
          ],
          'recent_activities': [
            {
              'type': 'email',
              'lead': 'Acme Corporation',
              'timestamp': '2025-03-31T14:30:00',
              'employee': 'John Doe',
              'details': 'Sent product demonstration follow-up'
            },
            {
              'type': 'call',
              'lead': 'Global Tech Solutions',
              'timestamp': '2025-03-31T13:15:00',
              'employee': 'Jane Smith',
              'details': 'Discovery call to understand requirements'
            },
            {
              'type': 'meeting',
              'lead': 'Innovate Partners',
              'timestamp': '2025-03-31T11:00:00',
              'employee': 'Sarah Williams',
              'details': 'Product demo with technical team'
            },
            {
              'type': 'followup',
              'lead': 'Nexus Enterprises',
              'timestamp': '2025-03-31T10:15:00',
              'employee': 'Michael Brown',
              'details': 'Sent proposal follow-up and pricing clarification'
            },
            {
              'type': 'email',
              'lead': 'Summit Technologies',
              'timestamp': '2025-03-31T09:45:00',
              'employee': 'Alex Johnson',
              'details': 'Introduction and initial outreach'
            }
          ],
          'activity_efficiency': {
            'response_time': 4.2, // hours
            'activities_per_lead': 3.8,
            'follow_up_rate': 68.5, // percentage
            'conversion_from_activity': 12.3 // percentage
          }
        };
      } else {
        // Generate individual employee data
        final multiplier =
            0.5 + (employees.indexOf(selectedEmployee.value) * 0.15);
        final emails = (28 * multiplier).round();
        final calls = (17 * multiplier).round();
        final meetings = (9 * multiplier).round();
        final followups = (7 * multiplier).round();
        final total = emails + calls + meetings + followups;
        final previousTotal = (total * 0.85).round();

        activityData.value = {
          'summary': {
            'total_activities': total,
            'emails': emails,
            'calls': calls,
            'meetings': meetings,
            'followups': followups,
            'previous_total': previousTotal,
            'change_percentage':
                ((total - previousTotal) / previousTotal * 100).toDouble()
          },
          'activity_by_day': [
            {
              'date': '2025-03-26',
              'emails': (emails * 0.9 / 6).round(),
              'calls': (calls * 1.1 / 6).round(),
              'meetings': (meetings * 0.9 / 6).round(),
              'followups': (followups * 0.8 / 6).round()
            },
            {
              'date': '2025-03-27',
              'emails': (emails * 1.1 / 6).round(),
              'calls': (calls * 0.9 / 6).round(),
              'meetings': (meetings * 1.2 / 6).round(),
              'followups': (followups * 0.9 / 6).round()
            },
            {
              'date': '2025-03-28',
              'emails': (emails * 0.8 / 6).round(),
              'calls': (calls * 0.8 / 6).round(),
              'meetings': (meetings * 0.7 / 6).round(),
              'followups': (followups * 1.2 / 6).round()
            },
            {
              'date': '2025-03-29',
              'emails': (emails * 0.6 / 6).round(),
              'calls': (calls * 0.5 / 6).round(),
              'meetings': (meetings * 0.5 / 6).round(),
              'followups': (followups * 0.8 / 6).round()
            },
            {
              'date': '2025-03-30',
              'emails': (emails * 0.7 / 6).round(),
              'calls': (calls * 0.7 / 6).round(),
              'meetings': (meetings * 0.8 / 6).round(),
              'followups': (followups * 1.1 / 6).round()
            },
            {
              'date': '2025-03-31',
              'emails': (emails * 0.9 / 6).round(),
              'calls': (calls * 1.0 / 6).round(),
              'meetings': (meetings * 0.9 / 6).round(),
              'followups': (followups * 1.2 / 6).round()
            }
          ],
          'recent_activities': [
            {
              'type': _randomActivityType(),
              'lead':
                  'Client ${String.fromCharCode(65 + (math.Random().nextDouble() * 20).floor())}',
              'timestamp':
                  '2025-03-31T${(14 - (math.Random().nextDouble() * 6).floor()).toString().padLeft(2, '0')}:${(math.Random().nextDouble() * 60).floor().toString().padLeft(2, '0')}:00',
              'employee': selectedEmployee.value,
              'details': _randomActivityDetail()
            },
            {
              'type': _randomActivityType(),
              'lead':
                  'Client ${String.fromCharCode(65 + (math.Random().nextDouble() * 20).floor())}',
              'timestamp':
                  '2025-03-31T${(14 - (math.Random().nextDouble() * 6).floor()).toString().padLeft(2, '0')}:${(math.Random().nextDouble() * 60).floor().toString().padLeft(2, '0')}:00',
              'employee': selectedEmployee.value,
              'details': _randomActivityDetail()
            },
            {
              'type': _randomActivityType(),
              'lead':
                  'Client ${String.fromCharCode(65 + (math.Random().nextDouble() * 20).floor())}',
              'timestamp':
                  '2025-03-31T${(14 - (math.Random().nextDouble() * 6).floor()).toString().padLeft(2, '0')}:${(math.Random().nextDouble() * 60).floor().toString().padLeft(2, '0')}:00',
              'employee': selectedEmployee.value,
              'details': _randomActivityDetail()
            },
            {
              'type': _randomActivityType(),
              'lead':
                  'Client ${String.fromCharCode(65 + (math.Random().nextDouble() * 20).floor())}',
              'timestamp':
                  '2025-03-31T${(14 - (math.Random().nextDouble() * 6).floor()).toString().padLeft(2, '0')}:${(math.Random().nextDouble() * 60).floor().toString().padLeft(2, '0')}:00',
              'employee': selectedEmployee.value,
              'details': _randomActivityDetail()
            }
          ],
          'activity_efficiency': {
            'response_time': 3.0 + math.Random().nextDouble() * 3.0, // hours
            'activities_per_lead': 2.5 + math.Random().nextDouble() * 2.0,
            'follow_up_rate':
                60.0 + math.Random().nextDouble() * 20.0, // percentage
            'conversion_from_activity':
                8.0 + math.Random().nextDouble() * 10.0 // percentage
          }
        };
      }
      isLoading.value = false;
    });
  }

  String _randomActivityType() {
    final types = ['email', 'call', 'meeting', 'followup'];
    return types[(math.Random().nextDouble() * types.length).floor()];
  }

  String _randomActivityDetail() {
    final details = [
      'Initial contact',
      'Follow-up discussion',
      'Product demonstration',
      'Price negotiation',
      'Technical consultation',
      'Contract review',
      'Proposal presentation'
    ];
    return details[(math.Random().nextDouble() * details.length).floor()];
  }

  void onEmployeeSelected(String? employee) {
    if (employee != null && employee != selectedEmployee.value) {
      selectedEmployee.value = employee;
      loadActivityData();
    }
  }

  void onActivityTypeSelected(String? type) {
    if (type != null && type != selectedActivityType.value) {
      selectedActivityType.value = type;
      // No need to reload data, we'll just filter the existing data
    }
  }

  void onDateRangeChanged(DateTimeRange? dateRange) {
    selectedDateRange.value = dateRange;
    loadActivityData();
  }
}

class ActivityMetricsPage extends StatelessWidget {
  const ActivityMetricsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityMetricsController());

    return ReportPageWrapper(
      title: "Activity Metrics",
      showFilterIcon: true,
      onFilterTap: () {
        CustomFilterModal.show(
          context,
          filterWidgets: [
            _buildFilterSection(
              "Activity Types",
              controller.activityTypes
                  .map((type) => _buildFilterChip(type,
                          isSelected:
                              type == controller.selectedActivityType.value,
                          onSelected: (selected) {
                        if (selected) {
                          controller.onActivityTypeSelected(type);
                          Navigator.pop(context);
                        }
                      }))
                  .toList(),
            ),
            _buildFilterSection(
              "Time Period",
              [
                _buildFilterChip("Today"),
                _buildFilterChip("Last 7 Days", isSelected: true),
                _buildFilterChip("Last 30 Days"),
                _buildFilterChip("This Month"),
                _buildFilterChip("Previous Month"),
              ],
            ),
            _buildFilterSection(
              "Lead Status",
              [
                _buildFilterChip("All Statuses", isSelected: true),
                _buildFilterChip("New"),
                _buildFilterChip("Contacted"),
                _buildFilterChip("Qualified"),
                _buildFilterChip("Proposal"),
                _buildFilterChip("Negotiation"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.loadActivityData();
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

            if (controller.activityData.isEmpty) {
              return const Center(
                child: Text("No data available"),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActivityCards(controller),
                const SizedBox(height: 24),
                _buildActivityChart(controller),
                const SizedBox(height: 24),
                _buildEfficiencyMetrics(controller),
                const SizedBox(height: 24),
                _buildRecentActivities(controller),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmployeeSelector(ActivityMetricsController controller) {
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

  Widget _buildActivityCards(ActivityMetricsController controller) {
    final summary = controller.activityData['summary'];
    final isPositiveChange = summary['change_percentage'] >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade600, Colors.indigo.shade900],
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
                "Total Activities",
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
                    "${summary['total_activities']}",
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
                        "${isPositiveChange ? '+' : ''}${summary['change_percentage'].toStringAsFixed(1)}%",
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
                "vs ${summary['previous_total']} in previous period",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActivityTypeCard(
                "Emails",
                summary['emails'],
                Icons.email_outlined,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityTypeCard(
                "Calls",
                summary['calls'],
                Icons.phone_outlined,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActivityTypeCard(
                "Meetings",
                summary['meetings'],
                Icons.people_outline,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityTypeCard(
                "Follow-ups",
                summary['followups'],
                Icons.replay_outlined,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityTypeCard(
      String title, int count, IconData icon, MaterialColor color) {
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
          const SizedBox(height: 12),
          Text(
            "$count",
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
        ],
      ),
    );
  }

  Widget _buildActivityChart(ActivityMetricsController controller) {
    final activityByDay = controller.activityData['activity_by_day'] as List;

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
            "Daily Activity Breakdown",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String type;
                      Color color;
                      int value = 0;

                      switch (rodIndex) {
                        case 0:
                          type = 'Emails';
                          color = Colors.blue;
                          value = activityByDay[groupIndex]['emails'];
                          break;
                        case 1:
                          type = 'Calls';
                          color = Colors.green;
                          value = activityByDay[groupIndex]['calls'];
                          break;
                        case 2:
                          type = 'Meetings';
                          color = Colors.orange;
                          value = activityByDay[groupIndex]['meetings'];
                          break;
                        case 3:
                          type = 'Follow-ups';
                          color = Colors.purple;
                          value = activityByDay[groupIndex]['followups'];
                          break;
                        default:
                          type = '';
                          color = Colors.grey;
                          break;
                      }

                      return BarTooltipItem(
                        '$type: $value',
                        GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
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
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < activityByDay.length) {
                          final date = DateTime.parse(
                              activityByDay[value.toInt()]['date']);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('MMM d').format(date),
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
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value % 5 == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
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
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(activityByDay.length, (index) {
                  final dayData = activityByDay[index];

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: dayData['emails'].toDouble(),
                        color: Colors.blue.shade500,
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: dayData['calls'].toDouble(),
                        color: Colors.green.shade500,
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: dayData['meetings'].toDouble(),
                        color: Colors.orange.shade500,
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: dayData['followups'].toDouble(),
                        color: Colors.purple.shade500,
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem("Emails", Colors.blue),
              _buildLegendItem("Calls", Colors.green),
              _buildLegendItem("Meetings", Colors.orange),
              _buildLegendItem("Follow-ups", Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, MaterialColor color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color.shade500,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildEfficiencyMetrics(ActivityMetricsController controller) {
    final efficiency = controller.activityData['activity_efficiency'];

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
            "Efficiency Metrics",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildEfficiencyCard(
                  "Avg. Response Time",
                  "${efficiency['response_time'].toStringAsFixed(1)} hrs",
                  Icons.timer_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEfficiencyCard(
                  "Activities Per Lead",
                  efficiency['activities_per_lead'].toStringAsFixed(1),
                  Icons.account_circle_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEfficiencyCard(
                  "Follow-up Rate",
                  "${efficiency['follow_up_rate'].toStringAsFixed(1)}%",
                  Icons.replay_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEfficiencyCard(
                  "Conversion Rate",
                  "${efficiency['conversion_from_activity'].toStringAsFixed(1)}%",
                  Icons.trending_up_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.indigo.shade600,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(ActivityMetricsController controller) {
    final recentActivities =
        controller.activityData['recent_activities'] as List;

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
            "Recent Activities",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...recentActivities
              .map((activity) => _buildActivityItem(activity))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final IconData icon;
    final Color color;

    switch (activity['type']) {
      case 'email':
        icon = Icons.email_outlined;
        color = Colors.blue;
        break;
      case 'call':
        icon = Icons.phone_outlined;
        color = Colors.green;
        break;
      case 'meeting':
        icon = Icons.people_outline;
        color = Colors.orange;
        break;
      case 'followup':
        icon = Icons.replay_outlined;
        color = Colors.purple;
        break;
      default:
        icon = Icons.event_note_outlined;
        color = Colors.grey;
    }

    final DateTime timestamp = DateTime.parse(activity['timestamp']);
    final timeFormatted = DateFormat('h:mm a').format(timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity['lead'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      timeFormatted,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity['details'],
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "By ${activity['employee']}",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.indigo.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> filterChips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filterChips,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildFilterChip(String label,
      {bool isSelected = false, Function(bool)? onSelected}) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey.shade800,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.indigo.shade600,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.indigo.shade600 : Colors.grey.shade300,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
