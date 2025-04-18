import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:leads/Tabs/homepage/model.dart';
import 'package:leads/alltasks/all_task_page.dart';
import 'package:leads/notifications/notifications_page.dart';
import 'package:leads/profile_pages/employee_profile/employee_detail.dart';
import 'package:leads/widgets/custom_date_picker.dart';
import 'package:leads/widgets/custom_field.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Tasks/taskDeatails/task_details_page.dart';
import '../../auth/login/login_controller.dart';
import '../../data/models/lead_list.dart';
import '../../google_service/demo_calender.dart';
import '../../meeting/landingPage/view.dart';
import '../../meeting/meeting_page.dart';
import '../../notifications/notification_controller.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_task_card.dart';
import 'admin_panel_controller.dart';
import 'homepage_controller.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final NotificationController notificationController =
      Get.put(NotificationController());
  final AdminPanelController controllerAdmin = Get.put(AdminPanelController());
  final LoginController loginController = Get.find<LoginController>();
  final HomeController controller = Get.put(HomeController());
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize data on screen load - optimize to single call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeData(); // New method to batch API calls
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Image.asset("assets/icons/sidebar.png"),
          ),
          SizedBox(width: 30),
          customToggle(),
          SizedBox(width: 10),
          _buildMeetingButton(),
          SizedBox(width: 10),
          _buildTodoButton(),
          _buildNotificationBadge(),
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFE1FFED),
      elevation: 0,
    );
  }

  Widget _buildMeetingButton() {
    return GestureDetector(
      onTap: () => Get.to(() => ScheduleScreen()),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/calender.png"),
        ),
      ),
    );
  }

  Widget _buildTodoButton() {
    return GestureDetector(
      onTap: () => Get.to(() => CalDemo()),
      child: Image.asset("assets/icons/todo.png"),
    );
  }

  Widget _buildNotificationBadge() {
    return Obx(() {
      int unreadCount = notificationController.notifications
          .where((notification) => !notification.isRead)
          .length;
      return badges.Badge(
        badgeContent: Text(
          unreadCount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        showBadge: unreadCount > 0,
        child: GestureDetector(
          onTap: () => Get.to(() => NotificationsPage()),
          child: Icon(
            Icons.notification_add_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
      );
    });
  }

  Widget _buildBody() {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
            ),
          ),
        ),
        // Main content
        Obx(() => controller.isAdminMode.value
            ? buildCommon()
            : adminPanel(controllerAdmin)),
      ],
    );
  }

  Widget customToggle() {
    return Center(
      child: Obx(
        () => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left side (Dashboard SVG)
                Positioned(
                  left: 10,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      "assets/icons/userdb.svg",
                      colorFilter:
                          ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                    ),
                  ),
                ),
                // Right side (Admin SVG)
                Positioned(
                  right: 10,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      "assets/icons/admin.svg",
                      colorFilter:
                          ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                    ),
                  ),
                ),
                // Animated Toggle Circle with SVG
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: controller.isAdminMode.value ? 70 : 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          controller.isAdminMode.value
                              ? "assets/icons/admin.svg"
                              : "assets/icons/userdb.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCommon() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row for Buttons
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button Area with proper layout constraints
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Obx(() => ElevatedButton(
                              onPressed: () {
                                controller.isTaskSelected.value = true;
                                controller.fetchTasksByTab("Today");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isTaskSelected.value
                                    ? primary3Color
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.grey),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/task.png",
                                    width: 24,
                                    height: 24,
                                    color: controller.isTaskSelected.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Task",
                                    style: TextStyle(
                                      color: controller.isTaskSelected.value
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    controller.taskCount.value.toString(),
                                    style: TextStyle(
                                      color: controller.isTaskSelected.value
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => ElevatedButton(
                              onPressed: () {
                                controller.isTaskSelected.value = false;
                                controller.fetchAssignedLead();
                                controller.resetToTodayTab();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isTaskSelected.value
                                    ? Colors.white
                                    : primary3Color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.grey),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/lead.png",
                                    width: 24,
                                    height: 24,
                                    color: controller.isTaskSelected.value
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Lead",
                                    style: TextStyle(
                                      color: controller.isTaskSelected.value
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    controller.leadCount.value.toString(),
                                    style: TextStyle(
                                      color: controller.isTaskSelected.value
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Task or Lead Card Display with proper heights
          Obx(() {
            return Container(
              height: controller.isTaskSelected.value
                  ? MediaQuery.of(context).size.height * 0.5
                  : MediaQuery.of(context).size.height * 0.5,
              child: controller.isTaskSelected.value ? TaskCard() : LeadCard(),
            );
          }),
          buildAnalyticsHeader(),
          SizedBox(
            height: 10,
          ),

          buildStatsdash()
          // Charts section with better layout
          // Obx(() => controller.isTaskSelected.value
          //     ? buildDoughnut()
          //     : buildPieChart()),
          // SizedBox(height: 16),

          // Stats grid with improved layout and consistent spacing
          // Obx(() => controller.isTaskSelected.value
          //     ? _buildTaskStats()
          //     : _buildLeadStats()),
        ],
      ),
    );
  }

  Widget buildAnalyticsHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : 24.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Analytics',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: isSmallScreen ? 22.0 : 28.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Obx(
                  () {
                    // Prepare the list of items
                    final List<String> items = [
                      'Last 30 Days',
                      'Last 60 Days',
                      'Last 90 Days',
                      'Custom Date Range',
                    ];

                    // If custom date range is active, use it as the selected value
                    final String selectedValue =
                        controller.isCustomDateRange.value
                            ? controller.customDateRangeLabel.value
                            : controller.selectedFilter.value;

                    // If custom date range is active and not in the list, add it
                    final List<String> finalItems = [
                      ...items,
                      if (controller.isCustomDateRange.value &&
                          !items
                              .contains(controller.customDateRangeLabel.value))
                        controller.customDateRangeLabel.value
                    ];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedValue,
                          hint: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Select Date Range',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 16.0,
                          ),
                          items: finalItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              if (newValue == 'Custom Date Range') {
                                _showCustomDateRangeBottomSheet(context);
                              } else {
                                controller.selectedFilter.value = newValue;
                                controller.isCustomDateRange.value = newValue ==
                                    controller.customDateRangeLabel.value;

                                if (!controller.isCustomDateRange.value) {
                                  _handleDateRangeSelection(newValue);
                                }
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildStatsdash() {
    // Pass controller if not globally accessible
    return Obx(() {
      // Wrap the return value with Obx
      if (controller.isStatsLoading.value) {
        // Check the isLoading status
        return Center(child: CustomLoader()); // Show loader if loading
      } else {
        // Show the main content if not loading
        // Add a null check for dashboardData before accessing its properties
        if (controller.dashboardData.value == null) {
          // Handle the case where data is not loaded yet but isLoading is false
          // Maybe show an error message or an empty state
          return Center(child: Text('No data available'));
        }
        // Original Column structure
        return SingleChildScrollView(
          // Added SingleChildScrollView to prevent overflow
          child: Column(
            children: [
              buildPerformanceMeter(PerformanceMetrics(
                // Use null-aware operators or ensure data is not null here
                completedTask: double.tryParse(controller
                        .dashboardData.value!.completedTasksPercentage
                        .toString()) ??
                    0.0, // Provide default value on parse failure
                leadGenerated: double.tryParse(controller
                        .dashboardData.value!.leadGeneratedPercentage
                        .toString()) ??
                    0.0, // Provide default value
                salesAchieved: double.tryParse(controller
                        .dashboardData.value!.salesAchievedPercentage
                        .toString()) ??
                    0.0, // Provide default value
              )),
              PerformanceAnalysisChart(
                // Ensure performanceTracking is not null
                performanceData:
                    controller.dashboardData.value!.performanceTracking ??
                        [], // Provide default empty list
              ),
              BuildStats(), // Assuming this widget handles its own state/data
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    BuildLeadPriorityChartSyncfusion(), // Assuming this widget handles its own state/data
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    BuildTaskOverview(), // Assuming this widget handles its own state/data
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    BuildExpenseOverviewChart(), // Assuming this widget handles its own state/data
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    BuildLeadsByStageChart(), // Assuming this widget handles its own state/data
              )
            ],
          ),
        );
      }
    });
  }

  void _handleDateRangeSelection(String filter) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (filter) {
      case 'Last 30 Days':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 'Last 60 Days':
        startDate = now.subtract(const Duration(days: 60));
        break;
      case 'Last 90 Days':
        startDate = now.subtract(const Duration(days: 90));
        break;
      default:
        startDate = now.subtract(const Duration(days: 30));
    }

    // Call your data fetching method
    controller.fetchFilteredData(startDate: startDate, endDate: now);
  }

  Future<void> _showCustomDateRangeBottomSheet(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Date Range',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Start Date Selection
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startDate == null
                                ? 'Select Start Date'
                                : 'Start: ${startDate!.day}/${startDate!.month}/${startDate!.year}',
                            style: TextStyle(
                              color: startDate == null
                                  ? Colors.grey[600]
                                  : Colors.black,
                            ),
                          ),
                          Icon(Icons.calendar_today, color: Colors.deepPurple),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // End Date Selection
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: startDate ?? DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            endDate == null
                                ? 'Select End Date'
                                : 'End: ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                            style: TextStyle(
                              color: endDate == null
                                  ? Colors.grey[600]
                                  : Colors.black,
                            ),
                          ),
                          Icon(Icons.calendar_today, color: Colors.deepPurple),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Apply Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: (startDate != null && endDate != null)
                        ? () {
                            controller.selectedFilter.value =
                                'Last 30 Days'; // Reset to a predefined value
                            controller.isCustomDateRange.value = true;
                            controller.customDateRangeLabel.value =
                                'Custom: ${startDate!.day}/${startDate!.month} - ${endDate!.day}/${endDate!.month}';

                            controller.fetchFilteredData(
                                startDate: startDate!, endDate: endDate!);

                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget BuildLeadsByStageChart() {
    // Assume this function fetches and prepares your data
    final List<Map<String, dynamic>> leadStageData = prepareLeadStagesData();

    // --- Calculate Dynamic Axis Values ---
    double maxLeadsCount = 0;

    if (leadStageData.isNotEmpty) {
      // Find the maximum leadsCount value from the data
      // Ensure type safety when accessing 'leadsCount'
      maxLeadsCount = leadStageData
          .map<double>((data) =>
              (data['leadsCount'] as num?)?.toDouble() ??
              0.0) // Safely cast and handle null
          .reduce(max); // Find the maximum value
    }

    // Determine a suitable maximum for the Y-axis:
    // Add some padding (e.g., 15%) and round up to a nice number (e.g., nearest 10)
    final double yAxisMaximum = (maxLeadsCount * 1.15 / 10).ceil() * 10;

    // Ensure a minimum axis height if all counts are 0 or data is empty
    final double finalYAxisMaximum =
        (yAxisMaximum > 0) ? yAxisMaximum : 10; // Default max 10

    // Calculate a suitable interval (aim for around 5 intervals/labels on the axis)
    // Ensure the interval is at least 1, even for small maximums
    final double yAxisInterval =
        (finalYAxisMaximum / 5).ceilToDouble().clamp(1.0, double.infinity);

    return LayoutBuilder(
      builder: (context, constraints) {
        // --- Handle Empty Data ---
        // It's better to show a message than an empty chart
        if (leadStageData.isEmpty) {
          return Container(
            height: 250, // Give the placeholder a height similar to the chart
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              // Use similar decoration for consistency
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'No lead stage data available.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          );
        }

        // --- Build Chart ---
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize
                .min, // Important for Column in potentially unbounded height
            children: [
              Text(
                'Number of Leads by Stages',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16.0),
              // Use AspectRatio to give the chart a defined size relative to width
              AspectRatio(
                aspectRatio:
                    1.8, // Adjust aspect ratio for bar chart (often wider than tall)
                child: SfCartesianChart(
                  // X Axis (Category - Lead Stages)
                  primaryXAxis: CategoryAxis(
                    isInversed: true, // Stages listed top-to-bottom
                    majorGridLines: const MajorGridLines(
                        width: 0), // Hide grid lines for cleaner look
                    axisLine: const AxisLine(width: 0), // Hide axis line itself
                    labelStyle: const TextStyle(color: Colors.black54),
                  ),
                  // Y Axis (Numeric - Lead Count)
                  primaryYAxis: NumericAxis(
                    minimum: 0, // Minimum is always 0 for counts
                    maximum:
                        finalYAxisMaximum, // Use dynamically calculated maximum
                    interval:
                        yAxisInterval, // Use dynamically calculated interval
                    axisLine: const AxisLine(width: 0), // Hide axis line
                    majorTickLines:
                        const MajorTickLines(size: 0), // Hide tick marks
                    labelStyle: const TextStyle(color: Colors.black54),
                  ),
                  // Series (The actual bars)
                  series: <BarSeries<Map<String, dynamic>, String>>[
                    BarSeries<Map<String, dynamic>, String>(
                      dataSource: leadStageData,
                      // Use safe casting and provide defaults for potentially null values
                      xValueMapper: (data, _) =>
                          data['stage'] as String? ?? 'Unknown',
                      yValueMapper: (data, _) =>
                          (data['leadsCount'] as num?)?.toDouble() ?? 0.0,
                      pointColorMapper: (data, _) =>
                          data['color'] as Color?, // Allow null color
                      name: 'Leads', // Used in tooltip/legend if enabled
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition
                            .outside, // Position labels outside bars
                        textStyle: TextStyle(
                            fontSize: 10,
                            color: Colors.black87), // Customize label style
                      ),
                      enableTooltip: true,
                      borderRadius: const BorderRadius.only(
                          // Optional: Rounded corners for bars
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      width:
                          0.7, // Optional: Adjust bar width (fraction of available space)
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: '', // Remove default header ('Leads')
                    format: 'point.x : point.y Leads', // Customize tooltip text
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // Add alpha value if not provided
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  // Calculate the maximum Y-axis value based on the data
  double calculateMaximumYAxis(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 10; // Default maximum

    int maxValue = data
        .map((item) => item['leadsCount'] as int)
        .reduce((max, value) => max > value ? max : value);

    // Add 10% padding to the maximum value to ensure bars don't touch the top
    return (maxValue * 1.1).ceilToDouble();
  }

  List<Map<String, dynamic>> prepareLeadStagesData() {
    final leadStagesFunnelData =
        controller.dashboardData.value!.leadStagesFunnelData;

    List<Map<String, dynamic>> result = [];
    for (int i = 0; i < leadStagesFunnelData.labels.length; i++) {
      // Convert hex color to Color object
      Color color = hexToColor(leadStagesFunnelData.colors[i]);

      result.add({
        'stage': leadStagesFunnelData.labels[i],
        'leadsCount': leadStagesFunnelData.values[i],
        'color': color,
      });
    }

    return result;
  }

  Widget BuildStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 3;
          double cardAspectRatio = 2.0;

          if (constraints.maxWidth < 600) {
            crossAxisCount = 2;
            cardAspectRatio = 1.5;
          } else if (constraints.maxWidth < 900) {
            crossAxisCount = 3;
            cardAspectRatio = 2.0;
          } else {
            crossAxisCount = 3;
            cardAspectRatio = 2.5;
          }

          return Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lead Analytics Overview',
                  style: TextStyle(
                    fontSize: 20.0, // Slightly larger title
                    fontWeight: FontWeight.w600, // Semi-bold title
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 20.0), // Increased spacing
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: cardAspectRatio,
                  children: [
                    _buildStatCard(
                      icon: Icons.person_add_alt_1_rounded,
                      iconColor: Colors.orange,
                      title: 'New Lead',
                      value: controller.dashboardData.value!.newLeadCount
                          .toString(),
                    ),
                    _buildStatCard(
                      icon: Icons.trending_up_rounded,
                      iconColor: Colors.blue,
                      title: 'Active Lead',
                      value: controller.dashboardData.value!.activeLeadCount
                          .toString(),
                    ),
                    _buildStatCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: Colors.green,
                      title: 'Qualified Lead',
                      value: controller.dashboardData.value!.qualifiedLeadCount
                          .toString(),
                    ),
                    _buildStatCard(
                      icon: Icons.cancel_rounded,
                      iconColor: Colors.redAccent,
                      title: 'Disqualified Lead',
                      value: controller
                          .dashboardData.value!.disqualifiedLeadCount
                          .toString(),
                    ),
                    _buildStatCard(
                      icon: Icons.wallet_rounded,
                      iconColor: Colors.green,
                      title: 'Qualified Budget',
                      value: controller.dashboardData.value!.qualifiedBudget
                          .toString(),
                    ),
                    _buildStatCard(
                      icon: Icons.money_off_rounded,
                      iconColor: Colors.redAccent,
                      title: 'Disqualified Budget',
                      value: controller.dashboardData.value!.disqualifiedBudget
                          .toString(),
                    ),
                    _buildStatCard(
                      icon: Icons.track_changes_rounded,
                      iconColor: Colors.blue,
                      title: 'Target Sale',
                      value:
                          controller.dashboardData.value!.targetSale.toString(),
                    ),
                    _buildStatCard(
                      icon: Icons.show_chart_rounded,
                      iconColor: Colors.blue,
                      title: 'Actual Sales',
                      value: controller.dashboardData.value!.actualSales
                          .toString(),
                    ),
                    const SizedBox(), // Placeholder
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Card(
      // Using Card widget for built-in elevation and rounded corners
      elevation: 4.0, // Subtle shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.white, // Lighter background
      child: Padding(
        padding:
            const EdgeInsets.all(10.0), // Increased padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  // Background for the icon
                  // padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: iconColor
                        .withOpacity(0.2), // Lighter shade of icon color
                    borderRadius:
                        BorderRadius.circular(8.0), // Rounded background
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 16.0, // Slightly larger icon
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.0, // Slightly larger title
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.0, // Slightly larger value
                fontWeight: FontWeight.w600, // Semi-bold value
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? colorString) {
    // Default color if input is null or invalid
    const defaultColor = Colors.grey;
    if (colorString == null || colorString.isEmpty) {
      print('Null or empty color string received. Using default.');
      return defaultColor;
    }

    // Trim whitespace for robustness
    colorString = colorString.trim();

    // 1. Check for HEX format (#RRGGBB or #AARRGGBB)
    if (colorString.startsWith('#')) {
      if (colorString.length == 7 || colorString.length == 9) {
        // #RRGGBB or #AARRGGBB
        try {
          final buffer = StringBuffer();
          if (colorString.length == 7)
            buffer
                .write('ff'); // Add alpha if missing (treat #RRGGBB as opaque)
          buffer.write(colorString.substring(1)); // Remove '#'
          return Color(int.parse(buffer.toString(), radix: 16));
        } catch (e) {
          print('Error parsing HEX color "$colorString": $e. Using default.');
          return defaultColor;
        }
      } else {
        print(
            'Invalid HEX color format: "$colorString". Length should be 7 or 9. Using default.');
        return defaultColor;
      }
    }
    // 2. Check for RGBA format (rgba(r, g, b, a))
    //    Case-insensitive check for 'rgba('
    else if (colorString.toLowerCase().startsWith('rgba(') &&
        colorString.endsWith(')')) {
      try {
        // Find the indices of '(' and ')'
        final startIndex = colorString.indexOf('(') + 1;
        final endIndex = colorString.lastIndexOf(')');

        // Extract the numbers part: e.g., "255, 99, 132, 0.8"
        final valueString = colorString.substring(startIndex, endIndex);
        final parts = valueString.split(',');

        if (parts.length == 4) {
          // Parse R, G, B as integers, A as double
          final r = int.parse(parts[0].trim());
          final g = int.parse(parts[1].trim());
          final b = int.parse(parts[2].trim());
          final a = double.parse(parts[3].trim());

          // Clamp values to valid ranges
          final int rClamped = r.clamp(0, 255);
          final int gClamped = g.clamp(0, 255);
          final int bClamped = b.clamp(0, 255);
          final double aClamped = a.clamp(0.0, 1.0);

          if (r != rClamped ||
              g != gClamped ||
              b != bClamped ||
              a != aClamped) {
            print(
                'Warning: Clamping RGBA values from "$colorString" to fit valid range.');
          }

          // Use Color.fromRGBO which takes int for R,G,B (0-255) and double for opacity (0.0-1.0)
          return Color.fromRGBO(rClamped, gClamped, bClamped, aClamped);
        } else {
          print(
              'Invalid RGBA format (expected 4 parts): "$colorString". Using default.');
          return defaultColor;
        }
      } catch (e) {
        print('Error parsing RGBA color "$colorString": $e. Using default.');
        return defaultColor;
      }
    }
    // (Optional) Add support for rgb(R, G, B) if needed, treating alpha as 1.0
    else if (colorString.toLowerCase().startsWith('rgb(') &&
        colorString.endsWith(')')) {
      try {
        final startIndex = colorString.indexOf('(') + 1;
        final endIndex = colorString.lastIndexOf(')');
        final valueString = colorString.substring(startIndex, endIndex);
        final parts = valueString.split(',');
        if (parts.length == 3) {
          final r = int.parse(parts[0].trim()).clamp(0, 255);
          final g = int.parse(parts[1].trim()).clamp(0, 255);
          final b = int.parse(parts[2].trim()).clamp(0, 255);
          return Color.fromRGBO(r, g, b, 1.0); // Full opacity
        } else {
          print(
              'Invalid RGB format (expected 3 parts): "$colorString". Using default.');
          return defaultColor;
        }
      } catch (e) {
        print('Error parsing RGB color "$colorString": $e. Using default.');
        return defaultColor;
      }
    }

    // 3. If none of the above formats match
    else {
      print(
          'Unknown or invalid color string format: "$colorString". Using default.');
      return defaultColor;
    }
  }

  Widget BuildLeadPriorityChartSyncfusion() {
    // 1. Access the Data (replace 'controller' with your actual controller instance)
    final leadData = controller.dashboardData.value?.leadPriorityData;

    // Print the raw data for debugging (optional)
    // print('Raw LeadPriorityData: ${leadData?.labels}, ${leadData?.values}, ${leadData?.colors}');

    // 2. Handle Null/Empty Data
    if (leadData == null ||
        leadData.labels.isEmpty ||
        leadData.values.isEmpty) {
      // Show a loading indicator or an empty state message
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          // Or use a CircularProgressIndicator() if data is loading
          child: Text(
            'Lead priority data is not available.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // 3. Transform Data
    final List<_ChartData> chartData = [];
    for (int i = 0; i < leadData.labels.length; i++) {
      // Ensure we don't go out of bounds if lists have different lengths
      if (i < leadData.values.length) {
        final label = leadData.labels[i];
        final value = leadData.values[i];
        final colorString =
            leadData.colors[label]; // Get color hex string from map
        final color = _parseColor(colorString); // Convert hex string to Color

        // Optional: Skip data points with zero value if you don't want them in the chart
        // if (value > 0) {
        chartData.add(_ChartData(label, value, color));
        // }
      } else {
        // Log a warning if lists are mismatched
        print(
            'Warning: Mismatch between labels and values length. Skipping label: ${leadData.labels[i]}');
      }
    }

    // Handle case where processing resulted in empty data (e.g., all values were 0 and skipped)
    if (chartData.isEmpty) {
      return Container(
        // Or similar empty state container
        padding: const EdgeInsets.all(16.0),
        child: const Center(child: Text('No valid chart data to display.')),
      );
    }

    // Calculate total *after* filtering/transforming data
    final totalLeads = chartData.fold(0, (sum, data) => sum + data.y);

    // 4. Use Transformed Data in the Widget
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Number of Leads by Priority',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16.0),
          AspectRatio(
            aspectRatio: 1.6,
            child: SfCircularChart(
              series: <CircularSeries<_ChartData, String>>[
                DoughnutSeries<_ChartData, String>(
                  // Use the dynamically generated chartData
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x, // Label
                  yValueMapper: (_ChartData data, _) => data.y, // Value
                  pointColorMapper: (_ChartData data, _) => data.color, // Color
                  innerRadius: '60%',
                  radius: '80%',
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    // Display label and percentage, for example
                    labelIntersectAction:
                        LabelIntersectAction.shift, // Avoid overlap
                    connectorLineSettings: ConnectorLineSettings(
                      // length: '10%', // Adjust connector length if needed
                      color: Colors.grey,
                      type: ConnectorType.curve,
                    ),
                    // Customize label format if needed:
                    // format: '{point.x}: {point.percentage}%',
                    textStyle:
                        TextStyle(fontSize: 10), // Adjust label font size
                  ),
                  enableTooltip: true,
                )
              ],
              // Optional: Add a title within the chart center
              // annotations: <CircularChartAnnotation>[
              //   CircularChartAnnotation(
              //     widget: Container(
              //       child: Text(
              //         '$totalLeads\nTotal',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(color: Colors.grey[600], fontSize: 14)
              //       )
              //     )
              //   )
              // ]
            ),
          ),
          const SizedBox(height: 16.0),
          // Use the dynamically generated chartData for the legend
          Wrap(
            spacing: 12.0, // Increased spacing
            runSpacing: 8.0, // Increased spacing
            alignment: WrapAlignment.center,
            children: chartData.map((data) {
              // Calculate percentage safely
              final percentage =
                  totalLeads > 0 ? (data.y / totalLeads * 100).toDouble() : 0.0;
              // Ensure _buildLegendItemSyncfusion uses the dynamic data
              return _buildLegendItemSyncfusion(
                  data.color, data.x, data.y, percentage);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItemSyncfusion(
      Color color, String text, int count, double percentage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$text : $count (${percentage.toStringAsFixed(1)} %)',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget BuildTaskOverview() {
    final int totalTasks = int.tryParse(
            controller.dashboardData.value?.totalTasks?.toString() ?? '') ??
        0;

    final int completedTasks = int.tryParse(
            controller.dashboardData.value?.completedTasksCount?.toString() ??
                '') ??
        0;

    final int pendingTasks = int.tryParse(
            controller.dashboardData.value?.pendingTasksCount?.toString() ??
                '') ??
        0;

    final int overdueTasks = int.tryParse(
            controller.dashboardData.value?.overdueTasksCount?.toString() ??
                '') ??
        0;

// ... rest of your BuildTaskOverview widget remains the same ...

    final double completionPercentage =
        totalTasks > 0 ? completedTasks.toDouble() / totalTasks : 0.0;

    // Now totalTasks and completedTasks are guaranteed to be non-null ints.
    // Ensure floating-point division by converting one operand to double.

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Overview and Analytics',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16.0),
              if (isSmallScreen)
                Column(
                  children: [
                    _buildCircularProgress(completionPercentage),
                    const SizedBox(height: 16.0),
                    _buildTaskInfoGrid(totalTasks!, completedTasks,
                        pendingTasks, overdueTasks),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align items to the start vertically
                  children: [
                    _buildCircularProgress(completionPercentage),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: _buildTaskInfoGrid(totalTasks!, completedTasks,
                            pendingTasks, overdueTasks),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularProgress(double completionPercentage) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: completionPercentage,
            strokeWidth: 8.0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(completionPercentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Complete',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInfoGrid(
      int totalTasks, int completedTasks, int pendingTasks, int overdueTasks) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: _buildTaskInfo(Icons.list_alt_rounded, 'Total Tasks',
                    totalTasks.toString(), Colors.blue)),
            const SizedBox(width: 8.0),
            Expanded(
                child: _buildTaskInfo(
                    Icons.check_circle_outline_rounded,
                    'Completed Tasks',
                    completedTasks.toString(),
                    Colors.green)),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: _buildTaskInfo(Icons.hourglass_empty_rounded,
                    'Pending Tasks', pendingTasks.toString(), Colors.orange)),
            const SizedBox(width: 8.0),
            Expanded(
                child: _buildTaskInfo(
                    Icons.warning_amber_rounded,
                    'Overdue Tasks',
                    overdueTasks.toString(),
                    Colors.redAccent)),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskInfo(
      IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget BuildExpenseOverviewChart() {
    // Get the data from the controller
    final expenseComparisonData =
        controller.dashboardData.value?.expenseComparisonData;

    // --- Data Transformation ---
    List<_ExpenseData> chartData = [];
    double maxYValue = 0;

    if (expenseComparisonData != null &&
        expenseComparisonData.labels.isNotEmpty &&
        expenseComparisonData.allocatedBudget.length ==
            expenseComparisonData.labels.length &&
        expenseComparisonData.actualExpenses.length ==
            expenseComparisonData.labels.length) {
      for (int i = 0; i < expenseComparisonData.labels.length; i++) {
        final label = expenseComparisonData.labels[i];
        final allocated = expenseComparisonData.allocatedBudget[i];
        final actual = expenseComparisonData.actualExpenses[i];
        chartData.add(_ExpenseData(label, allocated, actual));
        maxYValue = max(maxYValue, max(allocated, actual));
      }
    }

    // --- Calculate Y-Axis Max/Interval ---
    final double yAxisMaximum = (maxYValue * 1.15 / 5000).ceil() * 5000;
    final double finalYAxisMaximum =
        yAxisMaximum > 0 ? yAxisMaximum : 5000; // Min height 5000
    final double yAxisInterval =
        (finalYAxisMaximum / 5).ceilToDouble(); // ~5 intervals

    // --- Widget Build ---
    return LayoutBuilder(
      builder: (context, constraints) {
        // Handle loading and empty states
        if (expenseComparisonData == null) {
          // You might want a placeholder with a fixed height here too
          return const SizedBox(
              height: 250, child: Center(child: CircularProgressIndicator()));
        }
        if (chartData.isEmpty) {
          // Give the placeholder a defined height
          return const SizedBox(
              height: 100,
              child:
                  Center(child: Text('No expense overview data available.')));
        }

        // --- Build the Chart Container ---
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            // This Column needs a defined height OR its children shouldn't use Expanded
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Allow column to shrink to content size
            children: [
              // --- Chart Title ---
              Text(
                'Expense Overview',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16.0),

              // --- Chart ---
              // Use AspectRatio instead of Expanded
              AspectRatio(
                aspectRatio: 1.7, // Adjust this value as needed for your layout
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLine: const AxisLine(width: 0),
                    labelStyle: const TextStyle(color: Colors.black54),
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: finalYAxisMaximum,
                    interval: yAxisInterval,
                    labelFormat: '{value}',
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    labelStyle: const TextStyle(color: Colors.black54),
                  ),
                  series: <ColumnSeries<_ExpenseData, String>>[
                    ColumnSeries<_ExpenseData, String>(
                      dataSource: chartData,
                      xValueMapper: (_ExpenseData data, _) => data.expenseType,
                      yValueMapper: (_ExpenseData data, _) =>
                          data.allocatedBudget,
                      name: 'Allocated Budget',
                      color: Colors.lightBlueAccent.withOpacity(0.8),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      width: 0.7,
                      spacing: 0.2,
                    ),
                    ColumnSeries<_ExpenseData, String>(
                      dataSource: chartData,
                      xValueMapper: (_ExpenseData data, _) => data.expenseType,
                      yValueMapper: (_ExpenseData data, _) =>
                          data.actualExpenses,
                      name: 'Actual Expenses',
                      color: Colors.pinkAccent.withOpacity(0.8),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      width: 0.7,
                      spacing: 0.2,
                    ),
                  ],
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    orientation: LegendItemOrientation.horizontal,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: '',
                    canShowMarker: false,
                    format: 'point.x : point.y',
                  ),
                ),
              ), // End AspectRatio
            ],
          ),
        );
      },
    );
  }

  Widget TaskCard() {
    return Column(
      children: [
        // Tab Bar with improved appearance and error handling
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary3Color, buttonBgColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 6),
                blurRadius: 6,
              ),
            ],
          ),
          child: Obx(() {
            try {
              return TabBar(
                controller: controller.tabController,
                padding: EdgeInsets.all(5),
                isScrollable: false,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                dividerHeight: 0,
                onTap: (index) {
                  controller.pageController.jumpToPage(index);
                  final tabType = index == 0
                      ? 'Today'
                      : (index == 1 ? 'Upcoming' : 'Overdue');
                  controller.fetchTasksByTab(tabType);
                  controller.fetchDashboardCount();
                },
                tabs: [
                  Tab(
                    text: controller.isLoading.value
                        ? 'Today'
                        : 'Today ${controller.todayCount.value > 0 ? '(${controller.todayCount.value})' : ''}',
                  ),
                  Tab(
                    text: controller.isLoading.value
                        ? 'Upcoming'
                        : 'Upcoming ${controller.upcomingCount.value > 0 ? '(${controller.upcomingCount.value})' : ''}',
                  ),
                  Tab(
                    text: controller.isLoading.value
                        ? 'Overdue'
                        : 'Overdue ${controller.overdueCount.value > 0 ? '(${controller.overdueCount.value})' : ''}',
                  ),
                ],
              );
            } catch (e) {
              // Fallback tab bar if there are issues
              return Center(
                child: Text(
                  "Error loading tabs: ${e.toString()}",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }),
        ),
        // PageView for swiping between task types
        Expanded(
          child: PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.tabController.animateTo(index);
              final tabType =
                  index == 0 ? 'Today' : (index == 1 ? 'Upcoming' : 'Overdue');
              controller.fetchTasksByTab(tabType);
              controller.fetchDashboardCount();
            },
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchTasksByTab("Today");
                  await controller.fetchDashboardCount();
                },
                child: buildTaskList("Today"),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchTasksByTab("Upcoming");
                  await controller.fetchDashboardCount();
                },
                child: buildTaskList("Upcoming"),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchTasksByTab("Overdue");
                  await controller.fetchDashboardCount();
                },
                child: buildTaskList("Overdue"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildTaskList([String tabType = "Today"]) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      padding: EdgeInsets.only(top: 0, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(tabType),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CustomLoader(),
                );
              }

              if (controller.tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No tasks available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return CustomTaskCard(
                    taskType: task.entrytype ?? "",
                    date:
                        controller.formatDate(task.createdDateTime.toString()),
                    assigneeName: task.cname ?? "",
                    onNameTap: () {
                      Get.to(() => TaskDetailPage(), arguments: {
                        "taskId": task.id,
                      })!
                          .then((_) {
                        controller.fetchTasksByTab(tabType);
                      });
                    },
                    onCheckboxChanged: (bool? value) =>
                        controller.onCheckboxChanged(index, value, task.id!),
                    isChecked: task.isChecked,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String tabType) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$tabType tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black54),
              color: Colors.white,
              enabled: controller.selected.isNotEmpty,
              tooltip: controller.selected.isEmpty
                  ? "Select tasks to perform actions"
                  : "Actions for selected tasks",
              onSelected: (value) async {
                try {
                  List<Map<String, dynamic>> body =
                      controller.selected.map((taskId) {
                    return {
                      "Taskid": taskId.toString(),
                      "ACTIVITYSTATUS":
                          value == 'Mark as Completed' ? "Completed" : "Cancel",
                      "UserID": controller.box.read("userId"),
                    };
                  }).toList();

                  await controller.postStatus(body);
                  await controller.fetchTasksByTab(tabType);
                  await controller.fetchDashboardCount();
                  controller.selected.clear();

                  Get.snackbar(
                    "Success",
                    "Tasks updated successfully",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Failed to update tasks: ${e.toString()}",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Mark as Completed', 'Mark as Cancel'}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton(void Function() onpress) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onpress,
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          textStyle: TextStyle(fontSize: 14),
        ),
        child: Text("View All"),
      ),
    );
  }

  Widget LeadCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaders(),
        _buildLeadListSection(),
        _buildViewAllButton(() => Get.toNamed(Routes.LEAD_LIST)),
      ],
    );
  }

  Widget _buildHeaders() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: popupColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.people_alt, color: Colors.white, size: 20),
              SizedBox(width: 8),
              const Text(
                'Latest Leads',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            color: Colors.white,
            tooltip: 'Filter Leads',
            onSelected: (value) => _onMenuSelection(context, value),
            itemBuilder: (BuildContext context) =>
                {'Lead Date', 'Follow-Up Date'}
                    .map(
                      (String choice) => PopupMenuItem<String>(
                        value: choice,
                        child: Row(
                          children: [
                            Icon(
                              choice == 'Lead Date'
                                  ? Icons.calendar_today
                                  : Icons.event_repeat,
                              size: 18,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(choice),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget buildPerformanceMeter(PerformanceMetrics metrics) {
    final overallScore = metrics.calculateOverallScore();

    Color _getScoreColor(double score) {
      if (score < 30) return Colors.red;
      if (score < 60) return Colors.orange;
      return Colors.green;
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Gauge Container
            Container(
              width: 300,
              height: 150,
              child: CustomPaint(
                painter: GaugePainter(
                  score: overallScore,
                  backgroundColor: Colors.grey.shade300,
                  activeColor: _getScoreColor(overallScore),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${overallScore.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(overallScore),
                        ),
                      ),
                      Text(
                        'Overall Score',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Performance Details
            Column(
              children: [
                _buildDetailRow('Completed Task', metrics.completedTask),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildDetailRow('Lead Generated', metrics.leadGenerated),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildDetailRow('Sales Achieved', metrics.salesAchieved),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, double percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Spacer(),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadListSection() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CustomLoader());
          }

          if (controller.leads.isEmpty) {
            return _buildEmptyState();
          }

          return _buildLeadList();
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.person_search, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No leads available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadList() {
    return RefreshIndicator(
      onRefresh: () async {
        // Add refresh functionality
        await controller.fetchAssignedLead();
      },
      child: ListView.builder(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.leads.length,
        itemBuilder: (context, index) =>
            _buildLeadItem(controller.leads[index]),
      ),
    );
  }

  Widget _buildLeadItem(LeadList lead) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.leadDetail, arguments: lead.leadId),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeadName(lead),
              _buildLeadDate(lead),
              _buildLeadStatus(lead),
              _buildPriorityBadge(lead),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadName(LeadList lead) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lead.name,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (lead.phone.isNotEmpty)
            Text(
              lead.phone,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
        ],
      ),
    );
  }

  Widget _buildLeadDate(LeadList lead) {
    return Expanded(
      flex: 2,
      child: Text(
        controller.formatDate(lead.vdate),
        style: const TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildLeadStatus(LeadList lead) {
    return Expanded(
      flex: 2,
      child: Text(
        lead.leadStatus,
        style: const TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildPriorityBadge(LeadList lead) {
    // Check if priority is not empty before showing badge
    if (lead.priority.isEmpty) {
      return Expanded(flex: 1, child: Container());
    }

    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: _getBadgeColor(lead.priority),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          lead.priority,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

// Utility function to get badge color based on lead type
  Color _getBadgeColor(String leadType) {
    switch (leadType.toLowerCase()) {
      case 'cold':
        return Colors.blue;
      case 'warm':
        return Colors.orange;
      case 'hot':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _onMenuSelection(BuildContext context, String value) {
    if (value == 'Lead Date') {
      _selectLeadDate(context, value);
    }
    if (value == 'Follow-Up Date') {
      _selectFollowUpDate(context, value);
    }
  }

  Future<void> _selectLeadDate(BuildContext context, String menuType) async {
    // Open a bottom sheet for date selection
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          // height: 300, // Set height for the bottom sheet
          child: Column(
            children: [
              Text(
                'Select Date Range',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // From Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomField(
                      withShadow: true,
                      labelText: "From Date",
                      hintText: "Select Start date",
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.datetime,
                      showLabel: true,
                      bgColor: Colors.white,
                      enabled: true,
                      readOnly: true,
                      editingController: controller.fromDateController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      onFieldTap: () {
                        Get.bottomSheet(
                          CustomDatePicker(
                            pastAllow: true,
                            confirmHandler: (date) async {
                              controller.fromDateController.text = date ?? "";
                              controller.fromDateController.text = date ?? "";
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Up To Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomField(
                      withShadow: true,
                      labelText: "To Date",
                      hintText: "Select end date",
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.datetime,
                      showLabel: true,
                      bgColor: Colors.white,
                      enabled: true,
                      readOnly: true,
                      editingController: controller.toDateController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      onFieldTap: () {
                        Get.bottomSheet(
                          CustomDatePicker(
                            pastAllow: true,
                            confirmHandler: (date) async {
                              controller.toDateController.text = date ?? "";
                              controller.toDateController.text = date ?? "";
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // print("The date is ${controller.fromDateController.text}");
                  controller.fetchAssignedLead(
                      fromDate: controller.fromDateController.text,
                      toDate: controller.toDateController.text);
                  Get.back();
                  controller.fromDateController.clear();
                  controller.toDateController.clear();
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectFollowUpDate(
      BuildContext context, String menuType) async {
    // Open a bottom sheet for date selection
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          // height: 300, // Set height for the bottom sheet
          child: Column(
            children: [
              Text(
                'Select Date Range',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // From Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomField(
                      withShadow: true,
                      labelText: "From Date",
                      hintText: "Select Start date",
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.datetime,
                      showLabel: true,
                      bgColor: Colors.white,
                      enabled: true,
                      readOnly: true,
                      editingController: controller.fromDateController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      onFieldTap: () {
                        Get.bottomSheet(
                          CustomDatePicker(
                            pastAllow: true,
                            confirmHandler: (date) async {
                              controller.fromDateController.text = date ?? "";
                              controller.fromDateController.text = date ?? "";
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Up To Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomField(
                      withShadow: true,
                      labelText: "To Date",
                      hintText: "Select end date",
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.datetime,
                      showLabel: true,
                      bgColor: Colors.white,
                      enabled: true,
                      readOnly: true,
                      editingController: controller.toDateController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      onFieldTap: () {
                        Get.bottomSheet(
                          CustomDatePicker(
                            pastAllow: true,
                            confirmHandler: (date) async {
                              controller.toDateController.text = date ?? "";
                              controller.toDateController.text = date ?? "";
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // print("The date is ${controller.fromDateController.text}");

                  controller.fetchAssignedLead(
                      fromDate: controller.fromDateController.text,
                      toDate: controller.toDateController.text);
                  Get.back();
                  // controller.fromDateController.clear();
                  // controller.toDateController.clear();
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget adminPanel(AdminPanelController controller) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
            children: [
              StatCard(
                title: "Total Leads",
                value: "2,456",
                icon: Icons.people_alt,
                color: Colors.blue,
              ),
              StatCard(
                title: "Lost Leads",
                value: "145",
                icon: Icons.remove_circle,
                color: Colors.red,
              ),
              StatCard(
                title: "Total Amount",
                value: "₹45.2M",
                icon: Icons.monetization_on,
                color: Colors.green,
              ),
              StatCard(
                title: "Lost Amount",
                value: "₹5.8M",
                icon: Icons.money_off,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Lead Potential Chart
          SizedBox(
            height: 400,
            child: DashboardCard(
              title: "Leads Potential",
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  DoughnutSeries<Map<String, dynamic>, String>(
                    dataSource: controller.leadsData,
                    xValueMapper: (data, _) =>
                        "${data['label']} (${data['value']})",
                    yValueMapper: (data, _) => data['value'],
                    pointColorMapper: (data, _) => data['color'],
                    innerRadius: '70%',
                  ),
                ],
                annotations: [
                  CircularChartAnnotation(
                    widget: TotalDisplay(
                      total: controller.leadsData
                          .map((e) => e['value'] as int? ?? 0)
                          .reduce((a, b) => a + b),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Current Month Conversion Rate
          SizedBox(
            height: 400,
            child: DashboardCard(
              title: "Current Month Conversion Rate",
              child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}%',
                  minimum: 0,
                  maximum: 100,
                ),
                series: [
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: controller.conversionData,
                    xValueMapper: (data, _) => data['label'],
                    yValueMapper: (data, _) => data['value'],
                    pointColorMapper: (data, _) => data['color'],
                    borderRadius: BorderRadius.circular(8),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Top 5 Leads by Salesman
          SizedBox(
            height: 300,
            child: DashboardCard(
              title: "Top 5 Leads by Salesman",
              child: ListView.builder(
                itemCount: controller.topSalesmanLeads.length,
                itemBuilder: (context, index) {
                  final item = controller.topSalesmanLeads[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Text('${index + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          '₹${item['amount']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Top 5 Salesmen
          SizedBox(
            height: 300,
            child: DashboardCard(
              title: "Top 5 Salesmen",
              child: ListView.builder(
                itemCount: controller.topSalesmen.length,
                itemBuilder: (context, index) {
                  final item = controller.topSalesmen[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(item['avatar']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${item['deals']} deals',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${item['amount']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // State-wise Sales
          SizedBox(
            height: 400,
            child: DashboardCard(
              title: "State-wise Sales",
              child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Sales (in Millions)'),
                ),
                series: [
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: controller.stateSales,
                    xValueMapper: (data, _) => data['state'],
                    yValueMapper: (data, _) => data['sales'],
                    pointColorMapper: (data, _) => data['color'],
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Top 5 Products
          SizedBox(
            height: 400,
            child: DashboardCard(
              title: "Top 5 Hot Selling Products",
              child: ListView.builder(
                itemCount: controller.topProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.topProducts[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.purple.withOpacity(0.2)),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${product['units']} units sold',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${product['revenue']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
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
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(EmployeeDetail());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class TotalDisplay extends StatelessWidget {
  final int total;

  const TotalDisplay({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$total\nTotal',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TaskCards extends StatelessWidget {
  final HomeController controller;

  TaskCards({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(child: _buildPageView()),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(Get.context!).primaryColor, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: const Offset(0, 3),
            blurRadius: 4,
          ),
        ],
      ),
      child: TabBar(
        controller: controller.tabController,
        padding: const EdgeInsets.all(5),
        labelColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        onTap: _handleTabTap,
        tabs: _buildTabs(),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return [
      _buildTab('Today', controller.todayCount),
      _buildTab('Upcoming', controller.upcomingCount),
      _buildTab('Overdue', controller.overdueCount),
    ];
  }

  Widget _buildTab(String title, RxInt count) {
    return Tab(
      child: Obx(() => Text(
            controller.isLoading.value
                ? title
                : '$title ${count.value > 0 ? '(${count.value})' : ''}',
            style: const TextStyle(fontSize: 14),
          )),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: controller.pageController,
      onPageChanged: _handlePageChange,
      children: [
        _buildTaskListPage("Today"),
        _buildTaskListPage("Upcoming"),
        _buildTaskListPage("Overdue"),
      ],
    );
  }

  Widget _buildTaskListPage(String tabType) {
    return RefreshIndicator(
      onRefresh: () => _refreshTasks(tabType),
      child: _buildTaskListContainer(tabType),
    );
  }

  Widget _buildTaskListContainer(String tabType) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildListHeader(tabType),
          Expanded(
            child: _buildTaskListContent(tabType),
          ),
          _buildViewAllSection(),
        ],
      ),
    );
  }

  Widget _buildListHeader(String tabType) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$tabType Tasks',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          _buildHeaderActions(tabType),
        ],
      ),
    );
  }

  Widget _buildHeaderActions(String tabType) {
    return Obx(() => PopupMenuButton<String>(
          enabled: controller.selected.isNotEmpty,
          icon: Icon(
            Icons.more_vert,
            color: controller.selected.isEmpty ? Colors.grey : Colors.black87,
          ),
          onSelected: (value) => _handleMenuAction(value, tabType),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'complete',
              child: const Text('Mark as Completed'),
            ),
            PopupMenuItem(
              value: 'cancel',
              child: const Text('Mark as Cancelled'),
            ),
          ],
        ));
  }

  Widget _buildTaskListContent(String tabType) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.tasks.isEmpty) {
        return _buildEmptyState(tabType);
      }

      return ListView.builder(
        itemCount: controller.tasks.length.clamp(0, 5),
        itemBuilder: (context, index) => _buildTaskItem(
          controller.tasks[index],
          tabType,
        ),
      );
    });
  }

  Widget _buildEmptyState(String tabType) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No $tabType tasks available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(dynamic task, String tabType) {
    return CustomTaskCard(
      key: ValueKey(task.id),
      taskType: task.entrytype ?? 'Unknown',
      date: controller.formatDate(task.createdDateTime.toString()),
      assigneeName: task.cname ?? 'Unassigned',
      onNameTap: () => _navigateToTaskDetail(task, tabType),
      onCheckboxChanged: (value) =>
          controller.onCheckboxChanged(task.id!, value ?? false, task.id),
      isChecked: task.isChecked,
    );
  }

  Widget _buildViewAllSection() {
    return Obx(() => controller.tasks.isNotEmpty
        ? TextButton(
            onPressed: () => Get.to(() => AllTaskPage()),
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  // Helper Methods
  void _handleTabTap(int index) {
    controller.pageController.jumpToPage(index);
    _refreshCurrentTab(index);
  }

  void _handlePageChange(int index) {
    controller.tabController.animateTo(index);
    _refreshCurrentTab(index);
  }

  void _refreshCurrentTab(int index) {
    final tabType = _getTabType(index);
    controller.fetchTasksByTab(tabType);
    controller.fetchDashboardCount();
  }

  Future<void> _refreshTasks(String tabType) async {
    await controller.fetchTasksByTab(tabType);
    await controller.fetchDashboardCount();
  }

  String _getTabType(int index) {
    switch (index) {
      case 0:
        return 'Today';
      case 1:
        return 'Upcoming';
      case 2:
        return 'Overdue';
      default:
        return 'Today';
    }
  }

  Future<void> _handleMenuAction(String value, String tabType) async {
    final status = value == 'complete' ? 'Completed' : 'Cancel';

    try {
      controller.isLoading.value = true;
      final body = controller.selected
          .map((taskId) => {
                "Taskid": taskId.toString(),
                "ACTIVITYSTATUS": status,
                "UserID": controller.box.read("userId"),
              })
          .toList();

      controller.postStatus(body);
      await _refreshTasks(tabType);
      controller.selected.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update task status',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      controller.isLoading.value = false;
    }
  }

  void _navigateToTaskDetail(dynamic task, String tabType) {
    Get.to(
      () => TaskDetailPage(),
      arguments: {"taskId": task.id},
    )?.then((_) => controller.fetchTasksByTab(tabType));
  }
}

class GaugePainter extends CustomPainter {
  final double score;
  final Color backgroundColor;
  final Color activeColor;

  GaugePainter({
    required this.score,
    required this.backgroundColor,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final startAngle = pi;
    final sweepAngle = pi;

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Active arc
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final activeAngle = (score / 100) * sweepAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PerformanceMetrics {
  final double completedTask;
  final double leadGenerated;
  final double salesAchieved;

  PerformanceMetrics({
    required this.completedTask,
    required this.leadGenerated,
    required this.salesAchieved,
  });

  double calculateOverallScore() {
    return ((completedTask + leadGenerated + salesAchieved) / 3)
        .clamp(0.0, 100.0);
  }
}

class PerformanceAnalysisChart extends StatelessWidget {
  final List<PerformanceTracking> performanceData;

  const PerformanceAnalysisChart({
    Key? key,
    required this.performanceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle empty data case gracefully
    if (performanceData.isEmpty) {
      return Card(
        elevation: 4,
        color: Colors.white,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No performance data available.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Use ListView.separated for better spacing and handling many items
            ListView.separated(
              shrinkWrap: true, // Important when nesting ListView
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling if inside another scrollable
              itemCount: performanceData.length,
              itemBuilder: (context, index) {
                return _buildPerformanceRow(performanceData[index]);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12), // Space between rows
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to determine color based on achievement percentage
  Color _getColorForPercentage(double percentage) {
    // Clamp percentage between 0 and potentially > 1 for color logic
    percentage = percentage.clamp(0.0, double.infinity);

    if (percentage == 0) {
      return Colors.redAccent.shade400; // Specific color for zero achievement
    } else if (percentage < 0.5) {
      // Below 50%
      return Colors.red.shade400;
    } else if (percentage < 0.9) {
      // Between 50% and 89.9%
      return Colors.orange.shade400;
    } else if (percentage < 1.0) {
      // Between 90% and 99.9% (Target not yet met)
      return Colors.yellow.shade700;
    } else {
      // 100% and above (Target met or exceeded)
      return Colors.green.shade400;
    }
  }

  Widget _buildPerformanceRow(PerformanceTracking data) {
    // 1. Parse achievement and target, handle potential errors and nulls
    final int achievedValue = int.tryParse(data.achievement ?? '') ?? 0;
    final int targetValue = int.tryParse(data.target ?? '') ?? 0;

    // 2. Check if target is defined (greater than 0)
    final bool isTargetDefined = targetValue > 0;

    // 3. Calculate percentage and bar ratio *only* if target is defined
    double achievementPercentage = 0.0;
    double barRatio = 0.0; // Ratio for the bar width (0.0 to 1.0)

    if (isTargetDefined) {
      // Calculate actual percentage (can be > 1.0 if achieved > target)
      achievementPercentage = achievedValue.toDouble() / targetValue.toDouble();
      // Calculate ratio for the bar width, clamped between 0.0 and 1.0
      barRatio = achievementPercentage.clamp(0.0, 1.0);
    }

    // 4. Determine the color based on the *actual* percentage
    final Color achievedColor = _getColorForPercentage(achievementPercentage);

    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4), // Reduced vertical padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.activityName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500, // Slightly bolder
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none, // Allow potential markers outside
                children: [
                  // Background bar (represents 100% of target or just background)
                  Container(
                    height: 12, // Slightly thicker bar
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      // Use a lighter grey for background, more prominent if target is undefined
                      color: isTargetDefined
                          ? Colors.grey.shade300
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Achieved bar (only shown if target is defined)
                  if (isTargetDefined)
                    Container(
                      height: 12,
                      // Calculate width based on clamped barRatio
                      width: constraints.maxWidth * barRatio,
                      decoration: BoxDecoration(
                        // Use dynamic color
                        color: achievedColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  // Optional: Add a marker if achievement exceeds target
                  // if (isTargetDefined && achievementPercentage > 1.0)
                  //   Positioned(
                  //     left: constraints.maxWidth - 2, // Position near the end of the target bar
                  //     top: -2, // Adjust vertical position
                  //     child: Icon(Icons.star, color: Colors.amber, size: 16),
                  //   ),
                ],
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display raw achieved value
              Text(
                'Achieved: $achievedValue',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              // Display raw target value OR "Target not defined"
              Text(
                isTargetDefined ? 'Target: $targetValue' : 'Target not defined',
                style: TextStyle(
                  fontSize: 12,
                  color: isTargetDefined ? Colors.black54 : Colors.red.shade400,
                  fontStyle:
                      isTargetDefined ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ],
          ),
          // Optional: Display the calculated percentage if needed
          // if (isTargetDefined)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 4.0),
          //     child: Text(
          //       'Progress: ${(achievementPercentage * 100).toStringAsFixed(1)}%',
          //       style: TextStyle(fontSize: 11, color: achievedColor, fontWeight: FontWeight.bold),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class PerformanceData {
  final String label;
  final double achieved;
  final double target;

  const PerformanceData({
    required this.label,
    required this.achieved,
    required this.target,
  });
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);
  final String x; // Label (e.g., 'Hot', 'Warm')
  final int y; // Value (e.g., 45, 35)
  final Color color; // Color object
}

// Helper function to parse color strings (e.g., '#FFC107') into Color objects
// Place this outside the build method or make it a static helper method

class _ExpenseData {
  _ExpenseData(this.expenseType, this.allocatedBudget, this.actualExpenses);
  final String expenseType;
  final double allocatedBudget;
  final double actualExpenses;
}

class _LeadsStageData {
  _LeadsStageData(this.stage, this.leadsCount, this.color);
  final String stage;
  final int leadsCount;
  final Color color;
}
