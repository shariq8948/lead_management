import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller.dart';

class MonthlyCollectionReportPage extends GetView<CollectionReportController> {
  Future<void> _showMonthYearPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.updateSelectedDate(picked);
    }
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    // Implement the filter dialog logic
    // You can use a bottom sheet or a dialog to allow users to filter data
    Get.snackbar(
        'Filter', 'Filter dialog functionality is not implemented yet.',
        snackPosition: SnackPosition.BOTTOM);
  }

  void _exportData() {
    // Implement export functionality (e.g., to CSV, Excel, or PDF)
    Get.snackbar('Export', 'Export functionality is not implemented yet.',
        snackPosition: SnackPosition.BOTTOM);
  }

  void _showCollectionDetails(Collection collection) {
    // Display details of a specific collection
    Get.snackbar(
      'Collection Details',
      'Customer: ${collection.customerName}\nAmount: ₹${collection.amount}\nStatus: ${collection.status}',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Collection Report',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Obx(() => Text(
                  DateFormat('MMMM yyyy').format(controller.selectedDate.value),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                )),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: Colors.black87),
            onPressed: () => _showMonthYearPicker(context),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87),
            onPressed: () => controller.fetchCollections(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchCollections,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewStats(),
                _buildSummaryCards(),
                _buildCollectionsSection(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCollectionsSection() {
    final filteredCollections = controller.filteredCollections;

    if (filteredCollections.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No collections found for the selected month',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredCollections.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final collection = filteredCollections[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: collection.status == 'Collected'
                  ? Colors.green[50]
                  : Colors.orange[50],
              child: Icon(
                collection.status == 'Collected'
                    ? Icons.check_circle
                    : Icons.pending,
                color: collection.status == 'Collected'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    collection.customerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: collection.status == 'Collected'
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${NumberFormat('#,##,###').format(collection.amount)}',
                    style: TextStyle(
                      color: collection.status == 'Collected'
                          ? Colors.green[700]
                          : Colors.orange[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      collection.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    collection.time,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            onTap: () => _showCollectionDetails(collection),
          ),
        );
      },
    );
  }

  Widget _buildOverviewStats() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                'Total Collections',
                controller.collections.length.toString(),
                Icons.assignment_turned_in,
                Colors.blue,
              ),
              SizedBox(width: 12),
              _buildStatCard(
                'Success Rate',
                '${((controller.totalCollection.value / (controller.totalCollection.value + controller.totalPending.value)) * 100).toStringAsFixed(1)}%',
                Icons.trending_up,
                Colors.green,
              ),
              SizedBox(width: 12),
              _buildStatCard(
                'Avg Collection',
                '₹${NumberFormat('#,##,###').format(controller.totalCollection.value / (controller.collections.length > 0 ? controller.collections.length : 1))}',
                Icons.analytics,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Collected',
              controller.totalCollection.value,
              Colors.green,
              Icons.arrow_upward,
              'Up from last month',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Total Pending',
              controller.totalPending.value,
              Colors.orange,
              Icons.arrow_downward,
              'Down from last month',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, int value, Color color, IconData icon, String subtitle) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '₹${NumberFormat('#,##,###').format(value)}',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
