import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/apiResponse.dart';
import 'package:leads/data/models/leadDetails.dart';
import 'package:leads/data/models/lead_acivity_list.dart';
import 'package:leads/data/models/lead_task_model.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Tasks/taskDeatails/task_details_controller.dart';
import '../../data/models/dropdown_list.model.dart';
import '../../widgets/custom_snckbar.dart';

// Assuming a Task class for managing tasks

class LeadDetailController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    fetchLeadAssignTo();
    fetchLeadOwner();
    fetchLeadIndustry();
    fetchLeadSource();

    final id = Get.arguments as String;

    // Pass the ID to your fetchLead method
    if (id.isNotEmpty) {
      fetchLead(id);
      fetchLeadActivity(id);
      fetchLeadTask(id);
    } else {
      print("ID is empty or missing");
    }

    // Other methods and logic

    super.onInit();
  }

  void fetchLeadSource() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getLeadSource(box.read("userId"), ApiEndpoints.leadSource),
      dataList: leadSource,
      isFetchingState: isLoading,
    );
  }

  void fetchLeadOwner() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getLeadOwner(box.read("userId"), ApiEndpoints.userRoles),
      dataList: leadOwner,
      isFetchingState: isLoading,
    );
  }

  void fetchLeadAssignTo() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getLeadOwner(box.read("userId"), ApiEndpoints.userRoles),
      dataList: leadAssignToList,
      isFetchingState: isLoading,
    );
  }

  void fetchLeadIndustry() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getIndustry(box.read("userId"), ApiEndpoints.industryList),
      dataList: industryList,
      isFetchingState: isLoading,
    );
  }

  final callTypeController = TextEditingController();
  final callStatusController = TextEditingController();
  final remarkController = TextEditingController();
  RxList<StatusModel> calltype = <StatusModel>[
    StatusModel(status: "Inbound", value: "1"),
    StatusModel(status: "Outbound", value: "2"),
  ].obs;
  RxList<CallTypeModel> callstatus = <CallTypeModel>[
    CallTypeModel(status: "Pending", value: "1"),
    CallTypeModel(status: "Complete", value: "2"),
  ].obs;
  RxList<LeadResponse> details = <LeadResponse>[].obs;
  RxList<LeadActivityListModel> activityList = <LeadActivityListModel>[].obs;
  RxList<LeadTaskList> TaskList = <LeadTaskList>[].obs;
  RxList<LeadSourceDropdownList> leadSource = <LeadSourceDropdownList>[].obs;
  RxList<ownerDropdownList> leadOwner = <ownerDropdownList>[].obs;
  RxList<ownerDropdownList> leadAssignToList = <ownerDropdownList>[].obs;
  RxList<IndustryListDropdown> industryList = <IndustryListDropdown>[].obs;
  final leadOwnerController = TextEditingController();
  final leadNameController = TextEditingController();
  final leadMobileController = TextEditingController();
  final leadEmailController = TextEditingController();
  final leadAddressController = TextEditingController();
  final leadComapnyController = TextEditingController();
  final leadDealSizeController = TextEditingController();
  final leadDescriptionontroller = TextEditingController();
  final leadSourceController = TextEditingController();
  TextEditingController hoursInputController = TextEditingController();
  TextEditingController minutesInputController = TextEditingController();
  var selectedHours = 0.obs;
  var selectedMinutes = 0.obs;
  final leadAssignToController = TextEditingController();
  final leadIndustryController = TextEditingController();
  final showLeadSourceController = TextEditingController();
  final showLeadOwnerController = TextEditingController();
  final showLeadAssignToController = TextEditingController();
  final showLeadIndustryController = TextEditingController();
  final assignToController = TextEditingController();
  final showassignToController = TextEditingController();
  final followupRemarkController = TextEditingController();
  final titleController = TextEditingController();
  final fromDateCtlr = TextEditingController();
  final toDateController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final ocRemarkController = TextEditingController();
  final commentController = TextEditingController();

  // Observables
  var currentTabIndex = 0.obs;
  var currentStep = 0.obs;
  var isFabOpen = false.obs;
  var isLoading = false.obs;
  RxList leadPriority =
      ["Hot", "Cold", "Declined", "New", "completed", "MR4"].obs;
  //call details fields
  final TextEditingController cdDateController = TextEditingController();
  final TextEditingController cdAssignToController = TextEditingController();
  final TextEditingController cdShowAssignToController =
      TextEditingController();
  final TextEditingController cdShowCallTypeController =
      TextEditingController();
  final TextEditingController cdCallTypeController = TextEditingController();
  final TextEditingController cdCallStatusController = TextEditingController();
  final TextEditingController cdRemarkController = TextEditingController();
  final TextEditingController cdShowCallStatusController =
      TextEditingController();

  final TextEditingController DateCtlr = TextEditingController();
  final TextEditingController ReminderCtlr = TextEditingController();
  //call detail end

  //Add Followup
  final TextEditingController afAssignToController = TextEditingController();
  final TextEditingController afShowAssignToController =
      TextEditingController();
  final TextEditingController afDateController = TextEditingController();
  final TextEditingController afReminderController = TextEditingController();
  final TextEditingController afDescriptionController = TextEditingController();
  //Add follow up end

  // Form Controllers
  var formKey = GlobalKey<FormState>();
  Future<bool> updateLead(String id) async {
    try {
      await ApiClient().updateLeadData(
        endPoint: ApiEndpoints.updateLead,
        userId: box.read("userId"),
        AssignTo: leadAssignToController.text,
        company: leadComapnyController.text,
        dealSize: leadDealSizeController.text,
        name: leadNameController.text,
        mobileNumber: leadMobileController.text,
        productId: "0",
        address: leadAddressController.text,
        Description: leadDescriptionontroller.text,
        email: leadEmailController.text,
        source: leadSourceController.text,
        owner: leadOwnerController.text,
        industry: leadIndustryController.text,
        leadId: id,
      );
      return true;
      // Indicate success
    } catch (error) {
      print("Error saving lead: $error");
      return false; // Indicate failure
    } finally {
      // Get.back();
    }
  }

  Future<void> postComment(String id) async {
    try {
      final response = await ApiClient().addLeadComment(
        ApiEndpoints.updateLeadActivity,
        id,
        commentController.text,
      );

      if (response.isSuccess) {
        commentController.clear();
        await fetchLeadActivity(id);

        CustomSnack.show(
            content: "Successfully added",
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
        print("Task status updated successfully.");

        // fetchDetails();
        // Optionally trigger additional updates, e.g., fetching dashboard data
      } else {
        CustomSnack.show(
            content: response.message,
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      }
    } catch (e) {
      print("Error in postStatus: $e");
    } finally {}
  }

  Future<bool> addFollowUp(String id) async {
    try {
      var formatedtime =
          "${hoursInputController.text}:${minutesInputController.text}";
      await ApiClient().addLeadFollowUp(
          endPoint: ApiEndpoints.addLeadFollowUp,
          leadId: id,
          AssignTo: afAssignToController.text,
          date: afDateController.text,
          remark: afDescriptionController.text,
          time: formatedtime);
      print(id);
      print(afAssignToController.text);
      print(afDateController.text);
      print(afDescriptionController.text);
      print(formatedtime);
      Get.back();

      return true;
      // Indicate success
    } catch (error) {
      print("Error saving lead: $error");
      return false; // Indicate failure
    } finally {
      // Get.back();
    }
  }

  Future<void> addCall(String id) async {
    try {
      isLoading.value = true;
      var formatedtime =
          "${hoursInputController.text}:${minutesInputController.text}";
      final ApiResponse response = await ApiClient().addLeadCall(
          endPoint: ApiEndpoints.addLeadDetailTaskCommon,
          leadId: id,
          reminder: formatedtime,
          assignTo: cdAssignToController.text,
          description: cdRemarkController.text,
          date: cdDateController.text,
          CallType: cdCallStatusController.text);
      if (response.isSuccess) {
        CustomSnack.show(
            content: response.message,
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
        Get.back();
      } else {
        CustomSnack.show(
            content: response.message,
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

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

  final PageController pageController = PageController();

  fetchLead(String Id) async {
    isLoading.value = true;
    try {
      final data = await ApiClient()
          .getLeadDeails(ApiEndpoints.leadDetail, box.read("userId"), Id);
      if (data.isNotEmpty) {
        details.clear(); // Clear old data
        details.addAll(data);
      }
    } catch (e) {
      print("Error fetching lead details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeadActivity(String Id) async {
    isLoading.value = true;
    try {
      final data = await ApiClient().getLeadActivity(
          ApiEndpoints.LeadTaskActivity, box.read("userId"), Id);
      if (data.isNotEmpty) {
        activityList.assignAll(data);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchData({
    required Future<List<dynamic>> Function() apiCall,
    required RxList<dynamic> dataList,
    required RxBool isFetchingState,
  }) async {
    try {
      isFetchingState.value = true;
      final data = await apiCall();
      if (data.isNotEmpty) {
        dataList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isFetchingState.value = false;
    }
  }

  void fetchLeadTask(String Id) async {
    isLoading.value = true;
    try {
      final data = await ApiClient()
          .getLeadTask(ApiEndpoints.LeadDetailTask, box.read("userId"), Id);
      if (data.isNotEmpty) {
        TaskList.clear();
        TaskList.addAll(data);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

// Function to launch WhatsApp
  void launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

// Function to send an SMS
  void launchSMS(String phoneNumber) async {
    final url = 'sms:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send SMS';
    }
  }

// Function to launch email client
  void launchMail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email client';
    }
  }

// Function to share content
  void shareContent() async {
    await Share.share('Check out this task detail!');
  }

  // Submit the form
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      print("Form submitted!");
    }
  }
}
