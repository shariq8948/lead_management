import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/utils/api_endpoints.dart';
import '../../data/models/lead_list.dart';

class LeadListController extends GetxController {
  // Storage and State Management
  final box = GetStorage();
  RxList<LeadList> leads = <LeadList>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs;
  RxBool hasMoreLeads = true.obs;
  RxInt currentPage = 0.obs;
  Timer? _searchDebounceTimer;

  // Filter States
  RxBool filtered = false.obs;
  RxBool sourceFilter = false.obs;
  RxBool stateFilter = false.obs;
  RxBool cityFilter = false.obs;
  RxBool fromFilter = false.obs;
  RxBool toFilter = false.obs;

  // Search and Scroll Management
  late ScrollController scrollController;
  RxBool isScrollingDown = false.obs;
  RxDouble lastScrollPosition = 0.0.obs;
  RxBool isSearchOpen = false.obs;
  RxString searchQuery = ''.obs;

  // Dropdown Data Lists
  RxList<LeadSourceDropdownList> leadSource = <LeadSourceDropdownList>[].obs;
  RxList<StateListDropdown> stateList = <StateListDropdown>[].obs;
  RxList<cityListDropDown> cityList = <cityListDropDown>[].obs;
  RxList<areaListDropDown> areaList = <areaListDropDown>[].obs;
  RxList<ProductListDropDown> productList = <ProductListDropDown>[].obs;

  // Text Controllers
  final TextEditingController searchController = TextEditingController();
  final TextEditingController fromDateCtlr = TextEditingController();
  final TextEditingController toDateCtlr = TextEditingController();
  final TextEditingController leadSourceController = TextEditingController();
  final TextEditingController showLeadSourceController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController showCityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController showAreaController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController showStateController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController showProductController = TextEditingController();

  // Observable Values
  RxString fromDate = "".obs;
  RxString toDate = "".obs;
  RxString stateText = ''.obs;
  RxString cityText = ''.obs;

  // Sort State
  RxString currentSortField = "".obs;
  RxBool isAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    initScrollController();
    setupListeners();
    fetchInitialData();
  }

  void initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Handle scroll direction for FAB animation
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isScrollingDown.value = true;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      isScrollingDown.value = false;
    }

    // Handle infinite scroll
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isFetchingMore.value && hasMoreLeads.value) {
        fetchLeads(isInitialFetch: false);
      }
    }
  }

  void setupListeners() {
    stateController.addListener(() {
      stateText.value = stateController.text;
      if (stateController.text.isEmpty) {
        cityController.clear();
        showCityController.clear();
        areaController.clear();
        showAreaController.clear();
        cityList.clear();
        areaList.clear();
      }
    });

    // City listener
    cityController.addListener(() {
      cityText.value = cityController.text;
      if (cityController.text.isEmpty) {
        areaController.clear();
        showAreaController.clear();
        areaList.clear();
      }
    });

    // Search listener with proper debouncing using Timer
    ever(searchQuery, (_) {
      if (_searchDebounceTimer?.isActive ?? false) {
        _searchDebounceTimer?.cancel();
      }
      _searchDebounceTimer = Timer(Duration(milliseconds: 500), () {
        currentPage.value = 0;
        leads.clear();
        fetchLeads(isInitialFetch: true);
      });
    });
  }

  void fetchInitialData() {
    fetchLeads(isInitialFetch: true);
    fetchLeadSource();
    fetchLeadState();
    fetchProductList();
  }

  Future<void> fetchLeads({bool isInitialFetch = true}) async {
    if (isLoading.value) return;

    try {
      if (isInitialFetch) {
        isLoading.value = true;
        leads.clear();
        currentPage.value = 0;
      } else {
        isFetchingMore.value = true;
      }

      final Map<String, dynamic> queryParams = {
        "FromDate": fromDate.value,
        "Uptodate": toDate.value,
        "Searchfilter": searchQuery.value,
        // "SortField": currentSortField.value,
        // "SortOrder": isAscending.value ? "ASC" : "DESC",
      };

      final newLeads = await ApiClient().getLeadList(
        endPoint: ApiEndpoints.leadList,
        userId: box.read("userId") ?? "4",
        datatype: "LeadReport",
        tokenid: "65c9f919-f778-46ef-a2ec-31db7c417d4f",
        IsPagination: filtered.value ? "0" : "1",
        PageSize: "20",
        Pagenumber: currentPage.value.toString(),
        state: stateController.text,
        lead: leadSourceController.text,
        cityId: cityController.text,
        areaId: areaController.text,
        queryParams: queryParams,
      );

      if (newLeads.isNotEmpty) {
        leads.addAll(newLeads);
        currentPage.value++;
        hasMoreLeads.value = newLeads.length >= 20;
      } else {
        hasMoreLeads.value = false;
      }
    } catch (e) {
      print("Error fetching leads: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch leads. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  // Search Methods
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
    currentPage.value = 0;
    leads.clear();
    fetchLeads(isInitialFetch: true);
  }

  // Filter Methods
  void applyFilters() {
    filtered.value = true;
    currentPage.value = 0;
    leads.clear();
    fetchLeads(isInitialFetch: true);
  }

  void clearFilters() {
    filtered.value = false;
    leadSourceController.clear();
    showLeadSourceController.clear();
    stateController.clear();
    showStateController.clear();
    cityController.clear();
    showCityController.clear();
    areaController.clear();
    showAreaController.clear();
    fromDateCtlr.clear();
    toDateCtlr.clear();
    fromDate.value = "";
    toDate.value = "";
    fromFilter.value = false;
    toFilter.value = false;
    sourceFilter.value = false;
    stateFilter.value = false;
    cityFilter.value = false;
    currentPage.value = 0;
    leads.clear();
    fetchLeads(isInitialFetch: true);
  }

  void removeFilter(String filterType) {
    switch (filterType) {
      case 'leadSource':
        leadSourceController.clear();
        showLeadSourceController.clear();
        sourceFilter.value = false;
        break;
      case 'state':
        stateController.clear();
        showStateController.clear();
        cityController.clear();
        showCityController.clear();
        areaController.clear();
        showAreaController.clear();
        stateFilter.value = false;
        cityFilter.value = false;
        break;
      case 'city':
        cityController.clear();
        showCityController.clear();
        areaController.clear();
        showAreaController.clear();
        cityFilter.value = false;
        break;
      case 'area':
        areaController.clear();
        showAreaController.clear();
        break;
      case 'fromDate':
        fromDateCtlr.clear();
        fromDate.value = "";
        fromFilter.value = false;
        break;
      case 'toDate':
        toDateCtlr.clear();
        toDate.value = "";
        toFilter.value = false;
        break;
    }

    // Check if any filters remain active
    filtered.value = [
      leadSourceController.text,
      stateController.text,
      cityController.text,
      areaController.text,
      fromDate.value,
      toDate.value,
    ].any((element) => element.isNotEmpty);

    currentPage.value = 0;
    leads.clear();
    fetchLeads(isInitialFetch: true);
  }

  // Sort Methods
  void sortLeads(String field) {
    if (currentSortField.value == field) {
      isAscending.toggle();
    } else {
      currentSortField.value = field;
      isAscending.value = true;
    }
    currentPage.value = 0;
    leads.clear();
    fetchLeads(isInitialFetch: true);
  }

  // Data Fetching Methods
  Future<void> fetchLeadSource() async {
    try {
      final data = await ApiClient()
          .getLeadSource(box.read("userId"), ApiEndpoints.leadSource);
      if (data.isNotEmpty) {
        leadSource.assignAll(data);
      }
    } catch (e) {
      print("Error fetching lead sources: $e");
    }
  }

  Future<void> fetchLeadState() async {
    try {
      final data = await ApiClient()
          .getStateList(box.read("userId"), ApiEndpoints.stateList);
      if (data.isNotEmpty) {
        stateList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching states: $e");
    }
  }

  Future<void> fetchLeadCity() async {
    try {
      if (stateController.text.isEmpty) return;
      final data = await ApiClient()
          .getCityList(ApiEndpoints.cityList, stateController.text);
      if (data.isNotEmpty) {
        cityList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  Future<void> fetchLeadArea() async {
    try {
      if (cityController.text.isEmpty) return;
      final data = await ApiClient()
          .getAreaList(ApiEndpoints.areaList, cityController.text);
      if (data.isNotEmpty) {
        areaList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching areas: $e");
    }
  }

  Future<void> fetchProductList() async {
    try {
      final data = await ApiClient()
          .getProductList(box.read("userId"), ApiEndpoints.productList);
      if (data.isNotEmpty) {
        productList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  // Utility Methods
  String formatDate(String rawDate) {
    try {
      DateTime parsedDate = DateFormat("M/d/yyyy h:mm:ss a").parse(rawDate);
      return DateFormat("dd/MM/yyyy").format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();

    // Dispose all controllers
    scrollController.dispose();
    searchController.dispose();
    fromDateCtlr.dispose();
    toDateCtlr.dispose();
    leadSourceController.dispose();
    showLeadSourceController.dispose();
    cityController.dispose();
    showCityController.dispose();
    areaController.dispose();
    showAreaController.dispose();
    stateController.dispose();
    showStateController.dispose();
    productController.dispose();
    showProductController.dispose();
    super.onClose();
  }
}
