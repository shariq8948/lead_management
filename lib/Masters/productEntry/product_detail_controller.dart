import 'package:get/get.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';

import '../../data/models/produc_detail_model.dart';

class ProductDetailController extends GetxController {
  var productDetails = <ProductDetailModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchProductDetails(String userId, String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final details = await ApiClient()
          .getProductDetail(ApiEndpoints.ProductDetail, id);
      if (details.isNotEmpty) {
        productDetails.value = details;
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
      fetchProductDetails("userId", productId);
    }
  }
}
