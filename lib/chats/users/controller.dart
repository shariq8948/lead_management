import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/dropdown_list.model.dart';

import '../../data/api/api_client.dart';
import '../../utils/api_endpoints.dart';

class CustomerController extends GetxController {
  static const int PAGE_SIZE = 20;

  final customerData = <CustomerResponseModel>[].obs;
  final currentCustomerPage = 0.obs;
  final hasMoreCustomers = true.obs;
  final isLoadingMoreCustomers = false.obs;
  final isError = false.obs;
  final searchQuery = ''.obs;
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final box = GetStorage();

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    _initializeSearch();
    fetchCustomers(isInitialFetch: true);
  }

  void _initializeSearch() {
    searchController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        searchQuery.value = searchController.text;
        fetchCustomers(isInitialFetch: true);
      });
    });
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchCustomers();
    }
  }

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

  void _handleError(dynamic error, String message) {
    isError.value = true;
    print('$message: $error');
    Get.snackbar(
      'Error',
      'Failed to load customers. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> refreshCustomers() async {
    await fetchCustomers(isInitialFetch: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
