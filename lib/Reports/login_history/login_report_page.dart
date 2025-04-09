import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/utils/constants.dart';

import 'controller.dart';

class LoginHistoryPage extends StatelessWidget {
  final LoginHistoryController controller = Get.put(LoginHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                _buildAnalyticsGrid(),
                SizedBox(height: 20),
                _buildFilterSection(),
                SizedBox(height: 20),
                _buildMainContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primary3Color,
      elevation: 0,
      title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search by username, location, or browser',
            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
            prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onChanged: controller.filterRecords,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.download),
          onPressed: controller.exportData,
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () => controller.fetchLoginHistory(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Login Activity Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1F36),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildAnalyticCard(
          'Total Logins',
          controller.totalLogins.toString(),
          Icons.login,
          Color(0xFF3B82F6),
          [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        _buildAnalyticCard(
          'Unique Users',
          controller.uniqueUsers.toString(),
          Icons.person,
          Color(0xFF10B981),
          [Color(0xFF10B981), Color(0xFF059669)],
        ),
        _buildAnalyticCard(
          'Failed Attempts',
          '0',
          Icons.error_outline,
          Color(0xFFEF4444),
          [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        _buildAnalyticCard(
          'Active Sessions',
          '${controller.totalLogins}',
          Icons.device_hub,
          Color(0xFF8B5CF6),
          [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        ),
      ],
    );
  }

  Widget _buildAnalyticCard(String title, String value, IconData icon,
      Color color, List<Color> gradientColors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16), // Reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8), // Reduced padding
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: Colors.white, size: 20), // Reduced icon size
            ),
            Spacer(), // Use Spacer instead of MainAxisAlignment
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12, // Reduced font size
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Reduced font size
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildDatePicker(),
          SizedBox(width: 16),
          _buildViewSelector(),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton.icon(
          icon: Icon(Icons.calendar_today, color: Color(0xFF6B7280)),
          label: Obx(() => Text(
                controller.selectedDate.value == null
                    ? 'Select Date'
                    : DateFormat('MMM dd, yyyy')
                        .format(controller.selectedDate.value!),
                style: TextStyle(color: Color(0xFF6B7280)),
              )),
          onPressed: () async {
            final date = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2026),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: Color(0xFF3B82F6),
                    colorScheme: ColorScheme.light(primary: Color(0xFF3B82F6)),
                  ),
                  child: child!,
                );
              },
            );
            controller.setSelectedDate(date);
          },
        ),
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(8),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Table'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Map'),
          ),
        ],
        onPressed: (index) {
          controller.selectedView.value = index == 0 ? 'Table' : 'Map';
        },
        isSelected: [
          controller.selectedView.value == 'Table',
          controller.selectedView.value == 'Map',
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            headingRowHeight: 56,
            dataRowHeight: 64,
            columns: [
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Browser')),
              DataColumn(label: Text('Login Time')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Coordinates')),
            ],
            rows: controller.filteredRecords.map((record) {
              return DataRow(
                cells: [
                  DataCell(_buildUserCell(record.userName)),
                  DataCell(_buildBrowserCell(record.browser)),
                  DataCell(_buildTimeCell(record.loginTime)),
                  DataCell(_buildLocationCell(record.geolocation)),
                  DataCell(
                      _buildCoordinatesCell(record.latitude, record.longitude)),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildUserCell(String userName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
          radius: 16,
          child: Text(
            userName[0].toUpperCase(),
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(userName),
      ],
    );
  }

  Widget _buildBrowserCell(String browser) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        browser,
        style: TextStyle(
          color: Color(0xFF3B82F6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimeCell(DateTime time) {
    return Text(DateFormat('MMM dd, yyyy HH:mm:ss').format(time));
  }

  Widget _buildLocationCell(String location) {
    return Text(
      location,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCoordinatesCell(double lat, double lng) {
    return Text(
      '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
      style: TextStyle(
        fontFamily: 'Monospace',
      ),
    );
  }
}
