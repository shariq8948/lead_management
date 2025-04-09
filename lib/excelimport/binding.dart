import 'package:get/get.dart';

import 'controller.dart';

class ExcelImportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExcelImportController>(
      () => ExcelImportController(),
    );
  }
}
