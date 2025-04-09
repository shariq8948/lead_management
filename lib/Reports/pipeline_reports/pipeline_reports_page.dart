// pipeline_report_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads/utils/constants.dart';

import 'controller.dart';

class PipelineReportPage extends GetView<PipelineController> {
  const PipelineReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildHeaderFilters(),
                  const SizedBox(height: 16),
                  _buildSummaryCards(),
                  const SizedBox(height: 24),
                  _buildPipelineChart(),
                  const SizedBox(height: 24),
                  _buildStagesList(),
                  const SizedBox(height: 24), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Pipeline Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary3Color,
                primary3Color,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () {},
          tooltip: 'Export Report',
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
          tooltip: 'More Options',
        ),
      ],
    );
  }

  Widget _buildHeaderFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedPeriod.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: [
                      'This Week',
                      'This Month',
                      'This Quarter',
                      'This Year'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => controller.updatePeriod(value!),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Obx(
              () => SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Value',
                    label: Text('Value'),
                    icon: Icon(Icons.attach_money, size: 18),
                  ),
                  ButtonSegment(
                    value: 'Count',
                    label: Text('Count'),
                    icon: Icon(Icons.people, size: 18),
                  ),
                ],
                selected: {controller.selectedView.value},
                onSelectionChanged: (Set<String> selection) =>
                    controller.updateView(selection.first),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return SizedBox(
      height: 160,
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildSummaryCard(
              'Total Pipeline Value',
              '\Rs${controller.totalValue.toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.blue.shade700,
              'Active opportunities',
            ),
            _buildSummaryCard(
              'Total Leads',
              controller.totalLeads.toString(),
              Icons.people,
              Colors.green.shade600,
              'In pipeline',
            ),
            _buildSummaryCard(
              'Avg. Conversion',
              '${controller.averageConversion.toStringAsFixed(1)}%',
              Icons.trending_up,
              Colors.orange.shade600,
              'Success rate',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPipelineChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Obx(
        () => BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: controller.selectedView.value == 'Value'
                ? controller.totalValue
                : controller.totalLeads.toDouble(),
            barGroups: controller.stages
                .asMap()
                .entries
                .map(
                  (entry) => BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: controller.selectedView.value == 'Value'
                            ? entry.value['value']
                            : entry.value['count'].toDouble(),
                        color: Color(entry.value['color']),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: controller.selectedView.value == 'Value'
                              ? controller.totalValue
                              : controller.totalLeads.toDouble(),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          controller.stages[value.toInt()]['name'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      controller.selectedView.value == 'Value'
                          ? '\$${value.toInt()}'
                          : value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: controller.selectedView.value == 'Value'
                  ? controller.totalValue / 5
                  : controller.totalLeads / 5,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStagesList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pipeline Stages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
          Obx(() => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.stages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final stage = controller.stages[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(stage['color']).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(stage['color']),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    stage['name'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${stage['count']} leads • \$${stage['value'].toStringAsFixed(0)}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${stage['conversion']}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }
}
