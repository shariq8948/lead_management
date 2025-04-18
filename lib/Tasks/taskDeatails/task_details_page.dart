import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/Tasks/taskDeatails/task_details_controller.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/taskDeatails/task_details_controller.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_select.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../google_service/google_calendar_helper.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_loader.dart';

class TaskDetailPage extends StatelessWidget {
  final TaskDetailController controller = Get.put(TaskDetailController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Task Detail"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTaskDetails(context), // Header Section
              _buildTabBar(), // Custom ButtonsTabBar
              Expanded(
                child: TabBarView(
                  children: [
                    _buildActivitySection(), // Activity Section
                    // Conditional rendering based on `entrytype`
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Builder(
                        builder: (context) {
                          final entryType = controller.taskDetails[0].entrytype;
                          if (entryType == "Meeting") {
                            return buildMeetingDetails(context);
                          } else if (entryType == "FollowUp") {
                            return buildFollowUpDetails(context);
                          } else if (entryType == "CallActivity") {
                            return buildCallDetails(context);
                          } else {
                            return Center(
                              child: Text(
                                  "No details available for this entry type."),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return ButtonsTabBar(
      height: Get.size.height * .06,
      width: Get.size.width * .5,
      backgroundColor: Colors.teal,
      unselectedBackgroundColor: Colors.grey[200],
      borderWidth: 1,
      borderColor: Colors.transparent,
      unselectedLabelStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      labelStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      // radius: 25,
      contentPadding: EdgeInsets.symmetric(horizontal: Get.size.width * .18),
      tabs: [
        Tab(text: "Activity"),
        Tab(text: "Details"),
      ],
    );
  }

  Widget _buildActivitySection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: controller.commentController,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              hintText: "Add a comment...",
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 4.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (controller.commentController.text.isNotEmpty) {
                      controller.postComment(controller.taskDetails[0].id!);
                      controller.commentController.clear();
                    }
                  },
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Obx(
          () => Expanded(
            child: controller.isLoadingActivities.value
                ? Center(
                    child: CustomLoader(),
                  )
                : controller.taskActivities.isEmpty
                    ? Center(
                        child: Text(
                          "No activities yet",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: controller.taskActivities.length,
                        itemBuilder: (context, index) {
                          final activity = controller.taskActivities[index];
                          return _buildActivityTile(
                            date: activity.formateddate!,
                            time: activity.hon!,
                            title: activity.typename ?? "No Title",
                            details: activity.typemsg!,
                            user: activity.actihisycreatedbyname!,
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile({
    required String date,
    required String time,
    required String title,
    required String details,
    required String user,
  }) {
    IconData getIconForTitle(String title) {
      switch (title.toLowerCase()) {
        case "callactivity":
          return Icons.phone_outlined; // Example icon for "Call Activity"
        case "comment":
          return Icons.chat_bubble_outline; // Example icon for "Comment"
        case "updatestatus":
          return Icons.edit_outlined; // Example icon for "Lead Updated"
        case "followup":
          return Icons.recycling_outlined; // Example icon for "Follow Up"
        case "lead assign":
          return Icons
              .assignment_ind_outlined; // Example icon for "Lead Assign"
        case "lead status":
          return Icons.factory_outlined; // Example icon for "Lead Status"
        default:
          return Icons.info_outline; // Default icon for other titles
      }
    }

    Color getColorForTitle(String title) {
      switch (title.toLowerCase()) {
        case "callactivity":
          return Colors.blue; // Color for "Call Activity"
        case "comment":
          return Colors.green; // Color for "Comment"
        case "taskassign":
          return Colors.orange; // Color for "Comment"
        case "updatestatus":
          return Colors.orange; // Color for "Lead Updated"
        case "followup":
          return Colors.purple; // Color for "Follow Up"
        case "lead assign":
          return Colors.teal;
        case "taskcreated":
          return Colors.purpleAccent; // Color for "Lead Assign"
        case "lead status":
          return Colors.red; // Color for "Lead Status"
        default:
          return Colors.grey; // Default color for other titles
      }
    }

    final iconColor = getColorForTitle(title);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              date,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
            Icon(getIconForTitle(title), color: iconColor),
            Container(
              height: 50.0,
              width: 3.0,
              color: iconColor, // Line color based on the title
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: iconColor, // Title color to match the icon
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  details,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                    ),
                    Text(
                      "By $user",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Obx(
        () => controller.isLoadingDetails.value
            ? Center(child: CustomLoader())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Entry Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.taskDetails[0].entrytype ?? "",
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Assignment and Creator Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Assign to: ${controller.taskDetails[0].assigntoName ?? ""}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Created by: ${controller.taskDetails[0].createdByName ?? ""}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Customer Name and Mobile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.taskDetails[0].cname ?? "",
                        style: TextStyle(
                            fontSize: 18, color: Colors.pink.shade500),
                      ),
                      Text(
                        controller.taskDetails[0].mobile ?? "",
                        style: TextStyle(
                            fontSize: 18, color: Colors.black.withOpacity(.6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Communication Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Image(
                            image: AssetImage('assets/icons/call (2).png')),
                        onPressed: () =>
                            _launchPhone(controller.taskDetails[0].mobile!),
                        color: Colors.blue,
                      ),
                      IconButton(
                        icon: Image(
                            image: AssetImage('assets/icons/whatsapp.png')),
                        onPressed: () =>
                            _launchWhatsApp(controller.taskDetails[0].mobile!),
                        color: Colors.green,
                      ),
                      IconButton(
                        icon: Image(
                            image: AssetImage('assets/icons/message.png')),
                        onPressed: () =>
                            _launchSMS(controller.taskDetails[0].mobile!),
                        color: Colors.blue,
                      ),
                      IconButton(
                        icon: Image(image: AssetImage('assets/icons/mail.png')),
                        onPressed: () =>
                            _launchMail(controller.taskDetails[0].email ?? ""),
                        color: Colors.red,
                      ),
                      IconButton(
                        icon:
                            Image(image: AssetImage('assets/icons/share.png')),
                        onPressed: () => _shareContent(),
                      ),
                    ],
                  ),

                  // Status Buttons with Arrows
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatusButton("Pending", context),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey.shade600),
                      _buildStatusButton("Completed", context),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey.shade600),
                      _buildStatusButton("Cancelled", context),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatusButton(String status, BuildContext context) {
    final isSelected = controller.taskDetails[0].status == status;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          // Show follow-up popup for Cancelled or Complete status
          if (status == "Cancelled" || status == "Completed") {
            _showFollowUpPopup(context, status);
          } else {
            controller.postStatus(controller.taskDetails[0].id!, status);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? _getStatusColor(status)
              : Colors.grey.shade200, // Unselected background
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected
                ? _getTextColor(status)
                : Colors.grey.shade600, // Unselected text color
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showFollowUpPopup(BuildContext context, String status) {
    final followUpController = Get.put(TaskDetailController());
    followUpController.resetController();
    followUpController.setStatusType(status);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GetBuilder<TaskDetailController>(
          init: followUpController,
          builder: (controller) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Header decoration
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: status == 'Completed'
                                  ? [
                                      Colors.green.shade400,
                                      Colors.green.shade600
                                    ]
                                  : [Colors.red.shade400, Colors.red.shade600],
                            ),
                          ),
                        ),
                      ),

                      // Main content
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0, 0.05),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: controller.isStatusUpdated
                                ? _buildFollowUpForm(controller, context)
                                : _buildStatusUpdateForm(
                                    context, status, controller),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusUpdateForm(
      BuildContext context, String status, TaskDetailController controller) {
    return Column(
      key: ValueKey('status-form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              status == 'Completed' ? Icons.check_circle : Icons.cancel,
              color: status == 'Completed'
                  ? Colors.green.shade600
                  : Colors.red.shade600,
              size: 28,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Task ${status == 'Completed' ? 'Completion' : 'Cancellation'}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: status == 'Completed'
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Text(
          "Please provide a remark explaining why this task is being ${status.toLowerCase()}:",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              TextFormField(
                controller: controller.statusRemarkController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter your remarks here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: status == 'Completed'
                          ? Colors.green.shade400
                          : Colors.red.shade400,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.fromLTRB(16, 16, 50, 16),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: InkWell(
                  onTap: () => controller.toggleSpeechRecognition(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller.isListening
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isListening ? Icons.mic : Icons.mic_none,
                      color: controller.isListening
                          ? Colors.red
                          : Colors.grey.shade700,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (controller.isListening)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Listening...",
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                if (controller.statusRemarkController.text.trim().isEmpty) {
                  Get.snackbar(
                    'Required Field',
                    'Please provide a remark to continue',
                    backgroundColor: Colors.amber.shade100,
                    colorText: Colors.amber.shade900,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(16),
                    borderRadius: 10,
                    icon: Icon(Icons.warning_amber_rounded,
                        color: Colors.amber.shade900),
                  );
                  return;
                }

                // // Update task status with remark
                controller.postStatusWithRemark(
                    this.controller.taskDetails[0].id!,
                    status,
                    controller.statusRemarkController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: status == 'Completed'
                    ? Colors.green.shade600
                    : Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  controller.isSubmittingStatus
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.check, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFollowUpForm(
      TaskDetailController controller, BuildContext context) {
    final dateOptions = [
      {"text": "Today", "icon": Icons.today},
      {"text": "Tomorrow", "icon": Icons.event},
      {"text": "After a week", "icon": Icons.date_range},
      {"text": "After a month", "icon": Icons.calendar_month},
      {"text": "Custom date", "icon": Icons.edit_calendar},
    ];

    return Column(
      key: ValueKey('followup-form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event_note, color: Colors.blue.shade700, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Create Follow-up",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Text(
          "When would you like to follow up?",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 110,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: dateOptions.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  controller.selectDateOption(index);
                  if (index == 4) {
                    // Custom date option
                    _selectCustomDate(context, controller);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.selectedDateOption == index
                        ? Colors.blue.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.selectedDateOption == index
                          ? Colors.blue.shade300
                          : Colors.grey.shade300,
                      width: controller.selectedDateOption == index ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          dateOptions[index]["icon"] as IconData,
                          size: 16,
                          color: controller.selectedDateOption == index
                              ? Colors.blue.shade700
                              : Colors.grey.shade600,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            dateOptions[index]["text"] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: controller.selectedDateOption == index
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        if (controller.selectedDateOption != -1) // Any date option selected
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.blue.shade700, size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Follow-up date: ${DateFormat('EEEE, MMM dd, yyyy').format(controller.selectedDate)}",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (controller.selectedDateOption == 4) // Custom date
                  IconButton(
                    icon:
                        Icon(Icons.edit, size: 18, color: Colors.blue.shade700),
                    onPressed: () => _selectCustomDate(context, controller),
                    tooltip: "Change date",
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  )
              ],
            ),
          ),
        SizedBox(height: 20),
        Text(
          "Follow-up Remarks",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              TextFormField(
                controller: controller.followUpRemarkController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "What would you like to follow up on?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: Colors.blue.shade400, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.fromLTRB(16, 16, 50, 16),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: InkWell(
                  onTap: () => controller.toggleSpeechRecognition(context,
                      isFollowUp: true),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller.isListeningFollowUp
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isListeningFollowUp
                          ? Icons.mic
                          : Icons.mic_none,
                      color: controller.isListeningFollowUp
                          ? Colors.red
                          : Colors.grey.shade700,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (controller.isListeningFollowUp)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Listening...",
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                if (controller.followUpRemarkController.text.trim().isEmpty) {
                  Get.snackbar(
                    'Required Field',
                    'Please provide follow-up remarks',
                    backgroundColor: Colors.amber.shade100,
                    colorText: Colors.amber.shade900,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(16),
                    borderRadius: 10,
                    icon: Icon(Icons.warning_amber_rounded,
                        color: Colors.amber.shade900),
                  );
                  return;
                }

                // // Create follow-up
                // controller.createFollowUp(
                //   this.controller.taskDetails[0].id!,
                //   controller.getSelectedFollowUpDate(),
                //   controller.followUpRemarkController.text.trim(),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  controller.isSubmittingFollowUp
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.add_task, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Create Follow-up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectCustomDate(
      BuildContext context, TaskDetailController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 16,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setCustomDate(picked);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      case "Pending":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Completed":
        return Icons.check_circle;
      case "Cancelled":
        return Icons.cancel;
      case "Pending":
        return Icons.hourglass_empty;
      case "In Progress":
        return Icons.sync;
      default:
        return Icons.circle;
    }
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return "Very Low";
      case 2:
        return "Low";
      case 3:
        return "Medium";
      case 4:
        return "High";
      case 5:
        return "Critical";
      default:
        return "Medium";
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case "Complete":
      case "Cancelled":
      case "In Progress":
        return Colors.white;
      default:
        return Colors.black87;
    }
  }

  Widget buildFollowUpDetails(BuildContext context) {
    return Obx(() {
      // Show loading indicator if data is still loading
      if (controller.isLoadingDetails.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      final inputDate = controller.taskDetails[0].followUpDateTime;
      if (inputDate != null && inputDate.isNotEmpty) {
        try {
          final inputFormat = DateFormat("MM/dd/yyyy h:mm:ss a");

          final parsedDate = inputFormat.parse(inputDate);

          controller.DateCtlr.text =
              DateFormat('yyyy-MM-dd').format(parsedDate);

          print("Parsed and formatted date: ${controller.DateCtlr.text}");
        } catch (e) {
          print("Error parsing date: $e");
          controller.DateCtlr.text = "";
        }
      } else {
        print("Invalid date string: $inputDate");
        controller.DateCtlr.text = "";
      }
      controller.assignToController.text =
          controller.taskDetails[0].assigntoid ?? "";
      controller.remarkController.text =
          controller.taskDetails[0].followUpRemark ?? "";
      controller.showassignToController.text =
          controller.taskDetails[0].assigntoName ?? "";
      controller.callTypeController.text =
          controller.taskDetails[0].activitytype ?? "";
      controller.callStatusController.text =
          controller.taskDetails[0].status ?? "";
      controller.ReminderCtlr.text =
          controller.taskDetails[0].remindertime ?? "";

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => CustomSelect(
                label: "Assign to",
                withShadow: false,
                withIcon: true,
                customIcon: Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 28,
                ),
                placeholder: "Assign To",
                mainList: controller.leadAssignToList
                    .map(
                      (element) => CustomSelectItem(
                        id: element.id ?? "",
                        value: element.name ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.assignToController.text = val.id;
                  controller.showassignToController.text = val.value;
                },
                textEditCtlr: controller.showassignToController,
                showLabel: false,
                onTapField: () {
                  controller.assignToController.clear();
                  controller.showassignToController.clear();
                },
              ),
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "Date",
              hintText: "Select date",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              enabled: true,
              readOnly: true,
              editingController: controller.DateCtlr,
              onFieldTap: () {
                Get.bottomSheet(
                  CustomDatePicker(
                    pastAllow: true,
                    confirmHandler: (date) async {
                      controller.DateCtlr.text = date ?? "";
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "Remark",
              hintText: "Remark",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              editingController: controller.remarkController,
              minLines: 3,
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildMeetingDetails(BuildContext context) {
    return Obx(() {
      // Show loading indicator if data is still loading
      if (controller.isLoadingDetails.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      controller.assignToController.text =
          controller.taskDetails[0].assigntoid ?? "";
      controller.showassignToController.text =
          controller.taskDetails[0].assigntoName ?? "";

      controller.titleController.text = controller.taskDetails[0].title ?? "";
      controller.locationController.text =
          controller.taskDetails[0].address ?? "";
      controller.descriptionController.text =
          controller.taskDetails[0].description ?? "";
      controller.ocRemarkController.text =
          controller.taskDetails[0].remark ?? "";
      final fromDate = controller.taskDetails[0].checkinDatetime;
      final toDate = controller.taskDetails[0].checkoutDatetime;
      if (fromDate != null && fromDate.isNotEmpty) {
        try {
          final inputFormat = DateFormat("MM/dd/yyyy h:mm:ss a");

          final parsedDate = inputFormat.parse(fromDate);

          controller.fromDateCtlr.text =
              DateFormat('yyyy-MM-dd').format(parsedDate);

          print("Parsed and formatted date: ${controller.fromDateCtlr.text}");
        } catch (e) {
          print("Error parsing date: $e");
          controller.fromDateCtlr.text = "";
        }
      } else {
        print("Invalid date string: $fromDate");
        controller.fromDateCtlr.text = "";
      }
      if (toDate != null && toDate.isNotEmpty) {
        try {
          final inputFormat = DateFormat("MM/dd/yyyy h:mm:ss a");

          final parsedDate = inputFormat.parse(toDate);

          controller.toDateController.text =
              DateFormat('yyyy-MM-dd').format(parsedDate);

          print(
              "Parsed and formatted date: ${controller.toDateController.text}");
        } catch (e) {
          print("Error parsing date: $e");
          controller.toDateController.text = "";
        }
      } else {
        print("Invalid date string: $toDate");
        controller.toDateController.text = "";
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomField(
              withShadow: true,
              labelText: "title",
              hintText: "Title",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              editingController: controller.titleController,
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomSelect(
                label: "Assign to",
                withShadow: false,
                withIcon: true,
                customIcon: Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 28,
                ),
                placeholder: "Assign To",
                mainList: controller.leadAssignToList
                    .map(
                      (element) => CustomSelectItem(
                        id: element.id ?? "",
                        value: element.name ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.assignToController.text = val.id;
                  controller.showassignToController.text = val.value;
                },
                textEditCtlr: controller.showassignToController,
                showLabel: false,
                onTapField: () {
                  controller.assignToController.clear();
                  controller.showassignToController.clear();
                },
              ),
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "Date",
              hintText: "From date",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              enabled: true,
              readOnly: true,
              editingController: controller.fromDateCtlr,
              onFieldTap: () {
                Get.bottomSheet(
                  CustomDatePicker(
                    pastAllow: true,
                    confirmHandler: (date) async {
                      controller.fromDateCtlr.text = date ?? "";
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "Date",
              hintText: "To date",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              enabled: true,
              readOnly: true,
              editingController: controller.toDateController,
              onFieldTap: () {
                Get.bottomSheet(
                  CustomDatePicker(
                    pastAllow: true,
                    confirmHandler: (date) async {
                      controller.toDateController.text = date ?? "";
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "Location",
              hintText: "Location",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              editingController: controller.locationController,
              minLines: 3,
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "Description",
              hintText: "Description",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              editingController: controller.descriptionController,
              minLines: 3,
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "OutCome Remark",
              hintText: "OutComeRemark",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              editingController: controller.ocRemarkController,
              minLines: 3,
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Save meeting details to the backend
                  try {
                    // Show loading or processing state
                    print("Saving meeting details...");

                    // Get the authenticated Google client
                    final authClient = await getGoogleAuthClient();
                    if (authClient == null) {
                      print("Google Sign-In failed or was canceled.");
                      return;
                    }

                    // Schedule the task on Google Calendar
                    await ApiClient().scheduleTaskOnGoogleCalendar(
                      client: authClient,
                      title: controller.titleController.text,
                      location: controller.locationController.text,
                      description: controller.descriptionController.text,
                      startDate: controller.fromDateCtlr.text,
                      endDate: controller.toDateController.text,
                    );

                    print("Meeting saved and scheduled successfully.");
                  } catch (e) {
                    print("Error saving meeting: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildCallDetails(BuildContext context) {
    return Obx(() {
      // Show loading indicator if data is still loading
      if (controller.isLoadingDetails.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      print(controller.taskDetails[0].vdate);
      controller.remarkController.text = controller.taskDetails[0].remark ?? "";
      final inputDate = controller.taskDetails[0].vdate;
      if (inputDate != null && inputDate.isNotEmpty) {
        try {
          final inputFormat = DateFormat("MM/dd/yyyy h:mm:ss a");

          final parsedDate = inputFormat.parse(inputDate);

          controller.DateCtlr.text =
              DateFormat('yyyy-MM-dd').format(parsedDate);

          print("Parsed and formatted date: ${controller.DateCtlr.text}");
        } catch (e) {
          print("Error parsing date: $e");
          controller.DateCtlr.text = "";
        }
      } else {
        print("Invalid date string: $inputDate");
        controller.DateCtlr.text = "";
      }
      controller.assignToController.text =
          controller.taskDetails[0].assigntoid ?? "";
      controller.showassignToController.text =
          controller.taskDetails[0].assigntoName ?? "";
      controller.callTypeController.text =
          controller.taskDetails[0].activitytype ?? "";
      controller.callStatusController.text =
          controller.taskDetails[0].status ?? "";
      controller.ReminderCtlr.text =
          controller.taskDetails[0].remindertime ?? "";

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomField(
              withShadow: true,
              labelText: "Date",
              hintText: "Select date",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              enabled: true,
              readOnly: true,
              editingController: controller.DateCtlr,
              onFieldTap: () {
                Get.bottomSheet(
                  CustomDatePicker(
                    pastAllow: true,
                    confirmHandler: (date) async {
                      controller.DateCtlr.text = date ?? "";
                    },
                  ),
                );
              },
            ),
            // const SizedBox(height: 16),
            // CustomField(
            //   withShadow: true,
            //   labelText: "Reminder",
            //   hintText: "Set reminder",
            //   inputAction: TextInputAction.done,
            //   inputType: TextInputType.text,
            //   showLabel: false,
            //   bgColor: Colors.white,
            //   enabled: true,
            //   readOnly: true,
            //   editingController: controller.ReminderCtlr,
            //   onFieldTap: () {
            //     showTimePicker(
            //       context: context,
            //       initialTime: TimeOfDay.now(),
            //     ).then((pickedTime) {
            //       if (pickedTime != null) {
            //         final formattedTime =
            //             "${pickedTime.hour} hours and ${pickedTime.minute} minutes";
            //         controller.ReminderCtlr.text = formattedTime;
            //       }
            //     });
            //   },
            // ),
            const SizedBox(height: 16),
            Obx(
              () => CustomSelect(
                label: "Assign to",
                withShadow: false,
                withIcon: true,
                customIcon: Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 28,
                ),
                placeholder: "Assign To",
                mainList: controller.leadAssignToList
                    .map(
                      (element) => CustomSelectItem(
                        id: element.id ?? "",
                        value: element.name ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.assignToController.text = val.id;
                  controller.showassignToController.text = val.value;
                },
                textEditCtlr: controller.showassignToController,
                showLabel: false,
                onTapField: () {
                  controller.assignToController.clear();
                  controller.showassignToController.clear();
                },
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomSelect(
                label: "Call Type",
                withShadow: false,
                withIcon: true,
                customIcon: Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 28,
                ),
                placeholder: "Call Type",
                mainList: controller.calltype
                    .map(
                      (element) => CustomSelectItem(
                        id: element.value ?? "",
                        value: element.status ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.callTypeController.text = val.value;
                },
                textEditCtlr: controller.callTypeController,
                showLabel: false,
                onTapField: () {
                  controller.callTypeController.clear();
                },
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomSelect(
                label: "Call Status",
                withShadow: false,
                withIcon: true,
                customIcon: Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 28,
                ),
                placeholder: "Call Status",
                mainList: controller.callstatus
                    .map(
                      (element) => CustomSelectItem(
                        id: element.value ?? "",
                        value: element.status ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.callStatusController.text = val.value;
                },
                textEditCtlr: controller.callStatusController,
                showLabel: false,
                onTapField: () {
                  controller.callStatusController.clear();
                },
              ),
            ),
            const SizedBox(height: 16),
            CustomField(
              withShadow: true,
              labelText: "Remark",
              hintText: "Remark",
              inputAction: TextInputAction.done,
              inputType: TextInputType.datetime,
              showLabel: false,
              bgColor: Colors.white,
              editingController: controller.remarkController,
              minLines: 3,
            ),
            SizedBox(
              height: 12,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

// Function to launch the phone dialer
  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

// Function to launch WhatsApp
  void _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

// Function to send an SMS
  void _launchSMS(String phoneNumber) async {
    final url = 'sms:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send SMS';
    }
  }

// Function to launch email client
  void _launchMail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email client';
    }
  }

// Function to share content
  void _shareContent() async {
    await Share.share('Check out this task detail!');
  }
}

class AILeadAnalyticsController extends GetxController {
  // Returns the optimal number of days to wait before following up based on historical data
  int getOptimalFollowUpDays(
      {required String status, required String leadType}) {
    // In a real implementation, this would use ML models to analyze historical data
    // For this demonstration, we're using hardcoded values
    Map<String, Map<String, int>> optimalDays = {
      "Completed": {
        "Enterprise": 14,
        "SMB": 10,
        "Startup": 7,
        "Individual": 21,
      },
      "Cancelled": {
        "Enterprise": 30,
        "SMB": 14,
        "Startup": 7,
        "Individual": 21,
      },
      "Pending": {
        "Enterprise": 3,
        "SMB": 2,
        "Startup": 1,
        "Individual": 4,
      },
      "In Progress": {
        "Enterprise": 5,
        "SMB": 3,
        "Startup": 2,
        "Individual": 4,
      }
    };

    // Default values if specific combination not found
    if (!optimalDays.containsKey(status)) return 7;
    if (!optimalDays[status]!.containsKey(leadType))
      return optimalDays[status]!.values.first;

    return optimalDays[status]![leadType]!;
  }

  // Generates personalized follow-up notes based on lead data
  String generateSmartFollowUpNote({
    required String status,
    required String leadName,
    required String leadType,
    required List<String> previousInteractions,
    double engagementScore = 0.0,
  }) {
    // In a real implementation, this would use NLP to generate personalized notes
    // For this demonstration, we're using templates

    switch (status) {
      case "Completed":
        return "Task completed successfully with $leadName. Based on their engagement history and similar $leadType clients, recommended follow-up to discuss additional solutions that align with their business needs. Previous interactions show interest in our premium features.";

      case "Cancelled":
        return "Task cancelled with $leadName. Analysis of similar $leadType clients shows 42% can be re-engaged with a personalized approach addressing their specific concerns. Previous interactions suggest focus on ${_getLeadPainPoint(previousInteractions)}.";

      case "Pending":
        return "Follow up with $leadName about pending task. Based on engagement patterns for $leadType clients, recommend emphasizing key benefits and addressing potential objections about pricing. Provide case studies of similar companies.";

      case "In Progress":
        return "Check status with $leadName on ongoing task. Data from similar $leadType clients indicates providing additional resources at this stage increases completion rates by 27%. Consider sharing relevant documentation.";

      default:
        return "Follow up with $leadName based on recent interactions. Analyze their needs and prepare personalized solutions for the next discussion.";
    }
  }

  // Generates an alternative follow-up note when the user requests a refresh
  String generateAlternativeFollowUpNote({
    required String status,
    required String leadName,
    required String leadType,
    required List<String> previousInteractions,
  }) {
    // In a real implementation, this would generate a different note using NLP
    // For this demonstration, we're using alternative templates

    switch (status) {
      case "Completed":
        return "Follow up with $leadName to gather feedback on completed task. Their profile matches our ideal customer persona for upselling opportunities. Consider discussing how our advanced features could address their specific business challenge of ${_getLeadPainPoint(previousInteractions)}.";

      case "Cancelled":
        return "Re-engage with $leadName to understand reasons for cancellation. Similar $leadType clients have responded well to alternative offerings that address their specific pain points. Focus conversation on value proposition and ROI.";

      case "Pending":
        return "Check in with $leadName on pending decision. Analytics suggest that $leadType clients typically need additional information about implementation timeline and support options before converting. Prepare answers to potential technical questions.";

      case "In Progress":
        return "Touch base with $leadName on progress. Based on engagement patterns, now is an optimal time to discuss next steps and address any potential roadblocks. Consider offering a quick demo of recently added features.";

      default:
        return "Schedule follow-up with $leadName to maintain engagement. Based on their interaction history, they may be interested in our new solutions for ${_getLeadInterest(previousInteractions)}.";
    }
  }

  // Calculate lead priority based on various factors
  int calculateLeadPriority({
    required String status,
    required double leadValue,
    required int conversionProbability,
    required String industry,
  }) {
    // In a real implementation, this would use a scoring algorithm
    // For this demonstration, we're using a simplified approach

    // Base priority based on status
    int basePriority = status == "Completed"
        ? 3
        : status == "In Progress"
            ? 4
            : status == "Pending"
                ? 3
                : 2;

    // Adjust based on lead value
    if (leadValue > 10000) basePriority++;
    if (leadValue < 1000) basePriority--;

    // Adjust based on conversion probability
    if (conversionProbability > 75) basePriority++;
    if (conversionProbability < 25) basePriority--;

    // Ensure priority is within valid range
    return basePriority.clamp(1, 5);
  }

  // Helper methods to extract insights from previous interactions
  String _getLeadPainPoint(List<String> interactions) {
    // In a real implementation, this would use NLP to analyze conversations
    // For this demonstration, we're returning placeholder values
    List<String> painPoints = [
      "budget constraints",
      "implementation timeline",
      "technical integration",
      "team adoption",
      "scalability concerns"
    ];

    return painPoints[DateTime.now().microsecond % painPoints.length];
  }

  String _getLeadInterest(List<String> interactions) {
    // In a real implementation, this would use NLP to analyze conversations
    // For this demonstration, we're returning placeholder values
    List<String> interests = [
      "automation features",
      "reporting capabilities",
      "mobile integration",
      "team collaboration tools",
      "API access"
    ];

    return interests[DateTime.now().microsecond % interests.length];
  }
}
