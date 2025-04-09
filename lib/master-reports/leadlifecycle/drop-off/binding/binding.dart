import 'package:get/get.dart';
import '../controller/controller.dart';

class DropoffBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DropoffController>(() => DropoffController());
  }
}
