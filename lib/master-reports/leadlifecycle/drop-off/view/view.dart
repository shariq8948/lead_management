import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../widgets/page_wrapper.dart';
import '../controller/controller.dart';
import '../model/model.dart';

class DropoffAnalysisView extends GetView<DropoffController> {
  const DropoffAnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Lead Dropoff Analysis',
      onDateRangeSelected: controller.updateDateRange,
      showFilterIcon: true,
      onFilterTap: () => _showAdvancedFilterModal(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.montserrat(color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildComprehensiveSummary(),
              const SizedBox(height: 16),
              _buildInsightsSection(),
              const SizedBox(height: 16),
              _buildDropoffTrendChart(),
              const SizedBox(height: 16),
              _buildDetailedDropoffBreakdown(),
              const SizedBox(height: 16),
              _buildRecommendationSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildComprehensiveSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricCard(
                icon: Icons.receipt_long,
                label: 'Total Leads',
                value: controller.totalInitialLeads.toString(),
                color: Colors.blue,
              ),
              _buildMetricCard(
                icon: Icons.trending_down,
                label: 'Dropped Leads',
                value: controller.totalDroppedLeads.toString(),
                color: Colors.red,
              ),
              _buildMetricCard(
                icon: Icons.analytics,
                label: 'Dropoff Rate',
                value: '${controller.dropoffRate.toStringAsFixed(1)}%',
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: controller.conversionProgress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Conversion Funnel Progress',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          'Overall Conversion: ${controller.overallConversionRate.toStringAsFixed(1)}%',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    if (controller.insights.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Insights',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...controller.insights.map((insight) => _buildInsightItem(
                icon: insight.icon,
                title: insight.title,
                description: insight.description,
                color: insight.color,
              )),
        ],
      ),
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
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
          ),
        ],
      ),
    );
  }

  Widget _buildDropoffTrendChart() {
    if (controller.trendData.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dropoff Trend',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: _getMaxYAxisValue(),
                interval: 10,
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(
                  color: Colors.grey,
                  dashArray: <double>[3, 3],
                ),
                title: AxisTitle(
                  text: 'Dropoff Rate (%)',
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                canShowMarker: false,
                format: 'point.x : point.y%',
              ),
              series: <CartesianSeries>[
                LineSeries<TrendData, String>(
                  dataSource: controller.trendData,
                  xValueMapper: (TrendData data, _) => data.stage,
                  yValueMapper: (TrendData data, _) => data.dropoffRate,
                  color: Colors.blue.shade600,
                  width: 3,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.blue.shade600,
                    borderColor: Colors.white,
                    borderWidth: 2,
                  ),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    textStyle: GoogleFonts.montserrat(
                      fontSize: 10,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                AreaSeries<TrendData, String>(
                  dataSource: controller.trendData,
                  xValueMapper: (TrendData data, _) => data.stage,
                  yValueMapper: (TrendData data, _) => data.dropoffRate,
                  color: Colors.blue.shade100.withOpacity(0.5),
                  borderColor: Colors.blue.shade300,
                  borderWidth: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxYAxisValue() {
    if (controller.trendData.isEmpty) return 50.0;
    double maxValue = controller.trendData
        .map((data) => data.dropoffRate)
        .reduce((a, b) => a > b ? a : b);
    return (maxValue ~/ 10 + 1) * 10.0; // Round up to nearest 10
  }

  Widget _buildDetailedDropoffBreakdown() {
    if (controller.dropoffStages.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Dropoff Breakdown',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...controller.dropoffStages
              .map((stage) => _buildStageBreakdown(stage)),
        ],
      ),
    );
  }

  Widget _buildStageBreakdown(DropoffModel stage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stage.stageName,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Dropoff: ${stage.dropoffRate.toStringAsFixed(1)}%',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...stage.reasons.map((reason) => _buildReasonBreakdown(reason)),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildReasonBreakdown(DropoffReason reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              reason.reason,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: LinearPercentIndicator(
              lineHeight: 10,
              percent: reason.percentage / 100,
              progressColor: Colors.blue.shade300,
              backgroundColor: Colors.grey.shade300,
              barRadius: const Radius.circular(5),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${reason.percentage}% (${reason.count})',
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

  Widget _buildRecommendationSection() {
    if (controller.recommendations.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actionable Recommendations',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 16),
          ...controller.recommendations
              .map((recommendation) => _buildRecommendationItem(
                    icon: recommendation.getIconData(),
                    title: recommendation.title,
                    description: recommendation.description,
                  )),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.green.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CustomFilterModal(
        onApply: (selectedFilters) {
          controller.updateFilters(selectedFilters);
          Navigator.pop(context);
        },
        onClear: () {
          controller.clearFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}

// Custom filter modal implementation
class CustomFilterModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;
  final Function() onClear;

  const CustomFilterModal({
    Key? key,
    required this.onApply,
    required this.onClear,
  }) : super(key: key);

  @override
  State<CustomFilterModal> createState() => _CustomFilterModalState();

  static void show(
    BuildContext context, {
    required List<Widget> filterWidgets,
    required Function(Map<String, dynamic>) onApply,
    required Function() onClear,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CustomFilterModal(
        onApply: onApply,
        onClear: onClear,
      ),
    );
  }
}

class _CustomFilterModalState extends State<CustomFilterModal> {
  final Map<String, dynamic> selectedFilters = {};

  // Define available filters
  final Map<String, List<String>> availableFilters = {
    'Lead Source': ['Referral', 'Digital Marketing', 'Direct', 'Events'],
    'Industry': ['Technology', 'Healthcare', 'Finance', 'Retail'],
    'Lead Stage': ['New', 'Contacted', 'Proposal', 'Negotiation'],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advanced Filters',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                ...availableFilters.entries
                    .map((entry) => _buildFilterOption(entry.key, entry.value)),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: widget.onClear,
                child: Text(
                  'Clear All',
                  style: GoogleFonts.montserrat(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => widget.onApply(selectedFilters),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, List<String> options) {
    return ExpansionTile(
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: options
          .map((option) => CheckboxListTile(
                title: Text(
                  option,
                  style: GoogleFonts.montserrat(),
                ),
                value: selectedFilters[title] == option,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedFilters[title] = option;
                    } else if (selectedFilters[title] == option) {
                      selectedFilters.remove(title);
                    }
                  });
                },
              ))
          .toList(),
    );
  }
}
