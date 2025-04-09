import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller.dart';

class AttendanceListPage extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[600],
      body: SafeArea(
        child: Obx(() {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverAppBar(context),
              _buildHeader(),
              _buildDateFilter(context),
            ],
            body: _buildMainContent(context),
          );
        }),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: Get.size.height * .12, // You can adjust this if needed
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.teal[600],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Attendance Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.teal[400]!,
                Colors.teal[800]!,
              ],
            ),
          ),
        ),
      ),
      actions: _buildAppBarActions(context),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.calendar_month, color: Colors.white),
        onPressed: () => _showMonthYearPicker(context),
        tooltip: 'Select Month',
      ),
      IconButton(
        icon: const Icon(Icons.analytics_outlined, color: Colors.white),
        onPressed: () => _showAttendanceStats(context),
        tooltip: 'View Statistics',
      ),
      IconButton(
        icon: const Icon(Icons.tune, color: Colors.white),
        onPressed: () => _showFilterOptions(context),
        tooltip: 'Filter Options',
      ),
    ];
  }

  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal[600]!,
              Colors.teal[400]!,
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildOverviewCards(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Container(
      height: Get.size.height * 0.2,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
          _buildAnimatedStatCard(
            'Present',
            controller.presentCount.toString(),
            "${controller.attendancePercentage.toStringAsFixed(1)}%",
            Icons.check_circle_outline,
            Colors.green[400]!,
          ),
          _buildAnimatedStatCard(
            'Absent',
            controller.absentCount.toString(),
            "Leaves taken",
            Icons.cancel_outlined,
            Colors.red[400]!,
          ),
          _buildAnimatedStatCard(
            'Late',
            controller.lateCount.toString(),
            "Delays",
            Icons.watch_later_outlined,
            Colors.orange[400]!,
          ),
          _buildAnimatedStatCard(
            'Streak',
            controller.currentStreak.toString(),
            "Current streak",
            Icons.local_fire_department,
            Colors.blue[400]!,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard(
      String title, String count, String subtitle, IconData icon, Color color) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 800),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: _buildStatCard(title, count, subtitle, icon, color),
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String count, String subtitle, IconData icon, Color color) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              _buildCardLabel(title, color),
            ],
          ),
          SizedBox(height: 16),
          _buildCardContent(count, subtitle),
        ],
      ),
    );
  }

  Widget _buildCardLabel(String title, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCardContent(String count, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildDateFilter(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(controller.selectedMonth.value),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            _buildFilterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return InkWell(
      onTap: () => _showFilterOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list, size: 16, color: Colors.indigo[400]),
            SizedBox(width: 4),
            Text(
              'Filters',
              style: TextStyle(
                color: Colors.indigo[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return controller.filteredData.isEmpty
        ? _buildEmptyState(context)
        : ListView.builder(
            padding: EdgeInsets.only(top: 8, bottom: 16),
            itemCount: controller.filteredData.length,
            itemBuilder: (context, index) {
              return _buildAttendanceCard(controller.filteredData[index]);
            },
          );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            "No attendance records found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Records for this month will appear here",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showMonthYearPicker(context),
            icon: Icon(Icons.calendar_today),
            label: Text("Change Month"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedMonth.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateSelectedMonth(picked);
    }
  }

  void _showAttendanceStats(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStatsSheet(context),
    );
  }

  Widget _buildStatsSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildSheetHeader("Attendance Statistics"),
            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.all(16),
                children: [
                  _buildStatisticTile(
                    "Attendance Rate",
                    "${this.controller.attendancePercentage.toStringAsFixed(1)}%",
                    Icons.show_chart,
                    Colors.blue[400]!,
                  ),
                  _buildStatisticTile(
                    "Current Streak",
                    "${this.controller.currentStreak} days",
                    Icons.local_fire_department,
                    Colors.orange[400]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetHeader(String title) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatisticTile(
      String title, String value, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSheetHeader("Filter Options"),
          Obx(() => Column(
                children: [
                  _buildFilterSwitch(
                    "Present",
                    Icons.check_circle_outline,
                    Colors.green[400]!,
                    controller.showPresent.value,
                    controller.togglePresent,
                  ),
                  _buildFilterSwitch(
                    "Absent",
                    Icons.cancel_outlined,
                    Colors.red[400]!,
                    controller.showAbsent.value,
                    controller.toggleAbsent,
                  ),
                  _buildFilterSwitch(
                    "Late",
                    Icons.watch_later_outlined,
                    Colors.orange[400]!,
                    controller.showLate.value,
                    controller.toggleLate,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildFilterSwitch(String title, IconData icon, Color color,
      bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.indigo[600],
      ),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> entry) {
    final status = entry["status"] ?? "Unknown";
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.light(primary: statusColor),
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            if (expanded) {
              controller.logAttendanceView(entry["date"]!);
            }
          },
          leading: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor),
          ),
          title: Text(
            DateFormat('EEEE, dd MMM yyyy')
                .format(DateTime.parse(entry["date"]!)),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
          children: [
            _buildAttendanceDetails(entry),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green[400]!;
      case 'absent':
        return Colors.red[400]!;
      case 'late':
        return Colors.orange[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle_outline;
      case 'absent':
        return Icons.cancel_outlined;
      case 'late':
        return Icons.watch_later_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildAttendanceDetails(Map<String, dynamic> entry) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _buildDetailTimeline(entry),
          if (entry["notes"] != null) ...[
            Divider(height: 32),
            _buildNotesSection(entry["notes"]!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailTimeline(Map<String, dynamic> entry) {
    // Assuming the entry contains lists of check-ins and check-outs
    final List<dynamic> checkIns = entry["checkIns"] ?? [];
    final List<dynamic> checkOuts = entry["checkOuts"] ?? [];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Summary row showing first check-in and last check-out
          Row(
            children: [
              Expanded(
                child: _buildTimelineColumn(
                  'First Check-in',
                  checkIns.isNotEmpty ? checkIns.first["time"] : 'N/A',
                  Icons.login,
                  Colors.green[400]!,
                  isFirst: true,
                ),
              ),
              Expanded(
                child: _buildTimelineColumn(
                  'Last Check-out',
                  checkOuts.isNotEmpty ? checkOuts.last["time"] : 'N/A',
                  Icons.logout,
                  Colors.red[400]!,
                  isMiddle: true,
                ),
              ),
              Expanded(
                child: _buildTimelineColumn(
                  'Total Duration',
                  _calculateTotalDuration(checkIns, checkOuts),
                  null,
                  Colors.blue[400]!,
                  isLast: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Detailed timeline of all check-ins and check-outs
          _buildDetailedTimeline(checkIns, checkOuts),
        ],
      ),
    );
  }

  Widget _buildDetailedTimeline(
      List<dynamic> checkIns, List<dynamic> checkOuts) {
    // Combine and sort all entries by timestamp
    List<Map<String, dynamic>> timelineEntries = [];

    for (var checkIn in checkIns) {
      timelineEntries.add({
        ...checkIn,
        'type': 'check-in',
        'timestamp': DateTime.parse(checkIn['timestamp']),
      });
    }

    for (var checkOut in checkOuts) {
      timelineEntries.add({
        ...checkOut,
        'type': 'check-out',
        'timestamp': DateTime.parse(checkOut['timestamp']),
      });
    }

    // Sort entries by timestamp
    timelineEntries.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

    return Column(
      children:
          timelineEntries.map((entry) => _buildTimelineEntry(entry)).toList(),
    );
  }

  Widget _buildTimelineEntry(Map<String, dynamic> entry) {
    final bool isCheckIn = entry['type'] == 'check-in';
    final color = isCheckIn ? Colors.green[400]! : Colors.red[400]!;
    final icon = isCheckIn ? Icons.login : Icons.logout;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline connector
          Container(
            width: 2,
            height: entry['image'] != null ? 120 : 60,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
          // Entry content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time and type indicator
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['time'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          isCheckIn ? 'Checked In' : 'Checked Out',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Location if available
                if (entry['location'] != null) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        entry['location'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
                // Image if available
                if (entry['image'] != null) ...[
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      child: Image.network(
                        entry['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineColumn(
    String label,
    String value,
    IconData? icon,
    Color color, {
    bool isFirst = false,
    bool isMiddle = false,
    bool isLast = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        // Time Value
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        // Icon and connecting lines using Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isFirst)
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.grey[300],
                ),
              ),
            if (icon != null)
              Container(
                width: 36,
                height: 36,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            if (!isLast)
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.grey[300],
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _calculateTotalDuration(
      List<dynamic> checkIns, List<dynamic> checkOuts) {
    if (checkIns.isEmpty || checkOuts.isEmpty) {
      return 'N/A';
    }

    Duration totalDuration = Duration.zero;
    int checkOutIndex = 0;

    for (var i = 0; i < checkIns.length; i++) {
      // Find the next valid check-out after this check-in
      while (checkOutIndex < checkOuts.length) {
        final checkInTime = DateTime.parse(checkIns[i]['timestamp']);
        final checkOutTime =
            DateTime.parse(checkOuts[checkOutIndex]['timestamp']);

        if (checkOutTime.isAfter(checkInTime)) {
          totalDuration += checkOutTime.difference(checkInTime);
          checkOutIndex++;
          break;
        }
        checkOutIndex++;
      }
    }

    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes.remainder(60);
    return '$hours hrs ${minutes} mins';
  }

  Widget _buildNotesSection(String notes) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: Colors.yellow[700], size: 20),
              SizedBox(width: 8),
              Text(
                'Notes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.yellow[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            notes,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
