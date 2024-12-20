import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';

import '../../data/models/dropdown_list.model.dart';
import '../../utils/api_endpoints.dart';

class cityListController extends GetxController {
  final box = GetStorage();
  final stateedt = TextEditingController();
  final showstateedt = TextEditingController();

  RxList<cityListDropDown> states = <cityListDropDown>[].obs;

  Future<void> fetchCity(String stateId) async {
    try {
      final data =
          await ApiClient().getCityList(ApiEndpoints.cityList, stateId);
      if (data.isNotEmpty) {
        states.assignAll(data);
      }
    } catch (e) {
      print(e);
    }
  }
}
