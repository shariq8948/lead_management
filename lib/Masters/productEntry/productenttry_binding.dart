import 'package:get/get.dart';
import 'package:leads/Masters/productEntry/productListController.dart';

class ProductEntryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Productlistcontroller());
  }
}
