import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class ProductCartBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController());
  }
}
