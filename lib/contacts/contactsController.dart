import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/contact_count.dart';
import 'package:leads/data/models/customer_model.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:leads/data/models/dropdown_list.model.dart';

class ContactController extends GetxController {
  // Constants
  static const int PAGE_SIZE = 10;
  final mobileController = TextEditingController();
  // Storage
  final box = GetStorage();

  // State variables
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSearching = false.obs;

  // Customer data
  final RxList<CustomerResponseModel> customerData =
      <CustomerResponseModel>[].obs;
  final RxInt currentCustomerPage = 0.obs;
  final RxBool hasMoreCustomers = true.obs;
  final RxBool isLoadingMoreCustomers = false.obs;

  // Prospect data
  final RxList<CustomerResponseModel> prospectData =
      <CustomerResponseModel>[].obs;
  final RxInt currentProspectPage = 0.obs;
  final RxBool hasMoreProspects = true.obs;
  final RxBool isLoadingMoreProspects = false.obs;

  // Details and counts
  final RxList<CustomerDetail> details = <CustomerDetail>[].obs;
  final RxList<ContactsCount> counts = <ContactsCount>[].obs;
  final RxList<ownerDropdownList> leadAssignToList = <ownerDropdownList>[].obs;

  // Text Controllers
  final TextEditingController customerSearchController =
      TextEditingController();
  final TextEditingController prospectSearchController =
      TextEditingController();
  final TextEditingController followUpController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController leadAssignToController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  // Meeting Controllers
  final meetingControllers = MeetingControllers();

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([
        fetchLeadAssignments(),
        fetchCustomers(isInitialFetch: true),
        fetchProspect(isInitialFetch: true),
      ]);
    } catch (e) {
      _handleError(e, 'Failed to initialize data');
    }
  }

  void _disposeControllers() {
    customerSearchController.dispose();
    prospectSearchController.dispose();
    followUpController.dispose();
    dateController.dispose();
    leadAssignToController.dispose();
    reminderController.dispose();
    remarkController.dispose();
    meetingControllers.dispose();
  }

  // Fetch Lead Assignments
  Future<void> fetchLeadAssignments() async {
    try {
      final userId = box.read("userId");
      final data =
          await ApiClient().getLeadOwner(userId, ApiEndpoints.userRoles);

      if (data.isNotEmpty) {
        leadAssignToList.assignAll(data);
      }
    } catch (e) {
      _handleError(e, 'Failed to fetch lead assignments');
    }
  }

  // Customer Operations
  Future<void> fetchCustomers({
    bool isInitialFetch = false,
    String searchQuery = '',
  }) async {
    if (isInitialFetch) {
      currentCustomerPage.value = 0;
      hasMoreCustomers.value = true;
      customerData.clear();
    }

    if (!hasMoreCustomers.value || isLoadingMoreCustomers.value) return;

    try {
      isLoadingMoreCustomers.value = true;
      isError.value = false;

      final customers = await ApiClient().getCustomerList(
        endPoint: ApiEndpoints.customerList,
        userId: box.read("userId"),
        isPagination: "1",
        pageSize: PAGE_SIZE.toString(),
        pageNumber: currentCustomerPage.toString(),
        q: searchQuery,
      );

      if (customers.isNotEmpty) {
        customerData.addAll(customers);
        currentCustomerPage.value++;
        hasMoreCustomers.value = customers.length >= PAGE_SIZE;
      } else {
        hasMoreCustomers.value = false;
      }
    } catch (e) {
      _handleError(e, 'Failed to fetch customers');
    } finally {
      isLoadingMoreCustomers.value = false;
    }
  }

  // Prospect Operations
  Future<void> fetchProspect({
    bool isInitialFetch = false,
    String searchQuery = '',
  }) async {
    if (isInitialFetch) {
      currentProspectPage.value = 0;
      hasMoreProspects.value = true;
      prospectData.clear();
    }

    if (!hasMoreProspects.value || isLoadingMoreProspects.value) return;

    try {
      isLoadingMoreProspects.value = true;
      isError.value = false;

      final prospects = await ApiClient().getCustomerList(
        endPoint: ApiEndpoints.prospectList,
        userId: box.read("userId"),
        isPagination: "1",
        pageSize: PAGE_SIZE.toString(),
        pageNumber: currentProspectPage.toString(),
        q: searchQuery,
      );

      if (prospects.isNotEmpty) {
        prospectData.addAll(prospects);
        currentProspectPage.value++;
        hasMoreProspects.value = prospects.length >= PAGE_SIZE;
      } else {
        hasMoreProspects.value = false;
      }
    } catch (e) {
      _handleError(e, 'Failed to fetch prospects');
    } finally {
      isLoadingMoreProspects.value = false;
    }
  }

  // Search Operations
  Future<void> searchContacts(String query) async {
    if (query.isEmpty) {
      await refreshData();
      return;
    }

    isSearching.value = true;

    try {
      // Fetch both customers and prospects with search query
      await Future.wait([
        fetchCustomers(isInitialFetch: true, searchQuery: query),
        fetchProspect(isInitialFetch: true, searchQuery: query),
      ]);
    } finally {
      isSearching.value = false;
    }
  }

  // Refresh Operations
  Future<void> refreshData() async {
    customerSearchController.clear();
    prospectSearchController.clear();

    try {
      await Future.wait([
        fetchCustomers(isInitialFetch: true),
        fetchProspect(isInitialFetch: true),
      ]);
    } catch (e) {
      _handleError(e, 'Failed to refresh data');
    }
  }

  Future<void> refreshCustomers() async {
    customerSearchController.clear();
    await fetchCustomers(isInitialFetch: true);
  }

  Future<void> refreshProspects() async {
    prospectSearchController.clear();
    await fetchProspect(isInitialFetch: true);
  }

  // Detail Operations
  Future<void> fetchDetails(String id) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final data = await ApiClient().getCustomerDetails(
        ApiEndpoints.customerDetails,
        box.read("userId"),
        id,
      );

      if (data != null && data.isNotEmpty) {
        details.assignAll(data);
      }
    } catch (e) {
      _handleError(e, 'Failed to fetch contact details');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCounts(String number) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final data = await ApiClient().getContactCounts(
        ApiEndpoints.customerDetails,
        number,
      );

      if (data != null && data.isNotEmpty) {
        counts.assignAll(data);
      }
    } catch (e) {
      _handleError(e, 'Failed to fetch contact counts');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchCustomers(String query) async {
    if (query.isEmpty) {
      await refreshCustomers();
      return;
    }

    // Debounce the search to avoid too many API calls
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      isSearching.value = true;
      isError.value = false;

      // Reset pagination and fetch with search query
      currentCustomerPage.value = 0;
      hasMoreCustomers.value = true;
      customerData.clear();

      await fetchCustomers(
        isInitialFetch: true,
        searchQuery: query,
      );
    } catch (e) {
      _handleError(e, 'Failed to search customers');
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> searchProspects(String query) async {
    if (query.isEmpty) {
      await refreshProspects();
      return;
    }

    // Debounce the search to avoid too many API calls
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      isSearching.value = true;
      isError.value = false;

      // Reset pagination and fetch with search query
      currentProspectPage.value = 0;
      hasMoreProspects.value = true;
      prospectData.clear();

      await fetchProspect(
        isInitialFetch: true,
        searchQuery: query,
      );
    } catch (e) {
      _handleError(e, 'Failed to search prospects');
    } finally {
      isSearching.value = false;
    }
  }

  // Error Handling
  void _handleError(dynamic error, String message) {
    isError.value = true;
    errorMessage.value = message;
    print('$message: $error');
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

// Meeting Controllers Helper Class
class MeetingControllers {
  final titleController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final reminderController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  void dispose() {
    titleController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    reminderController.dispose();
    locationController.dispose();
    descriptionController.dispose();
  }
}
