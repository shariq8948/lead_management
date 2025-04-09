import 'package:get/get.dart';
import 'package:leads/leads/create_lead/create_lead_controller.dart';

class CreateLeadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateLeadController>(() => CreateLeadController());
  }
}
