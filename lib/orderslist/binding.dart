import 'package:get/get.dart';

import 'controller.dart';

class OrdersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrdersController());
  }
}
