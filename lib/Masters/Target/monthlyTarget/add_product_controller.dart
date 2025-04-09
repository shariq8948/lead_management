import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/data/models/monthly_target.dart';
import 'package:leads/data/models/monthly_target_details.dart';
import 'package:leads/utils/api_endpoints.dart';

import '../../../widgets/custom_select.dart';
import '../../../widgets/custom_snckbar.dart';

class TargetController extends GetxController {
  RxList<MonthlyTarget> monthlyTargetList = <MonthlyTarget>[].obs;
  RxList<MonthlyTargetDetail> TargetDetail = <MonthlyTargetDetail>[].obs;
  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  RxString id = "".obs;
  RxList<MonthsModel> monthsList = <MonthsModel>[
    MonthsModel(month: "Jan", value: "1"),
    MonthsModel(month: "Feb", value: "2"),
    MonthsModel(month: "Mar", value: "3"),
    MonthsModel(month: "Apr", value: "4"),
    MonthsModel(month: "May", value: "5"),
    MonthsModel(month: "Jun", value: "6"),
    MonthsModel(month: "Jul", value: "7"),
    MonthsModel(month: "Aug", value: "8"),
    MonthsModel(month: "Sep", value: "9"),
    MonthsModel(month: "Oct", value: "10"),
    MonthsModel(month: "Nov", value: "11"),
    MonthsModel(month: "Dec", value: "12"),
  ].obs;
  RxList<CordinatorList> cordinators = <CordinatorList>[].obs;
  RxList<MrList> mr = <MrList>[].obs;
  // Make the current year observable
  final RxInt currentYear = DateTime.now().year.obs;

  // Make the years list reactive
  RxList<CustomSelectItem> years = <CustomSelectItem>[].obs;
  Future<void> addMonthlyTarget() async {
    try {
      isLoading.value = true; // Start loading

      final response = await ApiClient().saveMonthlyTarget(
          endPoint: ApiEndpoints.AddMTargets,
          mrid: (selectedRole == "MR")
              ? MrController.text
              : cordinatorController.text,
          newLead: leadsController.text,
          year: yearController.text,
          ctarget: collectionController.text,
          month: monthController.text,
          local: localExController.text,
          night: nightHaultExController.text,
          extra: extraHqExController.text,
          salary: setSalaryExController.text,
          calls: callsController.text);

      if (response.isNotEmpty) {
        if (response == "Saved Successfully") {
          print("User added successfully.");
          await fetchMonthlyTarget();
          Get.back();
          clearFormMonthly();
          CustomSnack.show(
              content: "Saved Successfully",
              snackType: SnackType.success,
              behavior: SnackBarBehavior.fixed);
        } else {
          print("Failed to add user: ${response}");
          CustomSnack.show(
              content: "${response}",
              snackType: SnackType.error,
              behavior: SnackBarBehavior.fixed);
        }
      } else {
        print("Unexpected response format: $response");
        Get.snackbar("Error", "Unexpected response from the server.");
      }
    } catch (e) {
      print("An error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> updateMonthlyTarget(String id) async {
    try {
      isLoading.value = true; // Start loading

      final response = await ApiClient().updateMonthlyTarget(
          endPoint: ApiEndpoints.UpdateMTargets,
          mrid: (selectedRole == "MR")
              ? MrController.text
              : cordinatorController.text,
          newLead: leadsController.text,
          year: yearController.text,
          ctarget: collectionController.text,
          month: monthController.text,
          local: localExController.text,
          night: nightHaultExController.text,
          extra: extraHqExController.text,
          salary: setSalaryExController.text,
          calls: callsController.text,
          id: id);

      if (response.isNotEmpty) {
        if (response == "Updated Successfully!!") {
          print("User added successfully.");
          await fetchMonthlyTarget();
          Get.back();
          clearFormMonthly();
          CustomSnack.show(
              content: "Saved Successfully",
              snackType: SnackType.success,
              behavior: SnackBarBehavior.fixed);
        } else {
          print("Failed to add user: ${response}");
          CustomSnack.show(
              content: "${response}",
              snackType: SnackType.error,
              behavior: SnackBarBehavior.fixed);
        }
      } else {
        print("Unexpected response format: $response");
        Get.snackbar("Error", "Unexpected response from the server.");
      }
    } catch (e) {
      print("An error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> deleteMonthlyTarget(String id) async {
    try {
      isLoading.value = true; // Start loading

      final response = await ApiClient()
          .deleteMonthlyTarget(endPoint: ApiEndpoints.DeleteMTargets, id: id);

      if (response.isNotEmpty) {
        if (response == "Record Deleted Successfully!!") {
          print("Record Deleted Successfully!!");
          await fetchMonthlyTarget();
          update();
          clearFormMonthly();
          CustomSnack.show(
              content: response,
              snackType: SnackType.success,
              behavior: SnackBarBehavior.fixed);
        } else {
          print("Failed to delete: ${response}");
          CustomSnack.show(
              content: "${response}",
              snackType: SnackType.error,
              behavior: SnackBarBehavior.fixed);
        }
      } else {
        print("Unexpected response format: $response");
        Get.snackbar("Error", "Unexpected response from the server.");
      }
    } catch (e) {
      print("An error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  fetchMonthlyTarget() async {
    try {
      isLoading.value = true;
      final data =
          await ApiClient().getMonthlyTarget(ApiEndpoints.monthlyTarget);
      if (data.isNotEmpty) {
        monthlyTargetList.assignAll(data);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCordinators() async {
    await _fetchData(
      apiCall: () async =>
          await ApiClient().getCordinatorList(ApiEndpoints.BMList),
      dataList: cordinators,
      isFetchingState: isLoading,
    );
  }

  void fetchMr() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getMrList(ApiEndpoints.MRList),
      dataList: mr,
      isFetchingState: isLoading,
    );
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

  RxList<CustomerResponseModel> leadAssignToList =
      <CustomerResponseModel>[].obs;
  RxString selectedRole = 'MR'.obs;
  final leadAssignToController = TextEditingController();
  final leadsController = TextEditingController();
  final callsController = TextEditingController();
  final collectionController = TextEditingController();
  final localExController = TextEditingController();
  final nightHaultExController = TextEditingController();
  final extraHqExController = TextEditingController();
  final setSalaryExController = TextEditingController();
  final monthController = TextEditingController();
  final showMonthController = TextEditingController();
  final yearController = TextEditingController();
  final showLeadAssignToController = TextEditingController();
  final showCordinatorController = TextEditingController();
  final cordinatorController = TextEditingController();
  final showMrController = TextEditingController();
  final MrController = TextEditingController();
  void clearFormMonthly() {
    leadsController.clear();
    callsController.clear();
    collectionController.clear();
    localExController.clear();
    nightHaultExController.clear();
    extraHqExController.clear();
    setSalaryExController.clear();
    monthController.clear();
    showCordinatorController.clear();
    showMonthController.clear();
    yearController.clear();
    cordinatorController.clear();
    showMrController.clear();
    MrController.clear();
  }

  // Initialize the years list based on the current year
  void initializeYears() {
    years.assignAll(
      List.generate(
        3,
        (index) => CustomSelectItem(
          id: (currentYear.value + index).toString(),
          value: (currentYear.value + index).toString(),
        ),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchCordinators();
    fetchMr();
    fetchMonthlyTarget();
    initializeYears(); // Initialize the years list on controller initialization
  }
}

class MonthsModel {
  String month;
  String value;

  MonthsModel({required this.month, required this.value});
}
