import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming a Task class for managing tasks
class Task {
  final String status;
  final String assignee;
  final String deadline;
  final String remark;

  Task({
    required this.status,
    required this.assignee,
    required this.deadline,
    required this.remark,
  });
}

class LeadDetailController extends GetxController {
  // Observables
  var currentTabIndex = 0.obs;
  var currentStep = 0.obs;
  var isFabOpen = false.obs;
  RxList leadOwner = ["HO","MR","BDO","MR 2","MR3","MR4","MR5"].obs;
  RxList leadPriority = ["Hot","Cold","Declined","New","completed","MR4"].obs;
  RxList leadAssign = ["HO","MR","BDO","MR 2","MR3","MR4","MR5"].obs;
  RxList customerType = ["Type1","Type2","Type3","Type4","type5","Type6","Type7"].obs;
  RxList registrationType = ["Type1","Type2","Type3","Type4","type5","Type6","Type7"].obs;
  RxList partyType = ["Type1","Type2","Type3","Type4","type5","Type6","Type7"].obs;
  RxList industry = ["Type1","Type2","Type3","Type4","type5","Type6","Type7"].obs;
  RxList state = ["state1","state2","state3","Type4","type5","Type6","Type7"].obs;
  RxList area = ["area1","area2","area3","area4","area5","Type6","Type7"].obs;
  RxList city = ["area1","area2","area3","area4","area5","Type6","Type7"].obs;
 TextEditingController leadOwnerController=TextEditingController();
 TextEditingController leadPriorityController=TextEditingController();
 TextEditingController leadAssignController=TextEditingController();
 TextEditingController mobileController=TextEditingController();
 TextEditingController ledgerController=TextEditingController();
 TextEditingController customerTypeController=TextEditingController();
 TextEditingController registrationTypeController=TextEditingController();
 TextEditingController partyTypeController=TextEditingController();
 TextEditingController companyNameController=TextEditingController();
 TextEditingController industryController=TextEditingController();
 TextEditingController stateController=TextEditingController();
 TextEditingController areaController=TextEditingController();
 TextEditingController cityController=TextEditingController();
 TextEditingController pinController=TextEditingController();
 TextEditingController annualRevenueController=TextEditingController();
 TextEditingController gstController=TextEditingController();
 TextEditingController tcsController=TextEditingController();
 TextEditingController freightController=TextEditingController();
 TextEditingController panController=TextEditingController();
 TextEditingController aadharController=TextEditingController();
 TextEditingController companyWebsiteController=TextEditingController();
 TextEditingController remarkController=TextEditingController();
  // Form Controllers
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var companyController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  final activities = [
    {
      'date': 'Today',
      'type': 'Lead status',
      'status': 'Negotiation',
      'description': 'DealSize:1200 Remark-Engage and nurture leads...',
      'time': '11:36 am',
    },
    {
      'date': 'Today',
      'type': 'Email',
      'status': '',
      'description': 'Demo',
      'time': '12:36 am',
    },
    {
      'date': '26/10/2023',
      'type': 'Lead status',
      'status': 'Opportunity',
      'description': 'DealSize:454 Remark-fgn...',
      'time': '11:36 am',
    },
    {
      'date': '26/10/2023',
      'type': 'Email',
      'status': '',
      'description': 'Demo',
      'time': '12:36 am',
    },
  ].obs; // Make this observable with .obs
  // Task List
  var tasks = <Task>[
    Task(
      status: 'Completed',
      assignee: 'John Doe',
      deadline: '2024-11-10',
      remark: 'Task completed successfully.',
    ),
    Task(
      status: 'In Progress',
      assignee: 'Jane Doe',
      deadline: '2024-11-15',
      remark: 'Task is still in progress.',
    ),
    Task(
      status: 'Completed',
      assignee: 'John Doe',
      deadline: '2024-11-10',
      remark: 'Task completed successfully.',
    ),
    Task(
      status: 'In Progress',
      assignee: 'Jane Doe',
      deadline: '2024-11-15',
      remark: 'Task is still in progress.',
    ),
    Task(
      status: 'Completed',
      assignee: 'John Doe',
      deadline: '2024-11-10',
      remark: 'Task completed successfully.',
    ),
    Task(
      status: 'In Progress',
      assignee: 'Jane Doe',
      deadline: '2024-11-15',
      remark: 'Task is still in progress.',
    ),
    Task(
      status: 'Completed',
      assignee: 'John Doe',
      deadline: '2024-11-10',
      remark: 'Task completed successfully.',
    ),
    Task(
      status: 'In Progress',
      assignee: 'Jane Doe',
      deadline: '2024-11-15',
      remark: 'Task is still in progress.',
    ),
    Task(
      status: 'Completed',
      assignee: 'John Doe',
      deadline: '2024-11-10',
      remark: 'Task completed successfully.',
    ),
    Task(
      status: 'In Progress',
      assignee: 'Jane Doe',
      deadline: '2024-11-15',
      remark: 'Task is still in progress.',
    ),
    Task(
      status: 'Completed',
      assignee: 'John Doe',
      deadline: '2024-11-10',
      remark: 'Task completed successfully.',
    ),
    Task(
      status: 'In Progress',
      assignee: 'Jane Doe',
      deadline: '2024-11-15',
      remark: 'Task is still in progress.',
    ),
  ].obs;

  // Toggle FAB State
  void toggleFab() {
    isFabOpen.value = !isFabOpen.value;
  }

  // Change Tab
  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  // Change Step
  void changeStep(int step) {
    currentStep.value = step;
  }

  // Submit the form
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      print("Form submitted!");
    }
  }
}
