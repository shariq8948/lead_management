import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../calender.dart';
import '../../map.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_task_card.dart';
import '../../widgets/progress_card.dart';
import 'homepage_controller.dart'; // Import the controller

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController()); // Initialize controller
  late AnimationController _animationController; // Declare the animation controller

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
  List<Map<String, dynamic>> tasks = [
    {"taskType": "Call", "date": "2024-10-28", "assigneeName": "Alice", "isChecked": false},
    {"taskType": "Meeting", "date": "2024-10-29", "assigneeName": "Bob", "isChecked": false},
    {"taskType": "Call", "date": "2024-10-28", "assigneeName": "Alice", "isChecked": false},
    {"taskType": "Meeting", "date": "2024-10-29", "assigneeName": "Bob", "isChecked": false},
    {"taskType": "Call", "date": "2024-10-28", "assigneeName": "Alice", "isChecked": false},
    {"taskType": "Meeting", "date": "2024-10-29", "assigneeName": "Bob", "isChecked": false},
    {"taskType": "Call", "date": "2024-10-28", "assigneeName": "Alice", "isChecked": false},
    {"taskType": "Meeting", "date": "2024-10-29", "assigneeName": "Bob", "isChecked": false},
    {"taskType": "Call", "date": "2024-10-28", "assigneeName": "Alice", "isChecked": false},
    {"taskType": "Meeting", "date": "2024-10-29", "assigneeName": "Bob", "isChecked": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/icons/sidebar.png"),
            GestureDetector(
              onTap:(){
                Get.to(MapsPage());
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
      body: Container(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
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
        child: BottomAppBar(
          color: Colors.black54, // Set the BottomAppBar to transparent
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() => IconButton(
                icon: Icon(Icons.home, color: controller.selectedTab.value == 0 ? Colors.green : Colors.grey),
                onPressed: () {
                  controller.setSelectedTab(0);
                },
              )),
              SizedBox(width: 20),
              Obx(() => IconButton(
                icon: Icon(Icons.person, color: controller.selectedTab.value == 1 ? Colors.green : Colors.grey),
                onPressed: () {
                  controller.setSelectedTab(1);
                },
              )),
            ],
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

// Helper function to build task list for each tab
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return CustomTaskCard(
                  taskType: task["taskType"],
                  date: task["date"],
                  assigneeName: task["assigneeName"],
                  isChecked: task["isChecked"],
                  onNameTap: () {
                    // Logic for name tap action
                  },
                  onCheckboxChanged: (bool? value) => _onCheckboxChanged(index, value),
                );
              },
            ),
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

  void _onCheckboxChanged(int index, bool? newValue) {
    setState(() {
      tasks[index]["isChecked"] = newValue ?? false;
      print(newValue);
    });
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
                    // Handle the selected value
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


                  SizedBox(height: 10,)

                ],
              );
            },
          ),
        ),
      ],
    );
  }
}







