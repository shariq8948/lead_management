// ignore_for_file: unnecessary_cast

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/api/api_client.dart';
import '../../data/models/dropdown_list.model.dart';
import '../../data/models/login_response.model.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/tags.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/custom_snckbar.dart';


class LoginController extends GetxController {
  // TextControllers
  final TextEditingController domainController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  // Form Key
  final loginFormKey = GlobalKey<FormState>();

  // Api Client
  final ApiClient apiClient = Get.find<ApiClient>();

  // Get Storage
  final GetStorage box = Get.find<GetStorage>(tag: StorageTags.tag);

  // Domains List
  RxList<DomainListModel> domains = <DomainListModel>[].obs;
  Rx<CustomSelectItem?> selectedDomain = (null as CustomSelectItem?).obs;

  RxBool loading = false.obs;
  RxBool showPass = false.obs;

  Future<List<DomainListModel>?> fetchDomains(String filter) async {
    try {
      // domains.clear();

      Dio dio = Dio();
      String reqUrl = "https://crm.psmsofttech.com/api/getdomain/job";
      var query = {'filter': filter};
      var response = await dio.get(
        reqUrl,
        queryParameters: query,
      );
      if (response.statusCode != 200) {
        CustomSnack.show(
          content: "Something went wrong, please try again!",
          snackType: SnackType.error,
          behavior: SnackBarBehavior.floating,
        );
        return null;
      }

      if (response.data.runtimeType == List) {
        List<DomainListModel> arr = [];
        for (var cate in response.data) {
          arr.add(DomainListModel.fromJson(cate));
        }
        return arr;
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  login() async {
    try {
      if (loginFormKey.currentState!.validate() &&
          selectedDomain.value != null) {
        loading.value = true;
        String domainText = selectedDomain.value?.id ?? "";
        String rawDomainText = selectedDomain.value?.id ?? "";
        String emailText = emailController.text.toString();
        String passwordText = passwordController.text.toString();

        domainText = "${domainText}api";

        box.write(StorageTags.baseUrl, domainText);
        apiClient.updateBaseUrl(domainText);



        var loginBody = {
          "Login": emailText,
          "Password": passwordText,
        };

        // print(loginBody);

        // Do Login
        LoginResponse response = await apiClient.loginRequest(
          ApiEndpoints.login,
          loginBody,
        );
        // print(response.name);
        // print(response.userType);
        loading.value = false;
        if (response.message == null) {
          final loginRespString = jsonEncode(response.toJson());
          box.write(StorageTags.userDetails, loginRespString);
          box.write(StorageTags.baseUrlRaw, rawDomainText);
          box.write(
            StorageTags.baseComp,
            jsonEncode(
              {
                "id": selectedDomain.value?.id,
                "value": selectedDomain.value?.value
              },
            ),
          );
          box.write(StorageTags.loggedIn, "yes");
          // await _addOrUpdateUserInFirestore(emailText, fcm);

          Get.offAllNamed("/main");



          CustomSnack.show(
            content: "Logged in successfully!",
            snackType: SnackType.success,
          );
          return;
        } else {
          // Show error
          CustomSnack.show(
            content: response.message ?? "",
            snackType: SnackType.error,
            behavior: SnackBarBehavior.floating,
          );
          return;
        }
      }
    } catch (e) {
      loading.value = false;
    }
  }



  @override
  void onInit() {
    // fetchDomains();
    super.onInit();
  }

  @override
  void onReady() {
    String jsonString = box.read(StorageTags.baseComp) ?? "";
    if (jsonString.isNotEmpty) {
      var jsonDat = jsonDecode(jsonString);
      selectedDomain.value = CustomSelectItem(
        id: jsonDat['id'],
        value: jsonDat['value'],
      );
      domainController.text = jsonDat['value'];
    }
    super.onReady();
  }
}
