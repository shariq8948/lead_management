import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/taskDeatails/task_details_controller.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_select.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_date_picker.dart';
import '../widgets/text_to_speech.dart';
extension GroupByExtension<E> on List<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keySelector) {
    final Map<K, List<E>> map = {};
    for (var element in this) {
      final key = keySelector(element);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(element);
    }
    return map;
  }
}

class TaskDetailPage extends StatelessWidget {
  final TaskDetailController controller = Get.put(TaskDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text("Task Detail"),
      ),
      body: Obx(
            () {
          // Check loading state for task details and task activities
          if (controller.isLoadingDetails.value) {
            return Center(child: CircularProgressIndicator()); // Task details loading
          } else if (controller.isLoadingActivities.value) {
            return Center(child: CircularProgressIndicator()); // Task activities loading
          } else {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
                ),
              ),
              child: Column(
                children: [
                  // Task Details Section
                  _buildTaskDetails(),

                  // Tab Section
                  _buildTabSection(),

                  // Dynamic Content Based on Tab Selection
                  Obx(() {
                    return controller.selectedTab.value == 0
                        ? Expanded(child: _buildTaskActivityList())
                        : Expanded(child: _buildUpdaterTaskForm());
                  }),

                  // Contact Info Button
                  if(controller.selectedTab.value==0)
                    _buildContactInfoButton(),

                ],
              ),
            );
          }
        },
      ),
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
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      controller.taskDetails[0].entrytype ?? "",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(controller.taskDetails[0].cname ?? ""),
                  ],
                ),
                DropdownButton<String>(
                  value: controller.taskStatus.value,
                  items: ["Pending", "Completed", "Cancelled"]
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (newStatus) =>
                      controller.updateTaskStatus(newStatus!),
                ),
              ],
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Call Icon - Launch Dialer
                IconButton(
                  icon: Image(image: AssetImage('assets/icons/call (2).png')),
                  onPressed: () => _launchPhone(controller.taskDetails[0].mobile!),
                  color: Colors.blue,
                ),
                // WhatsApp Icon - Launch WhatsApp
                IconButton(
                  icon: Image(image: AssetImage('assets/icons/whatsapp.png')),
                  onPressed: () => _launchWhatsApp(controller.taskDetails[0].mobile!),
                  color: Colors.green,
                ),
                // Message Icon - Launch SMS
                IconButton(
                  icon: Image(image: AssetImage('assets/icons/message.png')),
                  onPressed: () => _launchSMS(controller.taskDetails[0].mobile!),
                  color: Colors.blue,
                ),
                // Mail Icon - Launch Email
                IconButton(
                  icon: Image(image: AssetImage('assets/icons/mail.png')),
                  onPressed: () => _launchMail(controller.taskDetails[0].email ?? ""),
                  color: Colors.red,
                ),
                // Share Icon - Share Content
                IconButton(
                  icon: Image(image: AssetImage('assets/icons/share.png')),
                  onPressed: () => _shareContent(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Text(
                controller.taskDetails[0].remark ?? "No Remark",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildTabSection() {
    return Obx(
          () => Container(
            margin: EdgeInsets.only(left: 10,right: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(12, 48, 42, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: controller.selectedTab.value == 0
                              ? Color(0xFF3CDBC0)
                              : Colors.transparent,
                          width: 5,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Task Activity",
                        style: TextStyle(
                          color: controller.selectedTab.value == 0
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: controller.selectedTab.value == 1
                              ? Color(0xFF3CDBC0)
                              : Colors.transparent,
                          width: 5,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Updater Task",
                        style: TextStyle(
                          color: controller.selectedTab.value == 1
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskActivityList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF0FFEE),
      ),
      child: Column(
        children: [
          // TextField for input
          ChatInputField(),
          Expanded(
            child: Obx(
                  () => controller.isLoadingActivities.value
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: _buildGroupedActivities(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedActivities() {
    // Use the `groupBy` extension to group activities by date
    final groupedActivities = controller.taskActivities.toList()
        .groupBy((activity) => activity.formateddate);

    List<Widget> widgets = [];

    groupedActivities.forEach((date, activities) {
      // Date Header
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          date! == DateFormat('dd MMM').format(DateTime.now())
              ? "Today"
              : date,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ));

      // List of activities for that date
      for (var activity in activities) {
        widgets.add(Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.typename!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  activity.typemsg!,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.hon!,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      activity.actihisycreatedbyname!,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
      }
    });

    return widgets;
  }

  Widget _buildUpdaterTaskForm() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Assign To",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18),),
                  ),
                ),
                Expanded(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: CustomSelect(
                        label: "Registration type",
                        placeholder: "Registration",
                        mainList: controller.assignto
                            .map(
                              (element) => CustomSelectItem(
                            id: element ?? "",
                            value: element ?? "",
                          ),
                        )
                            .toList(),
                        onSelect: (val) async {
                          controller.assignToController.text = val.value;
                        },
                        textEditCtlr: controller.assignToController,
                        showLabel: false,
                        onTapField: () {
                          controller.assignToController.clear();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please select a product";
                          }
                          return null;
                        },
                      ),

                    ),
                )
      
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Follow Up",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18),),
                  ),
                ),
                Expanded(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child:CustomField(
                          hintText: "Set Reminder",
                          labelText: "",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.datetime,
                          readOnly: true,
                          editingController: controller.toDateController,
                          onFieldTap: (){
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

                    ),
                )

              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Set Reminder",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18),),
                  ),
                ),
                Expanded(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child:CustomField(
                          hintText: "Set Reminder",
                          labelText: "",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.datetime,
                          readOnly: true,
                          editingController: controller.toDateController,
                          onFieldTap: (){
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

                    ),
                )

              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                Expanded(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child:CustomField(
                          hintText: "Enter Remark",
                          labelText: "",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.text,
                          readOnly: false,
                          editingController: controller.remarkController,
                          minLines: 6,
                      ),

                    ),
                ),


              ],
            ),
            SizedBox(height: 30,),
            CustomButton(onPressed: (){}, buttonType:ButtonTypes.primary, width: Get.size.width*1,text: "Save",bgColor: Colors.green,)

          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoButton() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GestureDetector(

        // onTap: () => Get.to(ContactInfoPage()),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200, width: 2),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Contact Info",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
