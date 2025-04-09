import 'package:get/get.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/category_details.dart';
import 'package:leads/utils/api_endpoints.dart';

class CategoryDetailController extends GetxController {
  var categoryDetails = <CategoryDetailsModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchCategoryDetails(String userId, String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final details = await ApiClient()
          .getCategoryDetail(userId, ApiEndpoints.CategoryDetail, id);
      if (details.isNotEmpty) {
        categoryDetails.value = details;
      } else {
        errorMessage.value = "No product details found.";
      }
    } catch (e) {
      errorMessage.value = "Failed to fetch product details. Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Extract productId and fetch details
    final productId = Get.arguments?['productId'];
    if (productId != null) {
      fetchCategoryDetails("userId", productId);
    }
  }
}
