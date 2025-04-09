import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/utils/api_endpoints.dart';

class LocationsController extends GetxController {
  static LocationsController get to => Get.find();
  final box = GetStorage();

  // State Variables
  final stateTextController = TextEditingController();
  final stateIdController = TextEditingController();
  RxList<StateListDropdown> states = <StateListDropdown>[].obs;

  // City Variables
  final cityTextController = TextEditingController();
  final cityIdController = TextEditingController();
  RxList<cityListDropDown> cities = <cityListDropDown>[].obs;

  // Area Variables
  final areaTextController = TextEditingController();
  final areaIdController = TextEditingController();
  RxList<areaListDropDown> areas = <areaListDropDown>[].obs;

  // Loading states
  RxBool isLoadingStates = false.obs;
  RxBool isLoadingCities = false.obs;
  RxBool isLoadingAreas = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStates();
  }

  @override
  void onClose() {
    stateTextController.clear();
    stateIdController.clear();
    cityTextController.clear();
    cityIdController.clear();
    areaTextController.clear();
    areaIdController.clear();
    super.onClose();
  }

  void clearForm() {
    stateTextController.clear();
    stateIdController.clear();
    cityTextController.clear();
    cityIdController.clear();
    areaTextController.clear();
    areaIdController.clear();
  }

  Future<void> fetchStates() async {
    try {
      isLoadingStates.value = true;
      final data = await ApiClient()
          .getStateList(box.read("userId"), ApiEndpoints.stateList);
      if (data.isNotEmpty) {
        states.assignAll(data);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch states',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching states: $e');
    } finally {
      isLoadingStates.value = false;
    }
  }

  Future<void> fetchCities(String stateId) async {
    try {
      isLoadingCities.value = true;
      final data =
          await ApiClient().getCityList(ApiEndpoints.cityList, stateId);
      if (data.isNotEmpty) {
        cities.assignAll(data);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch cities',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching cities: $e');
    } finally {
      isLoadingCities.value = false;
    }
  }

  Future<void> fetchAreas(String cityId) async {
    try {
      isLoadingAreas.value = true;
      final data = await ApiClient().getAreaList(ApiEndpoints.areaList, cityId);
      if (data.isNotEmpty) {
        areas.assignAll(data);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch areas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching areas: $e');
    } finally {
      isLoadingAreas.value = false;
    }
  }

  Future<void> saveState(String stateName, String stateCode) async {
    try {
      print(stateName);
      final response = await ApiClient().addState(
          endPoint: ApiEndpoints.addState,
          stateCode: stateCode,
          state: stateName);
      if (response) {
        await fetchStates(); // Refresh the states list
        Get.snackbar(
          'Success',
          'State added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add state',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saving state: $e');
    }
  }

  Future<void> saveCity(String cityName, String stateId) async {
    try {
      print(cityName);
      print(stateId);
      final res = await ApiClient().addCity(
          endPoint: ApiEndpoints.addCity, stateCode: stateId, city: cityName);
      if (res) {
        await fetchCities(stateId);
        Get.back();
        clearForm(); // Refresh the cities list
        Get.snackbar(
          'Success',
          'City added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add city',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saving city: $e');
    }
  }

  Future<void> saveArea(
      String areaName, String cityId, String stateCode) async {
    try {
      final res = await ApiClient().addArea(
          endPoint: ApiEndpoints.addArea,
          stateCode: stateCode,
          city: cityId,
          area: areaName);
      if (res) {
        await fetchAreas(cityId); // Refresh the areas list
        Get.back(); // Close the dialog
        Get.snackbar(
          'Success',
          'Area added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add area',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saving area: $e');
    }
  }

  void clearStateData() {
    stateTextController.clear();
    stateIdController.clear();
    cities.clear();
    clearCityData();
  }

  void clearCityData() {
    cityTextController.clear();
    cityIdController.clear();
    areas.clear();
    clearAreaData();
  }

  void clearAreaData() {
    areaTextController.clear();
    areaIdController.clear();
  }
}
