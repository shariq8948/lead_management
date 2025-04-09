import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';

import '../../data/models/payement_model.dart';
import '../../data/models/payment_type.dart';
import '../../widgets/custom_snckbar.dart';

class PayementModeController extends GetxController {
  var isLoading = false.obs;
  final payementTypeController = TextEditingController();
  final modeController = TextEditingController();
  final searchController = TextEditingController();

  RxList<PaymentModeModel> payementModes = <PaymentModeModel>[].obs;
  RxList<PaymentModeModel> filteredModes = <PaymentModeModel>[].obs;
  RxList<PaymentMode> type = <PaymentMode>[].obs;

  // Filter states
  RxMap<String, bool> activeFilters = <String, bool>{
    'cash': true,
    'online': true,
    'bank': true,
    'others': true,
  }.obs;

  RxString searchQuery = ''.obs;

  // Apply both search and filters
  void applySearchAndFilters() {
    filteredModes.value = payementModes.where((mode) {
      // Normalize the payment type
      String normalizedType = mode.paymentType.toLowerCase();

      // Check if the payment type is one of the predefined types
      bool isOtherType = !(normalizedType == 'cash' ||
          normalizedType == 'online' ||
          normalizedType == 'bank');

      // Determine if the current mode matches the active filters
      bool matchesFilter = isOtherType
          ? activeFilters['others'] ?? false
          : (activeFilters[normalizedType] ?? false);

      // If search query is empty, only apply filters
      if (searchQuery.value.isEmpty) {
        return matchesFilter;
      }

      // Apply both search and filters
      return matchesFilter &&
          (mode.paymentMode
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              mode.paymentType
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()));
    }).toList();
  }

  // Update search query
  void updateSearch(String query) {
    searchQuery.value = query;
    applySearchAndFilters();
  }

  // Toggle filter
  void toggleFilter(String filterKey, bool value) {
    activeFilters[filterKey] = value;
    applySearchAndFilters();
  }

  // Reset filters
  void resetFilters() {
    activeFilters.forEach((key, value) {
      activeFilters[key] = true;
    });
    applySearchAndFilters();
  }

  final formKey = GlobalKey<FormState>();
  RxBool isFetching = false.obs;
  RxBool isAddingProduct = false.obs;

  // Save payment mode
  Future<void> save() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isAddingProduct.value = true;

        bool isSuccess = await ApiClient().savePaymentMode(
          endPoint: ApiEndpoints.AddPaymentMode,
          mode: modeController.text,
          type: payementTypeController.text,
        );

        if (isSuccess) {
          clearForm();
          fetchMode();
          Get.back();
          CustomSnack.show(
              content: "Successfully Added",
              snackType: SnackType.success,
              behavior: SnackBarBehavior.fixed);
        } else {
          CustomSnack.show(
              content: "Failed To Add product",
              snackType: SnackType.error,
              behavior: SnackBarBehavior.fixed);
        }
      } catch (e) {
        print("Error adding product: $e");
        CustomSnack.show(
            content: "Failed To Add product",
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      } finally {
        isAddingProduct.value = false;
      }
    } else {
      CustomSnack.show(
          content: "Validation error",
          snackType: SnackType.warning,
          behavior: SnackBarBehavior.fixed);
    }
  }

  // Update payment mode
  Future<void> updateForm(String id) async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isAddingProduct.value = true;

        bool isSuccess = await ApiClient().updatePaymentMode(
          endPoint: ApiEndpoints.UpdatePaymentType,
          mode: modeController.text,
          type: payementTypeController.text,
          id: id,
        );

        if (isSuccess) {
          clearForm();
          fetchMode();
          Get.back();
          CustomSnack.show(
              content: "Successfully Edited",
              snackType: SnackType.success,
              behavior: SnackBarBehavior.fixed);
        } else {
          CustomSnack.show(
              content: "Failed To Update product",
              snackType: SnackType.error,
              behavior: SnackBarBehavior.fixed);
        }
      } catch (e) {
        print("Error updating product: $e");
        CustomSnack.show(
            content: "Failed To Update product",
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      } finally {
        isAddingProduct.value = false;
      }
    } else {
      CustomSnack.show(
          content: "Validation error",
          snackType: SnackType.warning,
          behavior: SnackBarBehavior.fixed);
    }
  }

  // Delete payment mode
  Future<void> deletePayment(String id) async {
    try {
      isAddingProduct.value = true;

      bool isSuccess = await ApiClient().deletePaymentMode(
        endPoint: ApiEndpoints.DeletePaymentType,
        id: id,
      );

      if (isSuccess) {
        fetchMode();
        CustomSnack.show(
            content: "Successfully Deleted",
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
      }
    } catch (e) {
      print("Error deleting product: $e");
      CustomSnack.show(
          content: "Failed To Delete product",
          snackType: SnackType.error,
          behavior: SnackBarBehavior.fixed);
    } finally {
      isAddingProduct.value = false;
    }
  }

  void clearForm() {
    modeController.clear();
    payementTypeController.clear();
  }

  // Fetch payment modes
  Future<void> fetchMode() async {
    isLoading.value = true;

    try {
      final data =
          await ApiClient().getPaymentModeList(ApiEndpoints.PaymentModes);
      if (data.isNotEmpty) {
        payementModes.assignAll(data);
        filteredModes.assignAll(data);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch payment types
  Future<void> fetchType() async {
    isLoading.value = true;

    try {
      final data = await ApiClient().getPaymentType(ApiEndpoints.PaymentType);
      if (data.isNotEmpty) {
        type.assignAll(data);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchMode();
    fetchType();
    super.onInit();
  }
}
