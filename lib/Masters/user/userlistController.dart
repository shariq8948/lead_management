import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/user_details.dart';
import 'package:leads/widgets/custom_snckbar.dart';

import '../../data/api/api_client.dart';
import '../../data/models/dropdown_list.model.dart';
import '../../data/models/users.dart';
import '../../utils/api_endpoints.dart';
import '../../widgets/custom_select.dart';

class UserListController extends GetxController {
  final formKey = GlobalKey<FormState>(); // Form key for validation
  RxBool isEdit = false.obs;
  final box = GetStorage();
  var isLoading = false.obs;
  var isLoading2 = false.obs;
  TextEditingController cityController = TextEditingController();
  TextEditingController showCityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController showStateController = TextEditingController();
  RxInt isActive = 0.obs;
  final titleController = TextEditingController();
  final idController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final joiningDateController = TextEditingController();
  final userTypeController = TextEditingController();
  final showuserTypeController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final companyController = TextEditingController();
  final showcompanyController = TextEditingController();
  final branchController = TextEditingController();
  final showbranchController = TextEditingController();
  final addressController = TextEditingController();
  void clearForm() {
    titleController.clear();
    firstnameController.clear();
    lastnameController.clear();
    mobileController.clear();
    emailController.clear();
    dobController.clear();
    joiningDateController.clear();
    userTypeController.clear();
    showuserTypeController.clear();
    loginController.clear();
    passwordController.clear();
    companyController.clear();
    showcompanyController.clear();
    branchController.clear();
    showbranchController.clear();
    addressController.clear();
    cityController.clear();
    showCityController.clear();
    stateController.clear();
    showStateController.clear();
    image = "".obs;
  }

  RxString image = "".obs;
  RxList<StateListDropdown> stateList = <StateListDropdown>[].obs;
  RxList<cityListDropDown> cityList = <cityListDropDown>[].obs;
  RxList<UserType> usertypeList = <UserType>[].obs;
  RxList<Branch> branchList = <Branch>[].obs;
  RxList<User> userList = <User>[].obs;
  RxList<UserDetailsModel> userDetail = <UserDetailsModel>[].obs;
  RxList<Company> companyList = <Company>[].obs;
  @override
  void onInit() async {
    super.onInit();
    await fetchUsers();
    searchUsers('');
    fetchState();
    fetchBranch();
    fetchuserType();
    fetchCompany();
  }

  Future<void> _fetchData({
    required Future<List<dynamic>> Function() apiCall,
    required RxList<dynamic> dataList,
    required RxBool isFetchingState,
  }) async {
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

  void fetchState() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getStateList(box.read("userId"), ApiEndpoints.stateList),
      dataList: stateList,
      isFetchingState: isLoading,
    );
  }

  Future<void> addUser() async {
    try {
      isLoading.value = true; // Start loading

      final response = await ApiClient().saveUser(
        endPoint: ApiEndpoints.adduser,
        title: titleController.text,
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        mobile: mobileController.text,
        state: stateController.text,
        city: cityController.text,
        address: addressController.text,
        dob: dobController.text,
        joining: joiningDateController.text,
        login: loginController.text,
        password: passwordController.text,
        userType: userTypeController.text,
        branch: branchController.text,
        comapny: companyController.text,
        image: image.toString(),
        isactive: isActive.value,
      );

      if (response.isSuccess) {
        print("User added successfully.");
        await fetchUsers();
        Get.back();
        clearForm();
        CustomSnack.show(
            content: "${response.message}",
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
      } else {
        print(response.message);
        print(response.isSuccess);
        print(response.status);
        print("not added");
        CustomSnack.show(
            content: "${response.message}",
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      }
    } catch (e) {
      print("An error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  final RxList filteredUsers = [].obs;

  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = userList;
      return;
    }

    filteredUsers.value = userList
        .where((user) =>
            user.username.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.login.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void filterByRole(String role) {
    if (role == 'all') {
      filteredUsers.value = userList;
      return;
    }

    filteredUsers.value = userList.where((user) => user.login == role).toList();
  }

  Future<void> editUser() async {
    print("edit users function running");
    try {
      isLoading.value = true; // Start loading

      final response = await ApiClient().updateUser(
        endPoint: ApiEndpoints.edituser,
        title: titleController.text,
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        mobile: mobileController.text,
        state: stateController.text,
        city: cityController.text,
        address: addressController.text,
        dob: dobController.text,
        joining: joiningDateController.text,
        login: loginController.text,
        password: passwordController.text,
        userType: userTypeController.text,
        branch: branchController.text,
        comapny: companyController.text,
        image: image.toString(),
        isactive: isActive.value,
        id: idController.text,
      );
      print("User added successfully.");
      await fetchUserDetails(idController.text);
      Get.back();
      await fetchUsers();

      clearForm();
    } catch (e) {
      print("An error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  void fetchuserType() async {
    await _fetchData(
      apiCall: () async =>
          await ApiClient().getUserType(ApiEndpoints.UserTypes),
      dataList: usertypeList,
      isFetchingState: isLoading,
    );
  }

  void fetchBranch() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getBranch(ApiEndpoints.franchise),
      dataList: branchList,
      isFetchingState: isLoading,
    );
  }

  fetchUsers() async {
    await _fetchData(
      apiCall: () async => await ApiClient().getUserList(ApiEndpoints.userList),
      dataList: userList,
      isFetchingState: isLoading,
    );
  }

  fetchUserDetails(String id) async {
    await _fetchData(
      apiCall: () async =>
          await ApiClient().getUserDetails(ApiEndpoints.userDetails, id),
      dataList: userDetail,
      isFetchingState: isLoading2,
    );
  }

  void fetchCompany() async {
    await _fetchData(
      apiCall: () async =>
          await ApiClient().getCompanyList(ApiEndpoints.company),
      dataList: companyList,
      isFetchingState: isLoading,
    );
  }

  Future<void> fetchCity() async {
    await _fetchData(
      apiCall: () async => await ApiClient()
          .getCityList(ApiEndpoints.cityList, stateController.text),
      dataList: cityList,
      isFetchingState: isLoading,
    );
  }

  var titles = ["Ms", "To", "Mr.", "Mrs.", "Ms.", "Dr.", "Prof.", "Rev."];
  List<CustomSelectItem> get titleItems {
    return List<CustomSelectItem>.generate(
      titles.length,
      (index) => CustomSelectItem(id: index.toString(), value: titles[index]),
    );
  }
}
