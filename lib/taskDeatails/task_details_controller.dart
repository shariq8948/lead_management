import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/activity_model.dart';
import 'package:leads/data/models/task_activity_model.dart';
import 'package:leads/data/models/task_details.dart';
import 'package:leads/utils/api_endpoints.dart';

class TaskDetailController extends GetxController {
  // Dependency Injection
  final ApiClient apiClient;
  final GetStorage storage;

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
  var assignto =['person A',"Person B","Person C"];
  // Controllers
  final assignToController = TextEditingController();
  final toDateController = TextEditingController();
  final remarkController = TextEditingController();

  // Task data
  RxList<TaskDetail> taskDetails = <TaskDetail>[].obs;
  RxList<TaskActivityModel> taskActivities = <TaskActivityModel>[].obs;

  // Task ID
  late String taskId;

  // Constructor with optional dependency injection
  TaskDetailController({ApiClient? apiClient, GetStorage? storage})
      : apiClient = apiClient ?? ApiClient(),
        storage = storage ?? GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Retrieve taskId from arguments or set a default value
    taskId = Get.arguments['taskId'] ?? '0';
    fetchDetails();
    fetchHistory();
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
      final data = await apiClient.getTaskDetails(ApiEndpoints.taskDetail, userId, taskId);
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
      final data = await apiClient.getTaskActivity(ApiEndpoints.taskHistory, taskId, userId);
      taskActivities.assignAll(data);
      print("Task history fetched: ${data.length}");
    } catch (e) {
      print("Error fetching task history: $e");
    } finally {
      isLoadingActivities.value = false; // Stop loading for task activities
    }
  }

  @override
  void onClose() {
    // Dispose controllers to avoid memory leaks
    assignToController.dispose();
    super.onClose();
  }
}
