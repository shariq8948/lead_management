import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class LeadListController extends GetxController {
  // List of lead data
  var leads = <Lead>[].obs;
  RxList leadSource = ["Just Dial","Offline","Whatsapp","Source 2","source4","jgjhgjd","gjgjgd"].obs;
  TextEditingController fromDateCtlr =
  TextEditingController(text: DateFormat("y-MM-dd").format(DateTime.now().subtract(const Duration(days: 30))));
  TextEditingController toDateCtlr =
  TextEditingController(text: DateFormat("y-MM-dd").format(DateTime.now()));
  RxString fromDate = (DateFormat("y-MM-dd").format(DateTime.now().subtract(const Duration(days: 30)))).obs;
  RxString toDate = DateFormat("y-MM-dd").format(DateTime.now()).obs;
  TextEditingController leadSourceController=TextEditingController();
  // Filters and other states
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeads(); // Load leads on init
  }

  // Fetch lead data (dummy data for now)
  void fetchLeads() async {
    isLoading(true);
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    leads.value = List.generate(20, (index) => Lead(
        empId: "SA0063",
        leadName: "Lead $index",
        mobileNo: "76228709387"
    ));
    isLoading(false);
  }
}

// Lead Model
class Lead {
  final String empId;
  final String leadName;
  final String mobileNo;

  Lead({required this.empId, required this.leadName, required this.mobileNo});
}
