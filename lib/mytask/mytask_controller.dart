import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:leads/data/models/task_list.dart';
import 'package:leads/utils/api_endpoints.dart';

import '../data/api/api_client.dart';
import '../data/models/dropdown_list.model.dart';

class CalendarController1 extends GetxController {
  //Todo Form
  final todoTitleController = TextEditingController();
  final tododateController = TextEditingController();
  final todoReminderController = TextEditingController();
  final todoremarkController = TextEditingController();
//Todo End

  //Meeting Start
  final mprospectController = TextEditingController();
  final mshowprospectController = TextEditingController();
  final mCustomerController = TextEditingController();
  final mshowCustomerController = TextEditingController();
  final mtitle = TextEditingController();
  final mfrom = TextEditingController();
  final mto = TextEditingController();
  final mreminedr = TextEditingController();
  final massign = TextEditingController();
  final mshowassign = TextEditingController();
  final mlocation = TextEditingController();
  final mdescription = TextEditingController();
  final moutcomeremark = TextEditingController();

  //Meeting End

  //Call Start
  final cassign = TextEditingController();
  final cshowassign = TextEditingController();
  final cshowCustomerController = TextEditingController();
  final cshowprospectController = TextEditingController();

  final cprospectController = TextEditingController();
  final cCustomerController = TextEditingController();
  final creminedr = TextEditingController();
  final cremark = TextEditingController();
  final cfollowup = TextEditingController();
  //CAll End

  //FollowUp start
  final fshowassign = TextEditingController();
  final fshowCustomerController = TextEditingController();
  final fshowprospectController = TextEditingController();

  final fassign = TextEditingController();
  final fprospectController = TextEditingController();
  final fCustomerController = TextEditingController();
  final freminedr = TextEditingController();
  final fremark = TextEditingController();
  final ffollowup = TextEditingController();

  //followup end

  TextEditingController toDateCtlr = TextEditingController();
  final TextEditingController ReminderCtlr = TextEditingController();
  RxString selectedRole = 'Customer'.obs;
  RxBool isCustomer = true.obs;
  RxList<ownerDropdownList> leadAssignToList = <ownerDropdownList>[].obs;
  RxList<TaskList> todoList = <TaskList>[].obs;
  RxList<CustomerResponseModel> customerList = <CustomerResponseModel>[].obs;
  RxList<CustomerResponseModel> prospectList = <CustomerResponseModel>[].obs;
  var selectedDate = DateTime.now().obs;
  var tasks = <DateTime, List<String>>{}.obs;
  RxBool isHavingTask = false.obs;
  final box = GetStorage();
  var isLoading = false.obs;
  final leadAssignToController = TextEditingController();
  final outcomeRemarkController = TextEditingController();

  final customerController = TextEditingController();
  final prospectController = TextEditingController();
  final showLeadAssignToController = TextEditingController();
  final showCustomerController = TextEditingController();
  final showProspectController = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchLeadAssignTo();
    fetchLeadCustomers();
    fetchProspects();
    fetchtasks();
  }

  Future<void> createGoogleCalendarEvent(AuthClient client, String title,
      starDate, enddate, location, remark) async {
    String entityName = isCustomer.value
        ? showCustomerController.text
        : showProspectController.text;

    // Construct event details
    String eventTitle = "$entityName Meeting";
    String location = ""; // Use location controller if needed
    String description =
        "${eventTitle}\n\nOutcome: ${outcomeRemarkController.text}";

    // Parse start and end dates
    String startDate = starDate.toString();
    String endDate = enddate.toString();

    try {
      final isScheduled = await ApiClient().scheduleTaskOnGoogleCalendar(
        client: client,
        title: title,
        location: location,
        description: remark,
        startDate: startDate,
        endDate: endDate,
      );

      if (isScheduled) {
        Get.snackbar('Success', 'Event created in Google Calendar');
      } else {
        Get.snackbar('Error', 'Failed to create Google Calendar event');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception occurred: $e');
    }
  }

  void switchRole(String role) {
    selectedRole.value = role;
    if (role == "Customer") {
      isCustomer.value = true;
      fetchLeadCustomers(); // Fetch customer list
    } else {
      isCustomer.value = false;
      fetchProspects(); // Fetch prospect list
    }
  }

  // Add a task to a specific date
  void addTask(DateTime date, String task) {
    if (tasks.containsKey(date)) {
      tasks[date]!.add(task);
    } else {
      tasks[date] = [task];
    }
    // Refresh the map to trigger UI updates
    tasks.refresh();
  }

  // Get tasks for a specific date
  List<String> getTasks(DateTime date) {
    return tasks[date] ?? [];
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

  void fetchLeadAssignTo() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getLeadOwner(box.read("userId"), ApiEndpoints.userRoles),
      dataList: leadAssignToList,
      isFetchingState: isLoading,
    );
  }

  void fetchtasks() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getTaskList(
          endPoint: ApiEndpoints.assignedTasks,
          userId: box.read("userId"),
          recordType: 'ToDOList',
          dataFilterType: 'nofilter'),
      dataList: todoList,
      isFetchingState: isLoading,
    );
  }

  void fetchLeadCustomers() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getCustomerList(
          endPoint: ApiEndpoints.customerList,
          userId: box.read("userId"),
          isPagination: "0",
          pageSize: "0",
          pageNumber: "0",
          q: ""),
      dataList: customerList,
      isFetchingState: isLoading,
    );
  }

  void fetchProspects() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getCustomerList(
          endPoint: ApiEndpoints.prospectList,
          userId: box.read("userId"),
          isPagination: "0",
          pageSize: "0",
          pageNumber: "0",
          q: ""),
      dataList: prospectList,
      isFetchingState: isLoading,
    );
  }

  // Delete a task for a specific date
  void deleteTask(DateTime date, int index) {
    if (tasks.containsKey(date)) {
      tasks[date]!.removeAt(index);
      if (tasks[date]!.isEmpty) {
        tasks.remove(date); // Remove the date if no tasks remain
      }
      tasks.refresh(); // Ensure the UI updates
    }
  }
}
