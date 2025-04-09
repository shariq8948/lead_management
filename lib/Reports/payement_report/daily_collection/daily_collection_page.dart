import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/utils/constants.dart';
import 'package:flutter/services.dart';
import 'controller.dart';

class DailyCollectionPage extends StatelessWidget {
  final controller = Get.put(DailyCollectionController());

  DailyCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Daily Collection Report',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _showExportOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateRangeSelector(context),
          _buildFiltersBar(context),
          _buildSearchBar(),
          _buildSummaryCard(context),
          _buildSortHeader(),
          _buildCollectionsList(),
        ],
      ),
    );
  }

  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Help & Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                /// 📝 How to View Reports
                _buildHelpSection(
                  title: '📝 Viewing Collection Reports',
                  content: [
                    'By default, the report shows today\'s collections.',
                    'To change the date range, use the Date Filter in the app bar.',
                    'Tap on a collection entry to see more details.',
                  ],
                ),

                /// 🎯 How to Use Filters
                _buildHelpSection(
                  title: '🎯 Using Filters',
                  content: [
                    'Tap the filter icon (🔽) to open filtering options.',
                    'Filter by Employee to see collections by a specific collector.',
                    'Use Mode of Payment to view cash, card, or bank transfers separately.',
                    'Select Status to see only completed or pending collections.',
                  ],
                ),

                /// 🔍 Searching for a Payment
                _buildHelpSection(
                  title: '🔍 Searching for a Payment',
                  content: [
                    'Use the search bar to quickly find a collection entry.',
                    'Search by employee name, amount, or payment method.',
                  ],
                ),

                /// 📊 Understanding Summary Section
                _buildHelpSection(
                  title: '📊 Understanding Summary',
                  content: [
                    'Total Collection: The total amount collected in the selected period.',
                    'Payment Breakdown: Shows collections by different payment methods.',
                  ],
                ),

                /// 📥 Exporting Reports
                _buildHelpSection(
                  title: '📥 Exporting Reports',
                  content: [
                    'Tap the download icon (⬇️) in the app bar.',
                    'Choose CSV, PDF, or Excel format to save the report.',
                  ],
                ),

                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper function to build help sections with a title and bullet points
  Widget _buildHelpSection(
      {required String title, required List<String> content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...content.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Export Report As',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('CSV'),
                onTap: () {
                  Navigator.pop(context);
                  controller.exportReport("CSV");
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('Excel'),
                onTap: () {
                  Navigator.pop(context);
                  controller.exportReport("Excel");
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('PDF'),
                onTap: () {
                  Navigator.pop(context);
                  controller.exportReport("PDF");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectDateRange(context),
              child: Row(
                children: [
                  Icon(Icons.date_range, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Obx(() => Text(
                        '${DateFormat('dd MMM yyyy').format(controller.startDate.value)} - ${DateFormat('dd MMM yyyy').format(controller.endDate.value)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () => controller.resetDateRange(),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: controller.startDate.value,
        end: controller.endDate.value,
      ),
    );
    if (picked != null) {
      controller.setDateRange(picked.start, picked.end);
    }
  }

  Widget _buildFiltersBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Employee',
              value: controller.selectedEmployee,
              items: controller.employees,
              onSelected: controller.setSelectedEmployee,
              icon: Icons.person,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Payment Method',
              value: controller.selectedPaymentMethod,
              items: controller.paymentMethods,
              onSelected: controller.setSelectedPaymentMethod,
              icon: Icons.payment,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Status',
              value: controller.selectedStatus,
              items: controller.statuses,
              onSelected: controller.setSelectedStatus,
              icon: Icons.flag,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required RxString value,
    required List<String> items,
    required Function(String?) onSelected,
    required IconData icon,
  }) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: value.value.isNotEmpty
                ? Theme.of(Get.context!).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton<String>(
            hint: Row(
              children: [
                Icon(icon, size: 16),
                const SizedBox(width: 4),
                Text(label),
              ],
            ),
            value: value.value.isEmpty ? null : value.value,
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: onSelected,
            underline: Container(),
          ),
        ));
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search by name, amount or payment method',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.setSearchQuery('');
                    },
                  )
                : const SizedBox.shrink()),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white.withOpacity(0.9),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Total Collection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
                  'Rs. ${NumberFormat('#,##,###.##').format(controller.totalCollection.value)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => _buildPaymentMethodSummary(
                      icon: Icons.credit_card,
                      label: 'Card',
                      amount: controller.cardTotal.value,
                      color: primary3Color,
                    )),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                Obx(() => _buildPaymentMethodSummary(
                      icon: Icons.money,
                      label: 'Cash',
                      amount: controller.cashTotal.value,
                      color: primary3Color,
                    )),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                Obx(() => _buildPaymentMethodSummary(
                      icon: Icons.phone_android,
                      label: 'UPI',
                      amount: controller.upiTotal.value,
                      color: primary3Color,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSummary({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rs. ${NumberFormat('#,##,###.##').format(amount)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSortHeader() {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSortButton('Name', 'name', Icons.person),
          _buildSortButton('Amount', 'amount', Icons.attach_money),
          _buildSortButton('Time', 'time', Icons.access_time),
          _buildSortButton('Collector', 'collector', Icons.person_outline),
        ],
      ),
    );
  }

  Widget _buildSortButton(String label, String field, IconData icon) {
    return Obx(() {
      final isSelected = controller.sortField.value == field;
      return TextButton.icon(
        onPressed: () => controller.setSortField(field),
        icon: Icon(
          isSelected
              ? (controller.isAscending.value
                  ? Icons.arrow_upward
                  : Icons.arrow_downward)
              : icon,
          size: 18,
          color: isSelected ? Theme.of(Get.context!).primaryColor : Colors.grey,
        ),
        label: Text(
          label,
          style: TextStyle(
            color:
                isSelected ? Theme.of(Get.context!).primaryColor : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    });
  }

  Widget _buildCollectionsList() {
    return Expanded(
      child: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: controller.filteredCollections.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredCollections[index];
                  return _buildCollectionCard(context, item);
                },
              ),
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, CollectionItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        onTap: () => _showPaymentDetails(context, item),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        child: Text(
                          item.customerName[0],
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.customerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Collected by: ${item.collectorName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${NumberFormat('#,##,###.##').format(item.amount)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item.time,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(context, item.status),
                  _buildPaymentMethodChip(context, item.paymentMethod),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChip(BuildContext context, String method) {
    IconData icon;
    switch (method.toLowerCase()) {
      case 'card':
        icon = Icons.credit_card;
        break;
      case 'cash':
        icon = Icons.money;
        break;
      case 'upi':
        icon = Icons.phone_android;
        break;
      default:
        icon = Icons.payment;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            method,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetails(BuildContext context, CollectionItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Customer', item.customerName),
            _buildDetailRow('Collector', item.collectorName),
            _buildDetailRow('Amount',
                'Rs. ${NumberFormat('#,##,###.##').format(item.amount)}'),
            _buildDetailRow('Time', item.time),
            _buildDetailRow('Status', item.status),
            _buildDetailRow('Payment Method', item.paymentMethod),
            _buildDetailRow('Transaction ID', item.transactionId),
            _buildDetailRow('Notes', item.notes),
            _buildDetailRow(
                'Date', DateFormat('dd MMM yyyy').format(item.date)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterDropdown(
              'Employee',
              controller.selectedEmployee.value,
              controller.employees,
              controller.setSelectedEmployee,
            ),
            const SizedBox(height: 16),
            _buildFilterDropdown(
              'Payment Method',
              controller.selectedPaymentMethod.value,
              controller.paymentMethods,
              controller.setSelectedPaymentMethod,
            ),
            const SizedBox(height: 16),
            _buildFilterDropdown(
              'Status',
              controller.selectedStatus.value,
              controller.statuses,
              controller.setSelectedStatus,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.resetFilters();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value.isEmpty ? null : value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
