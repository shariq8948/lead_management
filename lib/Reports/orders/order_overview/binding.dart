import 'package:get/get.dart';
import 'controller.dart';

class OrderReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersReportController>(() => OrdersReportController());
  }
}
