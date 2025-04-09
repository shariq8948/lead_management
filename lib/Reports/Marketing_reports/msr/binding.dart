import 'package:get/get.dart';
import 'controller.dart';

class MSRbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesController>(() => SalesController());
  }
}
