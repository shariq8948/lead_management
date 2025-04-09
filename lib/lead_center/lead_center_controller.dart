import 'package:get/get.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/data/models/lead_list.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:intl/intl.dart';

class LeadCenterController extends GetxController {
  RxList<LeadList> leads = <LeadList>[].obs;
  RxList<LeadList> filteredLeads = <LeadList>[].obs;
  RxBool isLoading = false.obs;
  Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  Rx<DateTime?> toDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    fromDate.value = now.subtract(Duration(days: 30));
    toDate.value = now;

    fetchLeads();
  }

  Future<void> fetchLeads() async {
    try {
      isLoading.value = true;
      final newLeads = await ApiClient().getLeadList(
        endPoint: ApiEndpoints.leadList,
        userId: "4",
        datatype: "LeadReport",
        tokenid: "65c9f919-f778-46ef-a2ec-31db7c417d4f",
        IsPagination: "0", // Disable pagination
        state: "",
        lead: "",
        cityId: "",
        areaId: "",
        queryParams: {
          "FromDate": fromDate.value != null
              ? DateFormat('yyyy-MM-dd').format(fromDate.value!)
              : "",
          "Uptodate": toDate.value != null
              ? DateFormat('yyyy-MM-dd').format(toDate.value!)
              : "",
        },
        PageSize: '0',
        Pagenumber: '0',
      );

      if (newLeads.isNotEmpty) {
        leads.assignAll(newLeads);
        filteredLeads.assignAll(newLeads);
      }
    } catch (e) {
      print("Error fetching leads: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterLeads(String query) {
    filteredLeads.value = leads.where((lead) {
      return lead.leadName.toLowerCase().contains(query.toLowerCase()) ||
          lead.email.toLowerCase().contains(query.toLowerCase()) ||
          lead.phone.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void filterByStatus(String status) {
    filteredLeads.value = leads.where((lead) {
      return lead.leadStatus.toLowerCase() == status.toLowerCase();
    }).toList();
  }

  void filterByDateRange(DateTime fromDate, DateTime toDate) {
    this.fromDate.value = fromDate;
    this.toDate.value = toDate;
    filteredLeads.clear();
    leads.clear();
    fetchLeads();
  }

  void resetLeads() {
    filteredLeads.value = leads;
  }

  RxList<StatusModel> calltype = <StatusModel>[
    StatusModel(status: "New", value: "2"),
    StatusModel(status: "Contacted", value: "3"),
    StatusModel(status: "Opportunity", value: "4"),
    StatusModel(status: "Negotiation", value: "5"),
    StatusModel(status: "Qualified", value: "6"),
    StatusModel(status: "Disqualified", value: "7"),
  ].obs;
}

class StatusModel {
  String status;
  String value;

  StatusModel({required this.status, required this.value});
}
