import 'package:get/get.dart';

class ProductTargetController extends GetxController {
  var selectedStatus = 'All'.obs;
  var selectedTimePeriod = 'All Time'.obs;
  var selectedCategory = 'All Categories'.obs;

  void resetFilters() {
    selectedStatus.value = 'All';
    selectedTimePeriod.value = 'All Time';
    selectedCategory.value = 'All Categories';
  }
}
