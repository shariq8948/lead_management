import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'details_controller.dart';

class ExpenseDetailsPage extends StatelessWidget {
  const ExpenseDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpenseDetailsController controller =
        Get.put(ExpenseDetailsController());

    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Expense Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.attachment_outlined),
            tooltip: 'View Attachments',
            onPressed: () {
              _showAttachmentBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More Options',
            onPressed: () {
              _showMoreOptionsBottomSheet(context);
            },
          ),
        ],
      ),
      body: Obx(() => SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                // Implement refresh logic if needed
                await Future.delayed(Duration(seconds: 2));
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    _buildGeneralDetailsCard(controller),
                    _buildExpenseDetailsCard(controller),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildGeneralDetailsCard(ExpenseDetailsController controller) {
    final details = controller.expenseDetails.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ExpansionTile(
          title: Text(
            'General Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
          subtitle: Text(
            'Expense ID: ${details.id}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          trailing: Icon(Icons.expand_more, color: Colors.deepPurple.shade700),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow('Name', details.name),
                  _buildDetailRow(
                      'Date', DateFormat('dd/MM/yyyy').format(details.date)),
                  _buildDetailRow('Location',
                      '${details.city}, ${details.state} (${details.area})'),
                  _buildDetailRow(
                      'Travel Period',
                      '${DateFormat('dd/MM/yyyy').format(details.fromDate)} - '
                          '${DateFormat('dd/MM/yyyy').format(details.toDate)}'),
                  _buildDetailRow('Status', details.status.value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseDetailsCard(ExpenseDetailsController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Expense Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
          ),
          _buildAnimatedExpenseTable(controller),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRemarkSection(controller),
                SizedBox(height: 16),
                _buildActionButtons(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedExpenseTable(ExpenseDetailsController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text('Proposed',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text('Checker',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text('Final',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          ...controller.expenseDetails.value.expenses.entries.map((entry) {
            return _buildAnimatedExpenseRow(entry.key, entry.value,
                (value) => controller.updateFinalExpense(entry.key, value));
          }).toList(),
          _buildTotalWidget(controller), // Changed from _buildTotalRow
        ],
      ),
    );
  }

// Replace TableRow with a Widget
  Widget _buildTotalWidget(ExpenseDetailsController controller) {
    return Container(
      color: Colors.deepPurple.shade50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Total',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                controller.totalProposedExpense.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                controller.totalCheckerExpense.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                controller.totalFinalExpense.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedExpenseRow(
      String category, ExpenseItem item, Function(double) onFinalChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(category, textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(item.proposed.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(item.checker.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                initialValue: item.finalAmount.toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.deepPurple.shade100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.deepPurple.shade400, width: 2),
                  ),
                ),
                onChanged: (value) {
                  final parsedValue = double.tryParse(value);
                  if (parsedValue != null) {
                    onFinalChanged(parsedValue);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarkSection(ExpenseDetailsController controller) {
    return TextField(
      controller: TextEditingController(
          text: controller.expenseDetails.value.remark.value),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Additional Remarks',
        labelStyle: TextStyle(color: Colors.deepPurple.shade700),
        hintText: 'Add any additional comments or notes...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
        ),
      ),
      onChanged: controller.updateRemark,
    );
  }

  Widget _buildActionButtons(ExpenseDetailsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.approveExpense,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Approve'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showRejectConfirmationDialog(controller);
            },
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Reject'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Attachments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.file_present, color: Colors.deepPurple),
              title: Text('Expense_Receipt.pdf'),
              subtitle: Text('2.3 MB'),
              trailing: IconButton(
                icon: Icon(Icons.download, color: Colors.deepPurple),
                onPressed: () {
                  // TODO: Implement download logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'More Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.print, color: Colors.deepPurple),
              title: Text('Print Expense Report'),
              onTap: () {
                // TODO: Implement print logic
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.deepPurple),
              title: Text('Share Expense Report'),
              onTap: () {
                _shareExpenseReport(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareExpenseReport(BuildContext context) {
    // Implement share logic
    // This could use a share package like share_plus in Flutter
    // For now, a placeholder implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing expense report...'),
        backgroundColor: Colors.deepPurple.shade700,
      ),
    );
  }

  void _showRejectConfirmationDialog(ExpenseDetailsController controller) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(
          'Reject Expense',
          style: TextStyle(color: Colors.deepPurple.shade700),
        ),
        content: TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Provide reason for rejection...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // onChanged: controller.updateRejectionReason,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // controller.rejectExpense();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: Text('Confirm Rejection'),
          ),
        ],
      ),
    );
  }
}
