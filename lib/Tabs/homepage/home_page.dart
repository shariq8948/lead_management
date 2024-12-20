import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads/alltasks/all_task_page.dart';
import 'package:leads/data/models/graph-model.dart';
import 'package:leads/leadlist/lead_list_page.dart';
import 'package:leads/taskDeatails/task_details_page.dart';
import 'package:leads/widgets/custom_date_picker.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Customer_entry/customer_entry_page.dart';
import '../../Masters/states/stateListPage.dart';
import '../../auth/login/login_controller.dart';
import '../../calender.dart';
import '../../calender_view/event_calendar.dart';
import '../../customerList/customer_list_page.dart';
import '../../data/models/lead_list.dart';
import '../../navbar/bottom_nav_bar.dart';
import '../../proCard.dart';
import '../../productEntry/product_entry_page.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_task_card.dart';
import '../../widgets/progress_card.dart';
import 'homepage_controller.dart'; // Import the controller

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final LoginController controller2 = Get.find<LoginController>();
  final HomeController controller =
      Get.put(HomeController()); // Initialize controller
  late AnimationController
      _animationController; // Declare the animation controller
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Initialize the Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilding");
    return Scaffold(
      key: _scaffoldKey,
      // Set the scaffold key here

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              // Use the key to open the drawer
              child: Image.asset("assets/icons/sidebar.png"), // Sidebar icon
            ),
            SizedBox(
              width: 30,
            ),
            customToggle(),
            SizedBox(
              width: 10,
            ),
            // rotatingIconToggle(),
            // flipCardToggle(),
            GestureDetector(
              onTap: () {
                Get.to(EventCalendar());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/calender.png",
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),

            GestureDetector(
              onTap: () {
                Get.to(EventCalendar());
              },
              child: Image.asset(
                "assets/icons/todo.png",
                fit: BoxFit.fill,
              ),
            ),
            GestureDetector(
                onTap: () {
                  Get.to(EventCalendar());
                },
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, backgroundColor: Colors.transparent),
                    onPressed: () {},
                    label: Icon(
                      Icons.notification_add_outlined,
                      color: Colors.black,
                      size: 20,
                    ))),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFE1FFED),
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          // Background Container
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
              ),
            ),
          ),
          Obx(() {
            // Show the respective dashboard based on switch state
            if (controller.isAdminMode.value) {
              return buildAdmin();
            } else {
              return Container(
                child: Text("data"),
              ); // Your My Dashboard widget
            }
          }),

          // Main Body Scrollable Content
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(
          bottom: 25,
        ),
        child: AnimatedSize(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn,
          child: Align(
            alignment: Alignment.bottomCenter, // Keep FAB fixed in place

            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1B1E24),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expandable buttons
                  Obx(() {
                    return controller.isExpanded.value
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              _buildExpandableButton(Icons.star, () {
                                print('Star button pressed');
                              }),
                              const SizedBox(height: 10),
                              _buildExpandableButton(Icons.task, () {
                                Get.to(ProductEntryPage());
                              }),
                              const SizedBox(height: 10),
                              _buildExpandableButton(Icons.person, () {
                                print('Person button pressed');
                              }),
                              const SizedBox(height: 10),
                              _buildExpandableButton(Icons.receipt, () {
                                print('Receipt button pressed');
                              }),
                              const SizedBox(height: 10),
                            ],
                          )
                        : SizedBox.shrink();
                  }),
                  // Main FAB
                  Container(
                    child: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        controller.toggleFab();
                        if (controller.isExpanded.value) {
                          _animationController.reverse(); // Animate out
                        } else {
                          _animationController.forward(); // Animate in
                        }
                      },
                      child: AnimatedIcon(
                        icon: AnimatedIcons.close_menu,
                        progress: _animationController,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          // height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE1FFED), // Start color
                Color(0xFFE6E6E6), // End color
              ],
            ),
          ),
          child: CustomBottomAppBar()),
    );
  }

  Widget buildAdmin() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row for Buttons
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Button Area
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => ElevatedButton(
                        onPressed: () {
                          controller.isTaskSelected.value = true;
                          controller.resetToTodayTab();
                          // controller.fetchTasksByTab("Today");
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
                              horizontal: 40, vertical: 15),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/icons/task.png",
                                color: controller.isTaskSelected.value
                                    ? Colors.white
                                    : Colors.black),
                            SizedBox(width: 15),
                            Text("Task",
                                style: TextStyle(
                                    color: controller.isTaskSelected.value
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 20)),
                            SizedBox(width: 15),
                            Text(controller.taskCount.value.toString(),
                                style: TextStyle(
                                    color: controller.isTaskSelected.value
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 20)),
                          ],
                        ),
                      )),
                  SizedBox(width: 10),
                  Obx(() => ElevatedButton(
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
                              horizontal: 40, vertical: 15),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/icons/lead.png",
                                color: controller.isTaskSelected.value
                                    ? Colors.black
                                    : Colors.white),
                            SizedBox(width: 15),
                            Text("Lead",
                                style: TextStyle(
                                    color: controller.isTaskSelected.value
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20)),
                            SizedBox(width: 15),
                            Text(controller.leadCount.value.toString(),
                                style: TextStyle(
                                    color: controller.isTaskSelected.value
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20)),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),

          // Task or Lead Card Display
          Obx(() {
            return SizedBox(
              height: controller.isTaskSelected.value
                  ? MediaQuery.of(context).size.height * 0.65
                  : MediaQuery.of(context).size.height * 0.8,
              child: controller.isTaskSelected.value ? TaskCard() : LeadCard(),
            );
          }),

          // Additional content that will scroll
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Additional Content Here",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            child: Obx(() => controller.isTaskSelected.value
                ? buildDoughnut()
                : buildPieChart()),
          ),
        ],
      ),
    ); // Your Admin Dashboard widget
  }

  Widget customToggle() {
    return Center(
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.toggleMode(!controller.isAdminMode.value);
          },
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber, // Base color
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
                  left:
                      controller.isAdminMode.value ? 70 : 0, // Toggle position
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black, // Active side color
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

  Widget _buildExpandableButton(IconData icon, VoidCallback onPressed) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.teal,
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget TaskCard() {
    return Column(
      children: [
        // Tab Bar for Today, Upcoming, Overdue
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary3Color, buttonBgColor], // Gradient effect
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
          child: Obx(() => TabBar(
                controller: controller
                    .tabController, // Use the controller's tabController
                padding: EdgeInsets.all(5),
                isScrollable: false, // Make it not scrollable
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                dividerHeight: 0,
                onTap: (index) {
                  controller.pageController
                      .jumpToPage(index); // Change page when a tab is tapped
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
              )),
        ),
        // PageView for Custom Animations
        Expanded(
          child: PageView(
            controller: controller.pageController, // Use PageController
            onPageChanged: (index) {
              controller.tabController
                  .animateTo(index); // Sync TabBar with PageView on page change
              final tabType =
                  index == 0 ? 'Today' : (index == 1 ? 'Upcoming' : 'Overdue');
              controller.fetchTasksByTab(tabType);
              controller.fetchDashboardCount();
            },
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  controller.fetchTasksByTab("Today");
                  controller.fetchDashboardCount();
                },
                child: buildTaskList("Today"),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  controller.fetchTasksByTab("Upcoming");
                  controller.fetchDashboardCount();
                },
                child: buildTaskList("Upcoming"),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  controller.fetchTasksByTab("Overdue");
                  controller.fetchDashboardCount();
                },
                child: buildTaskList("Overdue"),
              ),
            ],
          ),
        ),
        // Optional: Progress Bar Card at the bottom
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: progressCard(0.5),
        ),
      ],
    );
  }

  Widget buildTaskList(String tabType) {
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
                // Ensure the loading spinner is centered within the available space
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // If no tasks are available, show a message
              if (controller.tasks.isEmpty) {
                return Center(
                  child: Text('No tasks available.'),
                );
              }

              // If tasks are available, show them in a ListView
              return ListView.builder(
                itemCount:
                    controller.tasks.length > 5 ? 5 : controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return CustomTaskCard(
                    taskType: task.entrytype ?? "",
                    date:
                        controller.formatDate(task.createdDateTime.toString()),
                    assigneeName: task.cname ?? "",
                    onNameTap: () {
                      Get.to(() => TaskDetailPage(), arguments: {
                        "taskId":
                            task.id, // Replace this with your dynamic taskId
                      });

                      print('Name tapped: ${task.id}');
                    },
                    onCheckboxChanged: (bool? value) =>
                        controller.onCheckboxChanged(index, value, task.id!),
                    isChecked: task.isChecked,
                  );
                },
              );
            }),
          ),
          if (controller.tasks.length > 0)
            _buildViewAllButton(() {
              Get.to(AllTaskPage());
            }),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 05, // Simulating a fixed number of shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16 / 2, vertical: 8 / 2),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget progressCard(double progress) {
    return GestureDetector(
      onTap: () => _showDetailsBottomSheet(progress), // Interactive onTap
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Monthly Target",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${(progress * 100).toInt()}%", // Show progress percentage
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Custom Progress Bar
          Stack(
            children: [
              // Background Bar
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
              ),
              // Gradient Progress
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 30,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.green],
                  ),
                ),
              ),
              // Milestone Icons
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (progress >= 0.25)
                      Icon(Icons.flag, color: Colors.yellow, size: 16),
                    if (progress >= 0.5)
                      Icon(Icons.star, color: Colors.blue, size: 16),
                    if (progress >= 0.75)
                      Icon(Icons.emoji_events, color: Colors.red, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String tabType) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$tabType tasks',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black54),
              color: Colors.white,
              onSelected: (value) async {
                print(value);

                List<Map<String, dynamic>> body =
                    controller.selected.map((taskId) {
                  return {
                    "Taskid": taskId.toString(),
                    "ACTIVITYSTATUS":
                        value == 'Mark as Completed' ? "Completed" : "Cancel",
                    "UserID": "4",
                    // Assuming UserID is static or can be replaced by a dynamic value
                  };
                }).toList();

                print("Constructed body: $body");

                await controller.postStatus(body);

                await controller.fetchTasksByTab(tabType);
                await controller.fetchDashboardCount();

                controller.selected.clear();
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

  Widget _buildViewAllButton(void onpress()) {
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

  void _showDetailsBottomSheet(double progress) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.teal),
                SizedBox(width: 8),
                Text("Progress Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "You are ${(progress * 100).toInt()}% towards your goal.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 14,
              percent: progress,
              progressColor: Colors.teal,
              backgroundColor: Colors.grey.shade300,
              center: Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(), // Close the bottom sheet
              child: Text("Close", style: TextStyle(color: Colors.teal)),
            ),
            Row(
              children: [
                Icon(Icons.info, color: Colors.teal),
                SizedBox(width: 8),
                Text("Progress Details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "You are ${(progress * 100).toInt()}% towards your goal.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 14,
              percent: progress,
              progressColor: Colors.teal,
              backgroundColor: Colors.grey.shade300,
              center: Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(), // Close the bottom sheet
              child: Text("Close", style: TextStyle(color: Colors.teal)),
            ),
            buildPieChart()
          ],
        ),
      ),
      isScrollControlled:
          true, // Ensures the bottom sheet size can be adjusted based on content
    );
  }

  Widget LeadCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                onSelected: (value) {
                  _onMenuSelection(context, value);
                },
                itemBuilder: (BuildContext context) {
                  return {'Lead Date', 'Follow-Up Date'}.map((String choice) {
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

        // Lead List Section
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.leads.isEmpty) {
                return Center(
                  child: Text(
                    'No leads available.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                itemCount:
                    controller.leads.length > 5 ? 5 : controller.leads.length,
                itemBuilder: (context, index) {
                  LeadList lead = controller.leads[index];

                  // Individual Lead Row
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Name (Clickable)
                        SizedBox(
                          width: Get.width * 0.2,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to lead details or perform action
                            },
                            child: Text(
                              lead.name,
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        // Lead Date
                        SizedBox(
                          width: Get.width * 0.2,
                          child: Text(
                            controller.formatDate(lead.vdate),
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        // Lead Status
                        SizedBox(
                          width: Get.width * 0.15,
                          child: Text(
                            lead.leadStatus,
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        // Lead Type Badge
                        SizedBox(
                          width: Get.width * 0.20,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getBadgeColor(lead.priority),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              lead.priority,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ),
        _buildViewAllButton(() {
          Get.to(LeadListPage());
        }),

        SizedBox(height: 10),
        buildFunnel(), // Funnel Section
      ],
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
                  print("The date is ${controller.fromDateController.text}");
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
                  print("The date is ${controller.fromDateController.text}");

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

  Widget buildFunnel() {
    final List<FunnelGraph> chartData = controller.funnelData;
    print(chartData);
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SfFunnelChart(
        title: ChartTitle(text: 'Funnel Chart'),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: FunnelSeries<FunnelGraph, String>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.label,
          yValueMapper: (data, _) => data.y,
        ),
      ),
    );
  }

  Widget buildDoughnut() {
    final List<FunnelGraph> chartData = controller.funnelData;
    print(chartData);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SfCircularChart(
        borderColor: primary3Color,
        borderWidth: 2,
        // backgroundImage: AssetImage('assets/images/splash.gif',),
        palette: <Color>[
          Colors.red,
          Colors.green,
          primary3Color,
          Colors.blue,
          popupColor,
          Colors.yellow
        ],

        title: ChartTitle(text: 'Doughnut Chart'),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode
              .wrap, // Ensures legends adjust for long text
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <DoughnutSeries<FunnelGraph, String>>[
          DoughnutSeries<FunnelGraph, String>(
            dataSource: chartData,
            xValueMapper: (data, _) => data.label,
            // Map labels for the doughnut slices
            yValueMapper: (data, _) => data.y,
            name: 'Gold',
            // Map values for the doughnut slices
            dataLabelSettings: DataLabelSettings(
              isVisible: true, // Show labels on the chart
              labelPosition:
                  ChartDataLabelPosition.inside, // Place labels inside slices
            ),
            innerRadius:
                '60%', // Customize the inner radius to give it a "doughnut" look
          ),
        ],
      ),
    );
  }

  Widget buildPieChart() {
    final List<DealData> chartData = controller.pieData;
    print(chartData);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SfCircularChart(
        title: ChartTitle(text: 'Pie Chart'),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode
              .wrap, // Ensures legends adjust for long text
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <PieSeries<DealData, String>>[
          PieSeries<DealData, String>(
            dataSource: chartData,
            xValueMapper: (data, _) => data.monthName,
            // Map labels for the pie slices
            yValueMapper: (data, _) => data.dealSizeAmount,
            // Map values for the pie slices
            dataLabelSettings: DataLabelSettings(
              isVisible: true, // Show labels on the chart
              labelPosition:
                  ChartDataLabelPosition.outside, // Place labels outside slices
            ),
          ),
        ],
      ),
    );
  }

  Widget slidingToggle() {
    return Obx(() => GestureDetector(
          onTap: () {
            controller.toggleMode(!controller.isAdminMode.value);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 120,
            height: 40,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: controller.isAdminMode.value
                  ? Colors.green.shade300
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  left: controller.isAdminMode.value ? 70 : 0,
                  child: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    controller.isAdminMode.value ? "ON" : "OFF",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget fadeTextToggle() {
    return Obx(() => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: Container(
            width: 150,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: controller.isAdminMode.value
                  ? Colors.deepPurple
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text(
                controller.isAdminMode.value ? "Admin" : "User",
                key: ValueKey(controller.isAdminMode.value),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  Widget scaleToggle() {
    return Obx(() => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: controller.isAdminMode.value ? 120 : 100,
            height: controller.isAdminMode.value ? 50 : 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: controller.isAdminMode.value
                  ? Colors.teal
                  : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              controller.isAdminMode.value ? "Admin Mode" : "User Mode",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Widget rotatingIconToggle() {
    return Obx(() => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: Container(
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedRotation(
                  turns: controller.isAdminMode.value ? 0.5 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Icon(Icons.sync, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(
                  controller.isAdminMode.value ? "Admin" : "User",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }

  Widget flipCardToggle() {
    return Obx(() => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return RotationTransition(turns: animation, child: child);
            },
            child: Container(
              key: ValueKey(controller.isAdminMode.value),
              width: 100,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: controller.isAdminMode.value
                    ? Colors.pinkAccent
                    : Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.isAdminMode.value ? "Admin" : "Normal",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ));
  }

  Widget gradientToggle() {
    return Obx(() => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 130,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: controller.isAdminMode.value
                    ? [Colors.blue, Colors.green]
                    : [Colors.grey, Colors.black54],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              controller.isAdminMode.value ? "Admin" : "User",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }

  Widget glowToggle() {
    return Obx(() => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: Container(
            width: 120,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: controller.isAdminMode.value
                  ? Colors.purple
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
              boxShadow: controller.isAdminMode.value
                  ? [
                      BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.6),
                          blurRadius: 12,
                          spreadRadius: 1),
                    ]
                  : [],
            ),
            child: Text(
              controller.isAdminMode.value ? "Admin" : "Normal",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Widget underlineToggle() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => controller.toggleMode(false),
              child: Column(
                children: [
                  Text("Dashboard",
                      style: TextStyle(
                          color: controller.isAdminMode.value
                              ? Colors.black54
                              : Colors.blue,
                          fontWeight: FontWeight.bold)),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 3,
                    width: !controller.isAdminMode.value ? 80 : 0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () => controller.toggleMode(true),
              child: Column(
                children: [
                  Text("Admin",
                      style: TextStyle(
                          color: controller.isAdminMode.value
                              ? Colors.blue
                              : Colors.black54,
                          fontWeight: FontWeight.bold)),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 3,
                    width: controller.isAdminMode.value ? 80 : 0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget rippleToggle() {
    return GestureDetector(
      onTap: () => controller.toggleMode(!controller.isAdminMode.value),
      child: Obx(() => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            width: 130,
            height: 40,
            decoration: BoxDecoration(
                color: controller.isAdminMode.value
                    ? Colors.lightBlueAccent
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              controller.isAdminMode.value ? "Admin" : "Normal",
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }

  Widget bounceToggle() {
    return Obx(() => GestureDetector(
          onTap: () => controller.toggleMode(!controller.isAdminMode.value),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.bounceOut,
            width: 100,
            height: 40,
            alignment: controller.isAdminMode.value
                ? Alignment.centerRight
                : Alignment.centerLeft,
            decoration: BoxDecoration(
              color: controller.isAdminMode.value
                  ? Colors.blueAccent
                  : Colors.redAccent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ));
  }
}
