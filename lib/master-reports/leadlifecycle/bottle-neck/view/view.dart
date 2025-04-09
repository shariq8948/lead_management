import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../widgets/page_wrapper.dart';
import '../controller/controller.dart';
import '../model/models.dart';

class SalesPipelineBottleneckDashboard extends StatelessWidget {
  final SalesPipelineBottleneckController controller =
      Get.put(SalesPipelineBottleneckController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Sales Pipeline Bottleneck Analysis',
      onDateRangeSelected: (DateTimeRange? range) {
        if (range != null) {
          // controller.filterDataByDateRange(range);
        }
      },
      body: _buildDashboardContent(),
    );
  }

  Widget _buildDashboardContent() {
    return Obx(() => Container(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPerformanceSummary(),
                  const SizedBox(height: 20),
                  _buildStageStagnationChart(),
                  const SizedBox(height: 20),
                  _buildSalesLeadsDataTable(),
                  const SizedBox(height: 20),
                  _buildCriticalInsightsPanel(),
                  const SizedBox(height: 20),
                  _buildActionRecommendationsPanel(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildPerformanceSummary() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.red.shade100,
            Colors.red.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricCard(
            'Total Bottleneck Leads',
            controller.totalBottleneckLeads.value.toString(),
            Icons.warning_amber_outlined,
            Colors.red.shade700,
          ),
          SizedBox(
            width: 10,
          ),
          _buildMetricCard(
            'Avg Stagnation Time',
            '${controller.averageLeadStagnationDays.value.toStringAsFixed(1)} days',
            Icons.hourglass_empty,
            Colors.orange.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: GoogleFonts.montserrat(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageStagnationChart() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lead Stagnation by Stage',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries<SalesLead, String>>[
              BarSeries<SalesLead, String>(
                dataSource: controller.leadsAtBottleneck,
                xValueMapper: (SalesLead lead, _) =>
                    lead.currentStage.toString().split('.').last,
                yValueMapper: (SalesLead lead, _) => lead.daysSinceLastActivity,
                color: Colors.red.shade300,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.top,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesLeadsDataTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Leads Details',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Lead ID',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Customer',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stage',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Days Stagnant',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Potential Revenue',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Risk Level',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: controller.leadsAtBottleneck.map((lead) {
                return DataRow(
                  cells: [
                    DataCell(Text(lead.leadId)),
                    DataCell(Text(lead.leadName)),
                    DataCell(
                        Text(lead.currentStage.toString().split('.').last)),
                    DataCell(
                      Text(
                        lead.daysSinceLastActivity.toString(),
                        style: TextStyle(
                          color: lead.daysSinceLastActivity > 15
                              ? Colors.red
                              : Colors.black,
                          fontWeight: lead.daysSinceLastActivity > 15
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    DataCell(
                        Text('\$${lead.potentialRevenue.toStringAsFixed(0)}')),
                    DataCell(
                      Text(
                        lead.riskLevel.toString().split('.').last,
                        style: TextStyle(
                          color: lead.riskLevel == LeadRiskCategory.high
                              ? Colors.red
                              : lead.riskLevel == LeadRiskCategory.moderate
                                  ? Colors.orange
                                  : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalInsightsPanel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade100,
            Colors.orange.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Critical Insights',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.orange.shade900,
            ),
          ),
          const SizedBox(height: 15),
          ...controller.insights
              .map(
                (insight) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.orange.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          insight,
                          style: GoogleFonts.openSans(
                            color: Colors.orange.shade900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildActionRecommendationsPanel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.green.shade100,
            Colors.green.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.green.shade900,
            ),
          ),
          const SizedBox(height: 15),
          _buildActionItem(
            'Prioritize leads stagnant over 15 days',
            Icons.priority_high,
            Colors.red.shade700,
          ),
          _buildActionItem(
            'Schedule immediate follow-up calls',
            Icons.phone,
            Colors.blue.shade700,
          ),
          _buildActionItem(
            'Review and streamline sales process',
            Icons.settings,
            Colors.orange.shade700,
          ),
          _buildActionItem(
            'Provide additional training to sales team',
            Icons.school,
            Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.openSans(
                color: Colors.green.shade900,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
