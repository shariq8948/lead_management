import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/apiResponse.dart';

import '../../data/api/api_client.dart';
import '../../data/models/dropdown_list.model.dart';
import '../../data/models/leadDetails.dart';
import '../../utils/api_endpoints.dart';

class CreateLeadController extends GetxController {
  final leadOwnerController = TextEditingController();
  final leadNameController = TextEditingController();
  final leadMobileController = TextEditingController();
  final leadEmailController = TextEditingController();
  final leadAddressController = TextEditingController();
  final leadComapnyController = TextEditingController();
  final leadDealSizeController = TextEditingController();
  final leadDescriptionontroller = TextEditingController();
  final leadSourceController = TextEditingController();
  final leadAssignToController = TextEditingController();
  final leadIndustryController = TextEditingController();
  final showLeadSourceController = TextEditingController();
  final showLeadOwnerController = TextEditingController();
  final showLeadAssignToController = TextEditingController();
  final showLeadIndustryController = TextEditingController();
  RxList<LeadResponse> details = <LeadResponse>[].obs;
  final RxBool isEdit = false.obs;

  // Observable variables
  var isLoading = false.obs;
  final box = GetStorage();
  RxList<LeadSourceDropdownList> leadSource = <LeadSourceDropdownList>[].obs;
  RxList<ownerDropdownList> leadOwner = <ownerDropdownList>[].obs;
  RxList<ownerDropdownList> leadAssignToList = <ownerDropdownList>[].obs;
  RxList<IndustryListDropdown> industryList = <IndustryListDropdown>[].obs;

  // API Client
  final ApiClient _apiClient = ApiClient();

  Future<void> fetchLeadSource() async {
    try {
      isLoading.value = true;
      final data = await _apiClient.getLeadSource(
        box.read("userId"),
        ApiEndpoints.leadSource,
      );
      if (data.isNotEmpty) {
        leadSource.assignAll(data);
      }
    } catch (e) {
      print("Error fetching lead source: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<ApiResponse<void>> updateLead() async {
    try {
      final response = await _apiClient.updateLeadData(
        endPoint: ApiEndpoints.updateLead,
        userId: box.read("userId"),
        leadId: details[0].leadid, // Include the lead ID for update
        AssignTo: leadAssignToController.text,
        company: leadComapnyController.text,
        dealSize: leadDealSizeController.text,
        name: leadNameController.text,
        mobileNumber: leadMobileController.text,
        productId: "0",
        address: leadAddressController.text,
        Description: leadDescriptionontroller.text,
        email: leadEmailController.text,
        source: leadSourceController.text,
        owner: leadOwnerController.text,
        industry: leadIndustryController.text,
      );
      return response;
    } catch (error) {
      print("Error updating lead: $error");
      return ApiResponse(
        status: "0",
        message: "Failed to update lead. Please try again.",
      );
    }
  }

  Future<void> fetchLeadOwner() async {
    try {
      isLoading.value = true;
      final data = await _apiClient.getLeadOwner(
        box.read("userId"),
        ApiEndpoints.userRoles,
      );
      if (data.isNotEmpty) {
        leadOwner.assignAll(data);
      }
    } catch (e) {
      print("Error fetching lead owner: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeadAssignTo() async {
    try {
      isLoading.value = true;
      final data = await _apiClient.getLeadOwner(
        box.read("userId"),
        ApiEndpoints.userRoles,
      );
      if (data.isNotEmpty) {
        leadAssignToList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching lead assign to: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeadIndustry() async {
    try {
      isLoading.value = true;
      final data = await _apiClient.getIndustry(
        box.read("userId"),
        ApiEndpoints.industryList,
      );
      if (data.isNotEmpty) {
        industryList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching lead industry: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<ApiResponse<void>> save() async {
    try {
      final response = await _apiClient.postLeadData(
        endPoint: ApiEndpoints.saveLead,
        userId: box.read("userId"),
        AssignTo: leadAssignToController.text,
        company: leadComapnyController.text,
        dealSize: leadDealSizeController.text,
        name: leadNameController.text,
        mobileNumber: leadMobileController.text,
        productId: "0",
        address: leadAddressController.text,
        Description: leadDescriptionontroller.text,
        email: leadEmailController.text,
        source: leadSourceController.text,
        owner: leadOwnerController.text,
        industry: leadIndustryController.text,
      );
      return response;
    } catch (error) {
      print("Error saving lead: $error");
      return ApiResponse(
        status: "0",
        message: "Failed to save lead. Please try again.",
      );
    }
  }

  void populateForm() {
    if (details.isEmpty) return;

    final lead = details[0];
    leadSourceController.text = lead.leadSourceId;
    showLeadSourceController.text = lead.leadSource;
    leadNameController.text = lead.leadName;
    leadMobileController.text = lead.mobile;
    leadEmailController.text = lead.email ?? '';
    leadAddressController.text = lead.address;
    leadComapnyController.text = lead.company ?? '';
    leadDealSizeController.text = lead.dealSize;
    leadDescriptionontroller.text = lead.description;
    leadOwnerController.text = lead.ownerId;
    showLeadOwnerController.text = lead.ownerName;
    leadAssignToController.text = lead.assigntoId;
    showLeadAssignToController.text = lead.assignToName;
    leadIndustryController.text = lead.industrytype;
    showLeadIndustryController.text = lead.industrytype;
  }

  void clearForm() {
    leadOwnerController.clear();
    leadNameController.clear();
    leadMobileController.clear();
    leadEmailController.clear();
    leadAddressController.clear();
    leadComapnyController.clear();
    leadDealSizeController.clear();
    leadDescriptionontroller.clear();
    leadSourceController.clear();
    leadAssignToController.clear();
    leadIndustryController.clear();
    showLeadSourceController.clear();
    showLeadOwnerController.clear();
    showLeadAssignToController.clear();
    showLeadIndustryController.clear();
  }

  fetchLead(String Id) async {
    isLoading.value = true;
    try {
      final data = await ApiClient()
          .getLeadDeails(ApiEndpoints.leadDetail, box.read("userId"), Id);
      if (data.isNotEmpty) {
        details.clear(); // Clear old data
        details.addAll(data);
      }
    } catch (e) {
      print("Error fetching lead details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    await Future.wait([
      fetchLeadSource(),
      fetchLeadAssignTo(),
      fetchLeadIndustry(),
      fetchLeadOwner(),
    ]);

    // Check if we're in edit mode
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      final id = arguments['id'] as String?;
      isEdit.value = arguments['isEdit'] as bool? ?? false;

      if (isEdit.value && id != null && id.isNotEmpty) {
        await fetchLead(id);
        if (details.isNotEmpty) {
          populateForm();
        }
      }
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    leadOwnerController.dispose();
    leadNameController.dispose();
    leadMobileController.dispose();
    leadEmailController.dispose();
    leadAddressController.dispose();
    leadComapnyController.dispose();
    leadDealSizeController.dispose();
    leadDescriptionontroller.dispose();
    leadSourceController.dispose();
    leadAssignToController.dispose();
    leadIndustryController.dispose();
    showLeadSourceController.dispose();
    showLeadOwnerController.dispose();
    showLeadAssignToController.dispose();
    showLeadIndustryController.dispose();
    super.onClose();
  }
}
