import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as g;
import 'package:leads/data/models/QuotationFollowUpModel.dart';
import 'package:leads/data/models/category_details.dart';
import 'package:leads/data/models/contact_count.dart';
import 'package:leads/data/models/customer_model.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/data/models/leadDetails.dart';
import 'package:leads/data/models/lead_list.dart';
import 'package:leads/data/models/lead_task_model.dart';
import 'package:leads/data/models/main_category_model.dart';
import 'package:leads/data/models/payment_type.dart';
import 'package:leads/data/models/produc_detail_model.dart';
import 'package:leads/data/models/product.dart';
import 'package:leads/data/models/task_activity_model.dart';
import 'package:leads/data/models/task_details.dart';
import 'package:leads/data/models/user_details.dart';
import 'package:leads/data/models/users.dart';
import 'package:leads/orderslist/controller.dart';
import '../../utils/tags.dart';
import '../models/apiResponse.dart';
import '../models/categorymodel.dart';
import '../models/dashboard_count.dart';
import '../models/graph-model.dart';
import '../models/lead_acivity_list.dart';
import '../models/login_response.model.dart';
import '../models/monthly_target.dart';
import '../models/payement_model.dart';
import '../models/responseModel.dart';
import '../models/taskActivity.dart';
import '../models/task_list.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;

class ApiClient extends GetConnect implements GetxService {
  final Dio dio = Dio();
  final GetStorage box = GetStorage();
  @override
  String? baseUrl;

  ApiClient() {
    baseUrl = box.read(StorageTags.baseUrl); // Load base URL
    _configureDio(baseUrl ?? "");
  }

  void _configureDio(String url) {
    dio.options.baseUrl = url;
    dio.options.headers = {
      "Content-Type": "application/json; charset=UTF-8",
    };
  }

  Map<String, dynamic> get _defaultParams {
    final user = box.read(StorageTags.userDetails);
    return {
      'SysCompanyId': box.read(StorageTags.sysComapnyId),
      'SysBranchId': box.read(StorageTags.sysBranchid),
      'UserId': box.read(StorageTags.userId),
    }..removeWhere((key, value) => value == null);
  }

  // Helper method to merge query parameters
  Map<String, dynamic> _mergeQueryParams(
    Map<String, dynamic>? queryParams, {
    bool includeDefaults = false,
    List<String> exclude = const [],
  }) {
    final params = <String, dynamic>{};

    if (includeDefaults) {
      params.addAll(Map.from(_defaultParams)
        ..removeWhere((key, _) => exclude.contains(key)));
    }

    if (queryParams != null) {
      params.addAll(queryParams);
    }

    return params;
  }

  Future<dynamic> getR(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool includeDefaultParams = true,
    List<String> excludeParams = const [],
  }) async {
    try {
      final mergedParams = _mergeQueryParams(
        queryParameters,
        includeDefaults: includeDefaultParams,
        exclude: excludeParams,
      );

      print('Request URL: ${dio.options.baseUrl}$path');
      print('Query Parameters: $mergedParams');

      final response = await dio.get(
        path,
        queryParameters: mergedParams,
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      // _handleDioError(e);
    }
  }

  Future<dynamic> postg(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print(data);
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      print(response);
      return response.data;
    } on DioException catch (e) {
      // _handleDioError(e);
    }
  }

  Future<dynamic> putg(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print(data);
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      print(response);
      return response.data;
    } on DioException catch (e) {
      // _handleDioError(e);
    }
  }

  Future<dynamic> deleteg(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print(data);
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      print(response);
      return response.data;
    } on DioException catch (e) {
      // _handleDioError(e);
    }
  }

  Future<void> updateBaseUrl(String apiUrl) async {
    baseUrl = apiUrl; // Update the nullable baseUrl field
    _configureDio(apiUrl); // Update Dio configuration
    httpClient.baseUrl = apiUrl; // Update GetConnect base URL
    await box.write(StorageTags.baseUrl, apiUrl); // Save to storage
  }

  // Login request
  Future<LoginResponse> loginRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(endpoint, data: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List && data.isNotEmpty) {
          final loginResponse = LoginResponse.fromJson(data[0]);
          if (loginResponse.success == '1') {
            return loginResponse; // Return successful login response
          } else {
            return LoginResponse(
                message: loginResponse.message ?? "Login failed.");
          }
        } else {
          return LoginResponse(message: "Unexpected response format.");
        }
      } else {
        return LoginResponse(
            message: "Login failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      return LoginResponse(message: "Error: $e");
    }
  }

  // Get dashboard count
  Future<List<AllCountList>> getDashboardCount(String endpoint) async {
    try {
      final queryParams = {
        'UserId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'sysbranchid': box.read(StorageTags.sysBranchid),
      };

      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => AllCountList.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskList>> getTaskList({
    required String endPoint,
    required String userId,
    required String recordType,
    required String dataFilterType,
    String? fromDate, // Optional
    String? upToDate, // Optional
  }) async {
    try {
      // Build the query parameters map
      Map<String, dynamic> queryParams = {
        'userid': userId,
        'RecordType': recordType,
        'datafiltertype': dataFilterType,
      };

      // Only add fromDate and upToDate if they are provided
      if (fromDate != null && fromDate.isNotEmpty) {
        queryParams['Fromdate'] = fromDate;
      }
      if (upToDate != null && upToDate.isNotEmpty) {
        queryParams['Uptodate'] = upToDate;
      }

      final response = await dio.get(
        endPoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to TaskList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => TaskList.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load task list");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<LeadList>> getLeadList({
    required String endPoint,
    required String userId,
    required String datatype,
    required String tokenid,
    required String IsPagination,
    required String PageSize,
    required String Pagenumber,
    String? fromDate,
    String? toDate,
    String? state,
    String? product,
    String? lead,
    String? stateId,
    String? cityId,
    String? areaId,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      // Prepare the queryParams with conditionally added values
      final Map<String, dynamic> effectiveParams = {
        ...queryParams,
        'userId': userId,
        'custid': '0',
        'datatype': datatype,
        'tokenid': tokenid,
        'IsPagination': IsPagination,
        'PageSize': PageSize,
        'Pagenumber': Pagenumber,
      };

      // Conditionally add parameters only if they are not null or empty
      if (state != null && state.isNotEmpty) {
        effectiveParams['StateID'] = state;
      }
      if (cityId != null && cityId.isNotEmpty) {
        effectiveParams['CityID'] = cityId;
      }
      if (areaId != null && areaId.isNotEmpty) {
        effectiveParams['AreaID'] = areaId;
      }

      if (product != null && product.isNotEmpty) {
        effectiveParams['product'] = product;
      }
      if (lead != null && lead.isNotEmpty) {
        effectiveParams['LeadSourceId'] = lead;
      }
      if (fromDate != null && fromDate.isNotEmpty) {
        effectiveParams['fromDate'] = fromDate;
      }
      if (toDate != null && toDate.isNotEmpty) {
        effectiveParams['toDate'] = toDate;
      }

      // Make the GET request with the updated query parameters
      final response = await dio.get(
        endPoint,
        queryParameters: effectiveParams,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['data1'] ?? [];
        return responseData.map((data) => LeadList.fromJson(data)).toList();
      } else {
        throw Exception(
            "Failed to load lead list. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return []; // Return an empty list in case of error
    } catch (e) {
      return []; // Return an empty list in case of any other error
    }
  }

  Future<List<LeadList>> getAssignedLeadList({
    required String endPoint,
    required String userId,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        ...queryParams,
        'userId': userId,
      };

      final response = await dio.get(
        endPoint,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data ?? [];
        return responseData.map((data) => LeadList.fromJson(data)).toList();
      } else {
        throw Exception(
            "Failed to load lead list. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return []; // Return an empty list in case of error
    } catch (e) {
      return []; // Return an empty list in case of any other error
    }
  }

  Future<Taskactivity> taskActivity(
      String endpoint, List<Map<String, dynamic>> body) async {
    try {
      final response = await dio.post(endpoint,
          data: jsonEncode(body), queryParameters: {"Type": "US"});

      if (response.statusCode == 200) {
        final data = response.data;
        return Taskactivity(success: true, message: "Success");
      } else {
        return Taskactivity(
            message: "Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      return Taskactivity(message: "Error: $e");
    }
  }

  Future<ApiResponse<void>> updateTaskStatusActivity(
      String endpoint, String taskId, String status) async {
    // Creating the request body and query parameters
    var body = [
      {
        "Taskid": taskId,
        "ACTIVITYSTATUS": status,
        "UserID": box.read("userId"),
      }
    ];
    var params = {"Type": "US"};

    try {
      // Sending the POST request
      final response = await dio.post(
        endpoint,
        data: jsonEncode(body),
        queryParameters: params,
      );

      // Handling the response
      if (response.statusCode == 200) {
        final data = response.data;

        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          status: "0",
          message: "Request failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponse(
        status: "0",
        message: "An error occurred: $e",
      );
    }
  }

  Future<ApiResponse<void>> addTaskComment(
      String endpoint, String taskId, String desc) async {
    // Creating the request body and query parameters
    var body = [
      {
        "Taskid": taskId,
        "Description": desc,
        "UserID": box.read("userId"),
      }
    ];
    var params = {"Type": "ACOM"};

    try {
      final response = await dio.post(
        endpoint,
        data: jsonEncode(body),
        queryParameters: params,
      );

      // Handling the response
      if (response.statusCode == 200) {
        final data = response.data;
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          status: "0",
          message: "Request failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponse(
        status: "0",
        message: "An error occurred: $e",
      );
    }
  }

  Future<ApiResponse<void>> addLeadComment(
      String endpoint, String leadId, String desc) async {
    if (leadId.isEmpty || desc.isEmpty) {
      return ApiResponse(
        status: "0",
        message: "Lead ID and description cannot be empty",
      );
    }

    final userId = box.read(StorageTags.userId);
    if (userId == null) {
      return ApiResponse(
        status: "0",
        message: "User ID not found",
      );
    }

    var body = {
      "LeadId": leadId,
      "description": desc,
      "entrytype": "Comment",
      "UserID": userId
    };

    try {
      final response = await dio.post(
        endpoint,
        data: body,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          status: "0",
          message: "Request failed with status code: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      return ApiResponse(
        status: "0",
        message: "Network error: ${e.message}",
      );
    } catch (e) {
      return ApiResponse(
        status: "0",
        message: "An error occurred: $e",
      );
    }
  }

  Future<List<FunnelGraph>> getFunnelGraph(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Year': 2024,
          'Month': 03,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        return responseData.map((data) => FunnelGraph.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<DealData>> getPieGraph(String userId, int year) async {
    try {
      final response = await dio.get(
        'https://lead.mumbaicrm.com/api/PresalesMobile/GetMonthlyLeadClosingAmount',
        queryParameters: {
          'UserId': userId,
          'Year': year,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        return responseData.map((data) => DealData.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<LeadSourceDropdownList>> getLeadSource(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => LeadSourceDropdownList.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ownerDropdownList>> getLeadOwner(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => ownerDropdownList.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<IndustryListDropdown>> getIndustry(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => IndustryListDropdown.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<StateListDropdown>> getStateList(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => StateListDropdown.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductListDropDown>> getProductList(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => ProductListDropDown.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<cityListDropDown>> getCityList(
      String endPoint, String stateId) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'StateId': stateId, // Replace with the actual city ID
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => cityListDropDown.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<areaListDropDown>> getAreaList(
      String endPoint, String cityId) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'CityId': cityId, // Replace with the actual city ID
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => areaListDropDown.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CustomerResponseModel>> getCustomerList({
    required String endPoint,
    required String userId,
    required String isPagination,
    required String pageSize,
    required String pageNumber,
    required String q,
  }) async {
    try {
      final response = await dio.post(
        endPoint,
        queryParameters: {
          'userId': userId,
          'IsPagination': isPagination,
          'PageSize': pageSize,
          'Pagenumber': pageNumber,
          'filter': q,
        },
      );

      if (response.statusCode == 200) {
        // Ensure we handle response data properly
        final Map<String, dynamic> responseData =
            response.data is String ? jsonDecode(response.data) : response.data;

        // Check if 'data' exists and is a list
        if (responseData['data'] != null && responseData['data'] is List) {
          return responseData['data']
              .map<CustomerResponseModel>(
                  (item) => CustomerResponseModel.fromJson(item))
              .toList();
        } else {
          throw Exception(
              "Unexpected response structure: 'data' is not a list.");
        }
      } else {
        throw Exception(
            "Failed to load customer list. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<QuotationFollowUpModel>> getQuotationList({
    required String endPoint,
    required String userId,
    required String isPagination,
    required String pageSize,
    required String pageNumber,
  }) async {
    try {
      final response = await dio.post(
        endPoint,
        queryParameters: {
          'userId': userId,
          'IsPagination': isPagination,
          'PageSize': pageSize,
          'Pagenumber': pageNumber,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Ensure we handle response data properly
        final Map<String, dynamic> responseData =
            response.data is String ? jsonDecode(response.data) : response.data;

        // Check if 'data' exists and is a list
        if (responseData['data'] != null && responseData['data'] is List) {
          return responseData['data']
              .map<QuotationFollowUpModel>(
                  (item) => QuotationFollowUpModel.fromJson(item))
              .toList();
        } else {
          throw Exception(
              "Unexpected response structure: 'data' is not a list.");
        }
      } else {
        throw Exception(
            "Failed to load customer list. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Products1>> getAllProductList({
    required String endPoint,
    required String userId,
    required String isPagination,
    required String pageSize,
    required String pageNumber,
  }) async {
    try {
      final response = await dio.post(
        endPoint,
        queryParameters: {
          'userId': userId,
          'IsPagination': isPagination,
          'PageSize': pageSize,
          'Pagenumber': pageNumber,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          // 'Syscompanyid': "1012",
          // 'Sysbranchid': "1015",
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        print("called api0");
        // Parse the response data
        final responseData = response.data is String
            ? jsonDecode(response.data) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;

        // Ensure 'data' exists and is a list
        if (responseData['data'] != null && responseData['data'] is List) {
          print(responseData["data"]);
          return (responseData['data'] as List<dynamic>)
              .map<Products1>((item) => Products1.fromJson(item))
              .toList();
        } else {
          return []; // Return an empty list for invalid or missing 'data'
        }
      } else {
        throw Exception(
            "Failed to load product list. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      return []; // Return an empty list in case of error
    }
  }

  Future<ApiResponse<void>> postCustomerData({
    required String endPoint,
    required String userId,
    required String title,
    required String name,
    required String adD1,
    required String state,
    required String cityID,
    required String areaID,
    required String custType,
    required String registationType,
    required String partyType,
    required String mobile,
    required String email,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': userId,
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'ctitle': title,
        'ledgerid': "0",
        'name': name,
        'Displayname': "",
        'adD1': adD1,
        'adD2': "",
        "add3": "",
        "fax": "27",
        "stateID": state,
        "cityID": cityID,
        "areaID": areaID,
        "mobile": mobile,
        "whatsapp": "",
        "website": "",
        "phone": "",
        "email": email,
        "custType": custType,
        "pin": "",
        "cdays": "",
        "cLimit": "",
        "smanId": "0",
        "discount": "",
        "registationType": registationType,
        "partyType": partyType,
        "vatNo": "",
        "gstno": "",
        "othertax": "",
        "contact": "",
        "transportId": "0",
        "status": "Rate1",
        "remarK1": "",
        "remarK2": "",
        "remarK3": "",
        "remarK4": "",
        "bankId": "0",
        "ccemail": "",
        "dob": "",
        "doa": "",
        "autocode": "1",
        "active": "0",
        "cstNo": "",
        "adhno": "",
        "currencyName": "Rs",
        "currencySign": "",
        "Tcsrate": "",
        "freight": "",
        "vendorcode": "",
        "CreatedBy": userId,
        "isprospect": 0,
        "code": "",
      };

      // Make the POST request
      final response = await dio.post(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      }
      return ApiResponse(
        status: '0',
        message: 'Failed to Add customer. Please try again.',
      );
    } on DioException catch (dioError) {
      return ApiResponse(
        status: '0',
        message: dioError.response?.data ??
            'An error occurred while updating customer.',
        error: dioError.toString(),
      );
    } catch (e) {
      return ApiResponse(
        status: '0',
        message: 'Unexpected error occurred.',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> updateCustomerData({
    required String endPoint,
    required String Id,
    required String userId,
    required String title,
    required String name,
    required String adD1,
    required String state,
    required String cityID,
    required String areaID,
    required String custType,
    required String registationType,
    required String partyType,
    required String mobile,
    required String mail,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': userId,
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        'ctitle': title,
        'Id': Id,
        'name': name,
        'Displayname': "",
        'ledgerid': "2222",
        'adD1': adD1,
        'adD2': "",
        "add3": "",
        "fax": "27",
        "stateID": state,
        "cityID": cityID,
        "areaID": areaID,
        "mobile": mobile,
        "whatsapp": "",
        "website": "",
        "phone": "",
        "email": mail,
        "custType": custType,
        "pin": "",
        "cdays": "",
        "cLimit": "",
        "smanId": "0",
        "discount": "",
        "registationType": registationType,
        "partyType": partyType,
        "vatNo": "",
        "gstno": "",
        "othertax": "",
        "contact": "",
        "transportId": "0",
        "status": "Rate1",
        "remarK1": "",
        "remarK2": "",
        "remarK3": "",
        "remarK4": "",
        "bankId": "0",
        "ccemail": "",
        "dob": "",
        "doa": "",
        "autocode": "1",
        "active": "0",
        "cstNo": "",
        "adhno": "",
        "currencyName": "Rs",
        "currencySign": "",
        "Tcsrate": "",
        "freight": "",
        "vendorcode": "",
        "CreatedBy": userId,
        "isprospect": 0,
        "code": "",
      };

      final response = await dio.put(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
          response.data,
        );
      }

      return ApiResponse(
        status: '0',
        message: 'Failed to update customer. Please try again.',
      );
    } on DioException catch (dioError) {
      return ApiResponse(
        status: '0',
        message: dioError.response?.data ??
            'An error occurred while updating customer.',
        error: dioError.toString(),
      );
    } catch (e) {
      return ApiResponse(
        status: '0',
        message: 'Unexpected error occurred.',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> deleteCustomerData({
    required String endPoint,
    required String Id,
    required String userId,
  }) async {
    try {
      print("${box.read(StorageTags.baseUrl)}${endPoint}");
      // Prepare the request parameters
      final Map<String, dynamic> effectiveParams = {
        'userId': userId,
        'Id': Id,
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysBranchid),
      };

      print('Deleting customer data with params: $effectiveParams');
      print(
          "${box.read(StorageTags.baseUrl)}${endPoint}?Id=$Id&UserId=${userId}&Syscompanyid=${box.read(StorageTags.sysComapnyId)}&Sysbranchid=${box.read(StorageTags.sysComapnyId)}");
      final response = await dio.post(
        "${box.read(StorageTags.baseUrl)}${endPoint}?Id=$Id&UserId=${userId}&Syscompanyid=${box.read(StorageTags.sysComapnyId)}&Sysbranchid=${box.read(StorageTags.sysComapnyId)}",
        // data: effectiveParams, // Send data in the body of the POST request
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data); // Indicate success
      } else {
        return ApiResponse(
            status: "0",
            message: "Failed to delete customer"); // Indicate failure
      }
    } on DioException catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        return ApiResponse(
            status: "0",
            message: dioError.response?.data.toString() ?? dioError.message!);
      } else {
        return ApiResponse(
            status: "0", message: dioError.message ?? "Unknown error occurred");
      }
    } catch (e) {
      return ApiResponse(
          status: "0", message: e.toString()); // Indicate failure
    }
  }

  Future<List<TaskDetail>> getTaskDetails(
      String endPoint, String userId, String taskId) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId, // Replace with the actual city ID
          'id': taskId, // Replace with the actual city ID
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => TaskDetail.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load task");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskActivityModel>> getTaskActivity(
      String endPoint, String TaskId, String userId) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'TaskId': TaskId,
          'UserId': userId,
          'stype': '',
          // Replace with the actual city ID
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => TaskActivityModel.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<ApiResponse<void>> updateLeadData({
    required String endPoint,
    required String userId,
    required String leadId,
    required String AssignTo,
    required String company,
    required String dealSize,
    required String name,
    required String mobileNumber,
    required String productId,
    required String address,
    required String Description,
    required String email,
    required String source,
    required String owner,
    required String industry,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "leadId": leadId,
        "ownerid": userId,
        "company": company,
        "Leadname": name,
        "address": "",
        "email": email,
        "mobile": mobileNumber,
        "phone": mobileNumber,
        "state": "0",
        "city": "0",
        "area": "0",
        "pincode": "",
        "leadsource": source,
        "leadpriorityid": "1",
        "industrytype": industry,
        "noofemployee": "",
        "annualrevenue": "",
        "rating": "",
        "emailoptout": "",
        "skypeid": "",
        "twitter": "",
        "secondemail": "",
        "expecteddate": "",
        "Budget": "",
        "description": Description,
        "UserID": userId,
        "Assigntoid": "4",
        "Productid": "",
        "Product": "",
        "DealSize": dealSize
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        try {
          return ApiResponse.fromJson(response.data);
        } catch (e) {
          return ApiResponse(status: "0", message: "Invalid response format");
        }
      } else {
        return ApiResponse(
            status: "0",
            message: "Server returned status code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        return ApiResponse(status: "0", message: dioError.toString());
      }
      return ApiResponse(status: "0", message: "Network error occurred");
    } catch (e) {
      return ApiResponse(status: "0", message: e.toString());
    }
  }

  Future<ApiResponse<void>> postLeadData({
    required String endPoint,
    required String userId,
    required String AssignTo,
    required String company,
    required String dealSize,
    required String name,
    required String mobileNumber,
    required String productId,
    required String address,
    required String Description,
    required String email,
    required String source,
    required String owner,
    required String industry,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "Assigntoid": AssignTo,
        "Budget": "",
        "CNAME": '',
        "Customerid": "",
        "DealSize": dealSize,
        "Leadname": name,
        "ProductId": productId,
        "UserID": userId,
        "address": address,
        "annualrevenue": "",
        "area": "",
        "city": "",
        "company": company,
        "description": Description,
        "email": email,
        "emailoptout": "",
        "expecteddate": DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String()
            .split('T')[0],
        "industrytype": industry,
        "leadpriorityid": "1",
        "leadsource": source,
        "mobile": mobileNumber,
        "noofemployee": "",
        "ownerid": owner,
        "phone": mobileNumber,
        "pincode": "",
        "rating": "",
        "secondemail": "",
        "skypeid": "",
        "state": "",
        "twitter": "",
        "Product": ""
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        return ApiResponse(
          status: "0",
          message: "Server error: ${response.statusCode}",
        );
      }
    } on DioException catch (dioError) {
      String errorMessage = "Network error occurred";
      if (dioError.response != null) {
        errorMessage = "Server error: ${dioError.response?.statusCode}";
      }
      return ApiResponse(
        status: "0",
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse(
        status: "0",
        message: "An unexpected error occurred",
      );
    }
  }

  Future<List<LeadResponse>> getLeadDeails(
      String endPoint, String userId, String leadId) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId, // Replace with the actual city ID
          'LeadId': leadId, // Replace with the actual city ID
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => LeadResponse.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load task");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<LeadActivityListModel>> getLeadActivity(
      String endPoint, String userId, String leadId) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'leadid': leadId,
          'Syscompanyid': box.read("sysComapnyId"),
          "Sysbranchid": box.read("sysBranchId"),
          'UserId': box.read("userId"),
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => LeadActivityListModel.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load task");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<LeadTaskList>> getLeadTask(
      String endPoint, String userId, String leadId) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'leadid': leadId,
          'RecordType': "TaskList",
          'UserId': box.read("userId"),
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => LeadTaskList.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load task");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CustomerDetail>> getCustomerDetails(
      String endPoint, String userId, String id) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId, // Replace with the actual city ID
          'Id': id,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => CustomerDetail.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load task");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoryList>> getcategoryList(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => CategoryList.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<MainCategoryModel>> getMainCategory(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => MainCategoryModel.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> addCategory({
    required String endPoint,
    required String mainCategory,
    required String subcategory,
    required String icon,
    required String bannerimg,
    required String desc,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        "code": "",
        "name": subcategory,
        "ucategoryId": mainCategory,
        "description": desc,
        "iconimg": icon,
        "bannerimg": bannerimg,
        "categoryforapp": "0",
        "CreatedBy": box.read("userId")
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<bool> addState({
    required String endPoint,
    required String stateCode,
    required String state,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "Statecode": stateCode,
        "State": state,
        "userid": box.read("userId"),
        "id": "0"
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<bool> addArea({
    required String endPoint,
    required String stateCode,
    required String city,
    required String area,
    String? pin,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "state": stateCode,
        "city": city,
        "name": area,
        "locality": "",
        "pincode": pin ?? "0",
        "userid": box.read("userId"),
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<bool> addCity({
    required String endPoint,
    required String stateCode,
    required String city,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "State": stateCode,
        "City": city,
        "id": "0",
        "userid": box.read("userId"),
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        print(response.data);
        print(requestBody);
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<bool> updateCategory({
    required String endPoint,
    required String code,
    required String mainCategory,
    required String category,
    required String id,
    required String icon,
    required String bannerimg,
    required String desc,
  }) async {
    try {
      print("bann img encodeing ${bannerimg}");
      print("icon img encodeing ${icon}");
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };
      final Map<String, dynamic> requestBody = {
        "Id": id,
        "code": code,
        "name": category,
        "ucategoryId": mainCategory,
        "description": desc,
        "iconimg": icon,
        "bannerimg": bannerimg,
        "categoryforapp": "0",
        "modifiedBy": box.read("userId"),
        "iconimgname": "",
        "bannerimgname": ""
      };

      final response = await dio.put(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<ResponseModel> deleteCategory({
    required String endPoint,
    required String id,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
        'Id': id,
      };

      final response = await dio.delete(
        endPoint,
        queryParameters: effectiveParams,
      );

      // Assuming the response body is a string and contains the result message
      if (response.statusCode == 200) {
        return ResponseModel.fromResponse(response.data.toString());
      } else {
        throw Exception(
            "Failed to delete category. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return ResponseModel(
          success: false, message: 'An error occurred: ${dioError.message}');
    } catch (e) {
      return ResponseModel(success: false, message: 'An error occurred: $e');
    }
  }

  Future<List<ProductDetailModel>> getProductDetail(
      String endPoint, String id) async {
    try {
      // Logging request details for debugging

      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Id': id,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        print(response);
        // Validate if response data is a list
        if (response.data is List) {
          return (response.data as List<dynamic>)
              .map((data) => ProductDetailModel.fromJson(data))
              .toList();
        } else {
          throw Exception("Unexpected response format: ${response.data}");
        }
      } else {
        throw Exception(
            "Failed to fetch product details: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PaymentMode>> getPaymentType(String endPoint) async {
    try {
      // Logging request details for debugging

      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Validate if response data is a list
        if (response.data is List) {
          return (response.data as List<dynamic>)
              .map((data) => PaymentMode.fromJson(data))
              .toList();
        } else {
          throw Exception("Unexpected response format: ${response.data}");
        }
      } else {
        throw Exception(
            "Failed to fetch product details: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoryDetailsModel>> getCategoryDetail(
      String userId, String endPoint, String id) async {
    try {
      // Logging request details for debugging

      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Id': id,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        // Validate if response data is a list
        if (response.data is List) {
          return (response.data as List<dynamic>)
              .map((data) => CategoryDetailsModel.fromJson(data))
              .toList();
        } else {
          throw Exception("Unexpected response format: ${response.data}");
        }
      } else {
        throw Exception(
            "Failed to fetch product details: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<ApiResponse<dynamic>> addProduct({
    required String endPoint,
    required String name,
    required String unitId,
    required String packagingId,
    required String boxSize,
    required String comapnyId,
    required String stax,
    required String ptax,
    required String minQty,
    required String maxQty,
    required String category,
    required String hsn,
    required String size,
    required String property,
    required String remark1,
    required String remark2,
    required String remark3,
    required String remark4,
    required String remark5,
    required String remark6,
    required String minOrder,
    required String maxOrder,
    required String barcode,
    required String mrp,
    required String banner,
    required String icon,
    required String description,
    required String saleRate,
    required String discount,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        "id": 0,
        "iname": name,
        "unitId": unitId,
        "packingId": packagingId,
        "boxsize": boxSize,
        "companyId": comapnyId,
        "staxId": stax,
        "ptaxId": ptax,
        "minqty": minQty,
        "maxqty": maxQty,
        "prate": "",
        "igroupId": category,
        "undergroupid": "",
        "icode": "",
        "rate1": saleRate,
        "netrate": "",
        "rate3": "",
        "rate4": "",
        "rate5": "",
        "rate6": "",
        "rate7": "",
        "rate8": "",
        "rate9": "",
        "rate10": "",
        "rate11": "",
        "rate12": discount,
        "hsnId": hsn,
        "itemdisc": description,
        "itype": "1",
        "ssize": size,
        "imagepath": banner,
        "pwp": "0",
        "appimagepath": icon,
        "selfno": "",
        "mrp": mrp,
        "cprate": "",
        "itemforapp": "1",
        "remark1": remark1,
        "remark2": remark2,
        "remark3": remark3,
        "remark4": remark4,
        "remark5": remark5,
        "remark6": remark6,
        "barcode": barcode,
        "createdby": box.read("userId"),
        "autocode": "1",
        "services": "0",
        "minorderqty": minOrder,
        "maxorderqty": maxOrder,
        "ispackagingmaterial": "0",
        "property": property,
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<dynamic>.fromJson(response.data);
        return apiResponse; // Return the ApiResponse directly
      } else {
        return ApiResponse(
          status: '0',
          message:
              'Failed to save product. Status Code: ${response.statusCode}',
          error: 'HTTP Error',
        );
      }
    } on DioException catch (dioError) {
      return ApiResponse(
        status: '0',
        message: 'DioException occurred',
        error: dioError.response?.data.toString() ?? dioError.message,
      );
    } catch (e) {
      return ApiResponse(
        status: '0',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  Future<bool> deleteProduct({
    required String endPoint,
    required String id,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
        'Id': id,
      };

      final response = await dio.post(
        endPoint,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to delete product. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<ApiResponse<dynamic>> updateProduct({
    required String endPoint,
    required String id,
    required String name,
    required String unitId,
    required String packagingId,
    required String boxSize,
    required String comapnyId,
    required String stax,
    required String ptax,
    required String minQty,
    required String maxQty,
    required String category,
    required String hsn,
    required String size,
    required String property,
    required String remark1,
    required String remark2,
    required String remark3,
    required String remark4,
    required String remark5,
    required String remark6,
    required String minOrder,
    required String maxOrder,
    required String barcode,
    required String mrp,
    required String saleRate,
    required String banner,
    required String discount,
    required String icon,
    required String desc,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        "id": id,
        "iname": name,
        "unitId": unitId,
        "packingId": "",
        "boxsize": boxSize,
        "companyId": comapnyId,
        "staxId": stax,
        "ptaxId": ptax,
        "minqty": minQty,
        "maxqty": maxQty,
        "prate": "",
        "igroupId": category,
        "undergroupid": "",
        "icode": "",
        "rate1": saleRate,
        "netrate": "",
        "rate3": "",
        "rate4": "",
        "rate5": "",
        "rate6": "",
        "rate7": "",
        "rate8": "",
        "rate9": "",
        "rate10": "",
        "rate11": "",
        "rate12": discount,
        "hsnId": hsn,
        "itemdisc": desc,
        "itype": "1",
        "ssize": size,
        "imagepath": icon,
        "pwp": "0",
        "appimagepath": banner,
        "selfno": "",
        "mrp": mrp,
        "cprate": "",
        "itemforapp": "1",
        "remark5": remark5,
        "barcode": barcode,
        "remark1": remark1,
        "remark2": remark2,
        "remark3": remark3,
        "remark4": remark4,
        "createdby": box.read("userId"),
        "autocode": "1",
        "services": "0",
        "minorderqty": minOrder,
        "maxorderqty": maxOrder,
        "ispackagingmaterial": "0",
        "property": property

        //iname, unitid, igroupId, staxId, ptaxId, hsnId, companyId, autocode
      };

      final response = await dio.put(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
            response.data); // Return true if the request was successful
      } else {
        return ApiResponse(
          status: '0',
          message:
              'Failed to save product. Status Code: ${response.statusCode}',
          error: 'HTTP Error',
        );
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return ApiResponse(
        status: '0',
        message: 'DioException occurred',
        error: dioError.response?.data.toString() ?? dioError.message,
      ); // Return false in case of an error
    } catch (e) {
      return ApiResponse(
        status: '0',
        message: 'An unexpected error occurred',
        error: e.toString(),
      ); // Return false if there's a general error
    }
  }

  Future<bool> savePaymentMode({
    required String endPoint,
    required String mode,
    required String type,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        "paymenttype": type,
        "paymentmode": mode,
        "ledgerid": "5290"
        //iname, unitid, igroupId, staxId, ptaxId, hsnId, companyId, autocode
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<bool> updatePaymentMode({
    required String endPoint,
    required String mode,
    required String type,
    required String id,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        "paymenttype": type,
        "paymentmode": mode,
        "ledgerid": "5290",
        "id": id,

        //iname, unitid, igroupId, staxId, ptaxId, hsnId, companyId, autocode
      };

      final response = await dio.put(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<bool> deletePaymentMode({
    required String endPoint,
    required String id,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
        'Id': id,
      };

      final response = await dio.delete(
        endPoint,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return true; // Return true if the request was successful
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return false; // Return false in case of an error
    } catch (e) {
      return false; // Return false if there's a general error
    }
  }

  Future<List<UnitList>> getUnitList(String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => UnitList.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SGST>> getSaleGst(String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => SGST.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<HSN>> getHSN(String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => HSN.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CompanyName>> getComapny(String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => CompanyName.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PurchaseGst>> getPGST(String userId, String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': userId,
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => PurchaseGst.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PaymentModeModel>> getPaymentModeList(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => PaymentModeModel.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Company>> getCompanyList(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => Company.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<UserType>> getUserType(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => UserType.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Branch>> getBranch(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Syscompanyid': box.read(StorageTags.sysComapnyId),
          'Sysbranchid': box.read(StorageTags.sysComapnyId),
          'Id': "4",
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => Branch.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> getUserList(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'tokenid': '20a6aa3b-6b62-4cce-9283-4604275c99ed'
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => User.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<UserDetailsModel>> getUserDetails(
      String endPoint, String id) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Id': id,
        },
      );

      if (response.statusCode == 200) {
        print(response);
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => UserDetailsModel.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<ApiResponse<void>> saveUser({
    required String endPoint,
    required String title,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String state,
    required String city,
    required String address,
    required String dob,
    required String joining,
    required String login,
    required String password,
    required String userType,
    required String branch,
    required String comapny,
    required String image,
    required int isactive,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        "title": title,
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
        "mobile": mobile,
        "mobile2": "",
        "stateID": state,
        "cityID": city,
        "address": address,
        "dob": dob,
        "joiningDate": joining,
        "login": login,
        "password": password,
        "isActive": isactive,
        "isapproved": 1,
        "userType": userType,
        "imagePath": image,
        "userid": box.read("userId"),
        "isDeleted": "0",
        'Syscompanyid': box.read("sysComapnyId"),
        "sysbranchid": box.read("sysBranchId"),
        "usercode": "",
        "UserDepartment": "",
        "createdBy": box.read("userId"),
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
            response.data); // Return the parsed response body
      } else {
        return ApiResponse(status: "0", message: "Dio Exceptions");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return ApiResponse(
          status: "0",
          message: dioError.toString()); // Return an error response format
    } catch (e) {
      return ApiResponse(
          status: "0",
          message: e.toString()); // Return an error response format
    }
  }

  Future<dynamic> updateUser({
    required String endPoint,
    required String id,
    required String title,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String state,
    required String city,
    required String address,
    required String dob,
    required String joining,
    required String login,
    required String password,
    required String userType,
    required String branch,
    required String comapny,
    required String image,
    required int isactive,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };

      final Map<String, dynamic> requestBody = {
        "title": title,
        "Id": id,
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
        "mobile": mobile,
        "mobile2": "",
        "state": state,
        "city": city,
        "address": address,
        "dob": dob,
        "joiningDate": joining,
        "login": login,
        "password": password,
        "isActive": isactive,
        "isapproved": 1,
        "userType": userType,
        "imagePath": image,
        "userid": box.read("userId"),
        "isDeleted": "0",
        'Syscompanyid': box.read("sysComapnyId"),
        "sysbranchid": box.read("sysBranchId"),
        "usercode": "",
        "createdBy": box.read("userId"),
      };

      final response = await dio.put(
        endPoint,
        data: requestBody,
        queryParameters: effectiveParams,
      );

      if (response.statusCode == 200) {
        return response.data; // Return the parsed response body
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return {
        "success": false,
        "message": dioError.response?.data ?? dioError.message,
      }; // Return an error response format
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      }; // Return an error response format
    }
  }

  Future<void> postFollowUp({
    required String endPoint,
    required String quotationId,
    required String followupDate,
    required String conversationWith,
    required String followUpBy,
    required String remark,
    required String followUpStatus,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': box.read("userId"),
        'Syscompanyid': box.read(StorageTags.sysComapnyId),
        'Sysbranchid': box.read(StorageTags.sysComapnyId),
      };
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "quotationId": quotationId,
        "followupDate": followupDate,
        "conversationwith": conversationWith,
        "followupBy": followUpBy,
        "remark": remark,
        "followupstatus": followUpStatus,
        "userid": box.read("userId")
      };

      // Make the POST request with the request body
      final response = await dio.post(endPoint,
          data: requestBody,
          queryParameters:
              effectiveParams // Send data in the body of the request
          );

      // Check if the request was successful
      if (response.statusCode == 200) {
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
    } catch (e) {}
  }

  Future<void> postGeoLocation({
    required String endPoint,
    required String lat,
    required String add,
    required String long,
  }) async {
    try {
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "userId": box.read("userId"),
        "sessionIp": "",
        "geolocation": add,
        "latitude": lat,
        "longitude": long,
        "browser": "chrome"
      };

      // Make the POST request with the request body
      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
      } else {
        throw Exception(
            "Failed to save Geolocation. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
    } catch (e) {}
  }

  Future<List<MonthlyTarget>> getMonthlyTarget(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'tokenid': "5e9cf84a-d824-4caa-96ff-fbf095db3702",
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.data);
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => MonthlyTarget.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CordinatorList>> getCordinatorList(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => CordinatorList.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<MrList>> getMrList(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Syscompanyid': box.read("sysComapnyId"),
          'Sysbranchid': box.read("sysComapnyId"),
        },
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData.map((data) => MrList.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getOrderList(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'Syscompanyid': box.read("sysComapnyId"),
          'Sysbranchid': box.read("sysComapnyId"),
        },
        // queryParameters: {
        //   'UserId': "1033",
        //   'Syscompanyid': "1012",
        //   'Sysbranchid': "1015",
        // },
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Return the raw list from API
          return response.data;
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load order list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('API Error: $e');
      return []; // Return empty list on error
    }
  }

  Future<List<MonthlyTarget>> getTargetDetails(String endPoint) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'tokenid': "5e9cf84a-d824-4caa-96ff-fbf095db3702",
        },
      );

      if (response.statusCode == 200) {
        // Check if the response data is a list before mapping it
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => MonthlyTarget.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> deleteMonthlyTarget({
    required String endPoint,
    required String id,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "deletedby": box.read("userId"),
        "id": id,
      };

      final response = await dio.delete(
        endPoint,
        queryParameters: requestBody,
      );

      if (response.statusCode == 200) {
        return response.data; // Return the parsed response body
      } else {
        throw Exception(
            "Failed to Delete Monthly Target. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return {
        "success": false,
        "message": dioError.response?.data ?? dioError.message,
      }; // Return an error response format
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      }; // Return an error response format
    }
  }

  Future<dynamic> saveMonthlyTarget({
    required String endPoint,
    required String mrid,
    required String newLead,
    required String year,
    required String ctarget,
    required String month,
    required String local,
    required String night,
    required String extra,
    required String salary,
    required String calls,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "mrid": mrid,
        "calls": calls,
        "newDoctor": newLead,
        "year": year,
        "orders": ctarget,
        "month": month,
        "localhq": local,
        "nighthault": night,
        "exhq": extra,
        "salary": salary,
        "Userid": box.read("userId")
      };

      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return response.data; // Return the parsed response body
      } else {
        throw Exception(
            "Failed to save Monthly Target. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return {
        "success": false,
        "message": dioError.response?.data ?? dioError.message,
      }; // Return an error response format
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      }; // Return an error response format
    }
  }

  Future<dynamic> updateMonthlyTarget({
    required String endPoint,
    required String mrid,
    required String newLead,
    required String year,
    required String ctarget,
    required String month,
    required String local,
    required String night,
    required String extra,
    required String salary,
    required String calls,
    required String id,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "mrid": mrid,
        "Id": id,
        "calls": calls,
        "newDoctor": newLead,
        "year": year,
        "orders": ctarget,
        "month": month,
        "localhq": local,
        "nighthault": night,
        "exhq": extra,
        "salary": salary,
        "Userid": box.read("userId")
      };

      final response = await dio.put(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return response.data; // Return the parsed response body
      } else {
        throw Exception(
            "Failed to Update Monthly Target. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return {
        "success": false,
        "message": dioError.response?.data ?? dioError.message,
      }; // Return an error response format
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      }; // Return an error response format
    }
  }

  Future<List<ContactsCount>> getContactCounts(
      String endPoint, String number) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: {
          'UserId': box.read("userId"),
          'tokenid': "5e9cf84a-d824-4caa-96ff-fbf095db3702",
          'customermobile': number,
        },
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          List<dynamic> responseData = response.data;
          return responseData
              .map((data) => ContactsCount.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format, expected a list.');
        }
      } else {
        throw Exception(
            "Failed to load unit list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addLeadFollowUp({
    required String endPoint,
    required String leadId,
    required String AssignTo,
    required String date,
    required String remark,
    required String time,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "LeadId": leadId,
        "Assigntoid": AssignTo,
        "FollowUpDateTime": date,
        "FollowUpRemark": remark,
        "REMINDERTIME": time,
        "Customerid": "",
        "Prospectid": "",
        "UserID": box.read("userId")
      };
      // Make the POST request with the request body
      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
      } else {
        throw Exception(
            "Failed to save lead. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
    } catch (e) {}
  }

  Future<ApiResponse<void>> addLeadMetting({
    required String endPoint,
    required String leadId,
    required String title,
    required String from,
    required String to,
    required String location,
    required String description,
    required String outomeRemark,
    required String assignTo,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "leadId": leadId,
        "title": title,
        "CheckinDatetime": from,
        "CheckoutDatetime": to,
        "Address": location,
        "description": description,
        "Remark": outomeRemark,
        "entrytype": "Meeting",
        "userid": box.read(StorageTags.userId),
        "Assigntoid": assignTo,
        "REMINDERTIME": "00:30",
        "Customerid": "0",
        "Prospectid": 0
      };
      print(requestBody);
      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
            response.data); // Return the parsed response body
      } else {
        return ApiResponse(status: "0", message: "Dio Exceptions");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return ApiResponse(
          status: "0",
          message: dioError.toString()); // Return an error response format
    } catch (e) {
      return ApiResponse(
          status: "0",
          message: e.toString()); // Return an error response format
    }
  }

  Future<ApiResponse<dynamic>> addLeadCall({
    required String endPoint,
    required String leadId,
    required String reminder,
    required String assignTo,
    required String description,
    required String date,
    required String CallType,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "leadId": leadId,
        "vdate": date,
        "activitytime": date,
        "CallStatusId": "1",
        "remark": description,
        "activitytype": CallType,
        "iscall": "1",
        "entrytype": "CallActivity",
        "userid": box.read(StorageTags.userId),
        "Assigntoid": assignTo,
        "REMINDERTIME": "00:30",
        "Customerid": "0",
        "Prospectid": "0"
      };
      print(requestBody);
      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
            response.data); // Return the parsed response body
      } else {
        return ApiResponse(status: "0", message: "Dio Exceptions");
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {}
      return ApiResponse(
          status: "0",
          message: dioError.toString()); // Return an error response format
    } catch (e) {
      return ApiResponse(
          status: "0",
          message: e.toString()); // Return an error response format
    }
  }

  Future<Map<String, dynamic>?> uploadAttachment({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> effectiveParams = {
      'userId': box.read("userId"),
      'Syscompanyid': box.read(StorageTags.sysComapnyId),
      'Sysbranchid': box.read(StorageTags.sysComapnyId),
    };
    try {
      final response = await dio.post(endPoint,
          data: jsonEncode(data), queryParameters: effectiveParams);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to upload attachment");
      }
    } catch (e) {
      print("Error uploading attachment: $e");
      return null;
    }
  }

// Update attachment
  Future<Map<String, dynamic>?> updateAttachment({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post(
        endPoint,
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to update attachment");
      }
    } catch (e) {
      print("Error updating attachment: $e");
      return null;
    }
  }

// Delete attachment
  Future<Map<String, dynamic>?> deleteAttachment(
      {required String endPoint, required String id}) async {
    final Map<String, dynamic> effectiveParams = {
      'id': id,
      'deletedby': box.read("userId"),
      'userid': box.read("userId"),
      'syscompanyid': box.read(StorageTags.sysComapnyId),
      'sysbranchid': box.read(StorageTags.sysComapnyId),
    };
    print(effectiveParams);
    try {
      final response =
          await dio.delete(endPoint, queryParameters: effectiveParams);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to delete attachment");
      }
    } catch (e) {
      print("Error deleting attachment: $e");
      return null;
    }
  }

// Download attachment (returns the file bytes)
  Future<Uint8List?> downloadAttachment({
    required String fileUrl,
  }) async {
    try {
      // Configure options to return bytes
      final options = Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        validateStatus: (status) {
          return status! < 500;
        },
      );

      final response = await dio.get(
        fileUrl,
        options: options,
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading file: $e");
      return null;
    }
  }

  Future<List<dynamic>> getAttachments({
    required String endPoint,
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: params,
      );
      print(response);
      if (response.statusCode == 200) {
        if (response.data is List) {
          return response.data;
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to load attachments");
      }
    } catch (e) {
      print("Error fetching attachments: $e");
      return [];
    }
  }

// Generic data fetching method that can be used for various endpoints
  Future<dynamic> getData({
    required String endPoint,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch data from $endPoint");
      }
    } catch (e) {
      print("Error fetching data from $endPoint: $e");
      return null;
    }
  }

// Generic data posting method
  Future<dynamic> postData({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post(
        endPoint,
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to post data to $endPoint");
      }
    } catch (e) {
      print("Error posting data to $endPoint: $e");
      return null;
    }
  }

  Future<g.AuthClient?> getAuthClient() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/calendar',
          'https://www.googleapis.com/auth/tasks',
        ],
      );

      final GoogleSignInAccount? account = await googleSignIn.signInSilently();
      final GoogleSignInAccount? user = account ?? await googleSignIn.signIn();

      if (user == null) return null;

      final GoogleSignInAuthentication googleAuth = await user.authentication;

      return g.authenticatedClient(
        http.Client(),
        g.AccessCredentials(
          g.AccessToken(
            'Bearer',
            googleAuth.accessToken!,
            DateTime.now().add(Duration(hours: 1)),
          ),
          googleAuth.idToken, // Use idToken instead of refreshToken
          ['https://www.googleapis.com/auth/calendar'],
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> scheduleTaskOnGoogleCalendar({
    required g.AuthClient client,
    required String title,
    required String location,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final calendarApi = calendar.CalendarApi(client);

      // Parse the start and end dates
      final parsedStartDate = DateTime.parse(startDate);
      final parsedEndDate = DateTime.parse(endDate);

      final event = calendar.Event(
        summary: title,
        location: location,
        description: description,
        start: calendar.EventDateTime(
          dateTime: parsedStartDate,
          timeZone: 'GMT',
        ),
        end: calendar.EventDateTime(
          dateTime: parsedEndDate,
          timeZone: 'GMT',
        ),
      );

      // Insert the event into the primary calendar
      final calendarEvent = await calendarApi.events.insert(event, 'primary');
      return true;
    } catch (e) {
      return false;
    }
  }
}
