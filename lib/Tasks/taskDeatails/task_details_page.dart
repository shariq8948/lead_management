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
              _buildTaskDetails(), // Header Section
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

  Widget _buildTaskDetails() {
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
                      _buildStatusButton("Pending"),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey.shade600),
                      _buildStatusButton("Completed"),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey.shade600),
                      _buildStatusButton("Cancelled"),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    final isSelected = controller.taskDetails[0].status == status;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          controller.postStatus(controller.taskDetails[0].id!, status);
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

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange.shade100; // Light orange
      case "Completed":
        return Colors.green.shade100; // Light green
      case "Cancelled":
        return Colors.red.shade100; // Light red
      default:
        return Colors.grey.shade200; // Default light gray
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange.shade800;
      case "Completed":
        return Colors.green.shade800;
      case "Cancelled":
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

// Function to share content
  void _shareContent() async {
    await Share.share('Check out this task detail!');
  }
}
