import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../widgets/page_wrapper.dart';

// Import your page wrapper

// MODELS - Same as before
class Employee {
  final String id;
  final String name;
  final String position;
  final String avatarUrl;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.avatarUrl,
  });
}

class LeadStatusData {
  final Employee employee;
  final int assigned;
  final int contacted;
  final int converted;

  LeadStatusData({
    required this.employee,
    required this.assigned,
    required this.contacted,
    required this.converted,
  });

  double get conversionRate => assigned > 0 ? (converted / assigned * 100) : 0;

  double get contactRate => assigned > 0 ? (contacted / assigned * 100) : 0;
}

// CONTROLLER - Enhanced for large datasets
class LeadHandlingController extends GetxController {
  var isLoading = true.obs;
  var allLeadStatusData = <LeadStatusData>[].obs; // Full dataset
  var filteredData = <LeadStatusData>[].obs; // Filtered dataset
  var displayData = <LeadStatusData>[].obs; // Paginated data for display

  var dateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  // Pagination
  var currentPage = 0.obs;
  var itemsPerPage = 10.obs;
  var totalPages = 0.obs;

  // Filters and sorting
  var selectedFilter = 'all'.obs;
  var selectedPositions = <String>[].obs;
  var sortBy = 'conversion'.obs;
  var searchQuery = ''.obs;

  // Department grouping
  var showByDepartment = false.obs;
  var departmentStats = <String, Map<String, dynamic>>{}.obs;

  // Performance categories
  var performanceCategories = <String, List<LeadStatusData>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeadStatusData();
  }

  Future<void> fetchLeadStatusData() async {
    isLoading.value = true;

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real implementation, you would fetch data from your API with pagination
      // For example: GET /api/lead-status?page=${currentPage}&limit=${itemsPerPage}

      // For this example, generate 150 random employees
      allLeadStatusData.value = generateMockEmployees(150);

      // Process data
      applyFilters();
      calculatePerformanceCategories();
      calculateDepartmentStats();
    } catch (e) {
      print('Error fetching lead status data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Generate mock data for demonstration
  List<LeadStatusData> generateMockEmployees(int count) {
    List<LeadStatusData> employees = [];
    List<String> positions = [
      'Sales Manager',
      'Senior Sales Rep',
      'Sales Rep',
      'Junior Sales Rep',
      'Lead Generation Specialist',
      'Account Manager'
    ];

    for (int i = 0; i < count; i++) {
      int assigned = 20 + (80 * (i % 5) / 4).round();
      double contactFactor = 0.7 + (0.29 * (i % 7) / 6);
      double conversionFactor = 0.3 + (0.5 * (i % 9) / 8);

      int contacted = (assigned * contactFactor).round();
      int converted = (contacted * conversionFactor).round();

      employees.add(
        LeadStatusData(
          employee: Employee(
            id: 'EMP$i',
            name: 'Employee ${i + 1}',
            position: positions[i % positions.length],
            avatarUrl: 'https://i.pravatar.cc/150?img=${(i % 70) + 1}',
          ),
          assigned: assigned,
          contacted: contacted,
          converted: converted,
        ),
      );
    }

    return employees;
  }

  void onDateRangeSelected(DateTimeRange? range) {
    if (range != null) {
      dateRange.value = range;
      fetchLeadStatusData();
    }
  }

  void setSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void togglePosition(String position) {
    if (selectedPositions.contains(position)) {
      selectedPositions.remove(position);
    } else {
      selectedPositions.add(position);
    }
    applyFilters();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    applyFilters();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    applyFilters();
  }

  void setItemsPerPage(int count) {
    itemsPerPage.value = count;
    applyFilters();
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages.value) {
      currentPage.value = page;
      updateDisplayData();
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      currentPage.value++;
      updateDisplayData();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      updateDisplayData();
    }
  }

  void toggleDepartmentView() {
    showByDepartment.value = !showByDepartment.value;
    calculateDepartmentStats();
  }

  void applyFilters() {
    // Start with all data
    List<LeadStatusData> result = List.from(allLeadStatusData);

    // Apply search filter if any
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((data) =>
              data.employee.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              data.employee.position
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Apply position filter if any
    if (selectedPositions.isNotEmpty) {
      result = result
          .where((data) => selectedPositions.contains(data.employee.position))
          .toList();
    }

    // Apply performance filters
    switch (selectedFilter.value) {
      case 'highPerformers':
        result = result.where((data) => data.conversionRate > 50).toList();
        break;
      case 'lowContact':
        result = result.where((data) => data.contactRate < 80).toList();
        break;
      case 'newLeads':
        result = result.where((data) => data.assigned > 30).toList();
        break;
    }

    // Apply sorting
    switch (sortBy.value) {
      case 'conversion':
        result.sort((a, b) => b.conversionRate.compareTo(a.conversionRate));
        break;
      case 'assigned':
        result.sort((a, b) => b.assigned.compareTo(a.assigned));
        break;
      case 'contacted':
        result.sort((a, b) => b.contactRate.compareTo(a.contactRate));
        break;
      case 'name':
        result.sort((a, b) => a.employee.name.compareTo(b.employee.name));
        break;
    }

    // Update the filtered list
    filteredData.value = result;

    // Calculate total pages
    totalPages.value = (filteredData.length / itemsPerPage.value).ceil();
    if (totalPages.value == 0) totalPages.value = 1;

    // Ensure current page is valid
    if (currentPage.value >= totalPages.value) {
      currentPage.value = totalPages.value - 1;
    }

    // Update the display list
    updateDisplayData();
  }

  void updateDisplayData() {
    int start = currentPage.value * itemsPerPage.value;
    int end = start + itemsPerPage.value;

    if (end > filteredData.length) {
      end = filteredData.length;
    }

    if (start < filteredData.length) {
      displayData.value = filteredData.sublist(start, end);
    } else {
      displayData.value = [];
    }
  }

  void calculatePerformanceCategories() {
    Map<String, List<LeadStatusData>> categories = {
      'Top Performers': [],
      'Average Performers': [],
      'Underperformers': [],
    };

    for (var data in allLeadStatusData) {
      if (data.conversionRate > 55) {
        categories['Top Performers']!.add(data);
      } else if (data.conversionRate > 35) {
        categories['Average Performers']!.add(data);
      } else {
        categories['Underperformers']!.add(data);
      }
    }

    performanceCategories.value = categories;
  }

  void calculateDepartmentStats() {
    Map<String, List<LeadStatusData>> departments = {};

    // Group by position (department)
    for (var data in filteredData) {
      if (!departments.containsKey(data.employee.position)) {
        departments[data.employee.position] = [];
      }
      departments[data.employee.position]!.add(data);
    }

    // Calculate stats for each department
    Map<String, Map<String, dynamic>> stats = {};

    departments.forEach((department, employees) {
      int totalAssigned = 0;
      int totalContacted = 0;
      int totalConverted = 0;

      for (var emp in employees) {
        totalAssigned += emp.assigned;
        totalContacted += emp.contacted;
        totalConverted += emp.converted;
      }

      double contactRate =
          totalAssigned > 0 ? (totalContacted / totalAssigned * 100) : 0;

      double conversionRate =
          totalAssigned > 0 ? (totalConverted / totalAssigned * 100) : 0;

      stats[department] = {
        'employeeCount': employees.length,
        'totalAssigned': totalAssigned,
        'totalContacted': totalContacted,
        'totalConverted': totalConverted,
        'contactRate': contactRate,
        'conversionRate': conversionRate,
      };
    });

    departmentStats.value = stats;
  }
}

// VIEW
class LeadHandlingStatusReport extends StatelessWidget {
  LeadHandlingStatusReport({Key? key}) : super(key: key);

  final LeadHandlingController controller = Get.put(LeadHandlingController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Lead Handling Status',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context),
      onDateRangeSelected: controller.onDateRangeSelected,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildToggleView(),
            const SizedBox(height: 16),
            controller.showByDepartment.value
                ? _buildDepartmentView()
                : _buildPerformanceChart(),
            const SizedBox(height: 24),
            _buildSearchAndPagination(),
            const SizedBox(height: 16),
            _buildEmployeeList(),
            const SizedBox(height: 16),
            _buildPaginationControls(),
          ],
        );
      }),
    );
  }

  Widget _buildToggleView() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'View Mode:',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Obx(() => ToggleButtons(
              isSelected: [
                !controller.showByDepartment.value,
                controller.showByDepartment.value
              ],
              onPressed: (index) {
                if (index == 0) {
                  controller.showByDepartment.value = false;
                } else {
                  controller.showByDepartment.value = true;
                }
              },
              borderRadius: BorderRadius.circular(8),
              selectedBorderColor: Colors.blue,
              selectedColor: Colors.blue,
              fillColor: Colors.blue.shade50,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Performance',
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Department',
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildSummaryCards() {
    // Calculate totals
    int totalAssigned = 0;
    int totalContacted = 0;
    int totalConverted = 0;

    for (var data in controller.allLeadStatusData) {
      totalAssigned += data.assigned;
      totalContacted += data.contacted;
      totalConverted += data.converted;
    }

    double overallConversionRate =
        totalAssigned > 0 ? (totalConverted / totalAssigned * 100) : 0;
    double contactRate =
        totalAssigned > 0 ? (totalContacted / totalAssigned * 100) : 0;

    return Column(
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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                'Total Team',
                controller.allLeadStatusData.length.toString(),
                Icons.people,
                Colors.indigo.shade100,
                Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                'Total Assigned',
                totalAssigned.toString(),
                Icons.assignment,
                Colors.blue.shade100,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                'Total Contacted',
                totalContacted.toString(),
                Icons.contact_phone,
                Colors.orange.shade100,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                'Total Converted',
                totalConverted.toString(),
                Icons.check_circle,
                Colors.green.shade100,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                'Contact Rate',
                '${contactRate.toStringAsFixed(1)}%',
                Icons.call_made,
                Colors.amber.shade100,
                Colors.amber.shade800,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                'Conversion Rate',
                '${overallConversionRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                Colors.purple.shade100,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Categories',
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
              child: _buildCategoryCard(
                'Top Performers',
                controller.performanceCategories['Top Performers']?.length ?? 0,
                Colors.green.shade400,
                Icons.emoji_events,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                'Average',
                controller
                        .performanceCategories['Average Performers']?.length ??
                    0,
                Colors.blue.shade400,
                Icons.thumbs_up_down,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                'Underperformers',
                controller.performanceCategories['Underperformers']?.length ??
                    0,
                Colors.orange.shade400,
                Icons.signal_cellular_alt_1_bar,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          height: 200,
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
          child: _buildAggregatedPerformanceChart(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _chartLegendItem('Contact Rate', Colors.orange),
            const SizedBox(width: 24),
            _chartLegendItem('Conversion Rate', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAggregatedPerformanceChart() {
    // Create sample data for the grouped bar chart
    // In a real app, you would aggregate this from your actual data
    List<Map<String, dynamic>> groups = [
      {
        'group': 'Top',
        'contactRate': 92.5,
        'conversionRate': 67.2,
      },
      {
        'group': 'Average',
        'contactRate': 84.6,
        'conversionRate': 43.8,
      },
      {
        'group': 'Under',
        'contactRate': 73.1,
        'conversionRate': 28.4,
      },
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label;
              switch (rodIndex) {
                case 0:
                  label = 'Contact Rate';
                  break;
                case 1:
                  label = 'Conversion Rate';
                  break;
                default:
                  label = '';
              }
              return BarTooltipItem(
                '$label: ${rod.toY.toStringAsFixed(1)}%',
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
                if (value >= 0 && value < groups.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      groups[value.toInt()]['group'],
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value % 20 == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${value.toInt()}%',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          groups.length,
          (index) {
            final data = groups[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data['contactRate'],
                  color: Colors.orange,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                BarChartRodData(
                  toY: data['conversionRate'],
                  color: Colors.green,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department Performance',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.departmentStats.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              String department =
                  controller.departmentStats.keys.elementAt(index);
              Map<String, dynamic> stats =
                  controller.departmentStats[department]!;

              return ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  department,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${stats['employeeCount']} employees · ${stats['conversionRate'].toStringAsFixed(1)}% conversion',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                trailing: Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${stats['totalConverted']}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _departmentStatItem(
                            'Assigned',
                            stats['totalAssigned'].toString(),
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _departmentStatItem(
                            'Contacted',
                            stats['totalContacted'].toString(),
                            Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: _departmentStatItem(
                            'Converted',
                            stats['totalConverted'].toString(),
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: LinearProgressIndicator(
                            value: stats['contactRate'] / 100,
                            backgroundColor: Colors.orange.shade100,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${stats['contactRate'].toStringAsFixed(1)}% Contact',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: LinearProgressIndicator(
                            value: stats['conversionRate'] / 100,
                            backgroundColor: Colors.green.shade100,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${stats['conversionRate'].toStringAsFixed(1)}% Conversion',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _departmentStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _chartLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndPagination() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => controller.setSearch(value),
              decoration: InputDecoration(
                hintText: 'Search employees...',
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        DropdownButton<int>(
          value: controller.itemsPerPage.value,
          hint: Text('Items', style: GoogleFonts.montserrat(fontSize: 12)),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
          underline: Container(),
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.black87,
          ),
          items: [10, 20, 50, 100].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value items'),
            );
          }).toList(),
          onChanged: (int? value) {
            if (value != null) controller.setItemsPerPage(value);
          },
        ),
      ],
    );
  }

  Widget _buildEmployeeList() {
    if (controller.displayData.isEmpty) {
      return Container(
        height: 200,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Text(
                'No employees match your search',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 52), // Avatar spacing
                Expanded(
                  flex: 2,
                  child: _tableHeader('Employee'),
                ),
                Expanded(
                  flex: 1,
                  child: _tableHeader('Assigned'),
                ),
                Expanded(
                  flex: 1,
                  child: _tableHeader('Contacted'),
                ),
                Expanded(
                  flex: 1,
                  child: _tableHeader('Converted'),
                ),
                Expanded(
                  flex: 1,
                  child: _tableHeader('Rate'),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.displayData.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final data = controller.displayData[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(data.employee.avatarUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.employee.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            data.employee.position,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data.assigned.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data.contacted.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data.converted.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRateIndicator(data.conversionRate),
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

  Widget _tableHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _buildRateIndicator(double rate) {
    Color color;
    String label;

    if (rate >= 50) {
      color = Colors.green;
      label = 'High';
    } else if (rate >= 30) {
      color = Colors.amber;
      label = 'Mid';
    } else {
      color = Colors.red;
      label = 'Low';
    }

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${rate.toStringAsFixed(1)}%',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          // 'Showing ${controller.currentPage.value * controller.itemsPerPage.value + 1} to ${(controller.currentPage.value * controller.itemsPerPage.value) + controller.displayData.length} of ${controller.filteredData.length} entries',
          '',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.grey.shade600),
              onPressed: controller.currentPage.value > 0
                  ? () => controller.previousPage()
                  : null,
              splashRadius: 20,
            ),
            ...List.generate(controller.totalPages.value, (index) {
              return InkWell(
                onTap: () => controller.goToPage(index),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index
                        ? Colors.blue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: controller.currentPage.value == index
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }).take(5).toList(),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.grey.shade600),
              onPressed:
                  controller.currentPage.value < controller.totalPages.value - 1
                      ? () => controller.nextPage()
                      : null,
              splashRadius: 20,
            ),
          ],
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
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
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 16),
            Text(
              'Performance Filters',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    _buildFilterOption(
                      'All Employees',
                      'all',
                      controller.selectedFilter.value,
                      () {
                        controller.setFilter('all');
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      'High Performers (>50% conversion)',
                      'highPerformers',
                      controller.selectedFilter.value,
                      () {
                        controller.setFilter('highPerformers');
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      'Low Contact Rate (<80%)',
                      'lowContact',
                      controller.selectedFilter.value,
                      () {
                        controller.setFilter('lowContact');
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      'High Lead Assignment (>30)',
                      'newLeads',
                      controller.selectedFilter.value,
                      () {
                        controller.setFilter('newLeads');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 24),
            Text(
              'Sort By',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    _buildFilterOption(
                      'Conversion Rate (Default)',
                      'conversion',
                      controller.sortBy.value,
                      () {
                        controller.setSortBy('conversion');
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      'Assigned Leads',
                      'assigned',
                      controller.sortBy.value,
                      () {
                        controller.setSortBy('assigned');
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      'Contact Rate',
                      'contacted',
                      controller.sortBy.value,
                      () {
                        controller.setSortBy('contacted');
                        Navigator.pop(context);
                      },
                    ),
                    _buildFilterOption(
                      'Name',
                      'name',
                      controller.sortBy.value,
                      () {
                        controller.setSortBy('name');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
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
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    String label,
    String value,
    String selectedValue,
    VoidCallback onTap,
  ) {
    final isSelected = selectedValue == value;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: isSelected ? Colors.blue : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
