import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/customer_model.dart';
import 'package:leads/utils/api_endpoints.dart';

import '../data/models/dropdown_list.model.dart';

class ContactController extends GetxController {
  @override
  void onInit() {
    fetchassignTo();
    // TODO: implement onInit
    super.onInit();
  }

  final box = GetStorage();
  RxList<CustomerDetail> details = <CustomerDetail>[].obs;
  RxBool isLoading = false.obs;
  RxList<ownerDropdownList> leadAssignToList = <ownerDropdownList>[].obs;

  final TextEditingController followUpType = TextEditingController();
  final TextEditingController DateCtlr = TextEditingController();
  final TextEditingController leadAssignToController = TextEditingController();
  final TextEditingController ReminderCtlr = TextEditingController();
  final TextEditingController meetingTitle = TextEditingController();
  final TextEditingController mettingFromDateCtlr = TextEditingController();
  final TextEditingController mettingToDateCtlr = TextEditingController();
  final TextEditingController mettingReminderCtlr = TextEditingController();
  final TextEditingController mettingLocation = TextEditingController();
  final TextEditingController meetingod = TextEditingController();
  final TextEditingController mettingdesc = TextEditingController();
  final TextEditingController showLeadAssignToController =
      TextEditingController();
  final TextEditingController remarkcontroller = TextEditingController();
  void fetchassignTo() async {
    try {
      final data = await ApiClient()
          .getLeadOwner(box.read("userId"), ApiEndpoints.userRoles);
      if (data.isNotEmpty) {
        leadAssignToList.addAll(data);
      }
    } catch (e) {}
  }

  void fetchDetails(String id) async {
    try {
      isLoading.value = true; // Start loading
      details.clear(); // Clear previous details
      final data = await ApiClient().getCustomerDetails(
          ApiEndpoints.customerDetails, box.read("userId"), id);

      if (data != null && data.isNotEmpty) {
        details.addAll(data);
      }
    } catch (e) {
      print("Error fetching details: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
