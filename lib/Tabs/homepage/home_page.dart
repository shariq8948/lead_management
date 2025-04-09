import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
      onTap: () => Get.to(() => MeetingPage()),
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

          buildPerformanceMeter(PerformanceMetrics(
            completedTask: 55.0,
            leadGenerated: 23.0,
            attendance: 28.0,
            salesAchieved: 80.0,
          )),
          PerformanceAnalysisChart(performanceData: [
            PerformanceData(label: 'Calls', achieved: 85, target: 100),
            PerformanceData(label: 'Meeting', achieved: 75, target: 100),
            PerformanceData(label: 'Product Sale', achieved: 70, target: 100),
            PerformanceData(label: 'Follow-up', achieved: 65, target: 100),
            PerformanceData(label: 'Collection', achieved: 80, target: 100),
            PerformanceData(label: 'Sales', achieved: 90, target: 100),
            PerformanceData(label: 'Lead', achieved: 60, target: 100),
          ]),
          BuildStats(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BuildLeadPriorityChartSyncfusion(),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BuildTaskOverview(),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BuildExpenseOverviewChart(),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BuildLeadsByStageChart(),
          )

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

  Future<void> _showAdvancedDateRangePicker(BuildContext context) async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: Colors.deepPurple,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      controller.selectedFilter.value =
          'Custom: ${pickedRange.start.day}/${pickedRange.start.month} - ${pickedRange.end.day}/${pickedRange.end.month}';

      controller.fetchFilteredData(
          startDate: pickedRange.start, endDate: pickedRange.end);
    }
  } // Modified date range picker to improve UX

  Widget BuildLeadsByStageChart() {
    final List<Map<String, dynamic>> leadsStageData = [
      {'stage': 'New', 'leadsCount': 55, 'color': Colors.blue},
      {'stage': 'Contacted', 'leadsCount': 40, 'color': Colors.green},
      {
        'stage': 'Opportunity',
        'leadsCount': 30,
        'color': Colors.deepPurpleAccent
      },
      {'stage': 'Negotiation', 'leadsCount': 20, 'color': Colors.purple},
      {'stage': 'Qualified', 'leadsCount': 15, 'color': Colors.pinkAccent},
      {'stage': 'Disqualified', 'leadsCount': 10, 'color': Colors.redAccent},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
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
                'Number of Leads by Stages',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16.0),
              AspectRatio(
                aspectRatio: 2.0,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(isInversed: true),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 60,
                    interval: 10,
                  ),
                  series: <BarSeries<Map<String, dynamic>, String>>[
                    BarSeries<Map<String, dynamic>, String>(
                      dataSource: leadsStageData,
                      xValueMapper: (data, _) => data['stage'],
                      yValueMapper: (data, _) => data['leadsCount'],
                      pointColorMapper: (data, _) => data['color'],
                      name: 'Leads',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                      ),
                      enableTooltip: true,
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                      value: '15',
                    ),
                    _buildStatCard(
                      icon: Icons.trending_up_rounded,
                      iconColor: Colors.blue,
                      title: 'Active Lead',
                      value: '32',
                    ),
                    _buildStatCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: Colors.green,
                      title: 'Qualified Lead',
                      value: '18',
                    ),
                    _buildStatCard(
                      icon: Icons.cancel_rounded,
                      iconColor: Colors.redAccent,
                      title: 'Disqualified Lead',
                      value: '7',
                    ),
                    _buildStatCard(
                      icon: Icons.wallet_rounded,
                      iconColor: Colors.green,
                      title: 'Qualified Budget',
                      value: '₹ 1,25,50,000',
                    ),
                    _buildStatCard(
                      icon: Icons.money_off_rounded,
                      iconColor: Colors.redAccent,
                      title: 'Disqualified Budget',
                      value: '₹ 35,75,000',
                    ),
                    _buildStatCard(
                      icon: Icons.track_changes_rounded,
                      iconColor: Colors.blue,
                      title: 'Target Sale',
                      value: '₹ 85,000',
                    ),
                    _buildStatCard(
                      icon: Icons.show_chart_rounded,
                      iconColor: Colors.blue,
                      title: 'Actual Sales',
                      value: '₹ 78,500',
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

  Widget BuildLeadPriorityChartSyncfusion() {
    final List<_ChartData> chartData = [
      _ChartData('Hot', 45, Colors.pinkAccent),
      _ChartData('Warm', 35,
          Colors.amber), // Using amber for a slightly different yellow
      _ChartData('Cold', 15, Colors.lightBlue), // Using lightBlue
      _ChartData('High Value', 5, Colors.teal), // Using teal
      _ChartData('Low Value', 0,
          Colors.purple[400]!), // Using a slightly different purple
    ];

    final totalLeads = chartData.fold(0, (sum, data) => sum + data.y);

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
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  pointColorMapper: (_ChartData data, _) => data.color,
                  innerRadius: '60%',
                  radius: '80%',
                  // Enable data labels
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(
                        color: Colors.grey, type: ConnectorType.curve),
                  ),
                  // Enable tooltip
                  enableTooltip: true,
                )
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            children: chartData.map((data) {
              final percentage =
                  totalLeads > 0 ? (data.y / totalLeads * 100).toDouble() : 0.0;
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
    final totalTasks = 50;
    final completedTasks = 35;
    final pendingTasks = 10;
    final overdueTasks = 5;

    final completionPercentage =
        totalTasks > 0 ? completedTasks / totalTasks : 0.0;

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
                    _buildTaskInfoGrid(
                        totalTasks, completedTasks, pendingTasks, overdueTasks),
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
                        child: _buildTaskInfoGrid(totalTasks, completedTasks,
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
    final List<_ExpenseData> expenseData = [
      _ExpenseData('Local Expenses', 25000, 18000),
      _ExpenseData('Outstation Expenses', 30000, 22000),
      _ExpenseData('Miscellaneous Expenses', 15000, 12000),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
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
                'Expense Overview',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16.0),
              AspectRatio(
                aspectRatio: 1.7, // Adjust as needed for better fit
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 30000, // Adjust based on your data range
                    interval: 5000,
                    labelFormat: '{value}',
                  ),
                  series: <ColumnSeries<_ExpenseData, String>>[
                    ColumnSeries<_ExpenseData, String>(
                      dataSource: expenseData,
                      xValueMapper: (_ExpenseData data, _) => data.expenseType,
                      yValueMapper: (_ExpenseData data, _) =>
                          data.allocatedBudget,
                      name: 'Allocated Budget',
                      color: Colors.lightBlueAccent,
                    ),
                    ColumnSeries<_ExpenseData, String>(
                      dataSource: expenseData,
                      xValueMapper: (_ExpenseData data, _) => data.expenseType,
                      yValueMapper: (_ExpenseData data, _) =>
                          data.actualExpenses,
                      name: 'Actual Expenses',
                      color: Colors.pinkAccent,
                    ),
                  ],
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    orientation: LegendItemOrientation.horizontal,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                ),
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: popupColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Latest Leads',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            onSelected: (value) => _onMenuSelection(context, value),
            itemBuilder: (BuildContext context) =>
                {'Lead Date', 'Follow-Up Date'}
                    .map(
                      (String choice) => PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
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
                _buildDetailRow('Attendance', metrics.attendance),
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
    return ListView.builder(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.leads.length,
      itemBuilder: (context, index) => _buildLeadItem(controller.leads[index]),
    );
  }

  Widget _buildLeadItem(LeadList lead) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
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
    );
  }

  Widget _buildLeadName(LeadList lead) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.leadDetail, arguments: lead.leadId),
        child: Text(
          lead.name,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
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
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: _getBadgeColor(lead.priority),
          borderRadius: BorderRadius.circular(12),
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
  final double attendance;
  final double salesAchieved;

  PerformanceMetrics({
    required this.completedTask,
    required this.leadGenerated,
    required this.attendance,
    required this.salesAchieved,
  });

  double calculateOverallScore() {
    return ((completedTask + leadGenerated + attendance + salesAchieved) / 4)
        .clamp(0.0, 100.0);
  }
}

class PerformanceAnalysisChart extends StatelessWidget {
  final List<PerformanceData> performanceData;

  const PerformanceAnalysisChart({
    Key? key,
    required this.performanceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            ...performanceData
                .map((data) => _buildPerformanceRow(data))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(PerformanceData data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Target bar (light blue)
                  Container(
                    height: 10,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  // Achieved bar (purple)
                  Container(
                    height: 10,
                    width: constraints.maxWidth * (data.achieved / data.target),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Achieved: ${data.achieved}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              Spacer(),
              Text(
                'Target: ${data.target}%',
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
  final String x;
  final int y;
  final Color color;
}

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
