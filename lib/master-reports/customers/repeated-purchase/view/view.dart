import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../widgets/page_wrapper.dart';

class RepeatedPurchaseController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<CustomerPurchaseModel> customers = <CustomerPurchaseModel>[].obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxList<String> selectedCategories = <String>[].obs;
  final RxString selectedFrequency = 'Monthly'.obs;

  final List<String> frequencies = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Food',
    'Services',
    'Software'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void onDateRangeChanged(DateTimeRange? range) {
    selectedDateRange.value = range;
    fetchData();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    fetchData();
  }

  void setFrequency(String frequency) {
    selectedFrequency.value = frequency;
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data - would be replaced with actual API data
    customers.value = [
      CustomerPurchaseModel(
        id: '1',
        name: 'John Smith',
        email: 'john@example.com',
        totalPurchases: 12,
        lastPurchaseDate: DateTime.now().subtract(const Duration(days: 5)),
        purchaseFrequency: 'Monthly',
        averageSpend: 249.99,
        categories: ['Electronics', 'Software'],
        purchaseHistory: List.generate(
          12,
          (index) => PurchaseModel(
            date: DateTime.now().subtract(Duration(days: index * 30)),
            amount: 200 + (index % 5) * 20,
            category: index % 2 == 0 ? 'Electronics' : 'Software',
          ),
        ),
      ),
      CustomerPurchaseModel(
        id: '2',
        name: 'Sarah Johnson',
        email: 'sarah@example.com',
        totalPurchases: 8,
        lastPurchaseDate: DateTime.now().subtract(const Duration(days: 12)),
        purchaseFrequency: 'Quarterly',
        averageSpend: 399.50,
        categories: ['Clothing', 'Services'],
        purchaseHistory: List.generate(
          8,
          (index) => PurchaseModel(
            date: DateTime.now().subtract(Duration(days: index * 45)),
            amount: 350 + (index % 3) * 50,
            category: index % 2 == 0 ? 'Clothing' : 'Services',
          ),
        ),
      ),
      CustomerPurchaseModel(
        id: '3',
        name: 'Robert Chen',
        email: 'robert@example.com',
        totalPurchases: 24,
        lastPurchaseDate: DateTime.now().subtract(const Duration(days: 2)),
        purchaseFrequency: 'Weekly',
        averageSpend: 89.95,
        categories: ['Food', 'Services'],
        purchaseHistory: List.generate(
          24,
          (index) => PurchaseModel(
            date: DateTime.now().subtract(Duration(days: index * 7)),
            amount: 75 + (index % 4) * 15,
            category: index % 2 == 0 ? 'Food' : 'Services',
          ),
        ),
      ),
      CustomerPurchaseModel(
        id: '4',
        name: 'Emily Davis',
        email: 'emily@example.com',
        totalPurchases: 5,
        lastPurchaseDate: DateTime.now().subtract(const Duration(days: 60)),
        purchaseFrequency: 'Yearly',
        averageSpend: 899.99,
        categories: ['Electronics', 'Software'],
        purchaseHistory: List.generate(
          5,
          (index) => PurchaseModel(
            date: DateTime.now().subtract(Duration(days: index * 120)),
            amount: 800 + (index % 3) * 100,
            category: index % 2 == 0 ? 'Electronics' : 'Software',
          ),
        ),
      ),
      CustomerPurchaseModel(
        id: '5',
        name: 'Michael Wilson',
        email: 'michael@example.com',
        totalPurchases: 16,
        lastPurchaseDate: DateTime.now().subtract(const Duration(days: 8)),
        purchaseFrequency: 'Monthly',
        averageSpend: 149.50,
        categories: ['Clothing', 'Food'],
        purchaseHistory: List.generate(
          16,
          (index) => PurchaseModel(
            date: DateTime.now().subtract(Duration(days: index * 25)),
            amount: 120 + (index % 6) * 10,
            category: index % 2 == 0 ? 'Clothing' : 'Food',
          ),
        ),
      ),
    ];

    // Filter by date range if selected
    if (selectedDateRange.value != null) {
      customers.value = customers.where((customer) {
        return customer.lastPurchaseDate
                .isAfter(selectedDateRange.value!.start) &&
            customer.lastPurchaseDate.isBefore(selectedDateRange.value!.end);
      }).toList();
    }

    // Filter by categories if any selected
    if (selectedCategories.isNotEmpty) {
      customers.value = customers.where((customer) {
        return customer.categories
            .any((category) => selectedCategories.contains(category));
      }).toList();
    }

    // Filter by frequency
    if (selectedFrequency.value != 'All') {
      customers.value = customers
          .where((customer) =>
              customer.purchaseFrequency == selectedFrequency.value)
          .toList();
    }

    isLoading.value = false;
  }

  // Analytics methods
  List<PurchaseModel> getAllPurchases() {
    List<PurchaseModel> allPurchases = [];
    for (var customer in customers) {
      allPurchases.addAll(customer.purchaseHistory);
    }
    return allPurchases;
  }

  Map<String, double> getCategoryDistribution() {
    Map<String, double> distribution = {};

    for (var purchase in getAllPurchases()) {
      if (distribution.containsKey(purchase.category)) {
        distribution[purchase.category] =
            distribution[purchase.category]! + purchase.amount;
      } else {
        distribution[purchase.category] = purchase.amount;
      }
    }

    return distribution;
  }

  List<MapEntry<DateTime, double>> getPurchaseTimeline() {
    Map<DateTime, double> timeline = {};

    for (var purchase in getAllPurchases()) {
      // Normalize date to just year and month
      DateTime normalizedDate =
          DateTime(purchase.date.year, purchase.date.month);

      if (timeline.containsKey(normalizedDate)) {
        timeline[normalizedDate] = timeline[normalizedDate]! + purchase.amount;
      } else {
        timeline[normalizedDate] = purchase.amount;
      }
    }

    var entries = timeline.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return entries;
  }
}

class PurchaseModel {
  final DateTime date;
  final double amount;
  final String category;

  PurchaseModel({
    required this.date,
    required this.amount,
    required this.category,
  });
}

class CustomerPurchaseModel {
  final String id;
  final String name;
  final String email;
  final int totalPurchases;
  final DateTime lastPurchaseDate;
  final String purchaseFrequency;
  final double averageSpend;
  final List<String> categories;
  final List<PurchaseModel> purchaseHistory;

  CustomerPurchaseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPurchases,
    required this.lastPurchaseDate,
    required this.purchaseFrequency,
    required this.averageSpend,
    required this.categories,
    required this.purchaseHistory,
  });
}

class RepeatedPurchasePatternsPage extends StatelessWidget {
  const RepeatedPurchasePatternsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RepeatedPurchaseController());

    return ReportPageWrapper(
      title: 'Repeated Purchase Patterns',
      onDateRangeSelected: controller.onDateRangeChanged,
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context, controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.customers.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(controller),
            const SizedBox(height: 24),
            _buildPurchaseTimeline(controller),
            const SizedBox(height: 24),
            _buildCategoryDistribution(controller),
            const SizedBox(height: 24),
            _buildCustomerList(controller),
            const SizedBox(height: 24),
            // RetentionStrategyRecommendation(controller: controller),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No purchase patterns found',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or date range',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(RepeatedPurchaseController controller) {
    final customerCount = controller.customers.length;
    final totalPurchases = controller.customers
        .fold<int>(0, (sum, customer) => sum + customer.totalPurchases);
    final avgSpend = controller.customers
            .fold<double>(0, (sum, customer) => sum + customer.averageSpend) /
        customerCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.people_alt_outlined,
                title: 'Repeat Customers',
                value: customerCount.toString(),
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.shopping_cart_outlined,
                title: 'Total Purchases',
                value: totalPurchases.toString(),
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.attach_money,
                title: 'Avg. Spend',
                value: '\$${avgSpend.toStringAsFixed(2)}',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.calendar_today_outlined,
                title: 'Most Common',
                value: controller.selectedFrequency.value,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  size: 20,
                ),
              ),
              const Spacer(),
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
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseTimeline(RepeatedPurchaseController controller) {
    final timelineData = controller.getPurchaseTimeline();

    if (timelineData.isEmpty) {
      return const SizedBox.shrink();
    }

    final dateFormat = DateFormat('MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchase Frequency Over Time',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monthly purchase volume and value trends',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          padding: const EdgeInsets.all(16),
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
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < 0 ||
                          value.toInt() >= timelineData.length) {
                        return const SizedBox.shrink();
                      }

                      // Only show every other month for readability
                      if (value.toInt() % 2 != 0 && timelineData.length > 6) {
                        return const SizedBox.shrink();
                      }

                      final date = timelineData[value.toInt()].key;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          dateFormat.format(date),
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
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
                          '\$${value.toInt()}',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              minX: 0,
              maxX: timelineData.length - 1.0,
              minY: 0,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    timelineData.length,
                    (index) =>
                        FlSpot(index.toDouble(), timelineData[index].value),
                  ),
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade300,
                      Colors.blue.shade600,
                    ],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade200.withOpacity(0.3),
                        Colors.blue.shade500.withOpacity(0.0),
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
    );
  }

  Widget _buildCategoryDistribution(RepeatedPurchaseController controller) {
    final categoryData = controller.getCategoryDistribution();

    if (categoryData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Prepare data for pie chart
    final categories = categoryData.keys.toList();
    final values = categoryData.values.toList();
    final total = values.fold<double>(0, (sum, value) => sum + value);

    // Colors for pie sections
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchase Category Distribution',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Breakdown of purchases by category',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: List.generate(
                      categories.length,
                      (index) {
                        final percentage =
                            (values[index] / total * 100).toStringAsFixed(1);
                        return PieChartSectionData(
                          color: colors[index % colors.length],
                          value: values[index],
                          title: '$percentage%',
                          radius: 100,
                          titleStyle: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  categories.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                        Text(
                          categories[index],
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerList(RepeatedPurchaseController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Repeat Customers',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Customers with most frequent purchases',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.customers
            .take(5)
            .map((customer) => _buildCustomerCard(customer))
            .toList(),
        const SizedBox(height: 16),
        if (controller.customers.length > 5)
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to full customer list
              },
              child: Text(
                'View All Customers',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCustomerCard(CustomerPurchaseModel customer) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    customer.name.substring(0, 1),
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      customer.email,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  customer.purchaseFrequency,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCustomerStat(
                  title: 'Purchases',
                  value: customer.totalPurchases.toString(),
                ),
              ),
              Expanded(
                child: _buildCustomerStat(
                  title: 'Avg. Spend',
                  value: '\$${customer.averageSpend.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _buildCustomerStat(
                  title: 'Last Purchase',
                  value: dateFormat.format(customer.lastPurchaseDate),
                  isDate: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: customer.categories.map((category) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerStat({
    required String title,
    required String value,
    bool isDate = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: isDate ? 11 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showFilterModal(
      BuildContext context, RepeatedPurchaseController controller) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Purchase Frequency',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text('All'),
                    selected: controller.selectedFrequency.value == 'All',
                    onSelected: (_) => controller.setFrequency('All'),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Colors.blue.shade100,
                    labelStyle: GoogleFonts.montserrat(
                      color: controller.selectedFrequency.value == 'All'
                          ? Colors.blue.shade700
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...controller.frequencies
                      .map((frequency) => FilterChip(
                            label: Text(frequency),
                            selected:
                                controller.selectedFrequency.value == frequency,
                            onSelected: (_) =>
                                controller.setFrequency(frequency),
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: Colors.blue.shade100,
                            labelStyle: GoogleFonts.montserrat(
                              color: controller.selectedFrequency.value ==
                                      frequency
                                  ? Colors.blue.shade700
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                      .toList(),
                ],
              )),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Product Categories',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.categories
                    .map((category) => FilterChip(
                          label: Text(category),
                          selected:
                              controller.selectedCategories.contains(category),
                          onSelected: (_) =>
                              controller.toggleCategory(category),
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: Colors.blue.shade100,
                          labelStyle: GoogleFonts.montserrat(
                            color:
                                controller.selectedCategories.contains(category)
                                    ? Colors.blue.shade700
                                    : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                    .toList(),
              )),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              controller.fetchData();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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
}

// Add these implementations to make the report page work with the existing ReportPageWrapper
class RetentionStrategyRecommendation extends StatelessWidget {
  final RepeatedPurchaseController controller;

  const RetentionStrategyRecommendation({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Retention Strategy Recommendations',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalized strategies based on purchase patterns',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          _buildStrategyCard(
            title: 'Weekly Shoppers',
            description: 'Customers who purchase on a weekly basis',
            strategies: [
              'Send weekly personalized product recommendations',
              'Create a VIP loyalty program with special perks',
              'Implement early access to new products/services'
            ],
            icon: Icons.star_border_rounded,
            color: Colors.amber,
          ),
          const SizedBox(height: 12),
          _buildStrategyCard(
            title: 'Monthly Subscribers',
            description: 'Customers who purchase monthly',
            strategies: [
              'Offer subscription discounts for 3+ month commitments',
              'Create "bundle and save" promotions',
              'Send monthly usage tips and product spotlights'
            ],
            icon: Icons.calendar_today_rounded,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildStrategyCard(
            title: 'Seasonal Buyers',
            description: 'Customers with quarterly or yearly purchases',
            strategies: [
              'Send reminders before typical purchase periods',
              'Create seasonal special offers',
              'Implement a "win-back" campaign for lapsed customers'
            ],
            icon: Icons.watch_later_outlined,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildStrategyCard(
            title: 'Cross-Category Opportunities',
            description: 'Encouraging purchases across multiple categories',
            strategies: [
              'Recommend complementary products across categories',
              'Create cross-category bundle discounts',
              'Implement a points system rewarding diverse purchases'
            ],
            icon: Icons.category_outlined,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyCard({
    required String title,
    required String description,
    required List<String> strategies,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          ...strategies
              .map((strategy) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: color,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            strategy,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Implement detailed strategy view
              },
              style: TextButton.styleFrom(
                foregroundColor: color,
              ),
              child: Text(
                'Implement Strategy',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Execute the report
