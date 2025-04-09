import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads/utils/constants.dart';

import 'controller.dart';

class OrdersReportView extends GetView<OrdersReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshData();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportHeader(),
              _buildMetricsGrid(),
              _buildCharts(),
              _buildOrdersTable(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primary3Color,
      elevation: 1,
      title: Text(
        'Orders Report',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.file_download, color: Colors.grey[700]),
          onPressed: () => controller.exportReport(),
          tooltip: 'Export Report',
        ),
        IconButton(
          icon: Icon(Icons.print, color: Colors.grey[700]),
          onPressed: () => controller.printReport(),
          tooltip: 'Print Report',
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.grey[700]),
          onPressed: controller.refreshData,
          tooltip: 'Refresh Data',
        ),
      ],
    );
  }

  Widget _buildReportHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.teal[200]!),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() => Text(
                      'Last updated: ${DateFormat('MMM dd, yyyy HH:mm').format(controller.lastUpdated.value)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    )),
              ],
            ),
            _buildDateRangePicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: Get.context!,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: controller.selectedDateRange.value ??
              DateTimeRange(
                start: DateTime.now().subtract(Duration(days: 30)),
                end: DateTime.now(),
              ),
        );
        if (picked != null) {
          controller.updateDateRange(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20),
            SizedBox(width: 8),
            Obx(() => Text(
                  controller.getDateRangeText(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Container(
      padding: EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          Obx(() => _buildMetricCard(
                'Total Orders',
                controller.totalOrders.value.toString(),
                controller.totalOrdersGrowth.value,
                Colors.blue[700]!,
                Icons.shopping_cart_outlined,
              )),
          Obx(() => _buildMetricCard(
                'Total Revenue',
                NumberFormat.currency(symbol: '\$')
                    .format(controller.totalRevenue.value),
                controller.totalRevenueGrowth.value,
                Colors.green[700]!,
                Icons.attach_money,
              )),
          Obx(() => _buildMetricCard(
                'Average Order Value',
                NumberFormat.currency(symbol: '\$')
                    .format(controller.avgOrderValue.value),
                controller.avgOrderValueGrowth.value,
                Colors.purple[700]!,
                Icons.analytics_outlined,
              )),
          Obx(() => _buildMetricCard(
                'Pending Orders',
                controller.pendingOrders.value.toString(),
                controller.pendingOrdersGrowth.value,
                Colors.orange[700]!,
                Icons.pending_actions,
              )),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, String growth, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: growth.startsWith('+')
                      ? Colors.green[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  growth,
                  style: TextStyle(
                    color: growth.startsWith('+')
                        ? Colors.green[700]
                        : Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRevenueChart(),
          SizedBox(height: 16),
          _buildOrderStatusChart(),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Container(
            height: 200,
            child: Obx(() => LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[200],
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            const months = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                              'Jul'
                            ];
                            if (value.toInt() < months.length) {
                              return Text(
                                months[value.toInt()],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                            }
                            return Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '\$${value.toInt()}k',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: controller.revenueData,
                        isCurved: true,
                        color: Colors.blue[700],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue[200]!.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusChart() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Container(
            height: 200,
            child: Obx(() => PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Colors.green[400],
                        value: controller.orderStatusData['Completed'] ?? 0,
                        title:
                            '${(controller.orderStatusData['Completed'] ?? 0).toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.orange[400],
                        value: controller.orderStatusData['In Progress'] ?? 0,
                        title:
                            '${(controller.orderStatusData['In Progress'] ?? 0).toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.red[400],
                        value: controller.orderStatusData['Cancelled'] ?? 0,
                        title:
                            '${(controller.orderStatusData['Cancelled'] ?? 0).toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.blue[400],
                        value: controller.orderStatusData['Pending'] ?? 0,
                        title:
                            '${(controller.orderStatusData['Pending'] ?? 0).toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          SizedBox(height: 24),
          _buildChartLegend(),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Obx(() => Column(
          children: [
            _buildLegendItem(
                'Completed',
                '${(controller.orderStatusData['Completed'] ?? 0).toStringAsFixed(0)}%',
                Colors.green[400]!),
            SizedBox(height: 8),
            _buildLegendItem(
                'In Progress',
                '${(controller.orderStatusData['In Progress'] ?? 0).toStringAsFixed(0)}%',
                Colors.orange[400]!),
            SizedBox(height: 8),
            _buildLegendItem(
                'Cancelled',
                '${(controller.orderStatusData['Cancelled'] ?? 0).toStringAsFixed(0)}%',
                Colors.red[400]!),
            SizedBox(height: 8),
            _buildLegendItem(
                'Pending',
                '${(controller.orderStatusData['Pending'] ?? 0).toStringAsFixed(0)}%',
                Colors.blue[400]!),
          ],
        ));
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search orders...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusFilter(),
                SizedBox(width: 8),
                _buildDateRangeFilter(),
                SizedBox(width: 8),
                _buildExportButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return PopupMenuButton<String>(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list, size: 20),
            SizedBox(width: 8),
            Obx(() => Text(controller.selectedStatus.value)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      onSelected: controller.updateStatus,
      itemBuilder: (context) => [
        'All',
        'Completed',
        'Pending',
        'In Progress',
        'Cancelled',
      ]
          .map((status) => PopupMenuItem(
                value: status,
                child: Text(status),
              ))
          .toList(),
    );
  }

  Widget _buildDateRangeFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 20),
          SizedBox(width: 8),
          Obx(() => Text(controller.getDateRangeText())),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return PopupMenuButton<String>(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.download, size: 20),
            SizedBox(width: 8),
            Text('Export'),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      onSelected: (format) => controller.exportReport(format: format),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'pdf',
          child: Text('Export as PDF'),
        ),
        PopupMenuItem(
          value: 'csv',
          child: Text('Export as CSV'),
        ),
        PopupMenuItem(
          value: 'excel',
          child: Text('Export as Excel'),
        ),
      ],
    );
  }

  Widget _buildOrdersTable() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Orders List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildFilters(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => DataTable(
                  columns: _buildColumns(),
                  rows: _buildRows(),
                )),
          ),
          _buildTablePagination(),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: Text('Order ID')),
      DataColumn(label: Text('Customer')),
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Amount')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Actions')),
    ];
  }

  List<DataRow> _buildRows() {
    final filteredOrders = controller.getFilteredOrders();
    final startIndex =
        (controller.currentPage.value - 1) * controller.itemsPerPage;
    final endIndex =
        min(startIndex + controller.itemsPerPage, filteredOrders.length);

    return filteredOrders
        .sublist(startIndex, endIndex)
        .map((order) => DataRow(
              cells: [
                DataCell(Text(order['orderId'])),
                DataCell(Text(order['customerName'])),
                DataCell(Text(order['date'])),
                DataCell(Text(NumberFormat.currency(symbol: '\$')
                    .format(order['rawAmount']))),
                DataCell(_buildStatusBadge(order['status'])),
                DataCell(_buildActionButtons(order)),
              ],
            ))
        .toList();
  }

  Widget _buildStatusBadge(String status) {
    final colors = {
      'Completed': Colors.green,
      'Pending': Colors.blue,
      'In Progress': Colors.orange,
      'Cancelled': Colors.red,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[status]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors[status],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> order) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.visibility, color: Colors.blue),
          onPressed: () => controller.viewOrderDetails(order),
          tooltip: 'View Details',
        ),
      ],
    );
  }

  Widget _buildTablePagination() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            final totalOrders = controller.getFilteredOrders().length;
            final startIndex =
                ((controller.currentPage.value - 1) * controller.itemsPerPage) +
                    1;
            final endIndex =
                min(startIndex + controller.itemsPerPage - 1, totalOrders);

            return Text(
              '$startIndex to $endIndex of $totalOrders entries',
              style: TextStyle(color: Colors.grey[600]),
            );
          }),
          Row(
            children: [
              Obx(() => TextButton(
                    onPressed: controller.currentPage.value > 1
                        ? controller.previousPage
                        : null,
                    child: Text('Previous'),
                  )),
              SizedBox(width: 8),
              Obx(() {
                final totalPages = (controller.getFilteredOrders().length /
                        controller.itemsPerPage)
                    .ceil();
                return Text(
                  'Page ${controller.currentPage.value} of $totalPages',
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }),
              SizedBox(width: 8),
              Obx(() {
                final totalPages = (controller.getFilteredOrders().length /
                        controller.itemsPerPage)
                    .ceil();
                return TextButton(
                  onPressed: controller.currentPage.value < totalPages
                      ? controller.nextPage
                      : null,
                  child: Text('Next'),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
