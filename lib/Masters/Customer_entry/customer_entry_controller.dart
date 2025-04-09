import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:leads/widgets/custom_select.dart';
import 'package:leads/widgets/custom_snckbar.dart';

import '../../data/models/apiResponse.dart';
import '../../widgets/snacks.dart';

class CustomerEntryController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>(); // Form key for validation
  @override
  void onInit() async {
    super.onInit();
    fetchState();

    await fetchCustomers();
  }

  Timer? debounce;

  RxString searchVal = "".obs;
  RxBool showSearch = false.obs;
  final searchController = SearchController();
  RxList<CustomerResponseModel> customerList = <CustomerResponseModel>[].obs;
  RxBool isFetchingInitial = false.obs; // Tracks initial fetching status
  RxBool isFetchingMore = false.obs;
  RxInt currentPage = 0.obs; // Track the current page number
  RxBool hasMoreLeads =
      true.obs; // Flag to track if there are more leads to load

  Future<void> fetchCustomers(
      {bool isInitialFetch = true,
      String query = "",
      String ispagination = "1"}) async {
    const String endpoint = ApiEndpoints.customerList;
    final String userId = box.read("userId");
    const String pageSize = "10";

    // Reset pagination for new searches
    if (isInitialFetch) {
      currentPage.value = 0;
      hasMoreLeads.value = true;
    }

    // Don't fetch if we're already fetching or have no more leads
    if ((isFetchingInitial.value || isFetchingMore.value) ||
        (!hasMoreLeads.value && !isInitialFetch)) {
      return;
    }

    try {
      if (isInitialFetch) {
        isFetchingInitial.value = true;
      } else {
        isFetchingMore.value = true;
      }

      final newCustomers = await ApiClient().getCustomerList(
        endPoint: endpoint,
        userId: userId,
        isPagination: ispagination,
        pageSize: pageSize,
        pageNumber: currentPage.value.toString(),
        q: query,
      );

      if (newCustomers.isNotEmpty) {
        if (isInitialFetch) {
          customerList.assignAll(newCustomers);
        } else {
          customerList.addAll(newCustomers);
        }

        // Only increment page for pagination requests
        if (!isInitialFetch) {
          currentPage.value++;
        }

        // Check if we've reached the end
        hasMoreLeads.value = newCustomers.length >= int.parse(pageSize);
      } else {
        hasMoreLeads.value = false;
        if (isInitialFetch) {
          customerList.clear();
        }
      }
    } catch (e) {
      print("An error occurred while fetching customers: $e");
      Get.snackbar("Error", "Failed to fetch customers. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isFetchingInitial.value = false;
      isFetchingMore.value = false;
    }
  }

  // Update the search handling in your UI
  void handleSearch(String query) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        fetchCustomers(
            isInitialFetch: true,
            query: query,
            ispagination: "1" // Keep pagination enabled for search
            );
      } else {
        fetchCustomers(isInitialFetch: true);
      }
    });
  }

  Future<ApiResponse<void>> deleteCustomer(String id) async {
    try {
      final userId = box.read("userId");

      // Check if userId is valid
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID is missing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return ApiResponse(status: "0", message: "User ID is missing");
      }

      // Call the delete API
      final result = await ApiClient().deleteCustomerData(
        endPoint: ApiEndpoints.deleteCustomer,
        Id: id,
        userId: userId,
      );

      // Check the result and return it
      if (result.status == "1") {
        currentPage = 0.obs;
        customerList.clear();
        await fetchCustomers(isInitialFetch: true);

        // Show success snack
        Get.snackbar(
          'Success',
          result.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return ApiResponse(
            status: "1", message: "Customer deleted successfully");
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Failed to delete customer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return ApiResponse(
            status: "0",
            message: result.message ?? "Failed to delete customer");
      }
    } catch (e) {
      print("Error deleting customer: $e");

      Get.snackbar(
        'Error',
        'Unable to delete customer',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return ApiResponse(status: "0", message: "Unable to delete customer");
    }
  }

  TextEditingController cityController = TextEditingController();
  TextEditingController showCityController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController showAreaController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController showStateController = TextEditingController();
  final customerIdController = TextEditingController();
  final customerNameController = TextEditingController();
  final registrationTypeController = TextEditingController();
  final customerTypeController = TextEditingController();
  final mobileController = TextEditingController();
  final titleController = TextEditingController();
  final displayNameController = TextEditingController();
  final lane1Controller = TextEditingController();
  final lane2Controller = TextEditingController();
  final ledgerIdController = TextEditingController();
  final tcsRateController = TextEditingController();
  final freightController = TextEditingController();
  final companyNameController = TextEditingController();
  final leadSourceController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final panController = TextEditingController();
  final webSiteController = TextEditingController();
  final partyTypeController = TextEditingController();
  RxList<StateListDropdown> stateList = <StateListDropdown>[].obs;
  RxList<cityListDropDown> cityList = <cityListDropDown>[].obs;
  RxList<areaListDropDown> areaList = <areaListDropDown>[].obs;
  var titles = ["Ms", "To", "Mr.", "Mrs.", "Ms.", "Dr.", "Prof.", "Rev."];
  var customerType = ["Local", "Outstation", "Export"];
  var registrationType = [
    "Regular",
    "Composition",
    "Consumer",
    "Unregistered",
    "Unknown"
  ];
  var partyType = [
    "Not Applicable",
    "Deemed export",
    "Government entity",
    "SEZ"
  ];
  RxString stateText = ''.obs; // Reactive string to track changes
  RxString cityText = ''.obs; // Reactive string to track changes

  // Convert titles to CustomSelectItem list
  List<CustomSelectItem> get titleItems {
    return List<CustomSelectItem>.generate(
      titles.length,
      (index) => CustomSelectItem(id: index.toString(), value: titles[index]),
    );
  }

  List<CustomSelectItem> get typeItems {
    return List<CustomSelectItem>.generate(
      customerType.length,
      (index) =>
          CustomSelectItem(id: index.toString(), value: customerType[index]),
    );
  }

  List<CustomSelectItem> get registrationItems {
    return List<CustomSelectItem>.generate(
      registrationType.length,
      (index) => CustomSelectItem(
          id: index.toString(), value: registrationType[index]),
    );
  }

  List<CustomSelectItem> get partyItems {
    return List<CustomSelectItem>.generate(
      partyType.length,
      (index) =>
          CustomSelectItem(id: index.toString(), value: partyType[index]),
    );
  }

  var formData = {}.obs;

  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
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

  void fetchLState() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getStateList(box.read("userId"), ApiEndpoints.stateList),
      dataList: stateList,
      isFetchingState: isLoading,
    );
  }

  Future<void> fetchLeadCity() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getCityList(ApiEndpoints.cityList, stateController.text),
      dataList: cityList,
      isFetchingState: isLoading,
    );
  }

  Future<void> fetchLeadArea() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getAreaList(ApiEndpoints.areaList, cityController.text),
      dataList: areaList,
      isFetchingState: isLoading,
    );
  }

  void fetchState() async {
    final data = await ApiClient()
        .getStateList(box.read("userId"), ApiEndpoints.stateList);
    if (data.isNotEmpty) {
      stateList.assignAll(data);
    }
  }

  @override
  void onClose() {
    clearFields();

    super.onClose();
  }

  void clearFields() {
    customerIdController.clear();
    customerNameController.clear();
    mobileController.clear();
    titleController.clear();
    displayNameController.clear();
    lane1Controller.clear();
    lane2Controller.clear();
    ledgerIdController.clear();
    tcsRateController.clear();
    freightController.clear();
    stateController.clear();
    companyNameController.clear();
    leadSourceController.clear();
    emailController.clear();
    phoneController.clear();
    panController.clear();
    webSiteController.clear();
    stateController.clear();
    cityController.clear();
    areaController.clear();
    showAreaController.clear();
    showCityController.clear();
    showStateController.clear();
    customerTypeController.clear();
    partyTypeController.clear();
    registrationTypeController.clear();

    formData.clear();
  }

  void saveCustomer() async {
    isLoading.value = true;
    final response = await ApiClient().postCustomerData(
      endPoint: ApiEndpoints.saveCustomer,
      title: titleController.text,
      name: customerNameController.text,
      adD1: lane1Controller.text,
      state: stateController.text,
      cityID: cityController.text,
      areaID: areaController.text,
      custType: customerTypeController.text,
      registationType: registrationTypeController.text,
      partyType: partyTypeController.text,
      mobile: mobileController.text,
      userId: box.read("userId"),
      email: emailController.text,
    );

    isLoading.value = false;

    if (response.isSuccess) {
      currentPage.value = 0;
      customerList.clear();
      await fetchCustomers(isInitialFetch: true);
      formData.clear();
      Get.back();

      CustomSnack.show(
        content: response.message,
        snackType: SnackType.success,
        behavior: SnackBarBehavior.fixed,
      );
    } else {
      CustomSnack.show(
        content: response.message,
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    }
  }

  void updateCustomer(String id) async {
    isLoading.value = true;

    final response = await ApiClient().updateCustomerData(
      endPoint: ApiEndpoints.updateCustomer,
      title: titleController.text,
      name: customerNameController.text,
      adD1: lane1Controller.text,
      state: stateController.text,
      cityID: cityController.text,
      areaID: areaController.text,
      custType: customerTypeController.text,
      registationType: registrationTypeController.text,
      partyType: partyTypeController.text,
      mobile: mobileController.text,
      mail: emailController.text,
      userId: box.read("userId"),
      Id: id,
    );

    isLoading.value = false;

    if (response.isSuccess) {
      currentPage.value = 0;
      customerList.clear();
      await fetchCustomers(isInitialFetch: true);
      formData.clear();
      Get.back();

      CustomSnack.show(
        content: response.message,
        snackType: SnackType.success,
        behavior: SnackBarBehavior.fixed,
      );
    } else {
      CustomSnack.show(
        content: response.message,
        snackType: SnackType.error,
        behavior: SnackBarBehavior.floating,
      );
    }
  }
}
