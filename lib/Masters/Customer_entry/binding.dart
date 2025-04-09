import 'package:get/get.dart';

import 'customer_entry_controller.dart';

class CustomerEntryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerEntryController());
  }
}
