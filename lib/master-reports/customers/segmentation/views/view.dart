import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../widgets/page_wrapper.dart';

// Controller for Customer Segmentation
class CustomerSegmentationController extends GetxController {
  final RxString selectedSegment = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> segments = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> customers = <Map<String, dynamic>>[].obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxList<Map<String, dynamic>> filteredCustomers =
      <Map<String, dynamic>>[].obs;

  // Filter parameters
  final RxBool showActiveOnly = false.obs;
  final RxString sortBy = 'Recent Activity'.obs;
  final RxList<String> selectedTags = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSegments();
    loadCustomers();
  }

  // Update date range and refresh data
  void updateDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    applyFilters();
  }

  // Load segmentation data
  Future<void> loadSegments() async {
    isLoading.value = true;
    try {
      // Simulating API call
      await Future.delayed(const Duration(milliseconds: 800));

      segments.value = [
        {
          'id': 'high_value',
          'name': 'High Value',
          'count': 145,
          'color': const Color(0xFF4CAF50),
          'growth': 12.5,
          'avgValue': 5200,
          'description': 'Customers with high spending and frequent purchases',
          'icon': 'assets/icons/diamond.svg'
        },
        {
          'id': 'regular',
          'name': 'Regular',
          'count': 287,
          'color': const Color(0xFF2196F3),
          'growth': 8.3,
          'avgValue': 2100,
          'description': 'Consistent customers with moderate spending',
          'icon': 'assets/icons/user_check.svg'
        },
        {
          'id': 'new',
          'name': 'New',
          'count': 94,
          'color': const Color(0xFFFFC107),
          'growth': 23.7,
          'avgValue': 1200,
          'description': 'Customers acquired in the last 30 days',
          'icon': 'assets/icons/user_plus.svg'
        },
        {
          'id': 'at_risk',
          'name': 'At Risk',
          'count': 63,
          'color': const Color(0xFFFF5722),
          'growth': -5.2,
          'avgValue': 1800,
          'description': 'Customers showing decreased engagement',
          'icon': 'assets/icons/alert_triangle.svg'
        },
        {
          'id': 'inactive',
          'name': 'Inactive',
          'count': 118,
          'color': const Color(0xFF9E9E9E),
          'growth': -2.8,
          'avgValue': 950,
          'description': 'No activity in the past 90 days',
          'icon': 'assets/icons/user_x.svg'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load segment data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Load customer data
  Future<void> loadCustomers() async {
    isLoading.value = true;
    try {
      // Simulating API call
      await Future.delayed(const Duration(milliseconds: 1200));

      // Sample customer data
      customers.value = List.generate(50, (index) {
        final segments = [
          'High Value',
          'Regular',
          'New',
          'At Risk',
          'Inactive'
        ];
        final segmentIndex = index % segments.length;

        return {
          'id': 'CUST${1000 + index}',
          'name': 'Customer ${1000 + index}',
          'email': 'customer${1000 + index}@example.com',
          'segment': segments[segmentIndex],
          'status': index % 7 == 0 ? 'Inactive' : 'Active',
          'value': 1000 + (index * 100) % 5000,
          'lastActivity': DateTime.now().subtract(Duration(days: index % 60)),
          'engagementScore': 0.3 + (index % 7) / 10,
          'tags': _generateRandomTags(),
        };
      });

      applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load customer data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Apply filters to customer list
  void applyFilters() {
    // Start with all customers
    List<Map<String, dynamic>> result = List.from(customers);

    // Apply date filter if selected
    if (selectedDateRange.value != null) {
      result = result.where((customer) {
        final activity = customer['lastActivity'] as DateTime;
        return activity.isAfter(selectedDateRange.value!.start) &&
            activity.isBefore(
                selectedDateRange.value!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply segment filter
    if (selectedSegment.value != 'All') {
      result = result
          .where((customer) => customer['segment'] == selectedSegment.value)
          .toList();
    }

    // Apply active/inactive filter
    if (showActiveOnly.value) {
      result =
          result.where((customer) => customer['status'] == 'Active').toList();
    }

    // Apply tag filters
    if (selectedTags.isNotEmpty) {
      result = result.where((customer) {
        final customerTags = customer['tags'] as List<String>;
        return selectedTags.any((tag) => customerTags.contains(tag));
      }).toList();
    }

    // Apply sorting
    if (sortBy.value == 'Recent Activity') {
      result.sort((a, b) => (b['lastActivity'] as DateTime)
          .compareTo(a['lastActivity'] as DateTime));
    } else if (sortBy.value == 'Customer Value') {
      result.sort((a, b) => (b['value'] as num).compareTo(a['value'] as num));
    } else if (sortBy.value == 'Engagement Score') {
      result.sort((a, b) =>
          (b['engagementScore'] as num).compareTo(a['engagementScore'] as num));
    }

    filteredCustomers.value = result;
  }

  // Helper to generate random tags
  List<String> _generateRandomTags() {
    final allTags = [
      'Enterprise',
      'SMB',
      'Startup',
      'Retail',
      'E-commerce',
      'B2B',
      'B2C',
      'Healthcare',
      'Technology',
      'Finance',
      'Subscriber',
      'Trial',
      'Referral'
    ];

    final tagCount = 1 + (DateTime.now().millisecond % 3);
    final selectedIndexes = List.generate(
            tagCount, (_) => DateTime.now().microsecond % allTags.length)
        .toSet()
        .toList();

    return selectedIndexes.map((index) => allTags[index]).toList();
  }

  // Get available tags from all customers
  List<String> getAllTags() {
    final Set<String> tags = {};
    for (final customer in customers) {
      final customerTags = customer['tags'] as List<String>;
      tags.addAll(customerTags);
    }
    return tags.toList()..sort();
  }

  // Change segment selection
  void changeSegment(String segmentName) {
    selectedSegment.value = segmentName;
    applyFilters();
  }

  // Toggle showing active customers only
  void toggleActiveOnly(bool value) {
    showActiveOnly.value = value;
    applyFilters();
  }

  // Change sorting method
  void changeSortBy(String value) {
    sortBy.value = value;
    applyFilters();
  }

  // Toggle a tag selection
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    applyFilters();
  }

  // Get segment distribution for pie chart
  List<PieChartSectionData> getSegmentDistribution() {
    final Map<String, int> counts = {};
    for (var segment in segments) {
      counts[segment['name']] = segment['count'];
    }

    double total = counts.values.fold(0, (prev, count) => prev + count);

    return segments.map((segment) {
      final name = segment['name'];
      final count = segment['count'];
      final color = segment['color'];

      return PieChartSectionData(
        color: color,
        value: count.toDouble(),
        title: '${(count / total * 100).toStringAsFixed(1)}%',
        radius: selectedSegment.value == name ? 60 : 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

// Customer Segmentation Page using your PageWrapper
class CustomerSegmentationPage extends StatelessWidget {
  const CustomerSegmentationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerSegmentationController());

    return ReportPageWrapper(
      title: 'Customer Segmentation',
      showFilterIcon: true,
      onFilterTap: () => _showFilterBottomSheet(context),
      onDateRangeSelected: (dateRange) {
        controller.updateDateRange(dateRange);
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SegmentOverviewSection(),
          const SizedBox(height: 24),
          const SegmentDistributionChart(),
          const SizedBox(height: 24),
          const SegmentSelectionRow(),
          const SizedBox(height: 16),
          const SegmentDetailCard(),
          const SizedBox(height: 24),
          _buildSectionHeading('Customer List'),
          const SizedBox(height: 16),
          const CustomerListView(),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final controller = Get.find<CustomerSegmentationController>();

    CustomFilterModal.show(
      context,
      filterWidgets: [
        // Status filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => SwitchListTile(
                    title: const Text('Active customers only'),
                    value: controller.showActiveOnly.value,
                    onChanged: controller.toggleActiveOnly,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  )),
            ],
          ),
        ),
        const Divider(),

        // Sort options
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Column(
                    children: [
                      _buildSortOption(controller, 'Recent Activity'),
                      _buildSortOption(controller, 'Customer Value'),
                      _buildSortOption(controller, 'Engagement Score'),
                    ],
                  )),
            ],
          ),
        ),
        const Divider(),

        // Tag filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tags',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.getAllTags().map((tag) {
                      final isSelected = controller.selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (_) => controller.toggleTag(tag),
                      );
                    }).toList(),
                  )),
            ],
          ),
        ),

        // Apply button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Apply Filters',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortOption(
      CustomerSegmentationController controller, String option) {
    return RadioListTile<String>(
      title: Text(option),
      value: option,
      groupValue: controller.sortBy.value,
      onChanged: (value) => controller.changeSortBy(value!),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// Segment Overview Section Widget
class SegmentOverviewSection extends StatelessWidget {
  const SegmentOverviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerSegmentationController>();

    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.segments.length,
                itemBuilder: (context, index) {
                  final segment = controller.segments[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                segment['name'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: segment['color'].withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIconData(segment['name']),
                                  color: segment['color'],
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            segment['count'].toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                segment['growth'] >= 0
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: segment['growth'] >= 0
                                    ? Colors.green
                                    : Colors.red,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${segment['growth'].abs().toStringAsFixed(1)}%',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: segment['growth'] >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  IconData _getIconData(String segmentName) {
    switch (segmentName) {
      case 'High Value':
        return Icons.diamond_outlined;
      case 'Regular':
        return Icons.person_outline;
      case 'New':
        return Icons.person_add_outlined;
      case 'At Risk':
        return Icons.warning_amber_outlined;
      case 'Inactive':
        return Icons.person_off_outlined;
      default:
        return Icons.people_outlined;
    }
  }
}

// Segment Distribution Chart Widget
class SegmentDistributionChart extends StatelessWidget {
  const SegmentDistributionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerSegmentationController>();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Segment Distribution',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: controller.getSegmentDistribution(),
                              pieTouchData: PieTouchData(
                                touchCallback: (_, pieTouchResponse) {
                                  if (pieTouchResponse != null &&
                                      pieTouchResponse.touchedSection != null) {
                                    final touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                    if (touchedIndex >= 0 &&
                                        touchedIndex <
                                            controller.segments.length) {
                                      controller.changeSegment(controller
                                          .segments[touchedIndex]['name']);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.segments.map((segment) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: segment['color'],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    segment['name'],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Segment Selection Row Widget
class SegmentSelectionRow extends StatelessWidget {
  const SegmentSelectionRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerSegmentationController>();

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSegmentChip('All', null, controller),
              ...controller.segments.map((segment) => _buildSegmentChip(
                  segment['name'], segment['color'], controller)),
            ],
          ),
        ));
  }

  Widget _buildSegmentChip(
      String name, Color? color, CustomerSegmentationController controller) {
    final isSelected = controller.selectedSegment.value == name;

    return GestureDetector(
      onTap: () => controller.changeSegment(name),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? Colors.blue.shade700)
              : (color?.withOpacity(0.1) ?? Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? Colors.blue.shade700)
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          name,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : (color ?? Colors.black87),
          ),
        ),
      ),
    );
  }
}

// Segment Detail Card Widget
class SegmentDetailCard extends StatelessWidget {
  const SegmentDetailCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerSegmentationController>();

    return Obx(() {
      // If 'All' is selected, don't show the detail card
      if (controller.selectedSegment.value == 'All') {
        return const SizedBox.shrink();
      }

      // Find the selected segment
      final selectedSegmentData = controller.segments.firstWhere(
        (segment) => segment['name'] == controller.selectedSegment.value,
        orElse: () => controller.segments.first,
      );

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: (selectedSegmentData['color'] as Color).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (selectedSegmentData['color'] as Color)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconData(selectedSegmentData['name']),
                    color: selectedSegmentData['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedSegmentData['name'],
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedSegmentData['description'],
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  'Total Customers',
                  '${selectedSegmentData['count']}',
                  Icons.people_outline,
                ),
                _buildStatColumn(
                  'Avg. Value',
                  '\$${selectedSegmentData['avgValue']}',
                  Icons.attach_money,
                ),
                _buildStatColumn(
                  'Growth',
                  '${selectedSegmentData['growth']}%',
                  selectedSegmentData['growth'] >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  textColor: selectedSegmentData['growth'] >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Recommended Actions',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildActionItem(
              selectedSegmentData['name'],
              selectedSegmentData['color'],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatColumn(String label, String value, IconData icon,
      {Color? textColor}) {
    return Column(
      children: [
        Icon(
          icon,
          color: textColor ?? Colors.grey.shade700,
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(String segmentName, Color color) {
    String actionText;
    IconData actionIcon;

    switch (segmentName) {
      case 'High Value':
        actionText = 'Send exclusive offers to maintain loyalty';
        actionIcon = Icons.star_outline;
        break;
      case 'Regular':
        actionText = 'Incentivize higher spending with targeted promotions';
        actionIcon = Icons.trending_up;
        break;
      case 'New':
        actionText = 'Onboard them with welcome campaigns';
        actionIcon = Icons.celebration_outlined;
        break;
      case 'At Risk':
        actionText = 'Re-engage with personalized outreach';
        actionIcon = Icons.assignment_return_outlined;
        break;
      case 'Inactive':
        actionText = 'Run win-back campaigns with special incentives';
        actionIcon = Icons.restore_outlined;
        break;
      default:
        actionText = 'Create targeted marketing campaign';
        actionIcon = Icons.campaign_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            actionIcon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              actionText,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              size: 18,
            ),
            onPressed: () {},
            color: color,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String segmentName) {
    switch (segmentName) {
      case 'High Value':
        return Icons.diamond_outlined;
      case 'Regular':
        return Icons.person_outline;
      case 'New':
        return Icons.person_add_outlined;
      case 'At Risk':
        return Icons.warning_amber_outlined;
      case 'Inactive':
        return Icons.person_off_outlined;
      default:
        return Icons.people_outlined;
    }
  }
}

// Customer List View Widget
class CustomerListView extends StatelessWidget {
  const CustomerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerSegmentationController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredCustomers.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No customers found with the current filters',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  controller.selectedSegment.value = 'All';
                  controller.selectedTags.clear();
                  controller.showActiveOnly.value = false;
                  controller.selectedDateRange.value = null;
                  controller.applyFilters();
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: min(controller.filteredCustomers.length, 10),
        itemBuilder: (context, index) {
          final customer = controller.filteredCustomers[index];
          final tags = customer['tags'] as List<String>;

          // Get color for segment
          final segmentData = controller.segments.firstWhere(
            (segment) => segment['name'] == customer['segment'],
            orElse: () => {'color': Colors.grey},
          );
          final segmentColor = segmentData['color'] as Color;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer initial avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: segmentColor.withOpacity(0.2),
                    child: Text(
                      customer['name'].toString().substring(0, 1),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: segmentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Customer details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              customer['name'],
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: segmentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                customer['segment'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: segmentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer['email'],
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Customer value and engagement
                        Row(
                          children: [
                            _buildMetricItem(
                              'Value',
                              '\$${customer['value']}',
                              Icons.attach_money,
                            ),
                            const SizedBox(width: 16),
                            _buildMetricItem(
                              'Engagement',
                              '${(customer['engagementScore'] * 100).toStringAsFixed(0)}%',
                              Icons.trending_up,
                            ),
                            const SizedBox(width: 16),
                            _buildMetricItem(
                              'Last Active',
                              _formatDate(customer['lastActivity']),
                              Icons.calendar_today_outlined,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Tags
                        if (tags.isNotEmpty)
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mail_outline),
                        onPressed: () {},
                        color: Colors.blue.shade700,
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                        color: Colors.grey.shade700,
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}

// Custom Filter Modal
class CustomFilterModal {
  static void show(
    BuildContext context, {
    required List<Widget> filterWidgets,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Customers',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final controller =
                              Get.find<CustomerSegmentationController>();
                          controller.selectedSegment.value = 'All';
                          controller.selectedTags.clear();
                          controller.showActiveOnly.value = false;
                          controller.selectedDateRange.value = null;
                          controller.applyFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: filterWidgets,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
