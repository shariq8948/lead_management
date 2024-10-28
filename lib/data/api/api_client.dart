import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/tags.dart';
import '../models/admin_responses.model.dart';
import '../models/chat_response.model.dart';
import '../models/common_responses.model.dart';
import '../models/create_edit_job_response.model.dart';
import '../models/customer_det.model.dart';
import '../models/dropdown_list.model.dart';
import '../models/home_jobs_response.model.dart';
import '../models/job_detail.model.dart';
import '../models/job_service_list.model.dart';
import '../models/jobs_count_response.model.dart';
import '../models/login_response.model.dart';
import '../models/product_list.model.dart';
import '../models/reports.model.dart';

class ApiClient extends GetConnect implements GetxService {
  late Map<String, String> _mainHeaders;

  ApiClient() {
    final box = GetStorage();
    baseUrl = box.read(StorageTags.baseUrl) ?? "";
    timeout = const Duration(seconds: 30);
    _mainHeaders = {
      "Content-Type": "application/json; charset=UTF-8",
    };
  }

  updateBaseUrl(String apiUrl) {
    baseUrl = apiUrl;
    httpClient.baseUrl = apiUrl;
  }

  // Login Request
  Future<LoginResponse> loginRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? LoginResponse.fromJson(response.body[0])
            : LoginResponse(message: "Invalid login details!");
      } else {
        return LoginResponse(
          message:
              "Something went wrong, please check your domain and try again!",
        );
      }
    } catch (e) {
      return LoginResponse(message: e.toString());
    }
  }

  // Daily Counts Request
  Future<JobsCountResponse> getJobsCount(
    String endpoint,
    List<Map<String, dynamic>> body,
  ) async
  {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? JobsCountResponse.fromJson(response.body[0])
            : JobsCountResponse(message: "Invalid login details!");
      } else {
        return JobsCountResponse(
          message: "Something went wrong, please try again!",
        );
      }
    } catch (e) {
      return JobsCountResponse(message: e.toString());
    }
  }

  // Admin Daily Counts Request
  Future<AdminCountsModel> getAdminJobsCount(
    String endpoint,
  ) async
  {
    try {
      Response response = await get(
        endpoint,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? AdminCountsModel.fromJson(response.body[0])
            : AdminCountsModel(message: "Invalid login details!");
      } else {
        return AdminCountsModel(
          message: "Something went wrong, please try again!",
        );
      }
    } catch (e) {
      return AdminCountsModel(message: e.toString());
    }
  }

  // Admin Today Counts Request
  Future<AdminTodayCountsModel> getAdminTodayCount(
    String endpoint,
  ) async {
    try {
      Response response = await get(
        endpoint,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? AdminTodayCountsModel.fromJson(response.body[0])
            : AdminTodayCountsModel(message: "Invalid login details!");
      } else {
        return AdminTodayCountsModel(
          message: "Something went wrong, please try again!",
        );
      }
    } catch (e) {
      return AdminTodayCountsModel(message: e.toString());
    }
  }

  // Get Admin Jobs List
  Future<CommonListResponse<AdminJobsModel>> getAdminJobsList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        headers: _mainHeaders,
        query: query,
      );
      if (response.body.runtimeType == List) {
        List<AdminJobsModel> arr = [];
        for (var cate in response.body) {
          arr.add(AdminJobsModel.fromJson(cate));
        }
        return CommonListResponse<AdminJobsModel>(data: arr);
      } else {
        return CommonListResponse<AdminJobsModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<AdminJobsModel>(message: e.toString());
    }
  }

  // Get Inq No
  Future<Map<String, String?>> getInqNo(
    String endpoint,
  ) async {
    try {
      Response response = await get(
        endpoint,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? {...response.body[0], "error": ""}
            : {"error": "Something went wrong, please try again!"};
      } else {
        return {"error": "Something went wrong, please try again!"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  // Get Years List
  Future<CommonListResponse<YearsModel>> getYearsList(
    String endpoint,
  ) async {
    try {
      Response response = await get(
        endpoint,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<YearsModel> arr = [];
        for (var cate in response.body) {
          arr.add(YearsModel.fromJson(cate));
        }
        return CommonListResponse<YearsModel>(data: arr);
      } else {
        return CommonListResponse<YearsModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<YearsModel>(message: e.toString());
    }
  }

  Future<CommonListResponse<AdminGraphModel>> getAdminGraph(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<AdminGraphModel> arr = [];
        for (var cate in response.body) {
          arr.add(AdminGraphModel.fromJson(cate));
        }
        return CommonListResponse<AdminGraphModel>(data: arr);
      } else {
        return CommonListResponse<AdminGraphModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<AdminGraphModel>(message: e.toString());
    }
  }

  // Get Home Jobs List
  Future<CommonListResponse<HomeJobsResponse>> getHomeJobsList(
    String endpoint,
    Map<String, dynamic> query,
  ) async
  {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      print(response);
      if (response.body.runtimeType == List) {
        List<HomeJobsResponse> arr = [];
        for (var cate in response.body) {
          arr.add(HomeJobsResponse.fromJson(cate));
        }
        return CommonListResponse<HomeJobsResponse>(data: arr);
      } else {
        return CommonListResponse<HomeJobsResponse>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<HomeJobsResponse>(message: e.toString());
    }
  }
  Future<CommonListResponse<HomeJobsResponse>> getSearchJobsList(
      String endpoint,
      Map<String, dynamic> query,
      ) async {
    try {
      // Use the GetX get method to send the request with the endpoint and query params
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders, // Your predefined headers
      );

      print(response);

      // Check if the response body is a list (i.e., if the search results are returned successfully)
      if (response.body.runtimeType == List) {
        // Map the response into a list of HomeJobsResponse
        List<HomeJobsResponse> arr = [];
        for (var job in response.body) {
          arr.add(HomeJobsResponse.fromJson(job));
        }
        // Return the list wrapped in CommonListResponse
        return CommonListResponse<HomeJobsResponse>(data: arr);
      } else {
        // Handle non-list responses (error handling)
        return CommonListResponse<HomeJobsResponse>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      // Handle any errors that occur during the request
      return CommonListResponse<HomeJobsResponse>(message: e.toString());
    }
  }


  Future<CommonListResponse<ReportsModel>> getReportsList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<ReportsModel> arr = [];
        for (var cate in response.body) {
          arr.add(ReportsModel.fromJson(cate));
        }
        return CommonListResponse<ReportsModel>(data: arr);
      } else {
        return CommonListResponse<ReportsModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<ReportsModel>(message: e.toString());
    }
  }

  // Get Reports Designer Collection
  Future<CommonListResponse<DesignerCollectionModel>>
      getReportsDesignerCollection(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<DesignerCollectionModel> arr = [];
        for (var cate in response.body) {
          arr.add(DesignerCollectionModel.fromJson(cate));
        }
        return CommonListResponse<DesignerCollectionModel>(data: arr);
      } else {
        return CommonListResponse<DesignerCollectionModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<DesignerCollectionModel>(message: e.toString());
    }
  }

  // Get Inquiry List
  Future<CommonListResponse<InquiryModel>> getInquiryList(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<InquiryModel> arr = [];
        for (var cate in response.body) {
          arr.add(InquiryModel.fromJson(cate));
        }
        return CommonListResponse<InquiryModel>(data: arr);
      } else {
        return CommonListResponse<InquiryModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<InquiryModel>(message: e.toString());
    }
  }

  // Get Inquiry Follow Up List
  Future<CommonListResponse<InquiryFollowUpModel>> getInquiryFollowUpList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<InquiryFollowUpModel> arr = [];
        for (var cate in response.body) {
          arr.add(InquiryFollowUpModel.fromJson(cate));
        }
        return CommonListResponse<InquiryFollowUpModel>(data: arr);
      } else {
        return CommonListResponse<InquiryFollowUpModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<InquiryFollowUpModel>(message: e.toString());
    }
  }


  Future<CommonListResponse<JobDetailModel>> getJobDetails(
      String endpoint,
      Map<String, dynamic> query,
      ) async
  {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );

      // Print the raw response body for debugging
      print("Raw Response Body: ${response.body}");

      // Check if the response body is a List
      if (response.body.runtimeType == List) {
        List<JobDetailModel> arr = [];
        for (var cate in response.body) {
          arr.add(JobDetailModel.fromJson(cate));
        }

        // Print parsed data for debugging
        print("Parsed Job Details: $arr");

        return CommonListResponse<JobDetailModel>(data: arr);
      } else {
        // Print an error message if the response is not a list
        print("Response was not a list. Body: ${response.body}");

        return CommonListResponse<JobDetailModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      // Print the exception for debugging
      print("Error in getJobDetails: $e");

      return CommonListResponse<JobDetailModel>(message: e.toString());
    }
  }


  // Fetch Customer Details
  Future<CommonListResponse<CustomerDetModel>> fetchCustomerByMobileNo(
    String endpoint,
    Map<String, dynamic> query,
  )
  async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<CustomerDetModel> arr = [];
        for (var cate in response.body) {
          arr.add(CustomerDetModel.fromJson(cate));
        }
        return CommonListResponse<CustomerDetModel>(data: arr);
      } else {
        return CommonListResponse<CustomerDetModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<CustomerDetModel>(message: e.toString());
    }
  }

  // Fetch Job Attachments
  Future<CommonListResponse<JobAttachmentModel>> getJobAttachments(
    String endpoint,
    Map<String, dynamic> query,
  ) async
  {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<JobAttachmentModel> arr = [];
        for (var cate in response.body) {
          arr.add(JobAttachmentModel.fromJson(cate));
        }
        return CommonListResponse<JobAttachmentModel>(data: arr);
      } else {
        return CommonListResponse<JobAttachmentModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<JobAttachmentModel>(message: e.toString());
    }
  }

  // Fetch Chat Details
  Future<CommonListResponse<ChatResponseModel>> getChatDetails(
    String endpoint,
    List<Map<String, dynamic>> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<ChatResponseModel> arr = [];
        for (var cate in response.body) {
          arr.add(ChatResponseModel.fromJson(cate));
        }
        return CommonListResponse<ChatResponseModel>(data: arr);
      } else {
        return CommonListResponse<ChatResponseModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<ChatResponseModel>(message: e.toString());
    }
  }

  // Fetch Chat Details
  Future<bool?> sendMessage(
    String endpoint,
    List<Map<String, dynamic>> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  // Fetch Inquiry Details
  Future<CommonListResponse<InquiryModel>> getInquiryDetails(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<InquiryModel> arr = [];
        for (var cate in response.body) {
          arr.add(InquiryModel.fromJson(cate));
        }
        return CommonListResponse<InquiryModel>(data: arr);
      } else {
        return CommonListResponse<InquiryModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<InquiryModel>(message: e.toString());
    }
  }

  // Update Profile Image
  Future<CommonStringResponse> updateProfileImageRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == String) {
        return CommonStringResponse(
          message: null,
        );
      } else {
        return CommonStringResponse(
          message: "Something went wrong, please try again!",
        );
      }
    } catch (e) {
      return CommonStringResponse(message: e.toString());
    }
  }

  // Fetch Products List
  Future<CommonListResponse<ProductModel>> getProductsList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<ProductModel> arr = [];
        for (var cate in response.body) {
          arr.add(ProductModel.fromJson(cate));
        }
        return CommonListResponse<ProductModel>(data: arr);
      } else {
        return CommonListResponse<ProductModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<ProductModel>(message: e.toString());
    }
  }

  // Fetch Products List
  Future<CommonListResponse<DomainListModel>> getDomainsList(
    String endpoint,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: {
          "filter": "psm",
        },
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<DomainListModel> arr = [];
        for (var cate in response.body) {
          arr.add(DomainListModel.fromJson(cate));
        }
        return CommonListResponse<DomainListModel>(data: arr);
      } else {
        return CommonListResponse<DomainListModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<DomainListModel>(message: e.toString());
    }
  }

  // Fetch Product Detail
  Future<ProductModel> getProductDetail(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? ProductModel.fromJson(response.body[0])
            : ProductModel(message: "Invalid login details!");
      } else {
        return ProductModel(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return ProductModel(message: e.toString());
    }
  }

  // Fetch Product Services List
  Future<CommonListResponse<JobServiceListModel>> getProductServicesList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<JobServiceListModel> arr = [];
        for (var cate in response.body) {
          arr.add(JobServiceListModel.fromJson(cate));
        }
        return CommonListResponse<JobServiceListModel>(data: arr);
      } else {
        return CommonListResponse<JobServiceListModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<JobServiceListModel>(message: e.toString());
    }
  }

  // Fetch Dropdown List (Desinger, Printer, Fabrication, Vendor)
  Future<CommonListResponse<DropdownListModel>> getDropdownList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<DropdownListModel> arr = [];
        for (var cate in response.body) {
          arr.add(DropdownListModel.fromJson(cate));
        }
        return CommonListResponse<DropdownListModel>(data: arr);
      } else {
        return CommonListResponse<DropdownListModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<DropdownListModel>(message: e.toString());
    }
  }

  Future<CommonListResponse<StorageLocationModel>> getLocationsList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<StorageLocationModel> arr = [];
        for (var cate in response.body) {
          arr.add(StorageLocationModel.fromJson(cate));
        }
        return CommonListResponse<StorageLocationModel>(data: arr);
      } else {
        return CommonListResponse<StorageLocationModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<StorageLocationModel>(message: e.toString());
    }
  }

  Future<CommonListResponse<PaymentModeModel>> getPaymentModeList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<PaymentModeModel> arr = [];
        for (var cate in response.body) {
          arr.add(PaymentModeModel.fromJson(cate));
        }
        return CommonListResponse<PaymentModeModel>(data: arr);
      } else {
        return CommonListResponse<PaymentModeModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<PaymentModeModel>(message: e.toString());
    }
  }

  Future<CommonListResponse<CustomerListModel>> getCustomerList(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      Response response = await get(
        endpoint,
        query: query,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        List<CustomerListModel> arr = [];
        for (var cate in response.body) {
          arr.add(CustomerListModel.fromJson(cate));
        }
        return CommonListResponse<CustomerListModel>(data: arr);
      } else {
        return CommonListResponse<CustomerListModel>(
          message: "Something went wrong, please try again later!",
        );
      }
    } catch (e) {
      return CommonListResponse<CustomerListModel>(message: e.toString());
    }
  }

  // Create/Edit Job Request
  Future<CreateEditJobResponseModel> createEditJobReq(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? CreateEditJobResponseModel.fromJson(response.body[0])
            : CreateEditJobResponseModel(
                errorMessage: "Invalid login details!");
      } else {
        return CreateEditJobResponseModel(
          errorMessage: "Something went wrong, please try again!",
        );
      }
    } catch (e) {
      return CreateEditJobResponseModel(errorMessage: e.toString());
    }
  }

  // Create/Edit Job Request
  Future<CreateInqResponse> createInqReq(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == List) {
        return response.body.length > 0
            ? CreateInqResponse.fromJson(response.body[0])
            : CreateInqResponse(message: "Invalid login details!");
      } else {
        return CreateInqResponse(
          message: "Something went wrong, please try again!",
        );
      }
    } catch (e) {
      return CreateInqResponse(message: e.toString());
    }
  }

  // Create/Edit Job Request
  Future<bool> updateTime(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == String) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> postReqStringResp(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await post(
        endpoint,
        body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == String) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> delReqStringResp(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      Response response = await delete(
        endpoint,
        query: body,
        headers: _mainHeaders,
      );
      if (response.body.runtimeType == String) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
