import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:leads/data/models/QuotationFollowUpModel.dart';
import 'package:leads/data/models/customer_model.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/data/models/leadDetails.dart';
import 'package:leads/data/models/lead_list.dart';
import 'package:leads/data/models/product.dart';
import 'package:leads/data/models/task_activity_model.dart';
import 'package:leads/data/models/task_details.dart';
import '../models/dashboard_count.dart';
import '../models/graph-model.dart';
import '../models/login_response.model.dart';
import '../models/taskActivity.dart';
import '../models/task_list.dart';

class ApiClient extends GetConnect implements GetxService {
  final Dio dio = Dio();
  final String baseUrl = 'https://lead.mumbaicrm.com/api';

  ApiClient() {
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      // Add any other default headers here (e.g., Authorization tokens)
    };
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
  Future<List<AllCountList>> getDashboardCount() async {
    try {
      final response = await dio.get(
        '/PresalesMobile/AllCountList',
        queryParameters: {
          'UserId': '4',
          'Syscompanyid': '4',
          'sysbranchid': '4',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => AllCountList.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to TaskList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => TaskList.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load task list");
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        print(effectiveParams);
        final List<dynamic> responseData = response.data['data1'] ?? [];
        return responseData.map((data) => LeadList.fromJson(data)).toList();
      } else {
        throw Exception(
            "Failed to load lead list. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      print('DioError: ${dioError.message}');
      if (dioError.response != null) {
        print('Dio Response: ${dioError.response?.data}');
      }
      return []; // Return an empty list in case of error
    } catch (e) {
      print('Error: $e');
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
      print(effectiveParams);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        print(response.data);
        final List<dynamic> responseData = response.data ?? [];
        return responseData.map((data) => LeadList.fromJson(data)).toList();
      } else {
        throw Exception(
            "Failed to load lead list. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      print('DioError: ${dioError.message}');
      if (dioError.response != null) {
        print('Dio Response: ${dioError.response?.data}');
      }
      return []; // Return an empty list in case of error
    } catch (e) {
      print('Errors: $e');
      return []; // Return an empty list in case of any other error
    }
  }

  Future<Taskactivity> taskActivity(
      String endpoint, List<Map<String, dynamic>> body) async {
    try {
      final response = await dio.post(endpoint, data: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = response.data;
        print("This is the status or response: $data");
        return Taskactivity(success: true, message: "Success");
      } else {
        return Taskactivity(
            message: "Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      return Taskactivity(message: "Error: $e");
    }
  }

  Future<List<FunnelGraph>> getFunnelGraph(
      String userId, String endPoint) async {
    try {
      final response = await dio.get(
        'https://lead.mumbaicrm.com/api/PresalesMobile/GetDashAllLeadwithStatusCount',
        queryParameters: {
          'UserId': userId,
          'Year': 2024,
          'Month': 03,
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => FunnelGraph.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => DealData.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body for leadSource: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => LeadSourceDropdownList.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body for leadSource: ${response.data}');

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
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body for leadSource: ${response.data}');

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
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

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
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

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
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

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
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData
            .map((data) => areaListDropDown.fromJson(data))
            .toList();
      } else {
        throw Exception("Failed to load dashboard count");
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<CustomerResponseModel>> getCustomerList({
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
        },
      );

      if (response.statusCode == 200) {
        print(response);
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
      print('Error: $e');
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
          'Syscompanyid': "4",
          'Sysbranchid': "4",
        },
      );

      if (response.statusCode == 200) {
        print(response);
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
      print('Error: $e');
      return [];
    }
  }

  Future<List<Products>> getAllProductList({
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
          'Syscompanyid': '4',
          'Sysbranchid': '4',
        },
      );

      if (response.statusCode == 200) {
        print(response);

        // Parse the response data
        final responseData = response.data is String
            ? jsonDecode(response.data) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;
        print("Response received: ${response.data}");
        print("Parsed 'data': ${responseData['data']}");

        // Ensure 'data' exists and is a list
        if (responseData['data'] != null && responseData['data'] is List) {
          return (responseData['data'] as List<dynamic>)
              .map<Products>((item) => Products.fromJson(item))
              .toList();
        } else {
          print(
              "Unexpected response structure: 'data' is not a list or is null.");
          return []; // Return an empty list for invalid or missing 'data'
        }
      } else {
        throw Exception(
            "Failed to load product list. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list in case of error
    }
  }

  Future<void> postCustomerData({
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
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': userId,
        'Syscompanyid': "4",
        'Sysbranchid': "4",
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
        "email": "",
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

      // Make the POST request with the request body
      final response = await dio.post(endPoint,
          data: requestBody,
          queryParameters:
              effectiveParams // Send data in the body of the request
          );

      print(requestBody);
      print(effectiveParams);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Success: ${response.data}');
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      print('DioError: ${dioError.message}');
      if (dioError.response != null) {
        print('Dio Response: ${dioError.response?.data}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateCustomerData({
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
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': userId,
        'Syscompanyid': "4",
        'Sysbranchid': "4",
      };
      // Prepare the request body
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
        "email": "",
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

      // Make the POST request with the request body
      final response = await dio.put(endPoint,
          data: requestBody,
          queryParameters:
              effectiveParams // Send data in the body of the request
          );

      print(requestBody);
      print(effectiveParams);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Success: ${response.data}');
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      print('DioError: ${dioError.message}');
      if (dioError.response != null) {
        print('Dio Response: ${dioError.response?.data}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteCustomerData({
    required String endPoint,
    required String Id,
    required String userId,
  }) async {
    try {
      final Map<String, dynamic> effectiveParams = {
        'userId': userId,
        'Syscompanyid': "4",
        'Sysbranchid': "4",
        'Id': Id
      };
      // Prepare the request body

      // Make the POST request with the request body
      final response = await dio.post(endPoint,
          queryParameters:
              effectiveParams // Send data in the body of the request
          );

      print(effectiveParams);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Success: ${response.data}');
      } else {
        throw Exception(
            "Failed to save customer. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      print('DioError: ${dioError.message}');
      if (dioError.response != null) {
        print('Dio Response: ${dioError.response?.data}');
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => TaskDetail.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load task");
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

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
      print('Error: $e');
      return [];
    }
  }

  Future<void> postLeadData({
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
      // Prepare the request body
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
        "expecteddate": "2024-11-26",
        "industrytype": industry,
        "leadpriorityid": "1",
        "leadsource": "",
        "mobile": mobileNumber,
        "noofemployee": "",
        "ownerid": owner,
        "phone": "",
        "pincode": "",
        "rating": "",
        "secondemail": "",
        "skypeid": "",
        "state": "",
        "twitter": ""
      };

      // Make the POST request with the request body
      final response = await dio.post(
        endPoint,
        data: requestBody,
      );

      print(requestBody);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Success: ${response.data}');
      } else {
        throw Exception(
            "Failed to save lead. Status Code: ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      print('DioError: ${dioError.message}');
      if (dioError.response != null) {
        print('Dio Response: ${dioError.response?.data}');
      }
    } catch (e) {
      print('Error: $e');
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

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        // If the response body contains a list, map it to AllCountList model
        List<dynamic> responseData = response.data;
        return responseData.map((data) => LeadResponse.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load task");
      }
    } catch (e) {
      print('Error: $e');
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
          "Syscompanyid": "4",
          "Sysbranchid": "4" // Replace with the actual city ID
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

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
      print('Error: $e');
      return [];
    }
  }
}
