import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/tags.dart';
import 'package:leads/widgets/custom_snckbar.dart';

import '../../data/models/dropdown_list.model.dart';
import '../../utils/api_endpoints.dart';
import '../meeting_page.dart';
import 'model.dart';

enum FilterType { today, all, upcoming, overdue }

class ScheduleController extends GetxController {
  final _apiService = ApiClient();
  final RxList<Meeting> meetings = <Meeting>[].obs;
  final RxList<Meeting> filteredMeetings = <Meeting>[].obs;
  final Rx<FilterType> currentFilter = FilterType.today.obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final box = GetStorage();
  final formKey = GlobalKey<FormState>(); // Form key for validation

  //customerForm
  TextEditingController cityController = TextEditingController();
  TextEditingController showCityController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController showAreaController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController showStateController = TextEditingController();
  final customerIdController = TextEditingController();
  final customerNameController = TextEditingController();
  final budgetController = TextEditingController();
  final productController = TextEditingController();
  final registrationTypeController = TextEditingController();
  final customerTypeController = TextEditingController();
  final mobileController = TextEditingController();
  final titleController = TextEditingController();
  final displayNameController = TextEditingController();
  final lane1Controller = TextEditingController();
  final remarkController = TextEditingController();
  final lane2Controller = TextEditingController();
  final ledgerIdController = TextEditingController();
  final tcsRateController = TextEditingController();
  final freightController = TextEditingController();
  final companyNameController = TextEditingController();
  final leadSourceController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final panController = TextEditingController();
  final webSiteController = TextEditingController();
  final partyTypeController = TextEditingController();
  RxList<StateListDropdown> stateList = <StateListDropdown>[].obs;
  RxList<cityListDropDown> cityList = <cityListDropDown>[].obs;
  RxList<areaListDropDown> areaList = <areaListDropDown>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLState();
    fetchMeetings();
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

  Future<void> fetchCustomerData(String mobileNumber) async {
    isLoading.value = true;

    try {
      var res = await _apiService.getR("/api/Mobileapi/AppCustomerList",
          includeDefaultParams: false,
          queryParameters: {
            "Userid": box.read(StorageTags.userId),
            "Mobile": mobileNumber
          });

      if (res != null && res is List && res.isNotEmpty) {
        print(res);
        mobileController.text = res[0]["mobile"]?.toString() ?? '';
        emailController.text = res[0]["email"]?.toString() ?? '';
        customerNameController.text = res[0]["name"]?.toString() ?? '';
        showStateController.text = res[0]["state"]?.toString() ?? '';
        stateController.text = res[0]["stateID"]?.toString() ?? '';
        cityController.text = res[0]["cityID"]?.toString() ?? '';
        showCityController.text = res[0]["city"]?.toString() ?? '';
        areaController.text = res[0]["areaID"]?.toString() ?? '';
        showAreaController.text = res[0]["area"]?.toString() ?? '';
        lane1Controller.text = res[0]["address"]?.toString() ?? '';
        print(phoneController.text);
      }
    } catch (e) {
      print("Error fetching customer data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchLState() async {
    await _fetchData(
      apiCall: () async => await _apiService.getStateList(
          box.read("userId"), ApiEndpoints.stateList),
      dataList: stateList,
      isFetchingState: isLoading,
    );
  }

  Future<void> fetchLeadCity() async {
    await _fetchData(
      apiCall: () async => await _apiService.getCityList(
          ApiEndpoints.cityList, stateController.text),
      dataList: cityList,
      isFetchingState: isLoading,
    );
  }

  Future<void> fetchLeadArea() async {
    await _fetchData(
      apiCall: () async => await _apiService.getAreaList(
          ApiEndpoints.areaList, cityController.text),
      dataList: areaList,
      isFetchingState: isLoading,
    );
  }

  Future<void> fetchMeetings() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _apiService.getR(
          "/api/presalesmobile/GetAssignTaskList?USERID=4&RecordType=ToDOList&datafiltertype=Meeting");
      print(response);

      // Convert the dynamic list to a list of Meeting objects
      if (response is List) {
        meetings.value =
            response.map((item) => Meeting.fromJson(item)).toList();
      } else {
        error.value = 'Invalid response format';
      }

      applyFilter(currentFilter.value);
    } catch (e) {
      error.value = 'Failed to load meetings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter(FilterType filter) {
    currentFilter.value = filter;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    // Sort meetings to place active ones at the top
    final List<Meeting> sorted = List.from(meetings);
    sorted.sort((a, b) {
      // Active meetings (checked in but not checked out) at top
      if (a.checkin == "1" && (a.checkout == "0" || a.checkout == "")) {
        return -1;
      }
      if (b.checkin == "1" && (b.checkout == "0" || b.checkout == "")) {
        return 1;
      }

      // Sort by date
      DateTime aDate = _parseDateTime(a.vdate);
      DateTime bDate = _parseDateTime(b.vdate);
      return aDate.compareTo(bDate);
    });

    switch (filter) {
      case FilterType.today:
        filteredMeetings.value = sorted.where((meeting) {
          DateTime meetingDate = _parseDateTime(meeting.vdate);
          return meetingDate.year == today.year &&
              meetingDate.month == today.month &&
              meetingDate.day == today.day;
        }).toList();
        break;
      case FilterType.upcoming:
        filteredMeetings.value = sorted.where((meeting) {
          DateTime meetingDate = _parseDateTime(meeting.vdate);
          return meetingDate.isAfter(today);
        }).toList();
        break;
      case FilterType.overdue:
        filteredMeetings.value = sorted.where((meeting) {
          DateTime meetingDate = _parseDateTime(meeting.vdate);
          return meetingDate.isBefore(today) &&
              (meeting.checkin != "1" || meeting.checkout != "1");
        }).toList();
        break;
      case FilterType.all:
        filteredMeetings.value = sorted;
        break;
    }
  }

  DateTime _parseDateTime(String dateTimeStr) {
    try {
      // Handle different date formats
      if (dateTimeStr.contains("AM") || dateTimeStr.contains("PM")) {
        return DateFormat("M/d/yyyy h:mm:ss a").parse(dateTimeStr);
      } else {
        return DateFormat("M/d/yyyy").parse(dateTimeStr);
      }
    } catch (e) {
      // Fallback to current date if parsing fails
      return DateTime.now();
    }
  }

  bool hasActiveMeeting() {
    return meetings.any((meeting) =>
        meeting.checkin == "1" &&
        (meeting.checkout == "0" || meeting.checkout == ""));
  }

  Future<void> checkIn(Meeting meeting) async {
    try {
      isLoading.value = true;

      // Get current location
      Position position = await _getCurrentPosition();

      var id = meeting.id;
      var response = await _apiService.postg("api/checkin", data: {
        "Id": id,
        "UserId": box.read(StorageTags.userId),
        "Checkin": "1",
        "Checkout": "",
        "Checkin_Location": "${position.latitude}, ${position.longitude}",
        "Checkin_longitude": position.longitude.toString(),
        "Checkin_latitude": position.latitude.toString()
      });
      print(response);
      print(response['status']);
      // Update local state
      if (response['status'] == "1") {
        CustomSnack.show(
            content: response["message"],
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
        fetchMeetings();
        Get.to(MeetingPage());
      } else {
        CustomSnack.show(
            content: response["message"],
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      }
      // applyFilter(currentFilter.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to check in: $e');
    } finally {
      isLoading.value = false;
    }
  }

// Function to get current position
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      Get.snackbar('Location Service',
          'Location services are disabled. Please enable location services.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        Get.snackbar('Location Permission',
            'Location permissions are denied. Please grant location permission.');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      Get.snackbar('Location Permission',
          'Location permissions are permanently denied. Please enable them in app settings.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can get the position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> checkOut(String id) async {
    try {
      isLoading.value = true;
      // Get current location
      Position position = await _getCurrentPosition();

      var response = await _apiService.putg("api/checkin", data: {
        "Id": id,
        "UserId": box.read(StorageTags.userId),
        "Mobile": mobileController.text,
        "Whatsapp": mobileController.text,
        "Email": emailController.text,
        "Name": customerNameController.text,
        "Company": "demo",
        "CustomerType": "Prospect",
        "Stateid": stateController.text,
        "Cityid": cityController.text,
        "Areaid": areaController.text,
        "Budget": budgetController.text,
        "Product": productController.text,
        "Pincode": "144400",
        "Address": lane1Controller.text,
        "Remark": remarkController.text,
        "Checkin": "1",
        "Checkout": "1",
        "Createdby": "4",
        "Checkout_Location": "${position.latitude}, ${position.longitude}",
        "Checkout_longitude": position.longitude.toString(),
        "Checkout_latitude": position.latitude.toString()
      });
      print(response);
      print(response['status']);
      // Update local state
      if (response['status'] == "1") {
        CustomSnack.show(
            content: response["message"],
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
        fetchMeetings();
        Get.to(MeetingPage());
      } else {
        CustomSnack.show(
            content: response["message"],
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed);
      }
      // applyFilter(currentFilter.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to check in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToMeeting(Meeting meeting) {
    // Handle navigation logic
    Get.snackbar('Navigation', 'Navigating to meeting location');
    // You could launch maps here with the address details
  }

  void callContact(Meeting meeting) {
    // Handle call logic
    Get.snackbar('Calling', 'Calling ${meeting.cname}');
    // You could launch phone dialer with the contact's number
  }

  void reschedule(Meeting meeting) {
    // Navigate to reschedule screen
    Get.toNamed('/reschedule', arguments: meeting);
  }
}
