import 'package:get/get.dart';

// Model
class LoginRecord {
  final String userName;
  final String browser;
  final DateTime loginTime;
  final double latitude;
  final double longitude;
  final String geolocation;

  LoginRecord({
    required this.userName,
    required this.browser,
    required this.loginTime,
    required this.latitude,
    required this.longitude,
    required this.geolocation,
  });
}

// Controller
class LoginHistoryController extends GetxController {
  var loginRecords = <LoginRecord>[].obs;
  var filteredRecords = <LoginRecord>[].obs;
  var searchQuery = ''.obs;
  var selectedDate = Rx<DateTime?>(null);
  var isLoading = false.obs;

  var selectedTimeRange = 'Today'.obs;
  var selectedView = 'Table'.obs;

  // Analytics data
  var totalLogins = 0.obs;
  var uniqueUsers = 0.obs;
  var browserStats = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoginHistory();
    updateAnalytics();
  }

  void updateAnalytics() {
    totalLogins.value = filteredRecords.length;
    uniqueUsers.value = filteredRecords.map((e) => e.userName).toSet().length;
    browserStats.value = {};
    for (var record in filteredRecords) {
      browserStats[record.browser] = (browserStats[record.browser] ?? 0) + 1;
    }
  }

  void fetchLoginHistory() {
    isLoading.value = true;
    // Simulated data loading
    loginRecords.value = [
      LoginRecord(
        userName: 'ho',
        browser: 'chrome',
        loginTime: DateTime.parse('2025-01-20 16:47:59'),
        latitude: 19.153302,
        longitude: 72.8841899,
        geolocation: 'Orchid Rd Mall,Goregaon(400065),Mumbai,Maharashtra,India',
      ),
      LoginRecord(
        userName: 'ho',
        browser: 'chrome',
        loginTime: DateTime.parse('2025-01-20 16:47:59'),
        latitude: 19.153302,
        longitude: 72.8841899,
        geolocation: 'Orchid Rd Mall,Goregaon(400065),Mumbai,Maharashtra,India',
      ),
      LoginRecord(
        userName: 'ho',
        browser: 'chrome',
        loginTime: DateTime.parse('2025-01-20 16:47:59'),
        latitude: 19.153302,
        longitude: 72.8841899,
        geolocation: 'Orchid Rd Mall,Goregaon(400065),Mumbai,Maharashtra,India',
      ),
      LoginRecord(
        userName: 'ho',
        browser: 'chrome',
        loginTime: DateTime.parse('2025-01-20 16:47:59'),
        latitude: 19.153302,
        longitude: 72.8841899,
        geolocation: 'Orchid Rd Mall,Goregaon(400065),Mumbai,Maharashtra,India',
      ),
      LoginRecord(
        userName: 'ho',
        browser: 'chrome',
        loginTime: DateTime.parse('2025-01-20 16:47:59'),
        latitude: 19.153302,
        longitude: 72.8841899,
        geolocation: 'Orchid Rd Mall,Goregaon(400065),Mumbai,Maharashtra,India',
      ),
      // Add more sample records here
    ];
    filteredRecords.value = loginRecords;
    isLoading.value = false;
  }

  void filterRecords(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setSelectedDate(DateTime? date) {
    selectedDate.value = date;
    applyFilters();
  }

  void applyFilters() {
    filteredRecords.value = loginRecords.where((record) {
      bool matchesSearch =
          record.userName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              record.geolocation
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              record.browser.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesDate = selectedDate.value == null ||
          (record.loginTime.year == selectedDate.value!.year &&
              record.loginTime.month == selectedDate.value!.month &&
              record.loginTime.day == selectedDate.value!.day);

      return matchesSearch && matchesDate;
    }).toList();
  }

  void exportData() {
    // Implement export functionality
    Get.snackbar(
      'Export',
      'Data exported successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
