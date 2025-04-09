import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../widgets/page_wrapper.dart';
import '../controllers/controller.dart';

class PaymentMethodAnalysisReport extends StatelessWidget {
  PaymentMethodAnalysisReport({Key? key}) : super(key: key);

  final PaymentMethodAnalysisController controller =
      Get.put(PaymentMethodAnalysisController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Payment Method Analysis',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context),
      onDateRangeSelected: controller.onDateRangeSelected,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildTimeFrameSelector(),
            const SizedBox(height: 20),
            _buildChartSection(),
            const SizedBox(height: 24),
            Text(
              'Payment Methods Breakdown',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodsList(),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Payment Analysis',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Revenue',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(controller.totalRevenue.value),
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Transactions',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.totalTransactions.value.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                '${controller.paymentMethods.length}',
                'Payment Methods',
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                controller.paymentMethods.isNotEmpty
                    ? controller.paymentMethods[0].method
                    : 'None',
                'Most Used',
                color: Colors.teal.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String value, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameSelector() {
    final timeFrames = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: timeFrames.map((timeFrame) {
          final isSelected = controller.selectedTimeFrame.value == timeFrame;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.changeTimeFrame(timeFrame),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  timeFrame,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods Distribution',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _getPieChartSections(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _buildChartLegend(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    final totalTxn = controller.totalTransactions.value.toDouble();

    return controller.paymentMethods.map((method) {
      final percentage = (method.transactions / totalTxn) * 100;

      return PieChartSectionData(
        color: method.color,
        value: method.transactions.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildChartLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.paymentMethods.map((method) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: method.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  method.method,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodsList() {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final totalTxn = controller.totalTransactions.value.toDouble();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.paymentMethods.length,
      itemBuilder: (context, index) {
        final method = controller.paymentMethods[index];
        final percentage = (method.transactions / totalTxn) * 100;

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
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: method.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      method.icon,
                      color: method.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              method.method,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: method.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${method.transactions} transactions',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              currencyFormat.format(method.amount),
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(method.color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterModal(BuildContext context) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        _buildFilterOption(
          context: context,
          title: 'Sort by Number of Transactions',
          trailing: const Icon(Icons.sort),
          onTap: () {
            controller.paymentMethods
                .sort((a, b) => b.transactions.compareTo(a.transactions));
            controller.paymentMethods.refresh();
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Sort by Total Revenue',
          trailing: const Icon(Icons.sort),
          onTap: () {
            controller.paymentMethods
                .sort((a, b) => b.amount.compareTo(a.amount));
            controller.paymentMethods.refresh();
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Show Only Digital Payments',
          trailing: const Icon(Icons.filter_alt_outlined),
          onTap: () {
            // In a real app, you would call your API with this filter
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Show Only Cash & Check',
          trailing: const Icon(Icons.filter_alt_outlined),
          onTap: () {
            // In a real app, you would call your API with this filter
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Reset All Filters',
          trailing: const Icon(Icons.refresh),
          onTap: () {
            controller.fetchPaymentMethodData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildFilterOption({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.white,
    );
  }
}
