import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../widgets/page_wrapper.dart';
import '../controller/controller.dart';

// Main page
class CategorySalesReport extends StatelessWidget {
  const CategorySalesReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategorySalesController());

    return ReportPageWrapper(
      title: 'Category Sales Report',
      showFilterIcon: false,
      // onFilterTap: () => _showFilterModal(context, controller),
      onDateRangeSelected: (range) {
        controller.setDateRange(range);
      },
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // View type toggle
            _buildViewToggle(controller),

            const SizedBox(height: 16),

            // Summary cards
            _buildSummaryCards(controller),

            const SizedBox(height: 24),

            // Main visualization - Chart or Table
            controller.selectedViewType.value == 'chart'
                ? _buildChartView(controller)
                : _buildTableView(controller),

            const SizedBox(height: 32),

            // Category breakdown
            Text(
              'Category Breakdown',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Category cards
            ...controller.categoryData
                .map((category) => _buildCategoryCard(category, controller))
                .toList(),
          ],
        );
      }),
    );
  }

  Widget _buildViewToggle(CategorySalesController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            title: 'Chart',
            isSelected: controller.selectedViewType.value == 'chart',
            onTap: () => controller.setViewType('chart'),
          ),
          _buildToggleButton(
            title: 'Table',
            isSelected: controller.selectedViewType.value == 'table',
            onTap: () => controller.setViewType('table'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black87 : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(CategorySalesController controller) {
    // Calculate totals
    double totalSales =
        controller.categoryData.fold(0, (sum, item) => sum + item.sales);
    int totalUnits =
        controller.categoryData.fold(0, (sum, item) => sum + item.units);
    double totalProfit =
        controller.categoryData.fold(0, (sum, item) => sum + item.profit);
    double avgGrowth = controller.categoryData.isEmpty
        ? 0
        : controller.categoryData.fold(0.0, (sum, item) => sum + item.growth) /
            controller.categoryData.length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          title: 'Total Sales',
          value: controller.formatCurrency(totalSales),
          icon: Icons.attach_money,
          iconColor: Colors.green,
        ),
        _buildSummaryCard(
          title: 'Units Sold',
          value: NumberFormat('#,###').format(totalUnits),
          icon: Icons.inventory_2_outlined,
          iconColor: Colors.blue,
        ),
        _buildSummaryCard(
          title: 'Total Profit',
          value: controller.formatCurrency(totalProfit),
          icon: Icons.trending_up,
          iconColor: Colors.purple,
        ),
        _buildSummaryCard(
          title: 'Avg Growth',
          value: '${avgGrowth.toStringAsFixed(1)}%',
          icon: Icons.show_chart,
          iconColor: avgGrowth >= 0 ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
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
              fontSize: 18,
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
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls(CategorySalesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        TextField(
          onChanged: controller.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search categories...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),

        const SizedBox(height: 12),

        // Row with filter settings
        Row(
          children: [
            // Show only top categories toggle
            Row(
              children: [
                Obx(() => Checkbox(
                      value: controller.showOnlyTopCategories.value,
                      onChanged: (value) =>
                          controller.toggleTopCategoriesFilter(value ?? true),
                    )),
                Text(
                  'Show only top',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),

            // Top N selector
            Obx(() => DropdownButton<int>(
                  value: controller.topCategoriesCount.value,
                  onChanged: (int? value) {
                    if (value != null) controller.setTopCategoriesCount(value);
                  },
                  items: [5, 10, 15, 20, 25, 50]
                      .map((int value) => DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          ))
                      .toList(),
                )),

            const Spacer(),

            // Sort selector
            Text(
              'Sort by:',
              style: GoogleFonts.montserrat(fontSize: 14),
            ),
            const SizedBox(width: 8),

            Obx(() => DropdownButton<String>(
                  value: controller.sortBy.value,
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.setSorting(
                          value, controller.sortDirection.value);
                    }
                  },
                  items: [
                    DropdownMenuItem(value: 'sales', child: Text('Sales')),
                    DropdownMenuItem(value: 'growth', child: Text('Growth')),
                    DropdownMenuItem(value: 'profit', child: Text('Profit')),
                    DropdownMenuItem(value: 'units', child: Text('Units')),
                  ],
                )),

            const SizedBox(width: 8),

            // Sort direction toggle
            Obx(() => IconButton(
                  icon: Icon(
                    controller.sortDirection.value == 'desc'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  onPressed: () => controller.setSorting(
                    controller.sortBy.value,
                    controller.sortDirection.value == 'desc' ? 'asc' : 'desc',
                  ),
                )),
          ],
        ),
      ],
    );
  }

// Add this method to build a scrollable legend
  Widget _buildScrollableLegend(
      CategorySalesController controller, List<CategoryPercentage> chartData) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.builder(
        itemCount: chartData.length,
        itemBuilder: (context, index) {
          final item = chartData[index];
          return ListTile(
            leading: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              item.category,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: Text(
              '${item.percentage.toStringAsFixed(1)}%',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartView(CategorySalesController controller) {
    // Get processed categories
    final topCategories = controller.processedCategories;

    // Create pie chart data from top categories
    List<CategoryPercentage> chartData = [];

    // Calculate total sales of all categories for percentage calculation
    double totalSales =
        controller.categoryData.fold(0, (sum, item) => sum + item.sales);

    // Add top categories to chart data
    for (var category in topCategories) {
      chartData.add(CategoryPercentage(
        category: category.category,
        percentage: (category.sales / totalSales * 100),
        color: controller.getColorForCategory(category.category),
      ));
    }

    // Add "Others" category if showing only top categories and there are more categories
    if (controller.showOnlyTopCategories.value &&
        controller.categoryData.length > controller.topCategoriesCount.value) {
      final othersCategory = controller.getOthersCategory(topCategories);
      if (othersCategory.sales > 0) {
        chartData.add(CategoryPercentage(
          category: 'Others',
          percentage: (othersCategory.sales / totalSales * 100),
          color: Colors.grey,
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales Distribution',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 16),

        // Category filtering controls
        _buildFilterControls(controller),

        const SizedBox(height: 16),

        Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: chartData.isEmpty
              ? Center(
                  child: Text(
                    'No categories match your filter criteria',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
              : PieChart(
                  PieChartData(
                    sections: chartData.map((item) {
                      return PieChartSectionData(
                        value: item.percentage,
                        title: '${item.percentage.toStringAsFixed(1)}%',
                        color: item.color,
                        radius: 100,
                        titleStyle: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                  ),
                ),
        ),

        const SizedBox(height: 16),

        // Scrollable legend with search capability
        _buildScrollableLegend(controller, chartData),
      ],
    );
  }

  Widget _buildTableView(CategorySalesController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
            columns: [
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
                  'Sales',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Units',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Profit',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Growth',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
            rows: controller.categoryData.map((item) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      item.category,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      controller.formatCurrency(item.sales),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      NumberFormat('#,###').format(item.units),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      controller.formatCurrency(item.profit),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.growth >= 0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: item.growth >= 0 ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.growth.abs().toStringAsFixed(1)}%',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: item.growth >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      CategorySalesData category, CategorySalesController controller) {
    final isExpanded = controller.selectedCategory.value == category.category;

    return GestureDetector(
      onTap: () {
        if (isExpanded) {
          controller.setSelectedCategory(null);
        } else {
          controller.setSelectedCategory(category.category);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: controller
                          .getColorForCategory(category.category)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(category.category),
                      color: controller.getColorForCategory(category.category),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.category,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${category.products.length} products',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        controller.formatCurrency(category.sales),
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            category.growth >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: category.growth >= 0
                                ? Colors.green
                                : Colors.red,
                            size: 14,
                          ),
                          Text(
                            '${category.growth.abs().toStringAsFixed(1)}%',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: category.growth >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Products',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: category.products.length,
                itemBuilder: (context, index) {
                  final product = category.products[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            product.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            controller.formatCurrency(product.sales),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${product.units} units',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final iconMap = {
      'Electronics': Icons.devices,
      'Clothing': Icons.checkroom,
      'Home & Kitchen': Icons.home,
      'Beauty & Personal Care': Icons.spa,
      'Sports & Outdoors': Icons.sports_basketball,
    };

    return iconMap[category] ?? Icons.category;
  }

  void _showFilterModal(
      BuildContext context, CategorySalesController controller) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Time Frame',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8,
            children: [
              _buildFilterChip(
                label: 'Daily',
                isSelected: controller.selectedTimeFrame.value == 'daily',
                onTap: () => controller.setTimeFrame('daily'),
              ),
              _buildFilterChip(
                label: 'Weekly',
                isSelected: controller.selectedTimeFrame.value == 'weekly',
                onTap: () => controller.setTimeFrame('weekly'),
              ),
              _buildFilterChip(
                label: 'Monthly',
                isSelected: controller.selectedTimeFrame.value == 'monthly',
                onTap: () => controller.setTimeFrame('monthly'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Sort By',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.attach_money, color: Colors.green),
          title: Text(
            'Highest Sales',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          onTap: () {
            // Implement sorting by highest sales
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.trending_up, color: Colors.blue),
          title: Text(
            'Highest Growth',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          onTap: () {
            // Implement sorting by highest growth
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.trending_down, color: Colors.red),
          title: Text(
            'Lowest Growth',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          onTap: () {
            // Implement sorting by lowest growth
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Apply filters
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Apply Filters',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
