import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';

import '../../../data/models/dropdown_list.model.dart';
import '../../../utils/api_endpoints.dart';

class areaController extends GetxController {
  final stateedt = TextEditingController();
  final cityedt = TextEditingController();
  final showstateedt = TextEditingController();
  final showcityeedt = TextEditingController();

  RxList<areaListDropDown> areas = <areaListDropDown>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    fetchState();
  }

  final box = GetStorage();

  RxList<StateListDropdown> states = <StateListDropdown>[].obs;
  RxList<cityListDropDown> city = <cityListDropDown>[].obs;

  fetchState() async {
    try {
      final data = await ApiClient()
          .getStateList(box.read("userId"), ApiEndpoints.stateList);
      if (data.isNotEmpty) {
        states.assignAll(data);
      }
    } catch (e) {
      print(e);
    }
  }

  fetchCity(String stateId) async {
    try {
      final data =
          await ApiClient().getCityList(ApiEndpoints.cityList, stateId);
      if (data.isNotEmpty) {
        city.assignAll(data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchArea(String areaId) async {
    try {
      final data = await ApiClient().getAreaList(ApiEndpoints.areaList, areaId);
      if (data.isNotEmpty) {
        areas.assignAll(data);
      }
    } catch (e) {
      print(e);
    }
  }
}
