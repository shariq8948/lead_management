import 'package:get/get.dart';

import 'controller.dart';

class CollectionReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollectionReportController>(
      () => CollectionReportController(),
    );
  }
}
