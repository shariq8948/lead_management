import 'package:get/get.dart';
import 'package:leads/leads/details/lead_detail_controller.dart';

class LeadDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadDetailController>(() => LeadDetailController());
  }
}
