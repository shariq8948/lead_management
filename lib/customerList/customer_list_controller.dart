import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/dropdown_list.model.dart';

import '../data/api/api_client.dart';
import '../utils/api_endpoints.dart';

class CustomerListController extends GetxController{
  @override
  void onInit() async {
    super.onInit();
    await fetchCustomers();
  }
  RxList<CustomerResponseModel> customerList=<CustomerResponseModel>[].obs;
  RxBool isFetchingMore = false.obs;
  RxInt currentPage = 0.obs; // Track the current page number
  var isLoading = false.obs;
  RxBool hasMoreLeads = true.obs; // Flag to track if there are more leads to load
  final box = GetStorage();
  Future<void> fetchCustomers({bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.customerList;
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

      final newCustomers = await ApiClient().getCustomerList(
        endPoint: endpoint,
        userId: userId,
        isPagination: isPagination,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (newCustomers.isNotEmpty) {
        if (isInitialFetch) {
          customerList.assignAll(newCustomers );
        } else {
          customerList.addAll(newCustomers );
        }
        currentPage.value++;
        if (newCustomers.length < int.parse(pageSize)) {
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
  void deleteCustomer(String id){
    ApiClient().deleteCustomerData(endPoint:ApiEndpoints.deleteCustomer, Id: id, userId: box.read("userId"));
  }

}