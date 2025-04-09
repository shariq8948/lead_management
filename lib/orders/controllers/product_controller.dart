import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/tags.dart';

import 'dart:math' as math;

import '../model/product.dart';

class ProductListController extends GetxController {
  final storage = GetStorage();

  // Filter-related variables
  final categories = <String>[].obs;
  final gstRates = <String>[].obs;
  final selectedCategory = ''.obs;
  final selectedGst = ''.obs;
  final selectedPriceRange = const RangeValues(0.0, 10000.0).obs;
  final minPrice = 0.0.obs;
  final maxPrice = 10000.0.obs;

  // Products and search
  final filteredProducts = <Products>[].obs;
  final allProducts = <Products>[].obs;
  final searchQuery = ''.obs;
  final hasActiveFilters = false.obs;

  // Loading states
  final isLoading = false.obs;
  final isInitialLoading = true.obs;
  final isSearching = false.obs;

  // Pagination
  final hasMoreProducts = true.obs;
  final currentPage = 0.obs;
  final pageSize = 20.obs;
  final isLoadingMore = false.obs;
  final totalProducts = 0.obs;

  // Debounce for search
  final _debounce = Rx<DateTime?>(null);
  static const _searchDebounceTime = Duration(milliseconds: 100);

  // Search products
  void searchProducts(String query) async {
    searchQuery.value = query;

    // Set a debounce to avoid too many API calls while typing
    final now = DateTime.now();
    _debounce.value = now;

    await Future.delayed(_searchDebounceTime);
    if (_debounce.value != now) return;

    // Reset pagination when performing a new search
    if (query.isNotEmpty) {
      currentPage.value = 0;
      hasMoreProducts.value = true;
      await fetchProducts(isSearch: true);
    } else {
      // If search query is cleared, reset to regular product list
      currentPage.value = 0;
      hasMoreProducts.value = true;
      await fetchProducts();
    }
  }

  // Clear specific filters
  void clearCategoryFilter() {
    selectedCategory.value = '';
    applyFilters();
  }

  void clearGstFilter() {
    selectedGst.value = '';
    applyFilters();
  }

  void clearPriceFilter() {
    selectedPriceRange.value = RangeValues(minPrice.value, maxPrice.value);
    applyFilters();
  }

  // Load more products
  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts.value || isLoadingMore.value) {
      return;
    }

    isLoadingMore.value = true;
    currentPage.value++;

    try {
      await fetchProducts(
          isLoadMore: true, isSearch: searchQuery.value.isNotEmpty);
    } catch (e) {
      print('Error loading more products: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts().then((_) {
      // Make sure to explicitly clear all filters after initial load
      clearAllFilters();
    });

    // Set up listeners for filters other than search
    ever(selectedCategory, (_) => applyFilters());
    ever(selectedGst, (_) => applyFilters());
    ever(selectedPriceRange, (_) => applyFilters());
  }

  Future<void> fetchProducts(
      {bool isLoadMore = false, bool isSearch = false}) async {
    if (!isLoadMore) {
      isLoading.value = true;

      if (isSearch) {
        isSearching.value = true;
      }
    }

    try {
      final Map<String, String> queryParams = {
        'userId': storage.read(StorageTags.userId),
        'pagesize': pageSize.value.toString(),
        'PageNumber': currentPage.value.toString(),
      };

      // Add search filter if there's a query
      if (searchQuery.value.isNotEmpty) {
        queryParams['filter'] = searchQuery.value;
      }

      final response = await ApiClient().getR(
          "api/Mobileapi/appGetProductDetailsList",
          queryParameters: queryParams);

      List<Products> products = [];

      // Parse products from response
      if (response is List) {
        products = response.map((item) => Products.fromJson(item)).toList();
        print("Products loaded this batch: ${products.length}");
      } else if (response is Map &&
          response.containsKey('data') &&
          response['data'] is List) {
        products = (response['data'] as List)
            .map((item) => Products.fromJson(item))
            .toList();
      }

      if (!isLoadMore) {
        allProducts.clear();
        filteredProducts.clear();
        // Reset the counter if we're refreshing
        totalProducts.value = 0;
      }

      allProducts.addAll(products);

      if (products.length < pageSize.value) {
        totalProducts.value = allProducts.length;
        hasMoreProducts.value = false;
      } else {
        hasMoreProducts.value = true;

        totalProducts.value = math.max(totalProducts.value,
            allProducts.length + (hasMoreProducts.value ? 1 : 0));
      }

      _updateFilterOptions();

      // If we're searching, the API already returned filtered results
      // so we just need to apply local filters
      if (isSearch) {
        filteredProducts.assignAll(allProducts);
        _applyLocalFilters();
      } else {
        applyFilters();
      }

      print("Total products loaded so far: ${allProducts.length}");
      print("Estimated total products: ${totalProducts.value}");
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        "Error",
        "Failed to load products.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isInitialLoading.value = false;
      isSearching.value = false;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    isLoading.value = true;
    currentPage.value = 0;
    hasMoreProducts.value = true;
    allProducts.clear();
    filteredProducts.clear();
    await fetchProducts(isSearch: searchQuery.value.isNotEmpty);
  }

  void applyFilters() {
    if (allProducts.isEmpty) return;

    print('Applying filters:');
    print('- Search query: "${searchQuery.value}"');
    print('- Selected category: "${selectedCategory.value}"');
    print('- Selected GST: "${selectedGst.value}"');
    print(
        '- Price range: ${selectedPriceRange.value.start} to ${selectedPriceRange.value.end}');
    print('- Price min/max: ${minPrice.value} to ${maxPrice.value}');

    // For search filtering, we use the API
    if (searchQuery.value.isNotEmpty) {
      // Trigger a new search API call
      currentPage.value = 0;
      hasMoreProducts.value = true;
      fetchProducts(isSearch: true);
      return;
    }

    // For other filters, apply them locally
    _applyLocalFilters();
  }

  void _applyLocalFilters() {
    int excludedByCategory = 0;
    int excludedByGst = 0;
    int excludedByPrice = 0;

    final filtered = allProducts.where((product) {
      // Category filter
      if (selectedCategory.value.isNotEmpty) {
        if (product.category != selectedCategory.value) {
          excludedByCategory++;
          return false;
        }
      }

      // GST filter
      if (selectedGst.value.isNotEmpty) {
        if (product.gst != selectedGst.value) {
          excludedByGst++;
          return false;
        }
      }

      // Price filter
      final price = double.tryParse(product.saleRate) ?? 0.0;
      if (price < selectedPriceRange.value.start ||
          price > selectedPriceRange.value.end) {
        excludedByPrice++;
        return false;
      }

      return true;
    }).toList();

    filteredProducts.assignAll(filtered);

    print('Filter results:');
    print('- Total products: ${allProducts.length}');
    print('- Filtered products: ${filteredProducts.length}');
    print('- Excluded by category: $excludedByCategory');
    print('- Excluded by GST: $excludedByGst');
    print('- Excluded by price: $excludedByPrice');

    _updateActiveFiltersStatus();
  }

  void _updateFilterOptions() {
    if (allProducts.isEmpty) return;

    // Update categories
    categories.assignAll(allProducts
        .map((p) => p.category)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort());

    // Update GST rates
    gstRates.assignAll(allProducts
        .map((p) => p.gst)
        .where((g) => g.isNotEmpty)
        .toSet()
        .toList()
      ..sort());

    // Update price range
    if (allProducts.isNotEmpty) {
      final prices = allProducts
          .map((p) => double.tryParse(p.saleRate) ?? 0.0)
          .toList(); // Remove the filter for positive prices

      if (prices.isNotEmpty) {
        // Add some buffer to ensure all products are included
        minPrice.value = (prices.reduce((a, b) => a < b ? a : b)) * 0.9;
        maxPrice.value = (prices.reduce((a, b) => a > b ? a : b)) * 1.1;

        // Initially set the selected range to match all products
        selectedPriceRange.value = RangeValues(minPrice.value, maxPrice.value);
      }
    }
  }

  void _updateActiveFiltersStatus() {
    hasActiveFilters.value = selectedCategory.value.isNotEmpty ||
        selectedGst.value.isNotEmpty ||
        searchQuery.value.isNotEmpty ||
        (selectedPriceRange.value.start > minPrice.value ||
            selectedPriceRange.value.end < maxPrice.value);
  }

  void clearAllFilters() {
    print('Clearing all filters');
    selectedCategory.value = '';
    selectedGst.value = '';

    // Reset search and fetch products without search filter
    searchQuery.value = '';
    currentPage.value = 0;
    hasMoreProducts.value = true;
    fetchProducts();

    // Make sure price range is set to min/max values
    double minPossible = 0.0;
    double maxPossible =
        double.maxFinite; // Or a very large number like 999999999.0
    selectedPriceRange.value = RangeValues(minPossible, maxPossible);

    // Double-check active filter status
    hasActiveFilters.value = false;

    print('After clearing filters:');
    print('- Filtered products count: ${filteredProducts.length}');
    print('- All products count: ${allProducts.length}');
    print('- hasActiveFilters: ${hasActiveFilters.value}');
  }

  @override
  void onClose() {
    super.onClose();
  }
}
