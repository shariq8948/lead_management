import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:leads/data/models/graph-model.dart';
import 'package:leads/widgets/custom_snckbar.dart';
import '../../data/models/lead_list.dart';
import '../../data/api/api_client.dart'; // Assuming the ApiClient is in this path
import '../../data/models/dashboard_count.dart';
import '../../data/models/task_list.dart';
import '../../utils/api_endpoints.dart'; // Assuming the AllCountList model is here

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  final box = GetStorage();
  late TabController tabController;
  late PageController pageController;
  RxBool isAdminMode = true.obs;

  // Method to toggle between screens
  void toggleMode(bool value) {
    isAdminMode.value = value;
  }

  var selectedTab = 0.obs;
  RxBool isTaskSelected = true.obs; // Reactive variable for task selection
  var isExpanded = false.obs; // Reactive variable for FAB expansion
  RxList<TaskList> tasks = <TaskList>[].obs; // List to hold TaskList objects
  RxList<AllCountList> dashboardCount = <AllCountList>[].obs;
  RxList<FunnelGraph> funnelData = <FunnelGraph>[].obs;
  RxList<DealData> pieData = <DealData>[].obs;
  RxList<LeadList> leads = <LeadList>[].obs;
  RxBool isChecked = false.obs; // Reactive variable for
  // Initialize ApiClient
  // State variables for pagination
  RxInt currentPage = 0.obs; // Track the current page number
  RxBool hasMoreLeads =
      true.obs; // Flag to track if there are more leads to load
  // final ApiClient apiClient = Get.put(ApiClient());
  ScrollController scrollController = ScrollController(); // Add this line
  final fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  RxInt todayCount = 0.obs; // Store the Today's Task count
  RxInt upcomingCount = 0.obs; // Store the Upcoming Task count
  RxInt overdueCount = 0.obs; // Store the Overdue Task count
  RxInt taskCount = 0.obs; // Store the TaskList count
  RxInt leadCount = 0.obs; // Store the LeadList count
  RxBool isLoading = true.obs; // Flag to track loading state
  RxList selected = [].obs;
  @override
  void onInit() {
    super.onInit();
    final List<PerformanceData> datatask = [
      PerformanceData(label: 'Calls', achieved: 85, target: 100),
      PerformanceData(label: 'Meeting', achieved: 75, target: 100),
      PerformanceData(label: 'Product Sale', achieved: 70, target: 100),
      PerformanceData(label: 'Follow-up', achieved: 65, target: 100),
      PerformanceData(label: 'Collection', achieved: 80, target: 100),
      PerformanceData(label: 'Sales', achieved: 90, target: 100),
      PerformanceData(label: 'Lead', achieved: 60, target: 100),
    ];
    fetchDashboardCount();
    // fetchLeads();
    fetchTasksByTab("Today");

    fetchAssignedLead();
    print("this is testing for every task");
    fetchFunnelData();
    fetchPieData();
    tabController =
        TabController(length: 3, vsync: this); // Initialize TabController
    pageController = PageController(); // Initialize PageController
  }

  void initializeData() {
    fetchDashboardCount();
    fetchTasksByTab("Today");
    fetchAssignedLead();
    fetchFunnelData();
    fetchPieData();
  }

  void refreshHomePage() {
    fetchAssignedLead();
    fetchDashboardCount();
    fetchTasksByTab("Today");
    fetchFunnelData();
    fetchPieData();
  }

  @override
  void onClose() {
    tabController
        .dispose(); // Dispose the tab controller when it's no longer needed
    pageController = PageController(); // Initialize PageController

    scrollController
        .dispose(); // Dispose of the controller when no longer needed
    super.onClose();
  }
  // Function to fetch dashboard count

  Future<void> fetchFunnelData() async {
    isLoading.value = true; // Set loading to true while fetching data
    try {
      List<FunnelGraph> data =
          await ApiClient().getFunnelGraph("4", ApiEndpoints.funnelData);
      funnelData.value = data; // Update the dashboardCount list
      print(ApiEndpoints.funnelData);
      // Extract counts for various categories
      print("this is lengthg${data.length}");
      print(data);
      // print("Dashboard count data: $dashboardCount");
    } catch (e) {
      print("Error fetching dashboard count: $e");
    } finally {
      isLoading.value = false; // Set loading to false after data is fetched
    }
  }

  Future<void> fetchPieData() async {
    isLoading.value = true;
    try {
      List<DealData> data =
          await ApiClient().getPieGraph(box.read("userId"), 2024);
      pieData.value = data;
    } catch (e) {
      print("Error fetching dashboard count: $e");
    } finally {
      isLoading.value = false; // Set loading to false after data is fetched
    }
  }

  Future<void> fetchDashboardCount() async {
    isLoading.value = true; // Set loading to true while fetching data
    try {
      List<AllCountList> counts =
          await ApiClient().getDashboardCount(ApiEndpoints.dashboardCount);
      dashboardCount.value = counts; // Update the dashboardCount list

      // Extract counts for various categories
      todayCount.value = _getCountByName(counts, 'TodaysTask');
      upcomingCount.value = _getCountByName(counts, 'UpcomingTask');
      overdueCount.value = _getCountByName(counts, 'OverdueTask');
      taskCount.value = _getCountByName(counts, 'TaskList');
      leadCount.value = _getCountByName(counts, 'LeadList');

      // print("Dashboard count data: $dashboardCount");
    } catch (e) {
      print("Error fetching dashboard count: $e");
    } finally {
      isLoading.value = false; // Set loading to false after data is fetched
    }
  }

  fetchTasksByTab(String tabType) {
    String filterType = '';
    if (tabType == 'Today') {
      filterType = 'todaystask';
    } else if (tabType == 'Upcoming') {
      filterType = 'upcoming';
    } else if (tabType == 'Overdue') {
      filterType = 'overdue';
    }

    fetchAssignedTaskList(
      userId: box.read("userId"),
      recordType: 'dashboardtask',
      dataFilterType: filterType,
    );
  }

  // Fetch task list based on provided parameters
  Future<void> fetchAssignedTaskList({
    required String userId,
    required String recordType,
    required String dataFilterType,
    String? fromDate,
    String? upToDate,
  }) async {
    print(userId);
    isLoading.value = true; // Set loading to true while fetching data
    try {
      // Call getTaskList from the apiClient to fetch tasks
      List<TaskList> taskList = await ApiClient().getTaskList(
        endPoint: ApiEndpoints.assignedTasks, // Adjust the endpoint as needed
        userId: userId,
        recordType: recordType,
        dataFilterType: dataFilterType,
        fromDate: fromDate,
        upToDate: upToDate,
      );

      // Assign the fetched tasks to the tasks list
      tasks.value = taskList;

      // print("Fetched task list: $tasks");
    } catch (e) {
      print("Error fetching assigned task list: $e");
    } finally {
      isLoading.value = false; // Set loading to false after data is fetched
    }
  }

  // Helper function to extract count by name
  int _getCountByName(List<AllCountList> data, String name) {
    final countItem = data.firstWhere(
      (item) => item.name == name,
      orElse: () =>
          AllCountList(name: name, count: 0), // Default count of 0 if not found
    );
    return countItem.count;
  }

  void fetchAssignedLead({String? fromDate, String? toDate}) async {
    String userId = box.read("userId");

    try {
      isLoading.value = true; // Set loading to true
      final newLeads = await ApiClient().getAssignedLeadList(
        endPoint: ApiEndpoints.leaddashList,
        userId: userId,
        queryParams: {
          "fromdate": fromDate,
          "uptodate": toDate,
        },
      );

      leads.clear();

      if (newLeads.isNotEmpty) {
        leads.addAll(newLeads);
      }
    } catch (e) {
      print("Error fetching leads: $e");
    } finally {
      isLoading.value = false; // Set loading to false after the fetch is done
    }
  }

  void toggleTaskSelection() {
    isTaskSelected.value = !isTaskSelected.value;
  }

  void toggleFab() {
    isExpanded.value = !isExpanded.value;
  }

  void setSelectedTab(int index) {
    selectedTab.value = index;
  }

  void onCheckboxChanged(int index, bool? newValue, String id) {
    // Update the isChecked state of the specified task
    // print(newValue);
    tasks[index].isChecked.value = newValue ?? false; // Use .value to update
    // print(    tasks[index].isChecked
    // );
    if (newValue == true) {
      selected.add(id);
      // print("Added ${id}");
    }
    if (newValue == false) {
      selected.remove(id);
      // print("Removed ${id}");
    }
    // Notify the UI to refresh (this is automatic with Obx)
    // No need for refresh here; GetX handles the reactivity
  }

  void markSelected() {
    // print(selected);
  }
  Future<void> postStatus(List<Map<String, dynamic>> body) async {
    try {
      isLoading.value = true;
      final response = await ApiClient().taskActivity(
        ApiEndpoints.updateTaskActivity,
        body,
      );

      if (response.success) {
        CustomSnack.show(
            content: response.message,
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
      } else {
        CustomSnack.show(
            content: response.message,
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      }
    } catch (e) {
      CustomSnack.show(
          content: "Failed to update tasks: ${e.toString()}",
          snackType: SnackType.error,
          behavior: SnackBarBehavior.fixed);
    } finally {
      isLoading.value = false;
    }
  }

  void resetToTodayTab() {
    tabController.animateTo(0); // Reset to the first tab
    pageController.jumpToPage(0); // Reset to the first page
    fetchTasksByTab("Today"); // Fetch today's tasks
    fetchDashboardCount();
  }

  String formatDate(String rawDate) {
    try {
      DateTime parsedDate = DateFormat("MM/dd/yyyy hh:mm:ss a").parse(rawDate);
      return DateFormat("dd/MM/yy").format(parsedDate); // Outputs: 09 Nov 2024
    } catch (e) {
      return rawDate; // Fallback in case of parsing errors
    }
  }

  RxString selectedFilter = 'Last 30 Days'.obs;
  RxBool isCustomDateRange = false.obs;
  RxString customDateRangeLabel = ''.obs;

  void fetchFilteredData(
      {required DateTime startDate, required DateTime endDate}) {
    // Implement your data fetching logic here
    print('Fetching data from $startDate to $endDate');
  }
}

class PerformanceData {
  final String label;
  final double achieved;
  final double target;

  const PerformanceData({
    required this.label,
    required this.achieved,
    required this.target,
  });
}
