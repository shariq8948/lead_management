import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Customer_entry/customer_entry_page.dart';
import '../../auth/login/login_controller.dart';
import '../../calender.dart';
import '../../map.dart';
import '../../navbar/bottom_nav_bar.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_task_card.dart';
import '../../widgets/progress_card.dart';
import 'homepage_controller.dart'; // Import the controller

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final LoginController controller2 = Get.find<LoginController>();

  final HomeController controller = Get.put(HomeController()); // Initialize controller
  late AnimationController _animationController; // Declare the animation controller
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // Initialize the Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
      key: _scaffoldKey, // Set the scaffold key here

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(), // Use the key to open the drawer
              child: Image.asset("assets/icons/sidebar.png"), // Sidebar icon
            ),
            GestureDetector(
              onTap:(){
                Get.to(CustomerEntryForm());
                // controller2.logout();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.task_alt, color: Colors.black),
                    SizedBox(width: 5),
                    Text("My Task", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(CustomCalendarPage());
              },
              child: Row(
                children: [
                  Image.asset("assets/icons/calender.png", color: Colors.amber),
                  SizedBox(width: 10),
                  Icon(Icons.notifications_none, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFE1FFED),
        elevation: 0,

      ),
      drawer: CustomDrawer(),
      body: Stack(
        children:[
          Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Button display area
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => ElevatedButton(
                        onPressed: () {
                          controller.isTaskSelected.value = true;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isTaskSelected.value ? primary3Color : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.grey),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/icons/task.png", color: controller.isTaskSelected.value ? Colors.white : Colors.black),
                            SizedBox(width: 15),
                            Text("Task", style: TextStyle(color: controller.isTaskSelected.value ? Colors.white : Colors.black, fontSize: 20)),
                            SizedBox(width: 15),
                            Text("45", style: TextStyle(color: controller.isTaskSelected.value ? Colors.white : Colors.black, fontSize: 20)),
                          ],
                        ),
                      )),
                      SizedBox(width: 10,),
                      Obx(() => ElevatedButton(
                        onPressed: () {
                          controller.isTaskSelected.value = false;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isTaskSelected.value ? Colors.white : primary3Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.grey),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/icons/leads.png", color: controller.isTaskSelected.value ? Colors.black : Colors.white),
                            SizedBox(width: 15),
                            Text("Lead", style: TextStyle(color: controller.isTaskSelected.value ? Colors.black : Colors.white, fontSize: 20)),
                            SizedBox(width: 15),
                            Text("15", style: TextStyle(color: controller.isTaskSelected.value ? Colors.black : Colors.white, fontSize: 20)),
                          ],
                        ),
                      )),
                    ],
                  ),

                ],
              ),
              SizedBox(height: 10),

              // Card display area
              Expanded(
                child: Obx(() => controller.isTaskSelected.value ? TaskCard() : LeadCard()), // Use Obx to reactively update
              ),
            ],
          ),
        ),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedSize(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeIn,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
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
                    _buildExpandableButton(Icons.star, () {
                      print('Star button pressed');
                    }),
                    const SizedBox(height: 10),
                    _buildExpandableButton(Icons.task, () {
                      print('Task button pressed');
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
              FloatingActionButton(
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
                  icon: AnimatedIcons.menu_close,
                  progress: _animationController,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
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
        child:
        CustomBottomAppBar()      ),
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
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Column(
        children: [
          // Tab Bar for Today, Upcoming, Overdue
          Container(
            color: Colors.black,
            child: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.teal,
              tabs: [
                Tab(text: 'Today'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Overdue'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Each tab view will have its own list of tasks
                buildTaskList("Today"),
                buildTaskList("Upcoming"),
                buildTaskList("Overdue"),

              ],
            ),
          ),
          ProgressBarCard(
            title: "My Target",
            progress: 50,

          ),
          SizedBox(height: 20,)

        ],
      ),
    );
  }

  Widget buildTaskList(String tabType) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(08.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    '${tabType} task',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.black54),
                    color: Colors.white,
                    onSelected: (value) {
                      // Handle the selected value
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Mark as Completed', 'Mark as cancel'}.map((String choice) {
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
          ),

          Expanded(
            child: Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return CustomTaskCard(
                    taskType: task.taskType,
                    date: task.date,
                    assigneeName: task.assigneeName,
                    isChecked: task.isChecked,
                    onNameTap: () {
                      // Logic for name tap action
                      print('Name tapped: ${task.assigneeName}');
                    },
                    onCheckboxChanged: (bool? value) => controller.onCheckboxChanged(index, value),
                  );
                },
              );
            }),
          ),
          // "View All" Button at the Bottom
          Align(
            alignment: Alignment.center,
            child:
            TextButton(
              onPressed: () {
                // Logic to handle "View All" button tap
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 14),
              ),
              child: Text("View All"),
            ),
          ),
        ],
      ),
    );
  }

  Widget LeadCard() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Leads',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CustomCard(
                    name: "Akanksha Purbi",
                    date: "27th Feb",
                    status: "Hot",
                    statusColor: Colors.red,
                    phoneNumber: "+91 99999 99999",
                    qualification: "Qualified",
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _onMenuSelection(BuildContext context, String value) {
    if (value == 'Lead Date' || value == 'Follow-Up Date') {
      _selectDate(context, value);
    }
  }



  Future<void> _selectDate(BuildContext context, String menuType) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true, // Use Material 3
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.tealAccent, // Primary color
              primary: Colors.tealAccent, // Primary color for the date picker
              onPrimary: Colors.white, // Text color on primary
              surface: Colors.grey[800], // Surface color
              onSurface: Colors.white, // Text color on surface
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.grey[850], // Background color for the date picker
              dayStyle: TextStyle(color: Colors.white), // Style for days
              headerBackgroundColor: Colors.tealAccent, // Header background color
              headerHelpStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Header title style
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      String formattedDate = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      // Handle the selected date as needed, e.g., update state, notify user, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$menuType selected date: $formattedDate'),
        ),
      );
    }
  }


}





