import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/utils/constants.dart';

import 'controller.dart';

class AttendanceReportPage extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              // color: Colors.grey[100],
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(constraints),
                    _buildSearchAndFilters(constraints),
                    _buildStatisticsCards(constraints),
                    _buildAttendanceTable(constraints),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primary3Color,
      elevation: 0,
      title: Text(
        'Attendance Report',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          tooltip: 'Export Report',
          icon: Icon(
            Icons.file_download,
          ),
          onPressed: controller.exportToExcel,
        ),
        IconButton(
          tooltip: 'Print Report',
          icon: Icon(
            Icons.print,
          ),
          onPressed: () => () {},
        ),
      ],
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    final bool isWide = constraints.maxWidth > 600;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 20,
        runSpacing: 20,
        children: [
          Container(
            width:
                isWide ? constraints.maxWidth * 0.6 : constraints.maxWidth - 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Attendance Overview',
                  style: TextStyle(
                    fontSize: isWide ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() => Text(
                      'Report Period: ${DateFormat('MMM dd, yyyy').format(controller.startDate.value)} - ${DateFormat('MMM dd, yyyy').format(controller.endDate.value)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    )),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRefreshButton(),
              SizedBox(width: 8),
              _buildViewToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Obx(() => controller.isLoading.value
        ? Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: controller.fetchAttendanceData,
          ));
  }

  Widget _buildViewToggle() {
    return Obx(() => SegmentedButton<String>(
          segments: [
            ButtonSegment(
                value: 'table',
                icon: Icon(Icons.table_chart),
                label: Text('Table')),
            ButtonSegment(
                value: 'grid',
                icon: Icon(Icons.grid_view),
                label: Text('Grid')),
          ],
          selected: {controller.viewMode.value},
          onSelectionChanged: (Set<String> selection) {
            controller.viewMode.value = selection.first;
          },
        ));
  }

  Widget _buildSearchAndFilters(BoxConstraints constraints) {
    final bool isWide = constraints.maxWidth > 900;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.start,
        children: [
          Container(
            width: isWide
                ? constraints.maxWidth * 0.3 - 40
                : constraints.maxWidth - 40,
            child: _buildSearchBar(),
          ),
          Container(
            width: isWide
                ? constraints.maxWidth * 0.4 - 40
                : constraints.maxWidth - 40,
            child: _buildDateRangeSelector(),
          ),
          Container(
            width: isWide
                ? constraints.maxWidth * 0.3 - 40
                : constraints.maxWidth - 40,
            child: _buildFilterDropdowns(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      // height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        onChanged: controller.searchEmployees,
        decoration: InputDecoration(
          hintText: 'Search by name or ID...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          // contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final DateTimeRange? dateRange = await showDateRangePicker(
              context: Get.context!,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDateRange: DateTimeRange(
                start: controller.startDate.value,
                end: controller.endDate.value,
              ),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black87,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (dateRange != null) {
              controller.startDate.value = dateRange.start;
              controller.endDate.value = dateRange.end;
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.date_range, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Obx(() => Text(
                        '${DateFormat('MMM dd').format(controller.startDate.value)} - ${DateFormat('MMM dd').format(controller.endDate.value)}',
                        style: TextStyle(color: Colors.black87),
                      )),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdowns() {
    return Row(
      children: [
        Obx(
          () => Expanded(
            child: _buildFilterDropdown(
              value: controller.selectedDepartment.value,
              items: ['All', 'MR', 'HR', 'Other'],
              onChanged: (value) =>
                  controller.selectedDepartment.value = value!,
              hint: 'Department',
            ),
          ),
        ),
        SizedBox(width: 16),
        Obx(
          () => Expanded(
            child: _buildFilterDropdown(
              value: controller.sortBy.value,
              items: ['date', 'name', 'status'],
              onChanged: (value) {
                controller.sortBy.value = value!;
                controller.sortRecords(); // No arguments passed here
              },
              hint: 'Sort by',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.capitalizeFirst!),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(BoxConstraints constraints) {
    final bool isWide = constraints.maxWidth > 900;
    return Container(
      padding: EdgeInsets.all(20),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          Obx(
            () => _buildStatCard(
              width: isWide
                  ? constraints.maxWidth * 0.25 - 40
                  : constraints.maxWidth * 0.5 - 30,
              icon: Icons.check_circle,
              title: 'Present',
              value: '${controller.totalAbsentCount}',
              color: Colors.green,
            ),
          ),
          Obx(
            () => _buildStatCard(
              width: isWide
                  ? constraints.maxWidth * 0.25 - 40
                  : constraints.maxWidth * 0.5 - 30,
              icon: Icons.cancel,
              title: 'Absent',
              value: '${controller.totalAbsentCount}',
              color: Colors.red,
            ),
          ),
          Obx(
            () => _buildStatCard(
              width: isWide
                  ? constraints.maxWidth * 0.25 - 40
                  : constraints.maxWidth * 0.5 - 30,
              icon: Icons.timer,
              title: 'Late',
              value: '${controller.totalLateCount}',
              color: Colors.orange,
            ),
          ),
          Obx(
            () => _buildStatCard(
              width: isWide
                  ? constraints.maxWidth * 0.25 - 40
                  : constraints.maxWidth * 0.5 - 30,
              icon: Icons.pending_actions,
              title: 'On Leave',
              value: '${controller.totalLateCount}',
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required double width,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable(BoxConstraints constraints) {
    return Obx(() {
      if (controller.viewMode.value == 'grid') {
        return _buildGridView(constraints);
      }
      return _buildTableView(constraints);
    });
  }

  Widget _buildTableView(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: GetBuilder<AttendanceController>(
          // Use GetBuilder instead of Obx
          builder: (controller) {
            return DataTable(
              columns: [
                DataColumn(label: Text('Employee ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Check In')),
                DataColumn(label: Text('Check Out')),
                DataColumn(label: Text('Status')),
              ],
              rows: controller.filteredRecords.map((record) {
                return DataRow(
                  cells: [
                    DataCell(Text(record.employeeId)),
                    DataCell(Text(record.name)),
                    DataCell(Text(record.department)),
                    DataCell(
                        Text(DateFormat('MMM dd, yyyy').format(record.date))),
                    DataCell(Text(record.checkIn ?? '-')),
                    DataCell(Text(record.checkOut ?? '-')),
                    DataCell(_buildStatusChip(record.status)),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridView(BoxConstraints constraints) {
    final bool isWide = constraints.maxWidth > 900;
    final double cardWidth =
        isWide ? constraints.maxWidth * 0.3 - 40 : constraints.maxWidth - 40;

    return Container(
      padding: EdgeInsets.all(20),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: controller.filteredRecords.map((record) {
          return Container(
            width: cardWidth,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      record.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusChip(record.status),
                  ],
                ),
                SizedBox(height: 12),
                _buildInfoRow('ID', record.employeeId),
                _buildInfoRow('Department', record.department),
                _buildInfoRow(
                    'Date', DateFormat('MMM dd, yyyy').format(record.date)),
                _buildInfoRow('Check In', record.checkIn ?? '-'),
                _buildInfoRow('Check Out', record.checkOut ?? '-'),
                SizedBox(height: 12),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final Map<String, Color> statusColors = {
      'present': Colors.green,
      'absent': Colors.red,
      'late': Colors.orange,
      'leave': Colors.blue,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColors[status.toLowerCase()]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.capitalizeFirst!,
        style: TextStyle(
          color: statusColors[status.toLowerCase()],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
