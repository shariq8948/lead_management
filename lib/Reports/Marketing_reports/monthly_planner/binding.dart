import 'package:get/get.dart';
import 'controller.dart';

class MonthlyPlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MonthlyPlannerController>(() => MonthlyPlannerController());
  }
}
