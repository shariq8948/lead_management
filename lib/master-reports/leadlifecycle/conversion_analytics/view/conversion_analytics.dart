import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../widgets/page_wrapper.dart';
import '../controller/controller.dart';

class ConversionRatesScreen extends StatelessWidget {
  final ConversionRatesController controller =
      Get.put(ConversionRatesController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Conversion Analytics',
      onDateRangeSelected: (DateTimeRange? range) {
        if (range != null) {
          print(
              'Selected Date Range for Conversion Analytics: ${range.start} - ${range.end}');
          // controller.filterDataByDateRange(range); // Call your controller function
        }
      },
      showFilterIcon: true,
      body: _buildConversionAnalyticsContent(),
    );
  }

  Widget _buildConversionAnalyticsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPerformanceHeader(),
        const SizedBox(height: 20),
        _buildConversionChannelsGrid(),
        const SizedBox(height: 20),
        _buildConversionTrendSection(),
        const SizedBox(height: 20),
        _buildInsightSection(),
      ],
    );
  }

  void _showOtherFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Other Filter Options'),
              ListTile(
                title: const Text('Filter by Source'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement filter by source logic
                },
              ),
              // Add more filter options as needed
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Insights',
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comprehensive view of your marketing conversion strategies',
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Total Conversions', '1,234', Icons.analytics),
              _buildStatCard('Conversion Rate', '22.5%', Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionChannelsGrid() {
    return Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.conversionChannels.length,
          itemBuilder: (context, index) {
            final channel = controller.conversionChannels[index];
            return _buildConversionChannelCard(channel);
          },
        ));
  }

  Widget _buildConversionChannelCard(ConversionChannelData channel) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: channel.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: channel.iconColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  channel.channel,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: channel.iconColor,
                  ),
                ),
                Icon(channel.icon, color: channel.iconColor),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(channel.conversionRate * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _getColorForConversionRate(channel.conversionRate),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  channel.description,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionTrendSection() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversion Rate Trend',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: _buildLineChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.percentPattern(),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        majorGridLines: const MajorGridLines(
          color: Colors.grey,
          dashArray: <double>[5, 5],
          width: 0.5,
        ),
      ),
      series: <CartesianSeries<TimeSeriesConversion, String>>[
        LineSeries<TimeSeriesConversion, String>(
          dataSource: controller.conversionTrends,
          xValueMapper: (TimeSeriesConversion conversion, _) =>
              conversion.channel,
          yValueMapper: (TimeSeriesConversion conversion, _) =>
              conversion.conversionRate,
          color: Colors.blue.shade700,
          width: 3,
          markerSettings: const MarkerSettings(
            isVisible: true,
            color: Colors.blue,
            borderColor: Colors.white,
            borderWidth: 2,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: GoogleFonts.montserrat(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w600,
            ),
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Text(
                '${(data.conversionRate * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.montserrat(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              );
            },
          ),
        )
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y',
        header: 'Conversion Rate',
        textStyle: GoogleFonts.montserrat(),
      ),
    );
  }

  Widget _buildInsightSection() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversion Insights',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightRow(
              'Top Performing Channel',
              'Referral (30% Conversion Rate)',
              Icons.trending_up,
              Colors.green,
            ),
            const Divider(height: 16),
            _buildInsightRow(
              'Lowest Performing Channel',
              'Social Media (10% Conversion Rate)',
              Icons.trending_down,
              Colors.red,
            ),
            const Divider(height: 16),
            _buildInsightRow(
              'Overall Trend',
              'Steady Improvement',
              Icons.show_chart,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(
      String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.openSans(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForConversionRate(double rate) {
    if (rate < 0.15) return Colors.red;
    if (rate < 0.25) return Colors.orange;
    return Colors.green;
  }
}
