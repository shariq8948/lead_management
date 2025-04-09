import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../employee-performance/target-comparison/view.dart';
import '../controllers/controller.dart';

class OutstandingPaymentsReport extends StatelessWidget {
  OutstandingPaymentsReport({Key? key}) : super(key: key);

  final OutstandingPaymentsController controller =
      Get.put(OutstandingPaymentsController());

  @override
  Widget build(BuildContext context) {
    return ReportPageWrapper(
      title: 'Outstanding Payments',
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
            Text(
              'Outstanding Invoices',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentsList(),
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
          colors: [Colors.orange.shade300, Colors.deepOrange.shade400],
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
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Total Outstanding',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            currencyFormat.format(controller.totalOutstanding.value),
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                '${controller.outstandingPayments.length}',
                'Invoices',
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                '${controller.outstandingPayments.where((p) => p.overdueDays > 30).length}',
                'Critical',
                color: Colors.red.shade400,
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

  Widget _buildPaymentsList() {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.outstandingPayments.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final payment = controller.outstandingPayments[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
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
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    payment.customerName,
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getOverdueColor(payment.overdueDays),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${payment.overdueDays} days',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      payment.invoiceNumber,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'Due: ${dateFormat.format(payment.dueDate)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currencyFormat.format(payment.amount),
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepOrange.shade400,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Add follow-up action here
                      },
                      icon: const Icon(Icons.send, size: 16),
                      label: const Text('Follow Up'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.indigo,
                        side: BorderSide(color: Colors.indigo.shade200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 0),
                        minimumSize: const Size(100, 36),
                        textStyle: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              // Navigate to detailed invoice view
            },
          ),
        );
      },
    );
  }

  Color _getOverdueColor(int days) {
    if (days <= 7) return Colors.amber;
    if (days <= 30) return Colors.orange;
    return Colors.red.shade600;
  }

  void _showFilterModal(BuildContext context) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        _buildFilterOption(
          context: context,
          title: 'Show All Outstanding',
          onTap: () {
            controller.fetchOutstandingPayments();
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Overdue > 7 days',
          onTap: () {
            controller.filterByOverdueDays(7);
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Overdue > 30 days',
          onTap: () {
            controller.filterByOverdueDays(30);
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Overdue > 60 days',
          onTap: () {
            controller.filterByOverdueDays(60);
            Navigator.pop(context);
          },
        ),
        _buildFilterOption(
          context: context,
          title: 'Overdue > 90 days',
          onTap: () {
            controller.filterByOverdueDays(90);
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
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.white,
    );
  }
}
