  import 'package:get/get.dart';
  import 'package:flutter/material.dart';
  import 'package:get_storage/get_storage.dart';
  import 'package:intl/intl.dart';
  import 'package:leads/data/api/api_client.dart';
  import 'package:leads/data/models/dropdown_list.model.dart';
  import 'package:leads/utils/api_endpoints.dart';

  import '../data/models/lead_list.dart';

  class LeadListController extends GetxController {
    RxList<LeadList> leads = <LeadList>[].obs;
    RxBool isFetchingMore = false.obs;
    final box = GetStorage();
    RxBool filtered=false.obs;
    RxList<LeadSourceDropdownList> leadSource = <LeadSourceDropdownList>[].obs;
    RxList<StateListDropdown> stateList = <StateListDropdown>[].obs;
    RxList<cityListDropDown> cityList = <cityListDropDown>[].obs;
    RxList<areaListDropDown> areaList = <areaListDropDown>[].obs;
    RxList<ProductListDropDown> productList = <ProductListDropDown>[].obs;

    // TextEditingController fromDateCtlr = TextEditingController(
    //     text: DateFormat("y-MM-dd").format(DateTime.now().subtract(Duration(days: 30))));
    // TextEditingController toDateCtlr = TextEditingController(text: DateFormat("y-MM-dd").format(DateTime.now()));
    TextEditingController fromDateCtlr = TextEditingController();
    TextEditingController toDateCtlr = TextEditingController();

    RxString fromDate = "".obs;
    RxString toDate ="".obs;
// RxString fromDate = DateFormat("y-MM-dd").format(DateTime.now().subtract(Duration(days: 30))).obs;
//     RxString toDate = DateFormat("y-MM-dd").format(DateTime.now()).obs;

    TextEditingController leadSourceController = TextEditingController();
    TextEditingController showLeadSourceController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController showCityController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController showAreaController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController showStateController = TextEditingController();
    TextEditingController productController = TextEditingController();
    TextEditingController showProductController = TextEditingController();

    // Filters and other states
    var isLoading = false.obs;
    RxInt currentPage = 0.obs; // Track the current page number
    RxBool hasMoreLeads = true.obs; // Flag to track if there are more leads to load
    RxString stateText = ''.obs; // Reactive string to track changes
    RxString cityText = ''.obs; // Reactive string to track changes

    void updateStateText() {
      stateText.value = stateController.text;
    }
    void updateCityText() {
      cityText.value = cityController.text;
    }
    @override
    void onInit() {
      super.onInit();
      fetchLeads();
      fetchLeadSource();
      fetchLeadState();
      fetchProductList();
      stateController.addListener(() {
        stateText.value = stateController.text;
      });
      cityController.addListener(() {
        cityText.value = cityController.text;
      });
    }

    // Helper function for API calls with loading state management
    Future<void> _fetchData({
      required Future<List<dynamic>> Function() apiCall,
      required RxList<dynamic> dataList,
      required RxBool isFetchingState,
    }) async
    {
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

    // Fetch leads with pagination
    Future<void> fetchLeads({bool isInitialFetch = true}) async {
      const String endpoint = "https://lead.mumbaicrm.com/api/PresalesMobile/GetLeadsServerSide";
      const String userId = "4";
      const String datatype = "LeadReport";
      const String tokenid = "65c9f919-f778-46ef-a2ec-31db7c417d4f";
      const String pageSize = "20";
      final String pageNumber = currentPage.value.toString();

      // Check if any filters are applied to decide the pagination
      final bool isFiltered = stateController.text.isNotEmpty ||
          leadSourceController.text.isNotEmpty ||
          fromDate.value.isNotEmpty ||
          toDate.value.isNotEmpty;

      // Set pagination flag based on whether there are filters
      final String isPagination = isFiltered ? "0" : "1";

      try {
        // Set the appropriate loading state
        if (isInitialFetch) {
          isLoading.value = true;
          if (isFiltered) {
            leads.clear(); // Clear previous data if a filter is applied
            currentPage.value = 0; // Reset pagination for filtered results
            hasMoreLeads.value = true; // Reset the flag to allow fresh data loading
          }
        } else {
          isFetchingMore.value = true;
        }

        // Fetch the leads
        final newLeads = await ApiClient().getLeadList(
          endPoint: endpoint,
          userId: userId,
          datatype: datatype,
          tokenid: tokenid,
          IsPagination: isPagination,
          PageSize: pageSize,
          Pagenumber: pageNumber,
          state: stateController.text,
          lead: leadSourceController.text,
          cityId: cityController.text,
          areaId: areaController.text,
          queryParams: {
            "FromDate": fromDate.value,
            "Uptodate": toDate.value,
          },
        );

        // Handle the fetched leads
        if (newLeads.isNotEmpty) {
          if (isInitialFetch) {
            leads.assignAll(newLeads); // Replace the list for the initial fetch
          } else {
            leads.addAll(newLeads); // Append new leads for subsequent fetches
          }
          currentPage.value++; // Increment the page number

          // If the fetched results are less than the page size, no more pages available
          if (newLeads.length < int.parse(pageSize)) {
            hasMoreLeads.value = false;
          }
        } else {
          if (isFiltered) {
            // Clear previous data if no results are found for a filter
            leads.clear();
          }
          hasMoreLeads.value = false; // No more leads to fetch
        }
      } catch (e) {
        print("An error occurred while fetching leads: $e");
      } finally {
        // Reset loading states
        isLoading.value = false;
        isFetchingMore.value = false;
      }
    }

    // Fetch lead sources
    void fetchLeadSource() async {
      await _fetchData(
        apiCall: () async => await ApiClient().getLeadSource(box.read("userId"), ApiEndpoints.leadSource),
        dataList: leadSource,
        isFetchingState: isLoading,
      );
    }

    // Fetch lead states
    void fetchLeadState() async {
      await _fetchData(
        apiCall: () async => await ApiClient().getStateList(box.read("userId"), ApiEndpoints.stateList),
        dataList: stateList,
        isFetchingState: isLoading,
      );
    }
    Future<void> fetchLeadCity() async {
      await _fetchData(
        apiCall: () async => await ApiClient().getCityList( ApiEndpoints.cityList,stateController.text),
        dataList: cityList,
        isFetchingState: isLoading,
      );
    }
    Future<void> fetchLeadArea() async {
      await _fetchData(
        apiCall: () async => await ApiClient().getAreaList( ApiEndpoints.areaList,cityController.text),
        dataList: areaList,
        isFetchingState: isLoading,
      );
    }

    // Fetch product list
    void fetchProductList() async {
      await _fetchData(
        apiCall: () async => await ApiClient().getProductList(box.read("userId"), ApiEndpoints.productList),
        dataList: productList,
        isFetchingState: isLoading,
      );
    }
    @override
    void onClose() {
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
    String formatDate(String rawDate) {
      try {
        // Correct the input date format
        DateTime parsedDate = DateFormat("M/d/yyyy h:mm:ss a").parse(rawDate);
        return DateFormat("dd/MM/yyyy").format(
            parsedDate); // Format as "27/07/2024"
      } catch (e) {
        return rawDate; // Fallback in case of parsing errors
      }
    }

  }
