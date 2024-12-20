import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/utils/api_endpoints.dart';

import '../widgets/custom_select.dart';

class CustomerEntryController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;

  // Controllers for form fields
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

  // States list for selection
  var states = ["State 1", "State 2", "State 3"]; // Add your states here

  // Convert states to CustomSelectItem list
  List<CustomSelectItem> get stateItems {
    return List<CustomSelectItem>.generate(
      states.length,
      (index) => CustomSelectItem(id: index.toString(), value: states[index]),
    );
  }

  // Current page index
  var currentPage = 0.obs;

  // Form data to retain across pages
  var formData = {}.obs;

  // Function to navigate to the next page
  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
    }
  }

  // Function to navigate to the previous page
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

  // Save form data
  void saveData() {
    print(stateController.text);
    print(mobileController.text);
    print(titleController.text);
    print(customerNameController.text);
    print(cityController.text);
    print(areaController.text);
    print(lane1Controller.text);
    print(customerTypeController.text);
    print(registrationTypeController.text);
    clearFields();
    Get.back();
    // Add other fields here as needed

    Get.snackbar("Success", "Data saved successfully");
  }

  void fetchState() async {
    final data = await ApiClient()
        .getStateList(box.read("userId"), ApiEndpoints.stateList);
    if (data.isNotEmpty) {
      stateList.assignAll(data);
    }
  }

  // Clear controllers when done
  @override
  void onClose() {
    customerIdController.dispose();
    customerNameController.dispose();
    mobileController.dispose();
    titleController.dispose();
    displayNameController.dispose();
    lane1Controller.dispose();
    lane2Controller.dispose();
    ledgerIdController.dispose();
    tcsRateController.dispose();
    freightController.dispose();
    stateController.dispose();
    companyNameController.dispose();
    leadSourceController.dispose();
    emailController.dispose();
    phoneController.dispose();
    panController.dispose();
    webSiteController.dispose();
    clearFields(); // Clear all fields

    super.onClose();
  }

  @override
  void onInit() {
    fetchState();
    super.onInit();
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

    // Reset other form-related state variables if necessary
    formData.clear();
  }

  void saveCustomer() {
    ApiClient().postCustomerData(
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
        userId: box.read("userId"));
  }

  void updateCustomer(String id) {
    final response = ApiClient().updateCustomerData(
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
        userId: box.read("userId"),
        Id: id);
    Get.back();
    Get.snackbar("Message", response.toString());
  }
}
