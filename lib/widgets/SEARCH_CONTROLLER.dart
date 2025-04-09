import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var showSearch = false.obs; // To toggle the search bar visibility
  var searchController = TextEditingController();
  var searchVal = ''.obs; // To store the search value
  Timer? debounce;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
