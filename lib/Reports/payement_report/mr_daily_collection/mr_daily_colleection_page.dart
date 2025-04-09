import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants.dart';
import 'controller.dart';

class CollectionReportPage extends GetView<CollectionReportController> {
  final DateTime currentDate = DateTime.now();

  Future<void> _showDatePicker(BuildContext context) async {
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Collections'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All'),
                leading: Radio<String>(
                  value: 'All',
                  groupValue: controller.selectedFilter.value,
                  onChanged: (value) {
                    controller.updateFilter(value!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Collected'),
                leading: Radio<String>(
                  value: 'Collected',
                  groupValue: controller.selectedFilter.value,
                  onChanged: (value) {
                    controller.updateFilter(value!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Pending'),
                leading: Radio<String>(
                  value: 'Pending',
                  groupValue: controller.selectedFilter.value,
                  onChanged: (value) {
                    controller.updateFilter(value!);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportData() async {
    try {
      // Show loading indicator
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await controller.exportCollections();

      // Hide loading indicator
      Get.back();

      Get.snackbar(
        'Success',
        'Report exported successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back(); // Hide loading indicator
      Get.snackbar(
        'Error',
        'Failed to export report',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showCollectionDetails(CollectionData collection) {
    Get.dialog(
      AlertDialog(
        title: Text('Collection Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Customer', collection.customerName),
            _detailRow('Amount',
                '₹${NumberFormat('#,##,###').format(collection.amount)}'),
            _detailRow('Status', collection.status),
            _detailRow('Time', collection.time),
            _detailRow('Location', collection.location),
            if (collection.notes != null)
              _detailRow('Notes', collection.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          if (collection.status == 'Pending')
            ElevatedButton(
              onPressed: () {
                controller.markAsCollected(collection.id);
                Get.back();
              },
              child: Text('Mark as Collected'),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label + ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary3Color,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Collection Report',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Obx(() => Text(
                  DateFormat('EEEE, dd MMMM yyyy')
                      .format(controller.selectedDate.value),
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
            onPressed: () => _showDatePicker(context),
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

  // ... (rest of the UI widgets remain the same as in previous code)
  // Update the following in _buildCollectionsSection():
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
              'Up from yesterday',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Total Pending',
              controller.totalPending.value,
              Colors.orange,
              Icons.arrow_downward,
              'Down from yesterday',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collections',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: _exportData,
                icon: Icon(Icons.file_download, size: 18),
                label: Text('Export'),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildCollectionsList(),
        ],
      ),
    );
  }

  Widget _buildCollectionsList() {
    final filteredCollections = controller.filteredCollections;

    if (filteredCollections.isEmpty) {
      return Center(
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
              'No collections found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
}

Widget _buildStatCard(String title, String value, IconData icon, Color color) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSummaryCard(String title, double amount, Color color,
    IconData trendIcon, String trendText) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '₹${NumberFormat('#,##,###').format(amount)}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(trendIcon, size: 14, color: color),
            SizedBox(width: 4),
            Text(
              trendText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
