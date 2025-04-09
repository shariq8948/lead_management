import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/api/api_client.dart';
import '../../data/models/dropdown_list.model.dart';
import '../../utils/api_endpoints.dart';

class QuotationEntryController extends GetxController {
  // Customers
  RxList<CustomerResponseModel> customerData = <CustomerResponseModel>[].obs;
  RxBool isFetchingMoreCustomers = false.obs;
  RxBool hasMoreCustomers = true.obs;

  // Prospects
  // RxList<ProspectResponseModel> prospectData = <ProspectResponseModel>[].obs;
  RxBool isFetchingMoreProspects = false.obs;
  RxBool hasMoreProspects = true.obs;

  // Pagination
  RxInt currentCustomerPage = 0.obs; // Start from page 0
  RxInt currentProspectPage = 0.obs; // Start from page 0
  RxBool isLoading = false.obs;

  // Search Controllers
  final customerSearchController = TextEditingController();
  final prospectSearchController = TextEditingController();

  final box = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    await fetchCustomers(); // Fetch customers initially
    // await fetchProspects();  // Fetch prospects initially
  }

  // Fetch customers from API with pagination
  Future<void> fetchCustomers(
      {String query = '', bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.customerList;
    final String userId = box.read("userId");
    const String pageSize = "10"; // Page size for the API
    final String pageNumber =
        currentCustomerPage.value.toString(); // Current page number
    const String isPagination = "1";

    try {
      if (isInitialFetch) {
        isLoading.value = true;
      } else {
        isFetchingMoreCustomers.value = true;
      }

      final newCustomers = await ApiClient().getCustomerList(
        endPoint: endpoint,
        userId: userId,
        isPagination: isPagination,
        pageSize: pageSize,
        pageNumber: pageNumber, q: '',
        // query: query,  // Pass the search query if any
      );

      if (newCustomers.isNotEmpty) {
        if (isInitialFetch) {
          customerData.assignAll(newCustomers); // Set initial data
        } else {
          customerData.addAll(newCustomers); // Add more data
        }
        currentCustomerPage.value++; // Increment the page number for pagination
        if (newCustomers.length < int.parse(pageSize)) {
          hasMoreCustomers.value = false; // No more data to load
        }
      } else {
        hasMoreCustomers.value = false; // No data found
      }
    } catch (e) {
      print("An error occurred while fetching customers: $e");
      Get.snackbar("Error", "Failed to fetch customers. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = isFetchingMoreCustomers.value = false;
    }
  }

  // Fetch prospects from API with pagination
  // Future<void> fetchProspects({String query = '', bool isInitialFetch = true}) async {
  //   const String endpoint = ApiEndpoints.prospectList;
  //   final String userId = box.read("userId");
  //   const String pageSize = "10"; // Page size for the API
  //   final String pageNumber = currentProspectPage.value.toString();  // Current page number
  //   const String isPagination = "1";
  //
  //   try {
  //     if (isInitialFetch) {
  //       isLoading.value = true;
  //     } else {
  //       isFetchingMoreProspects.value = true;
  //     }
  //
  //     final newProspects = await ApiClient().getProspectList(
  //       endPoint: endpoint,
  //       userId: userId,
  //       isPagination: isPagination,
  //       pageSize: pageSize,
  //       pageNumber: pageNumber,
  //       query: query,  // Pass the search query if any
  //     );
  //
  //     if (newProspects.isNotEmpty) {
  //       if (isInitialFetch) {
  //         prospectData.assignAll(newProspects);  // Set initial data
  //       } else {
  //         prospectData.addAll(newProspects);  // Add more data
  //       }
  //       currentProspectPage.value++;  // Increment the page number for pagination
  //       if (newProspects.length < int.parse(pageSize)) {
  //         hasMoreProspects.value = false;  // No more data to load
  //       }
  //     } else {
  //       hasMoreProspects.value = false;  // No data found
  //     }
  //   } catch (e) {
  //     print("An error occurred while fetching prospects: $e");
  //     Get.snackbar("Error", "Failed to fetch prospects. Please try again.",
  //         snackPosition: SnackPosition.BOTTOM);
  //   } finally {
  //     isLoading.value = isFetchingMoreProspects.value = false;
  //   }
  // }

  // Filter customer data based on search query
  void filterCustomerData(String query) {
    query = query.toLowerCase();
    customerData.value = customerData.where((item) {
      return item.name!.toLowerCase().contains(query) ||
          item.mobile!.contains(query) ||
          item.email!.toLowerCase().contains(query);
    }).toList();
  }

  // Filter prospect data based on search query
  // void filterProspectData(String query) {
  //   query = query.toLowerCase();
  //   prospectData.value = prospectData.where((item) {
  //     return item['name']!.toLowerCase().contains(query) ||
  //         item['mobile']!.contains(query) ||
  //         item['email']!.toLowerCase().contains(query);
  //   }).toList();
  // }

  // Clear customer search
  void clearCustomerSearch() async {
    customerSearchController.clear();
    currentCustomerPage.value = 0; // Reset pagination
    hasMoreCustomers.value = true; // Reset load state
    customerData.clear(); // Clear existing data
    await fetchCustomers(
        query: '', isInitialFetch: true); // Fetch all customers
    customerData.refresh(); // Notify observers to rebuild UI
  }

  // Clear prospect search
  // void clearProspectSearch() {
  //   prospectSearchController.clear();
  //   fetchProspects(query: '');  // Fetch all prospects
  // }

  @override
  void onClose() {
    super.onClose();
    customerSearchController.dispose();
    prospectSearchController.dispose();
  }
}
