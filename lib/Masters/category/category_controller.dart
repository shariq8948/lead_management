import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/categorymodel.dart';
import 'package:leads/data/models/main_category_model.dart';
import 'package:leads/data/models/category_details.dart';
import 'package:leads/data/models/responseModel.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:leads/widgets/custom_snckbar.dart';

import '../../utils/tags.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController {
  // Search related variables
  RxString searchVal = "".obs;
  RxBool showSearch = false.obs;
  final searchController = SearchController();
  Timer? debounce;
  var originalIconImage = "".obs;
  var originalBannerImage = "".obs;

  // Add flag to track if images were changed
  var isIconChanged = false.obs;
  var isBannerChanged = false.obs;
  Future<String> urlToBase64(String imageUrl) async {
    try {
      final baseUrl = GetStorage().read(StorageTags.baseUrl) ?? '';
      final response = await http.get(Uri.parse('$baseUrl$imageUrl'));
      print(response.statusCode);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        print("base 64 image ${base64Encode(bytes)}");
        return 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }
      return '';
    } catch (e) {
      print('Error converting URL to base64: $e');
      return '';
    }
  }

  // State variables
  var categoryDetails = <CategoryDetailsModel>[].obs;
  var errorMessage = ''.obs;
  var isSaveAttempted = false.obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  var isEditing = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final mainCategoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final showMainCategoryController = TextEditingController();
  final subCatid = TextEditingController();
  // Image storage
  var bannerImageBase64 = RxString("");
  var iconImageBase64 = RxString("");

  // Data storage
  RxList<MainCategoryModel> mainCategories = <MainCategoryModel>[].obs;
  RxList<CategoryList> categories = <CategoryList>[].obs;
  final box = GetStorage();

  // Focus nodes
  FocusNode showMainCategoryFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetcMainCategories();
  }

  @override
  void dispose() {
    debounce?.cancel();
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    nameController.dispose();
    mainCategoryController.dispose();
    descriptionController.dispose();
    showMainCategoryController.dispose();
    showMainCategoryFocusNode.dispose();
    searchController.dispose();
  }

  Future<void> fetcMainCategories() async {
    try {
      final data = await ApiClient()
          .getMainCategory(box.read("userId"), ApiEndpoints.mainCategory);
      if (data.isNotEmpty) {
        mainCategories.clear();
        mainCategories.addAll(data);
      }
    } catch (e) {
      print("Error fetching main categories: $e");
      CustomSnack.show(
        content: "Failed to fetch main categories",
        snackType: SnackType.error,
      );
    }
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final data = await ApiClient().getcategoryList(
        box.read("userId"),
        ApiEndpoints.categoryList,
      );
      if (data.isNotEmpty) {
        categories.clear();
        categories.addAll(data);
      }
    } catch (e) {
      print("Error fetching categories: $e");
      CustomSnack.show(
        content: "Failed to fetch categories",
        snackType: SnackType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoryDetails(String id) async {
    try {
      isLoading.value = true;
      isEditing.value = true;
      errorMessage.value = '';

      final details = await ApiClient().getCategoryDetail(
          box.read("userId"), ApiEndpoints.CategoryDetail, id);

      if (details.isNotEmpty) {
        categoryDetails.value = details;
        final category = details[0];

        // Store original image paths
        originalIconImage.value = await urlToBase64(category.iconimg);
        originalBannerImage.value = await urlToBase64(category.bannerimg);

        // Convert existing images to base64 if they're URLs
        if (category.iconimg.isNotEmpty) {
          iconImageBase64.value = await urlToBase64(category.iconimg);
          print("in the cat${iconImageBase64}");
        } else {
          iconImageBase64.value = category.iconimg;
        }

        if (category.bannerimg.isNotEmpty) {
          bannerImageBase64.value = await urlToBase64(category.bannerimg);
          print("in the band${bannerImageBase64}");
        } else {
          bannerImageBase64.value = category.bannerimg;
        }
      } else {
        errorMessage.value = "No category details found.";
        CustomSnack.show(
          content: "Category details not found",
          snackType: SnackType.warning,
        );
      }
    } catch (e) {
      errorMessage.value = "Failed to fetch category details. Error: $e";
      CustomSnack.show(
        content: "Error fetching category details",
        snackType: SnackType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void saveCategory() async {
    if (_validateInputs()) {
      isSaving.value = true;

      try {
        bool isSuccess = await ApiClient().addCategory(
          endPoint: ApiEndpoints.addCategory,
          mainCategory: mainCategoryController.text.trim(),
          subcategory: nameController.text.trim(),
          icon: iconImageBase64.value,
          bannerimg: bannerImageBase64.value,
          desc: descriptionController.text.trim(),
        );

        if (isSuccess) {
          Get.back();
          _clearFields();
          fetchCategories();
          fetcMainCategories();
          CustomSnack.show(
            content: "Category successfully created",
            snackType: SnackType.success,
          );
        } else {
          CustomSnack.show(
            content: "Failed to create category",
            snackType: SnackType.warning,
          );
        }
      } catch (e) {
        print("Error saving category: $e");
        CustomSnack.show(
          content: "Error occurred while saving category",
          snackType: SnackType.error,
        );
      } finally {
        isSaving.value = false;
      }
    }
  }

  void updateCategory(String id, String code) async {
    if (_validateInputs()) {
      isSaving.value = true;

      try {
        print("tracking change${isIconChanged.value}");
        print("tracking change${originalIconImage.value}");
        print("tracking change${originalBannerImage.value}");
        // Use original image if no new image was selected
        final iconToSend = isIconChanged.value
            ? iconImageBase64.value
            : originalIconImage.value;

        final bannerToSend = isBannerChanged.value
            ? bannerImageBase64.value
            : originalBannerImage.value;

        bool isSuccess = await ApiClient().updateCategory(
          endPoint: ApiEndpoints.UpdateCategory,
          id: id,
          mainCategory: mainCategoryController.text.trim(),
          category: nameController.text.trim(),
          icon: iconToSend,
          bannerimg: bannerToSend,
          desc: descriptionController.text.trim(),
          code: code,
        );

        if (isSuccess) {
          Get.back();
          _clearFields();
          fetchCategories();
          fetcMainCategories();
          CustomSnack.show(
            content: "Category updated successfully",
            snackType: SnackType.success,
          );
        } else {
          CustomSnack.show(
            content: "Failed to update category",
            snackType: SnackType.warning,
          );
        }
      } catch (e) {
        print("Error updating category: $e");
        CustomSnack.show(
          content: "Error occurred while updating category",
          snackType: SnackType.error,
        );
      } finally {
        isSaving.value = false;
      }
    }
  }

  void setIconImage(String base64Image) {
    iconImageBase64.value = base64Image;
    isIconChanged.value = true;
  }

  void setBannerImage(String base64Image) {
    bannerImageBase64.value = base64Image;
    isBannerChanged.value = true;
  }

  void deleteCategory(String id) async {
    try {
      ResponseModel response = await ApiClient()
          .deleteCategory(endPoint: ApiEndpoints.DeleteCategory, id: id);

      if (response.success) {
        CustomSnack.show(
          content: response.message,
          snackType: SnackType.success,
          behavior: SnackBarBehavior.fixed,
        );
        fetcMainCategories();
        fetchCategories();
      } else {
        CustomSnack.show(
          content: response.message,
          snackType: SnackType.error,
          behavior: SnackBarBehavior.fixed,
        );
      }
    } catch (e) {
      print("Error deleting category: $e");
      CustomSnack.show(
        content: "An error occurred while deleting the category",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    }
  }

  bool _validateInputs() {
    isSaveAttempted.value = true;

    if (nameController.text.isEmpty) {
      CustomSnack.show(
        content: "Category name is required",
        snackType: SnackType.warning,
      );
      return false;
    }

    if (mainCategoryController.text.isEmpty) {
      CustomSnack.show(
        content: "Please select a parent category",
        snackType: SnackType.warning,
      );
      return false;
    }

    if (descriptionController.text.isEmpty) {
      CustomSnack.show(
        content: "Description is required",
        snackType: SnackType.warning,
      );
      return false;
    }

    return true;
  }

  void searchCategories(String query) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      searchVal.value = query;

      if (query.isNotEmpty) {
        final lowercaseQuery = query.toLowerCase();
        categories.value = categories
            .where((category) =>
                category.name.toLowerCase().contains(lowercaseQuery))
            .toList();
      } else {
        fetchCategories();
      }
    });
  }

  void resetForm() {
    _clearFields();
    isEditing.value = false;
    isSaveAttempted.value = false;
    categoryDetails.clear();
  }

  void _clearFields() {
    isIconChanged.value = false;
    isBannerChanged.value = false;
    originalIconImage.value = "";
    originalBannerImage.value = "";
    nameController.clear();
    mainCategoryController.clear();
    descriptionController.clear();
    showMainCategoryController.clear();
    bannerImageBase64.value = "";
    iconImageBase64.value = "";
  }
}
