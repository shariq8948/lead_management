// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:googleapis_auth/auth.dart';
// import 'package:intl/intl.dart';
// import 'package:leads/widgets/floatingbutton.dart';
// import '../Tasks/taskDeatails/task_details_page.dart';
// import '../data/models/task_list.dart';
// import '../google_service/google_calendar_helper.dart';
// import '../utils/routes.dart';
// import '../widgets/custom_date_picker.dart';
// import '../widgets/custom_field.dart';
// import '../widgets/custom_select.dart';
// import 'mytask_controller.dart';
//
// class CalendarPage extends StatelessWidget {
//   final CalendarController1 calendarController = Get.put(CalendarController1());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: CustomFloatingActionButton(
//           onPressed: () {
//             showFollowUpModal(calendarController.selectedDate.value, context);
//           },
//           icon: Icons.add),
//       appBar: AppBar(
//         title: const Text('Calendar'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Column(
//         children: [
//           // Calendar view
//           Expanded(
//             child: Obx(
//               () => SfCalendar(
//                 showCurrentTimeIndicator: true,
//                 showDatePickerButton: true,
//                 showTodayButton: true,
//                 dataSource: TaskDataSource(calendarController.todoList),
//                 viewHeaderStyle: ViewHeaderStyle(
//                   backgroundColor: Colors.tealAccent,
//                   dateTextStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   dayTextStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 view: CalendarView.month,
//                 allowedViews: const [
//                   CalendarView.day,
//                   CalendarView.week,
//                   CalendarView.workWeek,
//                   CalendarView.month,
//                   CalendarView.timelineDay,
//                   CalendarView.timelineWeek,
//                   CalendarView.timelineWorkWeek,
//                 ],
//                 initialSelectedDate: DateTime.now(),
//                 onTap: (CalendarTapDetails details) {
//                   if (details.date != null) {
//                     calendarController.selectedDate.value = details.date!;
//
//                     // Check tasks for the selected date
//                     final dateFormat = DateFormat("M/d/yyyy h:mm:ss a");
//                     final selectedDate = details.date!;
//                     final tasksForSelectedDate =
//                         calendarController.todoList.where((task) {
//                       try {
//                         final followUpDateTime = task.followUpDateTime != null
//                             ? dateFormat.parse(task.followUpDateTime!)
//                             : null;
//
//                         return followUpDateTime != null &&
//                             followUpDateTime.year == selectedDate.year &&
//                             followUpDateTime.month == selectedDate.month &&
//                             followUpDateTime.day == selectedDate.day;
//                       } catch (e) {
//                         print(
//                             "Error parsing date: ${task.followUpDateTime} - $e");
//                         return false;
//                       }
//                     }).toList();
//                   }
//                 },
//                 monthViewSettings: const MonthViewSettings(
//                   appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
//                 ),
//               ),
//             ),
//           ),
//           // Task list based on selected date
//           Obx(() {
//             final dateFormat = DateFormat("M/d/yyyy h:mm:ss a");
//
//             final selectedDate = calendarController.selectedDate.value;
//             print("Selected Date: $selectedDate");
//             print("Tasks in todoList: ${calendarController.todoList.length}");
//
//             final tasksForSelectedDate =
//                 calendarController.todoList.where((task) {
//               try {
//                 final followUpDateTime = task.followUpDateTime != null
//                     ? dateFormat.parse(task.followUpDateTime!)
//                     : null;
//
//                 return followUpDateTime != null &&
//                     followUpDateTime.year == selectedDate.year &&
//                     followUpDateTime.month == selectedDate.month &&
//                     followUpDateTime.day == selectedDate.day;
//               } catch (e) {
//                 print("Error parsing date: ${task.followUpDateTime} - $e");
//                 return false;
//               }
//             }).toList();
//
//             print("Tasks for selected date: ${tasksForSelectedDate.length}");
//
//             if (tasksForSelectedDate.isEmpty) {
//               return const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'No tasks available for the selected date.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               );
//             }
//
//             return Expanded(
//               child: ListView.builder(
//                 itemCount: tasksForSelectedDate.length,
//                 itemBuilder: (context, index) {
//                   final task = tasksForSelectedDate[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     elevation: 4,
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.task, color: Colors.blueAccent),
//                               SizedBox(width: 8),
//                               Text(
//                                 task.entrytype ?? 'No Entry Type',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'Follow-up Time: ${task.followUpDateTime ?? 'N/A'}',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           if (task.description != null)
//                             Text(
//                               'Description: ${task.remark}',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Priority: ${task.priority ?? 'Not set'}',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.redAccent,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Get.to(() => TaskDetailPage(), arguments: {
//                                     "taskId": task
//                                         .id, // Replace this with your dynamic taskId
//                                   })!
//                                       .then((_) {
//                                     calendarController.fetchtasks();
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: Text('Details'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   void showFollowUpModal(DateTime selectedDate, BuildContext context) {
//     Get.dialog(
//       Dialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Container(
//           width: Get.width * 0.9, // Increase width to 80% of the screen
//           height: Get.height * 0.7, // Increase height to 70% of the screen
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with title and close button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Follow Up [${selectedDate.toLocal().toString().split(' ')[0]}]',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Get.back(), // Close modal
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               // TabBar for navigation
//               DefaultTabController(
//                 length: 4,
//                 child: Expanded(
//                   child: Column(
//                     children: [
//                       TabBar(
//                         labelColor: Colors.teal,
//                         unselectedLabelColor: Colors.black54,
//                         indicatorColor: Colors.teal,
//                         tabs: const [
//                           Tab(text: 'FollowUp'),
//                           Tab(text: 'Call'),
//                           Tab(text: 'Meeting'),
//                           Tab(text: 'Todo'),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Expanded(
//                         child: TabBarView(
//                           children: [
//                             // FollowUp Form
//                             _buildFollowUpForm(context),
//                             _buildCallForm(context),
//                             _buildMettingForm(context),
//                             _buildTodoForm(context),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Action buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => Get.back(),
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.grey),
//                     child: const Text('Close'),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Save action
//                     },
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                     child: const Text('Save'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFollowUpForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         child: Column(
//           children: [
//             Obx(
//               () => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Customer"),
//                   Radio<String>(
//                     value: "Customer",
//                     groupValue: calendarController.selectedRole.value,
//                     onChanged: (value) {
//                       if (value != null &&
//                           value != calendarController.selectedRole.value) {
//                         FocusScope.of(context)
//                             .requestFocus(FocusNode()); // Unfocus all fields
//                         // Reset the text controllers
//                         calendarController.prospectController.clear();
//                         calendarController.showProspectController.clear();
//                         calendarController
//                             .switchRole(value); // Switch to Customer role
//                       }
//                     },
//                   ),
//                   Text("Prospect"),
//                   Radio<String>(
//                     value: "Prospect",
//                     groupValue: calendarController.selectedRole.value,
//                     onChanged: (value) {
//                       if (value != null &&
//                           value != calendarController.selectedRole.value) {
//                         FocusScope.of(context)
//                             .requestFocus(FocusNode()); // Unfocus all fields
//                         // Reset the text controllers
//                         calendarController.customerController.clear();
//                         calendarController.showCustomerController.clear();
//                         calendarController
//                             .switchRole(value); // Switch to Prospect role
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Assign To Field
//             Obx(
//               () => CustomSelect(
//                 label: "Assign to",
//                 withShadow: false,
//                 withIcon: true,
//                 customIcon:
//                     Icon(Icons.supervised_user_circle_outlined, size: 28),
//                 placeholder: "Assign To",
//                 mainList: calendarController.leadAssignToList
//                     .map((element) => CustomSelectItem(
//                         id: element.id ?? "", value: element.name ?? ""))
//                     .toList(),
//                 onSelect: (val) {
//                   calendarController.leadAssignToController.text = val.id;
//                   calendarController.showLeadAssignToController.text =
//                       val.value;
//                 },
//                 textEditCtlr: calendarController.showLeadAssignToController,
//                 showLabel: true,
//                 onTapField: () {
//                   calendarController.leadAssignToController.clear();
//                   calendarController.showLeadAssignToController.clear();
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty)
//                     return 'Please select Assignee';
//                   return null;
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Customer/Prospect Select
//             Obx(
//               () => CustomSelect(
//                 label: calendarController.isCustomer.value
//                     ? "Select Customer"
//                     : "Select Prospect",
//                 withShadow: false,
//                 withIcon: true,
//                 customIcon:
//                     Icon(Icons.supervised_user_circle_outlined, size: 28),
//                 placeholder: calendarController.isCustomer.value
//                     ? "Select Customer"
//                     : "Select Prospect",
//                 mainList: calendarController.isCustomer.value
//                     ? calendarController.customerList
//                         .map(
//                           (element) => CustomSelectItem(
//                             id: element.id,
//                             value: element.name ?? "",
//                           ),
//                         )
//                         .toList()
//                     : calendarController.prospectList
//                         .map(
//                           (element) => CustomSelectItem(
//                             id: element.id,
//                             value: element.name ?? "",
//                           ),
//                         )
//                         .toList(),
//                 onSelect: (val) {
//                   if (calendarController.isCustomer.value) {
//                     calendarController.customerController.text = val.id;
//                     calendarController.showCustomerController.text = val.value;
//                   } else {
//                     calendarController.prospectController.text = val.id;
//                     calendarController.showProspectController.text = val.value;
//                   }
//                 },
//                 textEditCtlr: calendarController.isCustomer.value
//                     ? calendarController.showCustomerController
//                     : calendarController.showProspectController,
//                 showLabel: true,
//                 onTapField: () {
//                   if (calendarController.isCustomer.value) {
//                     calendarController.customerController.clear();
//                     calendarController.showCustomerController.clear();
//                   } else {
//                     calendarController.prospectController.clear();
//                     calendarController.showProspectController.clear();
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Follow Up Date Field
//             CustomField(
//               withShadow: false,
//               labelText: "Follow Up Date",
//               hintText: "Follow Up Date",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.datetime,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.toDateCtlr,
//               onFieldTap: () {
//                 Get.bottomSheet(
//                   CustomDatePicker(
//                     pastAllow: true,
//                     confirmHandler: (date) async {
//                       calendarController.toDateCtlr.text = date ?? "";
//                     },
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             // Reminder Time Field
//             CustomField(
//               withShadow: false,
//               showIcon: true,
//               customIcon: Icon(Icons.watch_later_outlined),
//               labelText: "Reminder time",
//               hintText: "Set reminder",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.text,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.ReminderCtlr,
//               onFieldTap: () {
//                 showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 ).then((pickedTime) {
//                   if (pickedTime != null) {
//                     final formattedTime = DateFormat.jm().format(
//                       DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
//                     );
//                     calendarController.ReminderCtlr.text = formattedTime;
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 8),
//             // Remark Field
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "Remark",
//               labelText: "Remark",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               minLines: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCallForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         child: Column(
//           children: [
//             Obx(
//               () => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Customer"),
//                   Radio<String>(
//                     value: "Customer",
//                     groupValue: calendarController.selectedRole.value,
//                     onChanged: (value) {
//                       if (value != null &&
//                           value != calendarController.selectedRole.value) {
//                         FocusScope.of(context)
//                             .requestFocus(FocusNode()); // Unfocus all fields
//                         // Reset the text controllers
//                         calendarController.prospectController.clear();
//                         calendarController.showProspectController.clear();
//                         calendarController
//                             .switchRole(value); // Switch to Customer role
//                       }
//                     },
//                   ),
//                   Text("Prospect"),
//                   Radio<String>(
//                     value: "Prospect",
//                     groupValue: calendarController.selectedRole.value,
//                     onChanged: (value) {
//                       if (value != null &&
//                           value != calendarController.selectedRole.value) {
//                         FocusScope.of(context)
//                             .requestFocus(FocusNode()); // Unfocus all fields
//                         // Reset the text controllers
//                         calendarController.customerController.clear();
//                         calendarController.showCustomerController.clear();
//                         calendarController
//                             .switchRole(value); // Switch to Prospect role
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Assign To Field
//             Obx(
//               () => CustomSelect(
//                 label: "Assign to",
//                 withShadow: false,
//                 withIcon: true,
//                 customIcon:
//                     Icon(Icons.supervised_user_circle_outlined, size: 28),
//                 placeholder: "Assign To",
//                 mainList: calendarController.leadAssignToList
//                     .map((element) => CustomSelectItem(
//                         id: element.id ?? "", value: element.name ?? ""))
//                     .toList(),
//                 onSelect: (val) {
//                   calendarController.leadAssignToController.text = val.id;
//                   calendarController.showLeadAssignToController.text =
//                       val.value;
//                 },
//                 textEditCtlr: calendarController.showLeadAssignToController,
//                 showLabel: true,
//                 onTapField: () {
//                   calendarController.leadAssignToController.clear();
//                   calendarController.showLeadAssignToController.clear();
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty)
//                     return 'Please select Assignee';
//                   return null;
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Customer/Prospect Select
//             Obx(
//               () => CustomSelect(
//                 label: calendarController.isCustomer.value
//                     ? "Select Customer"
//                     : "Select Prospect",
//                 withShadow: false,
//                 withIcon: true,
//                 customIcon:
//                     Icon(Icons.supervised_user_circle_outlined, size: 28),
//                 placeholder: calendarController.isCustomer.value
//                     ? "Select Customer"
//                     : "Select Prospect",
//                 mainList: calendarController.isCustomer.value
//                     ? calendarController.customerList
//                         .map(
//                           (element) => CustomSelectItem(
//                             id: element.id,
//                             value: element.name ?? "",
//                           ),
//                         )
//                         .toList()
//                     : calendarController.prospectList
//                         .map(
//                           (element) => CustomSelectItem(
//                             id: element.id,
//                             value: element.name ?? "",
//                           ),
//                         )
//                         .toList(),
//                 onSelect: (val) {
//                   if (calendarController.isCustomer.value) {
//                     calendarController.customerController.text = val.id;
//                     calendarController.showCustomerController.text = val.value;
//                   } else {
//                     calendarController.prospectController.text = val.id;
//                     calendarController.showProspectController.text = val.value;
//                   }
//                 },
//                 textEditCtlr: calendarController.isCustomer.value
//                     ? calendarController.showCustomerController
//                     : calendarController.showProspectController,
//                 showLabel: true,
//                 onTapField: () {
//                   if (calendarController.isCustomer.value) {
//                     calendarController.customerController.clear();
//                     calendarController.showCustomerController.clear();
//                   } else {
//                     calendarController.prospectController.clear();
//                     calendarController.showProspectController.clear();
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Follow Up Date Field
//             CustomField(
//               withShadow: false,
//               labelText: "Follow Up Date",
//               hintText: "Follow Up Date",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.datetime,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.toDateCtlr,
//               onFieldTap: () {
//                 Get.bottomSheet(
//                   CustomDatePicker(
//                     pastAllow: true,
//                     confirmHandler: (date) async {
//                       calendarController.toDateCtlr.text = date ?? "";
//                     },
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             // Reminder Time Field
//             CustomField(
//               withShadow: false,
//               showIcon: true,
//               customIcon: Icon(Icons.watch_later_outlined),
//               labelText: "Reminder time",
//               hintText: "Set reminder",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.text,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.ReminderCtlr,
//               onFieldTap: () {
//                 showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 ).then((pickedTime) {
//                   if (pickedTime != null) {
//                     final formattedTime = DateFormat.jm().format(
//                       DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
//                     );
//                     calendarController.ReminderCtlr.text = formattedTime;
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 8),
//             // Remark Field
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "Remark",
//               labelText: "Remark",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               minLines: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMettingForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         child: Column(
//           children: [
//             Obx(
//               () => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Customer"),
//                   Radio<String>(
//                     value: "Customer",
//                     groupValue: calendarController.selectedRole.value,
//                     onChanged: (value) {
//                       if (value != null &&
//                           value != calendarController.selectedRole.value) {
//                         FocusScope.of(context)
//                             .requestFocus(FocusNode()); // Unfocus all fields
//                         // Reset the text controllers
//                         calendarController.prospectController.clear();
//                         calendarController.showProspectController.clear();
//                         calendarController
//                             .switchRole(value); // Switch to Customer role
//                       }
//                     },
//                   ),
//                   Text("Prospect"),
//                   Radio<String>(
//                     value: "Prospect",
//                     groupValue: calendarController.selectedRole.value,
//                     onChanged: (value) {
//                       if (value != null &&
//                           value != calendarController.selectedRole.value) {
//                         FocusScope.of(context)
//                             .requestFocus(FocusNode()); // Unfocus all fields
//                         // Reset the text controllers
//                         calendarController.customerController.clear();
//                         calendarController.showCustomerController.clear();
//                         calendarController
//                             .switchRole(value); // Switch to Prospect role
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Assign To Field
//             // Customer/Prospect Select
//             Obx(
//               () => CustomSelect(
//                 label: calendarController.isCustomer.value
//                     ? "Select Customer"
//                     : "Select Prospect",
//                 withShadow: false,
//                 withIcon: true,
//                 customIcon:
//                     Icon(Icons.supervised_user_circle_outlined, size: 28),
//                 placeholder: calendarController.isCustomer.value
//                     ? "Select Customer"
//                     : "Select Prospect",
//                 mainList: calendarController.isCustomer.value
//                     ? calendarController.customerList
//                         .map(
//                           (element) => CustomSelectItem(
//                             id: element.id,
//                             value: element.name ?? "",
//                           ),
//                         )
//                         .toList()
//                     : calendarController.prospectList
//                         .map(
//                           (element) => CustomSelectItem(
//                             id: element.id,
//                             value: element.name ?? "",
//                           ),
//                         )
//                         .toList(),
//                 onSelect: (val) {
//                   if (calendarController.isCustomer.value) {
//                     calendarController.customerController.text = val.id;
//                     calendarController.showCustomerController.text = val.value;
//                   } else {
//                     calendarController.prospectController.text = val.id;
//                     calendarController.showProspectController.text = val.value;
//                   }
//                 },
//                 textEditCtlr: calendarController.isCustomer.value
//                     ? calendarController.showCustomerController
//                     : calendarController.showProspectController,
//                 showLabel: true,
//                 onTapField: () {
//                   if (calendarController.isCustomer.value) {
//                     calendarController.customerController.clear();
//                     calendarController.showCustomerController.clear();
//                   } else {
//                     calendarController.prospectController.clear();
//                     calendarController.showProspectController.clear();
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "Title",
//               labelText: "Title",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               minLines: 3,
//             ),
//             const SizedBox(height: 8),
//
//             // Follow Up Date Field
//             CustomField(
//               withShadow: false,
//               labelText: "From",
//               hintText: "From",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.datetime,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.toDateCtlr,
//               onFieldTap: () {
//                 Get.bottomSheet(
//                   CustomDatePicker(
//                     pastAllow: true,
//                     confirmHandler: (date) async {
//                       calendarController.toDateCtlr.text = date ?? "";
//                     },
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             CustomField(
//               withShadow: false,
//               labelText: "To",
//               hintText: "To",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.datetime,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.toDateCtlr,
//               onFieldTap: () {
//                 Get.bottomSheet(
//                   CustomDatePicker(
//                     pastAllow: true,
//                     confirmHandler: (date) async {
//                       calendarController.toDateCtlr.text = date ?? "";
//                     },
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             // Reminder Time Field
//             CustomField(
//               withShadow: false,
//               showIcon: true,
//               customIcon: Icon(Icons.watch_later_outlined),
//               labelText: "Reminder time",
//               hintText: "Set reminder",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.text,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.ReminderCtlr,
//               onFieldTap: () {
//                 showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 ).then((pickedTime) {
//                   if (pickedTime != null) {
//                     final formattedTime = DateFormat.jm().format(
//                       DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
//                     );
//                     calendarController.ReminderCtlr.text = formattedTime;
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 8),
//             // Assign To Field
//             Obx(
//               () => CustomSelect(
//                 label: "Assign to",
//                 withShadow: false,
//                 withIcon: true,
//                 customIcon:
//                     Icon(Icons.supervised_user_circle_outlined, size: 28),
//                 placeholder: "Assign To",
//                 mainList: calendarController.leadAssignToList
//                     .map((element) => CustomSelectItem(
//                         id: element.id ?? "", value: element.name ?? ""))
//                     .toList(),
//                 onSelect: (val) {
//                   calendarController.leadAssignToController.text = val.id;
//                   calendarController.showLeadAssignToController.text =
//                       val.value;
//                 },
//                 textEditCtlr: calendarController.showLeadAssignToController,
//                 showLabel: true,
//                 onTapField: () {
//                   calendarController.leadAssignToController.clear();
//                   calendarController.showLeadAssignToController.clear();
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty)
//                     return 'Please select Assignee';
//                   return null;
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Remark Field
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "Location",
//               labelText: "Location",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               minLines: 3,
//             ),
//             const SizedBox(height: 8),
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "Description",
//               labelText: "Description",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               minLines: 3,
//             ),
//             const SizedBox(height: 8),
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "OutCome Remark",
//               labelText: "OutCome Remark",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               minLines: 3,
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTodoForm(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         child: Column(
//           children: [
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "Title",
//               labelText: "Title",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               editingController: calendarController.todoTitleController,
//             ),
//             const SizedBox(height: 8),
//
//             // Follow Up Date Field
//             CustomField(
//               withShadow: false,
//               labelText: "Date",
//               hintText: "Date",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.datetime,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.tododateController,
//               onFieldTap: () {
//                 Get.bottomSheet(
//                   CustomDatePicker(
//                     pastAllow: true,
//                     confirmHandler: (date) async {
//                       calendarController.tododateController.text = date ?? "";
//                     },
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             // Reminder Time Field
//             CustomField(
//               withShadow: false,
//               showIcon: true,
//               customIcon: Icon(Icons.watch_later_outlined),
//               labelText: "Reminder time",
//               hintText: "Set reminder",
//               inputAction: TextInputAction.done,
//               inputType: TextInputType.text,
//               showLabel: true,
//               bgColor: Colors.white,
//               enabled: true,
//               readOnly: true,
//               editingController: calendarController.todoReminderController,
//               onFieldTap: () {
//                 showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 ).then((pickedTime) {
//                   if (pickedTime != null) {
//                     final formattedTime = DateFormat.jm().format(
//                       DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
//                     );
//                     calendarController.todoReminderController.text =
//                         formattedTime;
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 8),
//             // Remark Field
//             CustomField(
//               withShadow: false,
//               showLabel: true,
//               hintText: "Remark",
//               labelText: "Remark",
//               inputAction: TextInputAction.next,
//               inputType: TextInputType.text,
//               minLines: 3,
//               editingController: calendarController.todoremarkController,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Assume you have obtained AuthClient from Google Sign-In
//                 final authClient = await getGoogleAuthClient();
//                 if (authClient != null) {
//                   await calendarController.createGoogleCalendarEvent(
//                       authClient,
//                       calendarController.todoTitleController.text,
//                       calendarController.tododateController.text,
//                       calendarController.tododateController.text,
//                       "Psm Softtech",
//                       calendarController.todoremarkController.text);
//                 }
//               },
//               child: Text('Create Google Calendar Event'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TaskDataSource extends CalendarDataSource {
//   TaskDataSource(List<TaskList> tasks) {
//     // Define the custom date format to handle AM/PM time
//     final DateFormat dateFormat = DateFormat("M/d/yyyy h:mm:ss a");
//
//     appointments = tasks
//         .where((task) =>
//             task.followUpDateTime != null) // Ensure the date is not null
//         .map((task) {
//           // Log the raw date string for debugging
//           print("Raw date string: ${task.followUpDateTime}");
//
//           try {
//             // Parse the date using the custom format
//             final startDate = dateFormat.parse(task.followUpDateTime!);
//             final endDate =
//                 startDate.add(Duration(hours: 1)); // Adjust duration as needed
//
//             return Appointment(
//               startTime: startDate,
//               endTime: endDate,
//               subject: task.entrytype ?? "No subject",
//               color: Colors.blue, // Customize color if needed
//             );
//           } catch (e) {
//             print("Invalid date format for task: ${task.followUpDateTime}");
//             return null; // Return null if date parsing fails
//           }
//         })
//         .where((appointment) =>
//             appointment != null) // Filter out null appointments
//         .cast<
//             Appointment>() // Cast to List<Appointment> after filtering out nulls
//         .toList();
//   }
// }
