import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/activity_model.dart';
import 'package:leads/data/models/task_activity_model.dart';
import 'package:leads/data/models/task_details.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:leads/utils/tags.dart';
import 'package:leads/widgets/custom_snckbar.dart';

import '../../Masters/Target/monthlyTarget/add_product_controller.dart';
import '../../data/models/dropdown_list.model.dart';

class TaskDetailController extends GetxController {
  // Dependency Injection
  final ApiClient apiClient;
  final GetStorage storage;
  final box = GetStorage();

  // Observable variables
  var taskStatus = "Pending".obs;
  var assigneeName = "BDO".obs;
  var createdBy = "HO".obs;
  var remark = "".obs;
  var title = "sanket sakpal".obs;
  var pageIndex = 0.obs; // Tracks the current page (20 words at a time)
  var isLoadingDetails = false.obs; // Loading for task details
  var isLoadingActivities = false.obs; // Loading for task activities
  var selectedTab = 0.obs; // Tracks the selected tab
  var assignto = ['person A', "Person B", "Person C"];
  // Controllers
  final assignToController = TextEditingController();
  final commentController = TextEditingController();
  final callTypeController = TextEditingController();
  final callStatusController = TextEditingController();
  final showassignToController = TextEditingController();
  final toDateController = TextEditingController();
  final remarkController = TextEditingController();
  final titleController = TextEditingController();
  final TextEditingController DateCtlr = TextEditingController();
  final TextEditingController fromDateCtlr = TextEditingController();
  final TextEditingController toDateCtlr = TextEditingController();
  final TextEditingController ReminderCtlr = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ocRemarkController = TextEditingController();
  RxList<StatusModel> calltype = <StatusModel>[
    StatusModel(status: "Inbound", value: "1"),
    StatusModel(status: "Outbound", value: "2"),
  ].obs;
  RxList<CallTypeModel> callstatus = <CallTypeModel>[
    CallTypeModel(status: "Pending", value: "1"),
    CallTypeModel(status: "Complete", value: "2"),
  ].obs;

  // Task data
  RxList<TaskDetail> taskDetails = <TaskDetail>[].obs;
  RxList<TaskActivityModel> taskActivities = <TaskActivityModel>[].obs;
  RxList<ownerDropdownList> leadAssignToList = <ownerDropdownList>[].obs;

  // Task ID
  late String taskId;

  // Constructor with optional dependency injection
  TaskDetailController({ApiClient? apiClient, GetStorage? storage})
      : apiClient = apiClient ?? ApiClient(),
        storage = storage ?? GetStorage();

  @override
  void onInit() {
    super.onInit();
    taskId = Get.arguments['taskId'] ?? '0';
    fetchassignTo();
    fetchDetails();
    fetchHistory();
  }

  void fetchassignTo() async {
    try {
      final data = await ApiClient()
          .getLeadOwner(box.read("userId"), ApiEndpoints.userRoles);
      if (data.isNotEmpty) {
        leadAssignToList.addAll(data);
      }
    } catch (e) {}
  }

  /// Updates the remark
  void updateRemark(String newRemark) => remark.value = newRemark;

  /// Changes the selected tab
  void changeTab(int index) => selectedTab.value = index;

  /// Updates the task status
  void updateTaskStatus(String newStatus) => taskStatus.value = newStatus;

  /// Updates the assignee
  void changeAssignee(String newAssignee) => assigneeName.value = newAssignee;

  /// Fetches task details
  Future<void> fetchDetails() async {
    isLoadingDetails.value = true; // Start loading for task details
    try {
      final userId = storage.read("userId") ?? '';
      if (userId.isEmpty) {
        print("User ID is missing in storage");
        return;
      }
      final data = await apiClient.getTaskDetails(
          ApiEndpoints.taskDetail, userId, taskId);
      taskDetails.assignAll(data);
      print("Task details fetched: ${data.length}");
    } catch (e) {
      print("Error fetching task details: $e");
    } finally {
      isLoadingDetails.value = false; // Stop loading for task details
    }
  }

  /// Fetches task activity history
  Future<void> fetchHistory() async {
    isLoadingActivities.value = true; // Start loading for task activities
    try {
      final userId = storage.read("userId") ?? '';
      if (userId.isEmpty) {
        print("User ID is missing in storage");
        return;
      }
      final data = await apiClient.getTaskActivity(
          ApiEndpoints.taskHistory, taskId, userId);
      taskActivities.assignAll(data);
      print("Task history fetched: ${data.length}");
    } catch (e) {
      print("Error fetching task history: $e");
    } finally {
      isLoadingActivities.value = false; // Stop loading for task activities
    }
  }

  Future<void> postStatus(String taskId, String status) async {
    try {
      isLoadingDetails.value = true;
      final response = await apiClient.updateTaskStatusActivity(
        ApiEndpoints.updateTaskActivity,
        taskId,
        status,
      );

      if (response.isSuccess) {
        CustomSnack.show(
            content: "Successfully Changed",
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
        print("Task status updated successfully.");
        fetchDetails();
        fetchHistory();
        // fetchDetails();
        // Optionally trigger additional updates, e.g., fetching dashboard data
      } else {
        print("Failed to update task status: ${response.message}");
      }
    } catch (e) {
      print("Error in postStatus: $e");
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> postComment(String taskId) async {
    try {
      isLoadingActivities.value = true;
      final response = await apiClient.addTaskComment(
        ApiEndpoints.updateTaskActivity,
        taskId,
        commentController.text,
      );

      if (response.isSuccess) {
        CustomSnack.show(
            content: "Successfully added",
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
        print("Task status updated successfully.");
        fetchHistory();
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
    } finally {
      isLoadingActivities.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers to avoid memory leaks
    assignToController.dispose();
    super.onClose();
  }
}

class StatusModel {
  String status;
  String value;

  StatusModel({required this.status, required this.value});
}

class CallTypeModel {
  String status;
  String value;

  CallTypeModel({required this.status, required this.value});
}
