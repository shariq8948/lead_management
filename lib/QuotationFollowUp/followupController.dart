import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/QuotationFollowUpModel.dart';

import '../data/api/api_client.dart';
import '../utils/api_endpoints.dart';

class QuotationFollowUp extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await fetchQuotations();
  }

  TextEditingController DateCtlr = TextEditingController();
  TextEditingController conversationWithController = TextEditingController();
  TextEditingController followUpByController = TextEditingController();
  TextEditingController followUpStatusController = TextEditingController();
  TextEditingController remarkcontroller = TextEditingController();

  RxString Date = "".obs;
  RxList<QuotationFollowUpModel> quotationList = <QuotationFollowUpModel>[].obs;
  RxBool isFetchingMore = false.obs;
  RxInt currentPage = 0.obs; // Track the current page number
  var isLoading = false.obs;
  RxBool hasMoreLeads =
      true.obs; // Flag to track if there are more leads to load
  final box = GetStorage();
  Future<void> fetchQuotations({bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.QuotationList;
    final String userId = box.read("userId");
    const String pageSize = "10";
    final String pageNumber = currentPage.value.toString();
    const String isPagination = "1";

    try {
      if (isInitialFetch) {
        isLoading.value = true;
      } else {
        isFetchingMore.value = true;
      }

      final newQuotations = await ApiClient().getQuotationList(
        endPoint: endpoint,
        userId: userId,
        isPagination: isPagination,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (newQuotations.isNotEmpty) {
        if (isInitialFetch) {
          quotationList.assignAll(newQuotations);
        } else {
          quotationList.addAll(newQuotations);
        }
        currentPage.value++;
        if (newQuotations.length < int.parse(pageSize)) {
          hasMoreLeads.value = false;
        }
      } else {
        hasMoreLeads.value = false;
      }
    } catch (e) {
      print("An error occurred while fetching customers: $e");
      Get.snackbar("Error", "Failed to fetch customers. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = isFetchingMore.value = false;
    }
  }
}
