import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/product.dart';

import '../../data/api/api_client.dart';
import '../../utils/api_endpoints.dart';

class ItemController extends GetxController {
  var filteredItemData = <Map<String, String>>[].obs;
  var itemData = <Map<String, String>>[].obs;
  final qtyController = TextEditingController();
  final seacrchController = TextEditingController();
  final discountController = TextEditingController(text: "0");
  RxInt qty = 1.obs;
  RxInt totalAmnt = 0.obs;
  final customerSearchController = TextEditingController();

  RxList<Products1> itemsList = <Products1>[].obs;

  RxList<Products1> selectedItems = <Products1>[].obs;

  // Add selected item to selectedItems list
  void addItem(Products1 item) {
    selectedItems.add(item);
  }

  // Increment for specific item
  void increment(Products1 item) {
    item.qty.value += 1;
    print(item.qty.value); // Increment the quantity
  }

  void decrement(Products1 item) {
    if (item.qty.value > 1) {
      item.qty.value -= 1; // Decrement the quantity
    }
  }

  void searchItems() {}
  void clearItems() {}
  // Update selected item in selectedItems list

  RxList<Products1> productList = <Products1>[].obs;
  RxBool isFetchingMore = false.obs;
  RxInt currentPage = 0.obs; // Track the current page number
  var isLoading = false.obs;
  RxBool hasMoreLeads =
      true.obs; // Flag to track if there are more leads to load
  final box = GetStorage();
  Future<void> fetchProducts({bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.allProductsList;
    final String userId = box.read("userId");
    const String pageSize = "10"; // Number of items per page
    final String pageNumber =
        currentPage.value.toString(); // Current page number
    const String isPagination = "1";

    try {
      if (isInitialFetch) {
        isLoading.value = true; // Show loading indicator for initial fetch
      } else {
        isFetchingMore.value = true; // Show loading indicator for more data
      }

      final newProducts = await ApiClient().getAllProductList(
        endPoint: endpoint,
        userId: userId,
        isPagination: isPagination,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (newProducts.isNotEmpty) {
        if (isInitialFetch) {
          productList.assignAll(newProducts); // Load the initial data
        } else {
          productList
              .addAll(newProducts); // Add more data for subsequent fetches
        }

        currentPage.value++; // Increment the current page number
        if (newProducts.length < int.parse(pageSize)) {
          hasMoreLeads.value = false; // No more data to load
        }
      } else {
        hasMoreLeads.value = false; // No more data to load
      }
    } catch (e) {
      print("An error occurred while fetching products: $e");
      Get.snackbar("Error", "Failed to fetch products. Please try again.");
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  @override
  void onInit() {
    fetchProducts();
    // TODO: implement onInit
    super.onInit();
  }

  // Remove item from selectedItems list
  void removeItem(Products1 item) {
    selectedItems.remove(item);
    update(); // Notify listeners to update UI
  }
}
