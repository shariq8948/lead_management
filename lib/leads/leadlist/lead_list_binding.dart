import 'package:get/get.dart';
import 'package:leads/leads/leadlist/lead_list_controller.dart';

class LeadListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadListController>(() => LeadListController());
  }
}
