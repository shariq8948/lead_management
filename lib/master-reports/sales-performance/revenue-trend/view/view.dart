import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widgets/page_wrapper.dart';
import '../controller/controller.dart';

class RevenueTrendsPage extends StatelessWidget {
  const RevenueTrendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RevenueTrendsController());

    return ReportPageWrapper(
      title: "Revenue Trends",
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context, controller),
      onDateRangeSelected: (dateRange) {
        if (dateRange != null) {
          controller.updateDateRange(dateRange);
        }
      },
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(controller),
            const SizedBox(height: 24),
            _buildPeriodSelector(controller),
            const SizedBox(height: 24),
            _buildRevenueChart(controller),
            const SizedBox(height: 32),
            _buildDetailedStats(controller),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard(RevenueTrendsController controller) {
    final currencyFormat = NumberFormat.currency(symbol: '\₹');

    return Container(
      width: double.infinity,
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
            color: Colors.blue.shade200.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Revenue',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(controller.totalRevenue.value),
            style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildComparisonIndicator(
                controller.revenueChangePercentage.value,
                "vs previous period",
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.getFormattedDateRange(),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonIndicator(double percentage, String label) {
    final isPositive = percentage >= 0;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isPositive
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive ? Colors.green.shade100 : Colors.red.shade100,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPositive
                  ? "+${percentage.toStringAsFixed(1)}%"
                  : "${percentage.toStringAsFixed(1)}%",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isPositive ? Colors.green.shade100 : Colors.red.shade100,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(RevenueTrendsController controller) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: RevenuePeriod.values.map((period) {
          final isSelected = controller.selectedPeriod.value == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.updatePeriod(period),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  period.displayName,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.black87 : Colors.black54,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRevenueChart(RevenueTrendsController controller) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Trends',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade100,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= controller.revenueData.length ||
                            value.toInt() < 0) {
                          return const SizedBox.shrink();
                        }

                        // Only show some labels to prevent overcrowding
                        if (controller.revenueData.length > 10) {
                          if (value.toInt() %
                                      (controller.revenueData.length ~/ 5) !=
                                  0 &&
                              value.toInt() !=
                                  controller.revenueData.length - 1) {
                            return const SizedBox.shrink();
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            controller.revenueData[value.toInt()].label,
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: controller.getChartYInterval(),
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            '\₹${value.toInt()}',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: controller.revenueData.length - 1.0,
                minY: 0,
                maxY: controller.getMaxRevenue() * 1.2,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final data =
                            controller.revenueData[touchedSpot.x.toInt()];
                        return LineTooltipItem(
                          '${data.label}\n\$${touchedSpot.y.toStringAsFixed(2)}',
                          GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: controller.revenueData
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value.value,
                            ))
                        .toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade400,
                        Colors.blue.shade700,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade300.withOpacity(0.3),
                          Colors.blue.shade400.withOpacity(0.0),
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

  Widget _buildDetailedStats(RevenueTrendsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Statistics',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatItem(
          title: 'Highest Revenue',
          value: '\₹${controller.highestRevenue.value.toStringAsFixed(2)}',
          subtitle: controller.highestRevenueDate.value,
          iconData: Icons.arrow_upward,
          iconColor: Colors.green,
          backgroundColor: Colors.green.shade50,
        ),
        const SizedBox(height: 12),
        _buildStatItem(
          title: 'Lowest Revenue',
          value: '\₹${controller.lowestRevenue.value.toStringAsFixed(2)}',
          subtitle: controller.lowestRevenueDate.value,
          iconData: Icons.arrow_downward,
          iconColor: Colors.red,
          backgroundColor: Colors.red.shade50,
        ),
        const SizedBox(height: 12),
        _buildStatItem(
          title: 'Average Revenue',
          value: '\₹${controller.averageRevenue.value.toStringAsFixed(2)}',
          subtitle:
              'per ${controller.selectedPeriod.value.displayName.toLowerCase()}',
          iconData: Icons.bar_chart,
          iconColor: Colors.blue,
          backgroundColor: Colors.blue.shade50,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required String subtitle,
    required IconData iconData,
    required Color iconColor,
    required Color backgroundColor,
  }) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            subtitle,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(
      BuildContext context, RevenueTrendsController controller) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        _buildFilterSection(
          title: 'Revenue Source',
          children: [
            for (final source in controller.revenueSources)
              _buildFilterCheckbox(source, controller.selectedSources,
                  (isSelected) {
                controller.toggleSource(source, isSelected);
              }),
          ],
        ),
        _buildFilterSection(
          title: 'Sort By',
          children: [
            _buildFilterRadio(
              'Date (Newest First)',
              controller.sortOption.value == SortOption.dateDesc,
              () => controller.setSortOption(SortOption.dateDesc),
            ),
            _buildFilterRadio(
              'Date (Oldest First)',
              controller.sortOption.value == SortOption.dateAsc,
              () => controller.setSortOption(SortOption.dateAsc),
            ),
            _buildFilterRadio(
              'Revenue (Highest First)',
              controller.sortOption.value == SortOption.revenueDesc,
              () => controller.setSortOption(SortOption.revenueDesc),
            ),
            _buildFilterRadio(
              'Revenue (Lowest First)',
              controller.sortOption.value == SortOption.revenueAsc,
              () => controller.setSortOption(SortOption.revenueAsc),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.resetFilters();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildFilterSection({
    required String title,
    required List<Widget> children,
  }) {
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
          ...children,
          const Divider(height: 32),
        ],
      ),
    );
  }

  Widget _buildFilterCheckbox(
    String label,
    RxList<String> selectedItems,
    Function(bool) onChanged,
  ) {
    return Obx(() => CheckboxListTile(
          title: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          value: selectedItems.contains(label),
          onChanged: (value) => onChanged(value ?? false),
          activeColor: Colors.blue.shade700,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ));
  }

  Widget _buildFilterRadio(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      leading: Radio<bool>(
        value: true,
        groupValue: isSelected,
        onChanged: (_) => onTap(),
        activeColor: Colors.blue.shade700,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
