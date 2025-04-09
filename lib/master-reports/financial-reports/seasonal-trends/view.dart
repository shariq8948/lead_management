import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../widgets/page_wrapper.dart';

class SeasonalTrendAnalysisPage extends StatelessWidget {
  const SeasonalTrendAnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeasonalTrendController());

    return ReportPageWrapper(
      title: 'Seasonal Trend Analysis',
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
            _buildYearSelector(controller),
            const SizedBox(height: 16),
            _buildSummaryCards(controller),
            const SizedBox(height: 24),
            _buildSeasonalTrendChart(controller),
            const SizedBox(height: 24),
            _buildMonthlyComparisonChart(controller),
            const SizedBox(height: 24),
            _buildSeasonalInsights(controller),
            const SizedBox(height: 24),
            _buildDataTable(controller),
          ],
        );
      }),
    );
  }

  Widget _buildYearSelector(SeasonalTrendController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current Year:',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Obx(() => DropdownButton<int>(
                value: controller.selectedCurrentYear.value,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    controller.updateCurrentYear(newValue);
                  }
                },
                items: controller.availableYears
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              )),
          const SizedBox(width: 16),
          Text(
            'Compare With:',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Obx(() => DropdownButton<int>(
                value: controller.selectedComparisonYear.value,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    controller.updateComparisonYear(newValue);
                  }
                },
                items: controller.availableYears
                    .where(
                        (year) => year != controller.selectedCurrentYear.value)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(SeasonalTrendController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            _buildSummaryCard(
              title: 'Peak Season',
              value: controller.peakSeason.value,
              icon: Icons.trending_up,
              color: Colors.green.shade400,
            ),
            _buildSummaryCard(
              title: 'Low Season',
              value: controller.lowSeason.value,
              icon: Icons.trending_down,
              color: Colors.orange.shade400,
            ),
            _buildSummaryCard(
              title: 'YoY Growth',
              value: '${controller.yearOverYearGrowth.value}%',
              icon: Icons.show_chart,
              color: Colors.blue.shade400,
            ),
            _buildSummaryCard(
              title: 'Seasonal Variance',
              value: '${controller.seasonalVariance.value}%',
              icon: Icons.compare_arrows,
              color: Colors.purple.shade400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalTrendChart(SeasonalTrendController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seasonal Revenue Trend',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 240,
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
          padding: const EdgeInsets.all(16),
          child: Obx(() => LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
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
                          const style = TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          );

                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Jan';
                              break;
                            case 1:
                              text = 'Feb';
                              break;
                            case 2:
                              text = 'Mar';
                              break;
                            case 3:
                              text = 'Apr';
                              break;
                            case 4:
                              text = 'May';
                              break;
                            case 5:
                              text = 'Jun';
                              break;
                            case 6:
                              text = 'Jul';
                              break;
                            case 7:
                              text = 'Aug';
                              break;
                            case 8:
                              text = 'Sep';
                              break;
                            case 9:
                              text = 'Oct';
                              break;
                            case 10:
                              text = 'Nov';
                              break;
                            case 11:
                              text = 'Dec';
                              break;
                            default:
                              text = '';
                          }
                          return Text(text, style: style);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}K',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
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
                  maxX: 11,
                  minY: 0,
                  maxY: controller.chartMaxY.value,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.seasonalData.value,
                      isCurved: true,
                      color: Colors.blue.shade400,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                        show: false,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.shade400.withOpacity(0.2),
                      ),
                    ),
                    LineChartBarData(
                      spots: controller.comparisonData.value,
                      isCurved: true,
                      color: Colors.grey.shade400,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                        show: false,
                      ),
                      dashArray: [5, 5],
                    ),
                  ],
                ),
              )),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(() => Text(
                      '${controller.selectedCurrentYear.value}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    )),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(() => Text(
                      '${controller.selectedComparisonYear.value}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlyComparisonChart(SeasonalTrendController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Year-over-Year Comparison',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 240,
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
          padding: const EdgeInsets.all(16),
          child: Obx(() => BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
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
                          const style = TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          );

                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Jan';
                              break;
                            case 1:
                              text = 'Feb';
                              break;
                            case 2:
                              text = 'Mar';
                              break;
                            case 3:
                              text = 'Apr';
                              break;
                            case 4:
                              text = 'May';
                              break;
                            case 5:
                              text = 'Jun';
                              break;
                            case 6:
                              text = 'Jul';
                              break;
                            case 7:
                              text = 'Aug';
                              break;
                            case 8:
                              text = 'Sep';
                              break;
                            case 9:
                              text = 'Oct';
                              break;
                            case 10:
                              text = 'Nov';
                              break;
                            case 11:
                              text = 'Dec';
                              break;
                            default:
                              text = '';
                          }
                          return Text(text, style: style);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}K',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
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
                  barGroups: controller.monthlyComparisonData.value,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String month;
                        switch (group.x) {
                          case 0:
                            month = 'January';
                            break;
                          case 1:
                            month = 'February';
                            break;
                          case 2:
                            month = 'March';
                            break;
                          case 3:
                            month = 'April';
                            break;
                          case 4:
                            month = 'May';
                            break;
                          case 5:
                            month = 'June';
                            break;
                          case 6:
                            month = 'July';
                            break;
                          case 7:
                            month = 'August';
                            break;
                          case 8:
                            month = 'September';
                            break;
                          case 9:
                            month = 'October';
                            break;
                          case 10:
                            month = 'November';
                            break;
                          case 11:
                            month = 'December';
                            break;
                          default:
                            month = '';
                        }
                        final String yearLabel = rodIndex == 0
                            ? '${controller.selectedCurrentYear.value}'
                            : '${controller.selectedComparisonYear.value}';
                        return BarTooltipItem(
                          '$month\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$yearLabel: \$${rod.toY.toInt()}K',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(() => Text(
                      '${controller.selectedCurrentYear.value}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    )),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(() => Text(
                      '${controller.selectedComparisonYear.value}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeasonalInsights(SeasonalTrendController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seasonal Insights',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
            width: double.infinity,
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var insight in controller.seasonalInsights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            insight.icon,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insight.title,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                insight.description,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )),
      ],
    );
  }

  Widget _buildDataTable(SeasonalTrendController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly Data',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            InkWell(
              onTap: () => controller.exportToCSV(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.download, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Export CSV',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
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
          child: Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 48,
                  headingRowColor:
                      MaterialStateProperty.all(Colors.grey.shade50),
                  columns: [
                    const DataColumn(
                      label: Text(
                        'Month',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '${controller.selectedCurrentYear.value}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '${controller.selectedComparisonYear.value}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'YoY Change',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: List.generate(
                    controller.monthlyTableData.length,
                    (index) {
                      final data = controller.monthlyTableData[index];
                      return DataRow(
                        cells: [
                          DataCell(Text(data.month)),
                          DataCell(Text('\$${data.currentYear}K')),
                          DataCell(Text('\$${data.previousYear}K')),
                          DataCell(
                            Row(
                              children: [
                                Icon(
                                  data.change >= 0
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 16,
                                  color: data.change >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${data.change.abs()}%',
                                  style: TextStyle(
                                    color: data.change >= 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
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
              )),
        ),
      ],
    );
  }

  void _showFilterModal(
      BuildContext context, SeasonalTrendController controller) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Data By',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Product Categories',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => Column(
                    children: [
                      for (var category in controller.productCategories)
                        _buildCheckboxOption(
                          title: category.name,
                          value: category.isSelected.value,
                          onChanged: (value) =>
                              category.isSelected.value = value!,
                        ),
                    ],
                  )),
              const SizedBox(height: 24),
              Text(
                'Data Frequency',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => Column(
                    children: [
                      _buildFilterOption(
                        title: 'Monthly',
                        value: 'monthly',
                        groupValue: controller.dataFrequency.value,
                        onChanged: (value) =>
                            controller.updateDataFrequency(value!),
                      ),
                      _buildFilterOption(
                        title: 'Quarterly',
                        value: 'quarterly',
                        groupValue: controller.dataFrequency.value,
                        onChanged: (value) =>
                            controller.updateDataFrequency(value!),
                      ),
                    ],
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    controller.resetFilters();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Reset Filters'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxOption({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue.shade500,
          ),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption({
    required String title,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.blue.shade500,
          ),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class SeasonalTrendController extends GetxController {
  final isLoading = true.obs;
  final availableYears = [2021, 2022, 2023, 2024];
  final selectedCurrentYear = 2024.obs;
  final selectedComparisonYear = 2023.obs;

  final peakSeason = 'Summer (Jun-Aug)'.obs;
  final lowSeason = 'Winter (Dec-Feb)'.obs;
  final yearOverYearGrowth = 15.3.obs;
  final seasonalVariance = 28.7.obs;

  final chartMaxY = 12.0.obs;

  final seasonalData = <FlSpot>[].obs;
  final comparisonData = <FlSpot>[].obs;
  final monthlyComparisonData = <BarChartGroupData>[].obs;

  final dataFrequency = 'monthly'.obs;
  final monthlyTableData = <MonthlyTableData>[].obs;

  final productCategories = <CategoryFilter>[
    CategoryFilter('Electronics', true.obs),
    CategoryFilter('Apparel', true.obs),
    CategoryFilter('Home & Garden', true.obs),
    CategoryFilter('Sports & Outdoors', true.obs),
  ];

  final seasonalInsights = <InsightData>[
    InsightData(
      Icons.trending_up,
      'Peak Season Growth',
      'Summer months (Jun-Aug) show 28% higher revenue than annual average, with consistent year-over-year growth.',
    ),
    InsightData(
      Icons.new_releases,
      'Emerging Trend',
      'Spring (Mar-May) has shown accelerating growth over the past 3 years, becoming a secondary peak season.',
    ),
    InsightData(
      Icons.trending_down,
      'Low Season Improvement',
      'Winter months (Dec-Feb) have improved from -32% to -24% below annual average compared to previous year.',
    ),
    InsightData(
      Icons.compare_arrows,
      'Seasonal Consistency',
      'Annual seasonality pattern remains consistent but with reduced variance, suggesting more stable year-round business.',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Load seasonal data for selected years
    _generateSeasonalData();

    // Update loading state
    isLoading.value = false;
  }

  void _generateSeasonalData() {
    // Generate data for current year
    seasonalData.value = [
      const FlSpot(0, 5.2), // Jan
      const FlSpot(1, 5.7), // Feb
      const FlSpot(2, 6.8), // Mar
      const FlSpot(3, 7.3), // Apr
      const FlSpot(4, 8.1), // May
      const FlSpot(5, 9.5), // Jun
      const FlSpot(6, 10.2), // Jul
      const FlSpot(7, 9.8), // Aug
      const FlSpot(8, 8.5), // Sep
      const FlSpot(9, 7.6), // Oct
      const FlSpot(10, 6.4), // Nov
      const FlSpot(11, 5.4), // Dec
    ];

    // Generate data for comparison year
    comparisonData.value = [
      const FlSpot(0, 4.2), // Jan
      const FlSpot(1, 4.8), // Feb
      const FlSpot(2, 5.7), // Mar
      const FlSpot(3, 6.2), // Apr
      const FlSpot(4, 7.0), // May
      const FlSpot(5, 8.3), // Jun
      const FlSpot(6, 8.9), // Jul
      const FlSpot(7, 8.6), // Aug
      const FlSpot(8, 7.3), // Sep
      const FlSpot(9, 6.5), // Oct
      const FlSpot(10, 5.8), // Nov
      const FlSpot(11, 4.7), // Dec
    ];

    // Set chart maximum Y value
    chartMaxY.value = 12.0;

    // Generate monthly comparison data
    monthlyComparisonData.value = List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: seasonalData[index].y,
            color: Colors.blue.shade400,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: comparisonData[index].y,
            color: Colors.grey.shade400,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
    // Generate monthly table data
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    monthlyTableData.value = List.generate(12, (index) {
      final currentYearValue = seasonalData[index].y;
      final previousYearValue = comparisonData[index].y;
      final percentChange =
          ((currentYearValue - previousYearValue) / previousYearValue * 100)
              .round();

      return MonthlyTableData(
        month: monthNames[index],
        currentYear: currentYearValue.toStringAsFixed(1),
        previousYear: previousYearValue.toStringAsFixed(1),
        change: percentChange,
      );
    });
  }

  void updateCurrentYear(int year) {
    selectedCurrentYear.value = year;
    _loadData();
  }

  void updateComparisonYear(int year) {
    selectedComparisonYear.value = year;
    _loadData();
  }

  void updateDateRange(DateTimeRange dateRange) {
    // Handle date range changes
    _loadData();
  }

  void updateDataFrequency(String frequency) {
    dataFrequency.value = frequency;
  }

  void applyFilters() {
    // Apply selected filters
    _loadData();
  }

  void resetFilters() {
    // Reset all filters to default
    for (var category in productCategories) {
      category.isSelected.value = true;
    }

    dataFrequency.value = 'monthly';
    _loadData();
  }

  void exportToCSV() {
    // Implement CSV export functionality
    Get.snackbar(
      'Export Started',
      'Your data is being exported to CSV format',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 3),
    );
  }
}

class CategoryFilter {
  final String name;
  final RxBool isSelected;

  CategoryFilter(this.name, this.isSelected);
}

class MonthlyTableData {
  final String month;
  final String currentYear;
  final String previousYear;
  final int change;

  MonthlyTableData({
    required this.month,
    required this.currentYear,
    required this.previousYear,
    required this.change,
  });
}

class InsightData {
  final IconData icon;
  final String title;
  final String description;

  InsightData(this.icon, this.title, this.description);
}

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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
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
