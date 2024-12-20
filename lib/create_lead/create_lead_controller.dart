import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/api/api_client.dart';
import '../data/models/dropdown_list.model.dart';
import '../utils/api_endpoints.dart';

class CreateLeadController extends GetxController{
  final leadOwnerController=TextEditingController();
  final leadNameController=TextEditingController();
  final leadMobileController=TextEditingController();
  final leadEmailController=TextEditingController();
  final leadAddressController=TextEditingController();
  final leadComapnyController=TextEditingController();
  final leadDealSizeController=TextEditingController();
  final leadDescriptionontroller=TextEditingController();
  final leadSourceController=TextEditingController();
  final leadAssignToController=TextEditingController();
  final leadIndustryController=TextEditingController();
  final showLeadSourceController=TextEditingController();
  final showLeadOwnerController=TextEditingController();
  final showLeadAssignToController=TextEditingController();
  final showLeadIndustryController=TextEditingController();
  var isLoading = false.obs;
  final box = GetStorage();
  RxList<LeadSourceDropdownList> leadSource = <LeadSourceDropdownList>[].obs;
  RxList<ownerDropdownList> leadOwner = <ownerDropdownList>[].obs;
  RxList<ownerDropdownList> leadAssignToList = <ownerDropdownList>[].obs;
  RxList<IndustryListDropdown> industryList = <IndustryListDropdown>[].obs;

  void fetchLeadSource() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getLeadSource(box.read("userId"), ApiEndpoints.leadSource),
      dataList: leadSource,
      isFetchingState: isLoading,
    );
  }
  void fetchLeadOwner() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getLeadOwner(box.read("userId"), ApiEndpoints.userRoles),
      dataList: leadOwner,
      isFetchingState: isLoading,
    );
  }
  void fetchLeadAssignTo() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getLeadOwner(box.read("userId"), ApiEndpoints.userRoles),
      dataList: leadAssignToList,
      isFetchingState: isLoading,
    );
  }
  void fetchLeadIndustry() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getIndustry(box.read("userId"), ApiEndpoints.industryList),
      dataList: industryList,
      isFetchingState: isLoading,
    );
  }
  void save()async{
    await ApiClient().postLeadData(endPoint: ApiEndpoints.saveLead,
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
        industry: leadIndustryController.text
    );
  }
  Future<void> _fetchData({
    required Future<List<dynamic>> Function() apiCall,
    required RxList<dynamic> dataList,
    required RxBool isFetchingState,
  }) async
  {
    try {
      isFetchingState.value = true;
      final data = await apiCall();
      if (data.isNotEmpty) {
        dataList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isFetchingState.value = false;
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    fetchLeadSource();
    fetchLeadAssignTo();
    fetchLeadIndustry();
    fetchLeadOwner();
    super.onInit();
  }
}