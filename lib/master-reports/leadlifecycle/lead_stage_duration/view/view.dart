import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/page_wrapper.dart';
import '../controller/controller.dart';
import '../model/model.dart';

class LeadStageDurationReport extends StatelessWidget {
  final LeadStageDurationController controller =
      Get.put(LeadStageDurationController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Lead Stage Duration Analytics',
      onDateRangeSelected: (DateTimeRange? range) {
        if (range != null) {
          controller.filterDataByDateRange(range);
        }
      },
      body: _buildLeadStageDurationContent(),
    );
  }

  Widget _buildLeadStageDurationContent() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryMetrics(),
                const SizedBox(height: 24),
                _buildChartSection(),
                const SizedBox(height: 24),
                _buildDetailedTable(),
                const SizedBox(height: 24),
                _buildInsightSection(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSummaryMetrics() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blueGrey[100]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetricCard(
              'Total Lead Time',
              '${controller.totalLeadTime.value.toStringAsFixed(1)} days',
              Icons.timer_outlined,
              Colors.teal.shade400,
            ),
            const SizedBox(width: 16),
            _buildMetricCard(
              'Avg Conversion',
              '${controller.conversionRate.value.toStringAsFixed(1)}%',
              Icons.trending_up_outlined,
              Colors.indigo.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: GradientBoxBorder(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.5), color.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.7), color.withOpacity(0.3)],
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blueGrey[50]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average Days per Lead Stage',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey[900],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: GoogleFonts.poppins(
                  color: Colors.blueGrey[700],
                  fontSize: 12,
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Average Days',
                  textStyle: GoogleFonts.poppins(
                    color: Colors.blueGrey[700],
                    fontSize: 14,
                  ),
                ),
                labelStyle: GoogleFonts.poppins(
                  color: Colors.blueGrey[700],
                  fontSize: 12,
                ),
                majorGridLines: MajorGridLines(
                  color: Colors.blueGrey.shade200,
                  dashArray: const [5, 3],
                ),
              ),
              series: <CartesianSeries<LeadStageDuration, String>>[
                BarSeries<LeadStageDuration, String>(
                  dataSource: controller.stageDurations,
                  xValueMapper: (LeadStageDuration duration, _) =>
                      duration.stage,
                  yValueMapper: (LeadStageDuration duration, _) =>
                      duration.averageDays,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.shade200,
                      Colors.blueAccent.shade700,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    textStyle: GoogleFonts.poppins(
                      color: Colors.blueGrey[900],
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blueGrey[50]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Stage Duration',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey[900],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(120),
                  1: FixedColumnWidth(100),
                  2: FixedColumnWidth(120),
                  3: FixedColumnWidth(100),
                },
                border: TableBorder.all(
                  color: Colors.blueGrey.shade200,
                  width: 1,
                  borderRadius: BorderRadius.circular(12),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    children: [
                      _buildTableHeader('Stage'),
                      _buildTableHeader('Avg Days'),
                      _buildTableHeader('Conversion %'),
                      _buildTableHeader('Status'),
                    ],
                  ),
                  ...controller.stageDurations
                      .map((stage) => TableRow(children: [
                            _buildTableCell(stage.stage),
                            _buildTableCell(
                                '${stage.averageDays.toStringAsFixed(1)}'),
                            _buildTableCell(
                                '${stage.conversionProbability.toStringAsFixed(1)}%'),
                            _buildStatusCell(stage.averageDays),
                          ]))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blueGrey[100]!,
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Insights',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey[900],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            ...controller.dynamicInsights
                .map((insight) => _buildInsightItem(insight))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade300,
                  Colors.blueGrey.shade600,
                ],
              ),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.openSans(
                color: Colors.blueGrey[800],
                height: 1.6,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: Colors.blueGrey[900],
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          color: Colors.blueGrey[800],
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStatusCell(double days) {
    Color color;
    IconData icon;

    if (days < 3) {
      color = Colors.green.shade600;
      icon = Icons.check_circle_outline;
    } else if (days < 5) {
      color = Colors.orange.shade600;
      icon = Icons.warning_amber_outlined;
    } else {
      color = Colors.red.shade600;
      icon = Icons.error_outline;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.3),
              color.withOpacity(0.1),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}
