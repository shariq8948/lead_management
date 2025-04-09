import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/contacts/contactsController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/customer_model.dart';
import '../leads/create_lead/create_lead_page.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_loader.dart';
import '../widgets/custom_select.dart';

class Detailspage extends StatefulWidget {
  const Detailspage({super.key});

  @override
  State<Detailspage> createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  final ContactController controller = Get.put(ContactController());
  late String id;

  @override
  void initState() {
    super.initState();
    id = Get.arguments; // Get the ID passed as arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDetails(id); // Fetch customer details
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        // Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        child: Obx(() {
          // Check if details are still loading
          if (controller.isLoading.value) {
            return const Center(child: CustomLoader());
          }
          // Check if no data is fetched
          if (controller.details.isEmpty) {
            return const Center(child: Text("No details available."));
          }
          // Build UI when details are loaded
          return Column(
            children: [
              _buildHeader(controller.details[0]),
              const SizedBox(height: 16),
              _buildContactActions(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(CustomerDetail detail) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      detail.createdOn,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(detail.contact ?? "Psm Softtech Pvt Ltd"),
                    const SizedBox(height: 4),
                    Text("Email: ${detail.email ?? "abc@gmail.com"}"),
                    Text("Mobile: ${detail.mobile ?? "99999 99999"}"),
                    const SizedBox(height: 4),
                    Text(
                      "Address: ${detail.address ?? ""}",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactActions() {
    final actions = [
      {"label": "Call", "count": 20, "icon": Icons.call, "color": Colors.blue},
      {
        "label": "WhatsApp",
        "count": 55,
        "icon": Icons.chat,
        "color": Colors.green
      },
      {"label": "SMS", "count": 5, "icon": Icons.sms, "color": Colors.red},
      {
        "label": "Email",
        "count": 10,
        "icon": Icons.email,
        "color": Colors.purple
      },
      {"label": "Leads", "count": 1, "icon": Icons.flag, "color": Colors.blue},
      {
        "label": "Meeting",
        "count": 6,
        "icon": Icons.event,
        "color": Colors.orange
      },
      {
        "label": "Follow up",
        "count": 44,
        "icon": Icons.update,
        "color": Colors.blueAccent
      },
      {
        "label": "Quotation",
        "count": 44,
        "icon": Icons.monetization_on,
        "color": Colors.amber
      },
    ];

    return Column(
      children: actions.map((action) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Section: Icon + Label
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: action['color'] as Color,
                    child: Icon(
                      action['icon'] as IconData,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    action['label'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Right Section: Count + Plus Icon with onTap
              Row(
                children: [
                  Text(
                    action['count'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      if (action['label'] == "WhatsApp") {
                        _launchWhatsApp(controller.details[0].mobile);
                      } else if (action['label'] == "SMS") {
                        _launchSMS(controller.details[0].mobile);
                      } else if (action['label'] == "Email") {
                        _launchMail(controller.details[0].email);
                      } else if (action['label'] == "Call") {
                        _launchPhone(controller.details[0].mobile);
                      } else if (action['label'] == "Leads") {
                        Get.toNamed('/create-lead',
                            arguments: {'isEdit': false});
                      }
                      // } else if (action['label'] == "Meeting") {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return MeetingDialog(); // Wrap the dialog here
                      //     },
                      //   );
                      // } else if (action['label'] == "Follow up") {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return FollowUpDialog(); // Wrap the dialog here
                      //     },
                      //   );
                      // }
                    },
                    child: Icon(
                      Icons.add_box_outlined,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

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

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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

  void _onPlusTapped(String label) {
    // Add your custom logic for the onTap
    Get.snackbar("Action Triggered", "You tapped on Plus for $label",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white);
  }
}

// class FollowUpDialog extends StatelessWidget {
//   final ContactController controller = Get.put(ContactController());
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: Get.size.height * .2),
//       child: Container(
//         decoration: BoxDecoration(),
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context)
//               .unfocus(), // Dismiss keyboard on tap outside
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context)
//                         .viewInsets
//                         .bottom, // Adjust for the keyboard
//                   ),
//                   child: Container(
//                     child: Dialog(
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Center(
//                               child: Text(
//                                 "Follow Up",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 26),
//                             CustomField(
//                               withShadow: true,
//                               labelText: "Date",
//                               hintText: "Select date",
//                               inputAction: TextInputAction.done,
//                               inputType: TextInputType.datetime,
//                               showLabel: false,
//                               bgColor: Colors.white,
//                               enabled: true,
//                               readOnly: true,
//                               editingController: controller.DateCtlr,
//                               onFieldTap: () {
//                                 Get.bottomSheet(
//                                   CustomDatePicker(
//                                     pastAllow: true,
//                                     confirmHandler: (date) async {
//                                       controller.DateCtlr.text = date ?? "";
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             Obx(
//                               () => CustomSelect(
//                                 label: "Assign to",
//                                 withShadow: false,
//                                 withIcon: true,
//                                 customIcon: Icon(
//                                   Icons.supervised_user_circle_outlined,
//                                   size: 28,
//                                 ),
//                                 placeholder: "Assign To",
//                                 mainList: controller.leadAssignToList
//                                     .map(
//                                       (element) => CustomSelectItem(
//                                         id: element.id ?? "",
//                                         // Extract the productId as id
//                                         value: element.name ??
//                                             "", // Extract the productName as value
//                                       ),
//                                     )
//                                     .toList(),
//                                 onSelect: (val) async {
//                                   controller.leadAssignToController.text =
//                                       val.id;
//                                   controller.showLeadAssignToController.text =
//                                       val.value;
//                                 },
//                                 textEditCtlr:
//                                     controller.showLeadAssignToController,
//                                 showLabel: false,
//                                 onTapField: () {
//                                   controller.leadAssignToController.clear();
//                                   controller.showLeadAssignToController.clear();
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             CustomField(
//                               withShadow: true,
//                               labelText: "Reminder",
//                               hintText: "Set reminder",
//                               inputAction: TextInputAction.done,
//                               inputType: TextInputType.text,
//                               showLabel: false,
//                               bgColor: Colors.white,
//                               enabled: true,
//                               readOnly: true,
//                               editingController: controller
//                                   .ReminderCtlr, // Add a new controller for reminder
//                               onFieldTap: () {
//                                 // Show a Time Picker when the field is tapped
//                                 showTimePicker(
//                                   context: context,
//                                   initialTime: TimeOfDay.now(),
//                                 ).then((pickedTime) {
//                                   if (pickedTime != null) {
//                                     // Format the selected time into hours and minutes
//                                     final formattedTime =
//                                         "${pickedTime.hour} hours and ${pickedTime.minute} minutes";
//                                     controller.ReminderCtlr.text =
//                                         formattedTime;
//                                   }
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             CustomField(
//                               editingController: controller.remarkcontroller,
//                               hintText: "Enter Remark",
//                               labelText: "Remark",
//                               inputType: TextInputType.text,
//                               inputAction: TextInputAction.next,
//                               minLines: 3,
//                             ),
//                             const SizedBox(height: 32),
//                             Center(
//                               child: SizedBox(
//                                 height: Get.size.height * .05,
//                                 width: Get.size.width *
//                                     .7, // Adjust the width as needed
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     print("Date: ${controller.DateCtlr}");
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blue,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     "Save",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MeetingDialog extends StatelessWidget {
//   final ContactController controller = Get.put(ContactController());
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(),
//       child: GestureDetector(
//         onTap: () =>
//             FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context)
//                       .viewInsets
//                       .bottom, // Adjust for the keyboard
//                 ),
//                 child: Container(
//                   child: Dialog(
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: Text(
//                               "Meeting",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                           CustomField(
//                             editingController: controller.meetingTitle,
//                             hintText: "Title",
//                             labelText: "title",
//                             inputType: TextInputType.text,
//                             inputAction: TextInputAction.next,
//                           ),
//                           const SizedBox(height: 26),
//                           CustomField(
//                             withShadow: true,
//                             labelText: "From",
//                             hintText: "From",
//                             inputAction: TextInputAction.done,
//                             inputType: TextInputType.datetime,
//                             showLabel: false,
//                             bgColor: Colors.white,
//                             enabled: true,
//                             readOnly: true,
//                             editingController: controller.mettingFromDateCtlr,
//                             onFieldTap: () {
//                               Get.bottomSheet(
//                                 CustomDatePicker(
//                                   pastAllow: true,
//                                   confirmHandler: (date) async {
//                                     controller.mettingFromDateCtlr.text =
//                                         date ?? "";
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           CustomField(
//                             withShadow: true,
//                             labelText: "To",
//                             hintText: "To",
//                             inputAction: TextInputAction.done,
//                             inputType: TextInputType.datetime,
//                             showLabel: false,
//                             bgColor: Colors.white,
//                             enabled: true,
//                             readOnly: true,
//                             editingController: controller.mettingToDateCtlr,
//                             onFieldTap: () {
//                               Get.bottomSheet(
//                                 CustomDatePicker(
//                                   pastAllow: true,
//                                   confirmHandler: (date) async {
//                                     controller.mettingToDateCtlr.text =
//                                         date ?? "";
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           Obx(
//                             () => CustomSelect(
//                               label: "Assign to",
//                               withShadow: false,
//                               withIcon: true,
//                               customIcon: Icon(
//                                 Icons.supervised_user_circle_outlined,
//                                 size: 28,
//                               ),
//                               placeholder: "Assign To",
//                               mainList: controller.leadAssignToList
//                                   .map(
//                                     (element) => CustomSelectItem(
//                                       id: element.id ?? "",
//                                       // Extract the productId as id
//                                       value: element.name ??
//                                           "", // Extract the productName as value
//                                     ),
//                                   )
//                                   .toList(),
//                               onSelect: (val) async {
//                                 controller.leadAssignToController.text = val.id;
//                                 controller.showLeadAssignToController.text =
//                                     val.value;
//                               },
//                               textEditCtlr:
//                                   controller.showLeadAssignToController,
//                               showLabel: false,
//                               onTapField: () {
//                                 controller.leadAssignToController.clear();
//                                 controller.showLeadAssignToController.clear();
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           CustomField(
//                             withShadow: true,
//                             labelText: "Reminder",
//                             hintText: "Set reminder",
//                             inputAction: TextInputAction.done,
//                             inputType: TextInputType.text,
//                             showLabel: false,
//                             bgColor: Colors.white,
//                             enabled: true,
//                             readOnly: true,
//                             editingController: controller
//                                 .mettingReminderCtlr, // Add a new controller for reminder
//                             onFieldTap: () {
//                               // Show a Time Picker when the field is tapped
//                               showTimePicker(
//                                 context: context,
//                                 initialTime: TimeOfDay.now(),
//                               ).then((pickedTime) {
//                                 if (pickedTime != null) {
//                                   // Format the selected time into hours and minutes
//                                   final formattedTime =
//                                       "${pickedTime.hour} hours and ${pickedTime.minute} minutes";
//                                   controller.mettingReminderCtlr.text =
//                                       formattedTime;
//                                 }
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           CustomField(
//                             editingController: controller.mettingLocation,
//                             hintText: "Location",
//                             labelText: "Location",
//                             inputType: TextInputType.text,
//                             inputAction: TextInputAction.next,
//                             minLines: 3,
//                           ),
//                           const SizedBox(height: 16),
//                           CustomField(
//                             editingController: controller.mettingdesc,
//                             hintText: "Description",
//                             labelText: "Description",
//                             inputType: TextInputType.text,
//                             inputAction: TextInputAction.next,
//                             minLines: 3,
//                           ),
//                           const SizedBox(height: 16),
//                           CustomField(
//                             editingController: controller.meetingod,
//                             hintText: "Outcome Description",
//                             labelText: "Outcome Description",
//                             inputType: TextInputType.text,
//                             inputAction: TextInputAction.next,
//                             minLines: 3,
//                           ),
//                           const SizedBox(height: 32),
//                           Center(
//                             child: SizedBox(
//                               height: Get.size.height * .05,
//                               width: Get.size.width *
//                                   .7, // Adjust the width as needed
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   print("Date: ${controller.DateCtlr}");
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "Save",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
