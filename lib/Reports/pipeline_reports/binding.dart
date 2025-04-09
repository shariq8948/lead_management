import 'package:get/get.dart';

import 'controller.dart';

class PipelineBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PipelineController());
  }
}
