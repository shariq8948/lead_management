import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductListController());
    Get.lazyPut(() => CartController());
  }
}
