import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:leads/data/models/lead_task_model.dart';
import 'package:leads/leads/details/lead_detail_controller.dart';
import 'package:leads/widgets/customActionbutton.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_loader.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Tasks/taskDeatails/task_details_page.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/custom_select.dart';

class LeadDetailsPage extends StatelessWidget {
  LeadDetailsPage({super.key});
  final controller = Get.find<LeadDetailController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lead Detail"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(), // Header Section
              _buildTabBar(), // Custom ButtonsTabBar
              Expanded(
                child: TabBarView(
                  children: [
                    _buildActivitySection(),
                    _buildTaskSection(context),
                    buildLeadForm(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () {
          if (controller.details.isEmpty) {
            return const Center(
              child: CustomLoader(),
            );
          }

          final lead = controller.details[0];
          final priorityColor = _getPriorityColor(lead.priority);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.leadName ?? "No Name",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              lead.company ?? "No Company",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lead.priority,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: 'assets/icons/call (2).png',
                    label: 'Call',
                    color: Colors.blue[700]!,
                    onPressed: () => controller.launchPhone(lead.mobile),
                  ),
                  _buildActionButton(
                    icon: 'assets/icons/whatsapp.png',
                    label: 'WhatsApp',
                    color: Colors.green[600]!,
                    onPressed: () => controller.launchWhatsApp(lead.mobile),
                  ),
                  _buildActionButton(
                    icon: 'assets/icons/message.png',
                    label: 'SMS',
                    color: Colors.blue[600]!,
                    onPressed: () => controller.launchSMS(lead.mobile),
                  ),
                  _buildActionButton(
                    icon: 'assets/icons/mail.png',
                    label: 'Email',
                    color: Colors.red[600]!,
                    onPressed: () => controller.launchMail(lead.email!),
                  ),
                  _buildActionButton(
                    icon: 'assets/icons/share.png',
                    label: 'Share',
                    color: Colors.grey[700]!,
                    onPressed: () => controller.shareContent(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(30),
            child: Image(
              image: AssetImage(icon),
              width: 24,
              height: 24,
              // color: color,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void populateForm() {
    // Populate fields when data is loaded
    controller.leadSourceController.text = controller.details[0].leadSourceId;
    controller.leadAddressController.text = controller.details[0].address;
    controller.showLeadSourceController.text = controller.details[0].leadSource;
    controller.leadOwnerController.text = controller.details[0].ownerId;
    controller.showLeadOwnerController.text = controller.details[0].ownerName;
    controller.leadNameController.text = controller.details[0].leadName;
    controller.leadMobileController.text = controller.details[0].phone;
    controller.leadEmailController.text = controller.details[0].email ?? "";
    controller.leadAddressController.text = controller.details[0].address;
    controller.leadIndustryController.text = controller.details[0].industrytype;
    controller.leadComapnyController.text = controller.details[0].company ?? "";
    controller.leadAssignToController.text =
        controller.details[0].assigntoId ?? "";
    controller.showLeadAssignToController.text =
        controller.details[0].assignToName ?? "";
    controller.leadDealSizeController.text =
        controller.details[0].dealSize ?? "";
    controller.leadDescriptionontroller.text =
        controller.details[0].description ?? "";
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'disqualified':
        return Colors.red[700]!;
      case 'cold':
        return Colors.orange[600]!;
      case 'warm':
        return Colors.green[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  // TabBar Section
  Widget _buildTabBar() {
    return ButtonsTabBar(
      width: Get.size.width * .33,
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
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      tabs: [
        Tab(text: "Activity"),
        Tab(text: "Task"),
        Tab(text: "Details"),
      ],
    );
  }

  Widget buildLeadForm(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        // Show loading indicator while data is loading
        return Center(
          child: CustomLoader(),
        );
      }

      populateForm();
      return SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
            child: Column(
              children: [
                // Lead Source
                Obx(
                  () => CustomSelect(
                    withIcon: true,
                    withShadow: false,
                    customIcon: Icon(Icons.search, size: 28),
                    label: "Select Lead Source",
                    placeholder: "Please select Lead Source",
                    mainList: controller.leadSource
                        .map((element) => CustomSelectItem(
                              id: element.id ?? "",
                              value: element.name ?? "",
                            ))
                        .toList(),
                    onSelect: (val) async {
                      controller.leadSourceController.text = val.id;
                      controller.showLeadSourceController.text = val.value;
                    },
                    textEditCtlr: controller.showLeadSourceController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadSourceController.clear();
                      controller.showLeadSourceController.clear();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Lead Source';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 18),

                // Lead Owner
                Obx(
                  () => CustomSelect(
                    label: "Lead Owner",
                    withShadow: false,
                    withIcon: true,
                    customIcon: Icon(Icons.handshake_outlined, size: 28),
                    placeholder: "Please select Lead Owner",
                    mainList: controller.leadOwner
                        .map((element) => CustomSelectItem(
                              id: element.id ?? "",
                              value: element.name ?? "",
                            ))
                        .toList(),
                    onSelect: (val) async {
                      controller.leadOwnerController.text = val.id;
                      controller.showLeadOwnerController.text = val.value;
                    },
                    textEditCtlr: controller.showLeadOwnerController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadOwnerController.clear();
                      controller.showLeadOwnerController.clear();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Lead Owner';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 18),

                // Lead Name
                CustomField(
                  labelText: "Lead Name",
                  hintText: 'Enter Lead Name',
                  editingController: controller.leadNameController,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  showIcon: true,
                  withShadow: false,
                  customIcon: Icon(Icons.star_border_purple500_sharp, size: 28),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Lead Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Mobile Number
                CustomField(
                  showIcon: true,
                  withShadow: false,
                  customIcon: Icon(Icons.phone_android_outlined, size: 28),
                  labelText: "Mobile",
                  hintText: 'Enter Mobile Number',
                  editingController: controller.leadMobileController,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mobile Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Email
                CustomField(
                  showIcon: true,
                  withShadow: false,
                  customIcon: Icon(Icons.mail_outline_outlined, size: 28),
                  labelText: "Email",
                  hintText: 'Enter Email',
                  editingController: controller.leadEmailController,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Address
                CustomField(
                  showIcon: true,
                  withShadow: false,
                  customIcon: Icon(Icons.map_outlined, size: 28),
                  labelText: "Address",
                  hintText: 'Enter Address',
                  editingController: controller.leadAddressController,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Industry
                Obx(
                  () => CustomSelect(
                    label: "Select Industry",
                    withShadow: false,
                    withIcon: true,
                    customIcon: Icon(Icons.factory_outlined, size: 28),
                    placeholder: "Please select Industry",
                    mainList: controller.industryList
                        .map((element) => CustomSelectItem(
                              id: element.id ?? "",
                              value: element.name ?? "",
                            ))
                        .toList(),
                    onSelect: (val) async {
                      controller.leadIndustryController.text = val.id;
                      controller.showLeadIndustryController.text = val.value;
                    },
                    textEditCtlr: controller.showLeadIndustryController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadIndustryController.clear();
                      controller.showLeadIndustryController.clear();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Industry';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 18),

                // Company Name
                CustomField(
                  showIcon: true,
                  withShadow: false,
                  customIcon: Icon(Icons.view_compact_alt_sharp, size: 28),
                  labelText: "Company",
                  hintText: 'Enter Company Name',
                  editingController: controller.leadComapnyController,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Company Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Assign To
                Obx(
                  () => CustomSelect(
                    label: "Assign to",
                    withShadow: false,
                    withIcon: true,
                    customIcon:
                        Icon(Icons.supervised_user_circle_outlined, size: 28),
                    placeholder: "Assign To",
                    mainList: controller.leadAssignToList
                        .map((element) => CustomSelectItem(
                              id: element.id ?? "",
                              value: element.name ?? "",
                            ))
                        .toList(),
                    onSelect: (val) async {
                      controller.leadAssignToController.text = val.id;
                      controller.showLeadAssignToController.text = val.value;
                    },
                    textEditCtlr: controller.showLeadAssignToController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadAssignToController.clear();
                      controller.showLeadAssignToController.clear();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Assignee';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 18),

                // Deal Size
                CustomField(
                  showIcon: true,
                  withShadow: false,
                  customIcon: Icon(Icons.currency_rupee_outlined, size: 28),
                  labelText: "Deal Size",
                  hintText: 'Enter Deal Size',
                  editingController: controller.leadDealSizeController,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Deal Size';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),

                // Description
                CustomField(
                  withShadow: false,
                  labelText: "Description",
                  hintText: 'Enter Lead Description',
                  editingController: controller.leadDescriptionontroller,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  minLines: 4,
                ),
                SizedBox(height: 18),
                CustomButton(
                  onPressed: () async {
                    await controller.updateLead(controller.details[0].leadid);
                    await controller.fetchLead(controller.details[0].leadid);
                    populateForm();
                    print("object done");
                  },
                  buttonType: ButtonTypes.primary,
                  width: Get.size.width,
                  text: "Update",
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  // Tab 1: Overview Section
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
                  onPressed: () async {
                    if (controller.commentController.text.isNotEmpty) {
                      controller
                          .postComment(controller.details[0].leadid.toString());
                    }
                    // Add your send functionality here
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
            child: controller.isLoading.value
                ? Center(
                    child: CustomLoader(),
                  )
                : controller.activityList.isEmpty
                    ? Center(
                        child: Text(
                          "No activities yet",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Obx(
                        () => ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: controller.activityList.length,
                          itemBuilder: (context, index) {
                            final activity = controller.activityList[index];
                            return _buildActivityTile(
                              date: activity.activityDateFormate,
                              time: activity.createdDateTime,
                              title: activity.entrytype ?? "No Title",
                              details: activity.description,
                              user: activity.createdByName,
                            );
                          },
                        ),
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
          return Icons.phone_outlined; // Example icon for "Lead Updated"
        case "comment":
          return Icons.chat_bubble_outline; // Example icon for "Lead Created"
        case "lead updated":
          return Icons.edit_outlined;
        case "followup":
          return Icons.recycling_outlined;
        case "lead assign":
          return Icons.assignment_ind_outlined;
        case "lead status":
          return Icons.factory_outlined; // Example icon for "Lead Deleted"
        default:
          return Icons.info_outline; // Default icon for other titles
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              date,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
            Icon(getIconForTitle(title), color: Colors.teal),
            Container(
              height: 50.0,
              width: 3.0,
              color: Colors.teal,
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

  Widget _buildTaskCard(LeadTaskList task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => TaskDetailPage(), arguments: {
            "taskId": task.id, // Replace this with your dynamic taskId
          })!
              .then((_) {
            controller.fetchLeadTask(task.id!);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTaskStatusContainer(task.status!),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.entrytype!,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${task.followUpRemark}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task.assigntoName ?? "",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      task.dueDate ?? "",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    (task.entrytype!.toLowerCase() == "callactivity")
                        ? Text("Call At ${task.vdate}")
                        : Text("Follow Up at At ${task.followUpDateTime}")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableFAB(BuildContext context) {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isFabOpen.value) ...[
              _buildMiniFab(Icons.call, Colors.orange, () {
                buildCallDetails(context);
              }),
              SizedBox(height: 8),
              _buildMiniFab(Icons.update, Colors.orange, () {
                followupDialog(context);
              }),
              SizedBox(height: 8),
              _buildMiniFab(Icons.meeting_room, Colors.orange, () {
                buildMeetingDetails(context);
              }),
            ],
            FloatingActionButton(
              onPressed: controller.toggleFab,
              backgroundColor: Colors.orange,
              child: Icon(
                controller.isFabOpen.value ? Icons.close : Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Widget _buildMiniFab(IconData icon, Color color, VoidCallback onPressed) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: FloatingActionButton(
        key: ValueKey(icon),
        mini: true,
        onPressed: onPressed,
        backgroundColor: color,
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildTaskStatusContainer(String status) {
    Color backgroundColor;
    Color textColor;

    // Define colors based on the status
    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green;
        break;
      case 'pending':
        backgroundColor = Colors.yellow.shade100;
        textColor = Colors.orange;
        break;
      case 'overdue':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Tab 2: Activity Section
  Widget _buildTaskSection(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CustomLoader(),
                )
              : controller.TaskList.isEmpty
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
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemCount: controller.TaskList.length,
                      itemBuilder: (context, index) {
                        final task = controller.TaskList[index];
                        return _buildTaskCard(task);
                      },
                    ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: _buildExpandableFAB(context),
          ),
        ),
      ],
    );
  }

  Future followupDialog(BuildContext context) {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.update, color: Colors.teal),
                  SizedBox(width: 12),
                  Text(
                    'Add Follow Up',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Get.back()),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Assign To Section
                    Text(
                      'Assign To',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() => CustomSelect(
                          withShadow: true,
                          withIcon: true,
                          customIcon: Icon(Icons.person_outline, size: 24),
                          placeholder: "Select Assignee",
                          mainList: controller.leadAssignToList
                              .map(
                                (element) => CustomSelectItem(
                                  id: element.id ?? "",
                                  value: element.name ?? "",
                                ),
                              )
                              .toList(),
                          onSelect: (val) {
                            controller.afAssignToController.text = val.id;
                            controller.afShowAssignToController.text =
                                val.value;
                          },
                          textEditCtlr: controller.afShowAssignToController,
                          showLabel: false,
                          label: '',
                        )),

                    SizedBox(height: 24),

                    // Date and Time Section
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              CustomField(
                                withShadow: true,
                                hintText: "Select date",
                                readOnly: true,
                                editingController: controller.afDateController,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.text,
                                labelText: '',
                                onFieldTap: () {
                                  Get.bottomSheet(
                                    CustomDatePicker(
                                      pastAllow: true,
                                      confirmHandler: (date) {
                                        controller.afDateController.text =
                                            date ?? "";
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reminder',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              CustomField(
                                withShadow: true,
                                hintText: "Set reminder",
                                readOnly: true,
                                editingController: controller.ReminderCtlr,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.text,
                                labelText: '',
                                onFieldTap: () => _showReminderPicker(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Description Section
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomField(
                      withShadow: true,
                      hintText: 'Enter follow-up details',
                      editingController: controller.afDescriptionController,
                      minLines: 4,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      labelText: '',
                    ),
                  ],
                ),
              ),
            ),

            // Footer with Action Button
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: CustomButton(
                onPressed: () async {
                  controller.isLoading.value = true;
                  await controller.addFollowUp(controller.details[0].leadid!);
                  controller.fetchLeadTask(controller.details[0].leadid!);
                  controller.fetchLeadActivity(controller.details[0].leadid!);
                  controller.isLoading.value = false;
                  // Get.back();
                },
                buttonType: ButtonTypes.primary,
                width: Get.size.width,
                text: "Save Follow Up",
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future buildCallDetails(BuildContext context) {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_in_talk, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    'Call Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and Assign To Row
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomField(
                                  withShadow: true,
                                  hintText: "Select date",
                                  readOnly: true,
                                  editingController:
                                      controller.cdDateController,
                                  inputAction: TextInputAction.next,
                                  inputType: TextInputType.text,
                                  labelText: '',
                                  onFieldTap: () {
                                    Get.bottomSheet(
                                      CustomDatePicker(
                                        pastAllow: true,
                                        confirmHandler: (date) {
                                          controller.cdDateController.text =
                                              date ?? "";
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assign To',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              Obx(() => CustomSelect(
                                    withShadow: true,
                                    customIcon:
                                        Icon(Icons.person_outline, size: 24),
                                    placeholder: "Select Assignee",
                                    mainList: controller.leadAssignToList
                                        .map(
                                          (element) => CustomSelectItem(
                                            id: element.id ?? "",
                                            value: element.name ?? "",
                                          ),
                                        )
                                        .toList(),
                                    onSelect: (val) {
                                      controller.cdAssignToController.text =
                                          val.id;
                                      controller.cdShowAssignToController.text =
                                          val.value;
                                    },
                                    textEditCtlr:
                                        controller.cdShowAssignToController,
                                    showLabel: false,
                                    label: '',
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Call Type and Status Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Call Type',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              Obx(() => CustomSelect(
                                    withShadow: true,
                                    customIcon: Icon(Icons.call_made, size: 24),
                                    placeholder: "Select Type",
                                    mainList: controller.calltype
                                        .map(
                                          (element) => CustomSelectItem(
                                            id: element.value ?? "",
                                            value: element.status ?? "",
                                          ),
                                        )
                                        .toList(),
                                    onSelect: (val) {
                                      controller.cdCallTypeController.text =
                                          val.id;
                                      controller.cdShowCallTypeController.text =
                                          val.value;
                                    },
                                    textEditCtlr:
                                        controller.cdShowCallTypeController,
                                    showLabel: false,
                                    label: '',
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Call Status',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              Obx(() => CustomSelect(
                                    withShadow: true,
                                    customIcon:
                                        Icon(Icons.pending_actions, size: 24),
                                    placeholder: "Select Status",
                                    mainList: controller.callstatus
                                        .map(
                                          (element) => CustomSelectItem(
                                            id: element.value ?? "",
                                            value: element.status ?? "",
                                          ),
                                        )
                                        .toList(),
                                    onSelect: (val) {
                                      controller.cdCallStatusController.text =
                                          val.value;
                                    },
                                    textEditCtlr:
                                        controller.cdCallStatusController,
                                    showLabel: false,
                                    label: '',
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Remarks Section
                    Text(
                      'Remarks',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomField(
                      withShadow: true,
                      hintText: 'Enter call remarks',
                      editingController: controller.cdRemarkController,
                      minLines: 4,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      labelText: '',
                    ),
                  ],
                ),
              ),
            ),

            // Footer with Action Button
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: CustomButton(
                onPressed: () {
                  controller.addCall(controller.details[0].leadid);
                },
                buttonType: ButtonTypes.primary,
                width: Get.size.width,
                text: "Save Call Details",
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future buildMeetingDetails(BuildContext context) {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.meeting_room, color: Colors.purple),
                  SizedBox(width: 12),
                  Text(
                    'Meeting Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Text(
                      'Meeting Title',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomField(
                      withShadow: true,
                      hintText: "Enter meeting title",
                      editingController: controller.titleController,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      labelText: '',
                    ),

                    SizedBox(height: 24),

                    // Assign To Section
                    Text(
                      'Assign To',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() => CustomSelect(
                          withShadow: true,
                          customIcon: Icon(Icons.person_outline, size: 24),
                          placeholder: "Select Assignee",
                          mainList: controller.leadAssignToList
                              .map(
                                (element) => CustomSelectItem(
                                  id: element.id ?? "",
                                  value: element.name ?? "",
                                ),
                              )
                              .toList(),
                          onSelect: (val) {
                            controller.assignToController.text = val.id;
                            controller.showassignToController.text = val.value;
                          },
                          textEditCtlr: controller.showassignToController,
                          showLabel: false,
                          label: '',
                        )),

                    SizedBox(height: 24),

                    // Date Range Section
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              CustomField(
                                withShadow: true,
                                hintText: "Start date",
                                readOnly: true,
                                editingController: controller.fromDateCtlr,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.text,
                                labelText: '',
                                onFieldTap: () {
                                  Get.bottomSheet(
                                    CustomDatePicker(
                                      pastAllow: true,
                                      confirmHandler: (date) {
                                        controller.fromDateCtlr.text =
                                            date ?? "";
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              CustomField(
                                withShadow: true,
                                hintText: "End date",
                                readOnly: true,
                                editingController: controller.toDateController,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.text,
                                labelText: '',
                                onFieldTap: () {
                                  Get.bottomSheet(
                                    CustomDatePicker(
                                      pastAllow: true,
                                      confirmHandler: (date) {
                                        controller.toDateController.text =
                                            date ?? "";
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Location Section
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomField(
                      withShadow: true,
                      hintText: "Enter meeting location",
                      editingController: controller.locationController,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      labelText: '',
                      minLines: 2,
                    ),

                    SizedBox(height: 24),

                    // Description Section
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomField(
                      withShadow: true,
                      hintText: "Enter meeting description",
                      editingController: controller.descriptionController,
                      minLines: 3,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      labelText: '',
                    ),

                    SizedBox(height: 24),

                    // Outcome Section
                    Text(
                      'Outcome Remarks',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomField(
                      withShadow: true,
                      hintText: "Enter meeting outcomes",
                      editingController: controller.ocRemarkController,
                      minLines: 3,
                      labelText: 'Meeting Outcome',
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),

            // Footer with Action Buttons
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomActionButton(
                      onPressed: () {
                        // Save meeting details
                        Get.back();
                      },
                      type: CustomButtonType.cancel,
                      label: 'Cancel',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomActionButton(
                      onPressed: () {
                        controller.addMetting();
                      },
                      type: CustomButtonType.save,
                      label: 'Save',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showReminderPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Set Reminder",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Hours",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: controller.hoursInputController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "0",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (value) {
                            controller.selectedHours.value =
                                int.tryParse(value) ?? 0;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Minutes",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: controller.minutesInputController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "0",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (value) {
                            controller.selectedMinutes.value =
                                int.tryParse(value) ?? 0;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                final hours = controller.selectedHours.value;
                final minutes = controller.selectedMinutes.value;
                controller.ReminderCtlr.text = "${hours}h ${minutes}m";
                Get.back();
              },
              buttonType: ButtonTypes.primary,
              width: Get.size.width,
            ),
          ],
        ),
      ),
    );
  }
}
