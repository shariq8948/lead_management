import 'package:get/get.dart';

import 'controller.dart';

class ContactImportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactImportController>(() => ContactImportController());
  }
}
