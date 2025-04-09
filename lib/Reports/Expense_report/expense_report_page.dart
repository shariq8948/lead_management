import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';
import 'controller.dart';

class ExpensesScreen extends StatelessWidget {
  final ExpensesController controller = Get.put(ExpensesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary3Color,
        elevation: 0,
        title: const Text(
          'Expense Report',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildQuickStats(),
          _buildExpensesList(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Expenses',
                  '\₹${controller.totalExpenses.toStringAsFixed(2)}',
                  Colors.blue[700]!,
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => _buildStatCard(
                      'This Month',
                      '\₹${controller.currentMonthExpenses.toStringAsFixed(2)}',
                      Colors.green[700]!,
                      Icons.date_range,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActiveFiltersChips(),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String amount, Color color, IconData icon) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    return Obx(() => Wrap(
          spacing: 8,
          children: [
            if (controller.selectedCategory.value.isNotEmpty)
              _buildFilterChip(
                controller.selectedCategory.value,
                Icons.category,
                () => controller.selectedCategory.value = '',
              ),
            if (controller.selectedPaymentMethod.value.isNotEmpty)
              _buildFilterChip(
                controller.selectedPaymentMethod.value,
                Icons.payment,
                () => controller.selectedPaymentMethod.value = '',
              ),
            if (controller.startDate.value != null)
              _buildFilterChip(
                'From: ${DateFormat('MMM d').format(controller.startDate.value!)}',
                Icons.calendar_today,
                () => controller.startDate.value = null,
              ),
          ],
        ));
  }

  Widget _buildFilterChip(String label, IconData icon, VoidCallback onRemove) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: Colors.teal,
      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
      onDeleted: () {
        onRemove();
        controller.applyFilters();
      },
    );
  }

  Widget _buildExpensesList() {
    return Expanded(
      child: Obx(
        () => controller.filteredExpenses.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.filteredExpenses.length,
                itemBuilder: (context, index) {
                  final expense = controller.filteredExpenses[index];
                  return _buildExpenseCard(expense);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No expenses found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseReport expense) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showExpenseDetails(expense),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      expense.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    '\₹${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip(
                    expense.category,
                    Icons.category,
                    Colors.blue[100]!,
                    Colors.blue[700]!,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    expense.paymentMethod,
                    Icons.payment,
                    Colors.green[100]!,
                    Colors.green[700]!,
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(expense.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMMM d, yyyy').format(expense.date),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      String label, IconData icon, Color backgroundColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: iconColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isApproved = status == 'Approved';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApproved ? Icons.check_circle : Icons.pending,
            size: 12,
            color: isApproved ? Colors.green[700] : Colors.orange[700],
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: isApproved ? Colors.green[700] : Colors.orange[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filter Expenses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildFilterSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterTitle('Category'),
        const SizedBox(height: 8),
        _buildDropdownFilter(
          value: controller.selectedCategory.value,
          items: ['Travel', 'Office Supplies', 'Meals', 'Other'],
          onChanged: (value) {
            controller.selectedCategory.value = value ?? '';
            controller.applyFilters();
          },
        ),
        const SizedBox(height: 16),
        _buildFilterTitle('Payment Method'),
        const SizedBox(height: 8),
        _buildDropdownFilter(
          value: controller.selectedPaymentMethod.value,
          items: ['Credit Card', 'Cash', 'Bank Transfer'],
          onChanged: (value) {
            controller.selectedPaymentMethod.value = value ?? '';
            controller.applyFilters();
          },
        ),
        const SizedBox(height: 16),
        _buildFilterTitle('Date Range'),
        const SizedBox(height: 8),
        _buildDateRangeFilter(),
      ],
    );
  }

  Widget _buildFilterTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          hint: const Text('Select'),
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            label: 'Start Date',
            value: controller.startDate.value,
            onTap: () async {
              final date = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                controller.startDate.value = date;
                controller.applyFilters();
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField(
            label: 'End Date',
            value: controller.endDate.value,
            onTap: () async {
              final date = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                controller.endDate.value = date;
                controller.applyFilters();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value != null ? DateFormat('MMM d, yyyy').format(value) : label,
                style: TextStyle(
                  color: value != null ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  void _showExpenseDetails(ExpenseReport expense) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expense Details',
                  style: TextStyle(
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
            const SizedBox(height: 24),
            _buildDetailRow('Amount', '\₹${expense.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Category', expense.category),
            _buildDetailRow('Payment Method', expense.paymentMethod),
            _buildDetailRow(
                'Date', DateFormat('MMMM d, yyyy').format(expense.date)),
            _buildDetailRow('Status', expense.status),
            _buildDetailRow('Description', expense.description),
            const SizedBox(height: 24),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     _buildActionButton(
            //       'Edit',
            //       Icons.edit,
            //       Colors.blue,
            //       () => _editExpense(expense),
            //     ),
            //     _buildActionButton(
            //       'Delete',
            //       Icons.delete,
            //       Colors.red,
            //       () => _deleteExpense(expense),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    String category = '';
    String paymentMethod = '';
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Expense',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\₹',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter an amount';
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      value: category.isEmpty ? null : category,
                      items: ['Travel', 'Office Supplies', 'Meals', 'Other']
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) => category = value ?? '',
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Payment Method',
                        border: OutlineInputBorder(),
                      ),
                      value: paymentMethod.isEmpty ? null : paymentMethod,
                      items: ['Credit Card', 'Cash', 'Bank Transfer']
                          .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (value) => paymentMethod = value ?? '',
                      validator: (value) => value == null
                          ? 'Please select a payment method'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      // Add expense logic here
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Expense'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _editExpense(ExpenseReport expense) {
    // Implement edit logic
    Get.back();
  }

  void _deleteExpense(ExpenseReport expense) {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete logic
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
