import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:leads/utils/tags.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceRecord {
  final String id;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String photoPath;
  final String status;
  final double? hoursWorked;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? checkinImageUrl;
  final String? checkoutImageUrl;
  final String? dayOfWeek;
  final String? name;
  final String? department;
  final String? attendanceStatus;
  final String? checkout; // Added this field to match API response

  AttendanceRecord({
    required this.id,
    required this.checkInTime,
    this.checkOutTime,
    required this.photoPath,
    required this.status,
    this.hoursWorked,
    this.latitude,
    this.longitude,
    this.address,
    this.checkinImageUrl,
    this.checkoutImageUrl,
    this.dayOfWeek,
    this.name,
    this.department,
    this.attendanceStatus,
    this.checkout,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'checkInTime': checkInTime.toIso8601String(),
        'checkOutTime': checkOutTime?.toIso8601String(),
        'photoPath': photoPath,
        'status': status,
        'hoursWorked': hoursWorked,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'checkinImageUrl': checkinImageUrl,
        'checkoutImageUrl': checkoutImageUrl,
        'dayOfWeek': dayOfWeek,
        'name': name,
        'department': department,
        'attendanceStatus': attendanceStatus,
        'checkout': checkout,
      };

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    // Parse check-in time
    DateTime? checkInTime;
    try {
      if (json['checkintime'] != null &&
          json['checkintime'].toString().isNotEmpty) {
        checkInTime =
            DateFormat('M/d/yyyy h:mm:ss a').parse(json['checkintime']);
      } else if (json['date'] != null && json['date'].toString().isNotEmpty) {
        checkInTime = DateFormat('M/d/yyyy h:mm:ss a').parse(json['date']);
      } else {
        checkInTime = DateTime.now();
      }
    } catch (e) {
      print('Error parsing check-in time: $e');
      checkInTime = DateTime.now();
    }

    // Parse check-out time
    DateTime? checkOutTime;
    try {
      if (json['checkouttime'] != null &&
          json['checkouttime'].toString().isNotEmpty) {
        checkOutTime =
            DateFormat('M/d/yyyy h:mm:ss a').parse(json['checkouttime']);
      }
    } catch (e) {
      print('Error parsing check-out time: $e');
      checkOutTime = null;
    }

    // Parse working hours
    double? hoursWorked;
    try {
      if (json['workingHours'] != null &&
          json['workingHours'].toString().isNotEmpty) {
        hoursWorked = double.tryParse(json['workingHours'].toString()) ?? 0.0;
      }
    } catch (e) {
      print('Error parsing hours worked: $e');
      hoursWorked = 0.0;
    }

    // Parse latitude
    double? latitude;
    try {
      if (json['checkinLatitude'] != null &&
          json['checkinLatitude'].toString().isNotEmpty) {
        latitude = double.tryParse(json['checkinLatitude'].toString());
      }
    } catch (e) {
      print('Error parsing latitude: $e');
    }

    // Parse longitude
    double? longitude;
    try {
      if (json['checkinLongitude'] != null &&
          json['checkinLongitude'].toString().isNotEmpty) {
        longitude = double.tryParse(json['checkinLongitude'].toString());
      }
    } catch (e) {
      print('Error parsing longitude: $e');
    }

    return AttendanceRecord(
      id: json['id']?.toString() ?? '',
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      photoPath: '', // Server doesn't return actual photo path
      status: json['attendancestatus'] ?? json['status'] ?? 'Unknown',
      hoursWorked: hoursWorked,
      latitude: latitude,
      longitude: longitude,
      address: json['checkinLocation'] ?? '',
      checkinImageUrl: json['checkinImageUrl'],
      checkoutImageUrl: json['checkoutImageUrl'],
      dayOfWeek: json['dayOfWeek'],
      name: json['name'],
      department: json['department'],
      attendanceStatus: json['attendancestatus'],
      checkout: json['checkout']?.toString() ?? '',
    );
  }
}

class MarkAttendanceController extends GetxController {
  CameraController? cameraController;
  final apiclient = ApiClient();
  final box = GetStorage();
  final isCameraInitialized = false.obs;
  final showCamera = false.obs;
  final isLoading = false.obs;
  final capturedImagePath = ''.obs;
  final List<Timer> timers = [];

  final currentRecord = Rxn<AttendanceRecord>();
  final attendanceRecords = <AttendanceRecord>[].obs;

  final totalHoursToday = 0.0.obs;
  final isProcessing = false.obs;

  // Location related variables
  final currentLatitude = 0.0.obs;
  final currentLongitude = 0.0.obs;
  final currentAddress = ''.obs;
  final isLocationLoading = false.obs;
  final locationErrorMessage = ''.obs;
  final hasLocationPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
    checkLocationPermission();
    loadAttendanceHistory();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    for (final timer in timers) {
      timer.cancel();
    }
    timers.clear();
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> checkLocationPermission() async {
    isLocationLoading(true);
    locationErrorMessage('');

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationErrorMessage(
            'Location services are disabled. Please enable the services');
        hasLocationPermission(false);
        isLocationLoading(false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationErrorMessage('Location permissions are denied');
          hasLocationPermission(false);
          isLocationLoading(false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationErrorMessage(
            'Location permissions are permanently denied, we cannot request permissions.');
        hasLocationPermission(false);
        isLocationLoading(false);
        return;
      }

      hasLocationPermission(true);
      await getCurrentLocation();
    } catch (e) {
      print('Error checking location permission: $e');
      locationErrorMessage('Error accessing location services');
      hasLocationPermission(false);
    } finally {
      isLocationLoading(false);
    }
  }

  Future<void> getCurrentLocation() async {
    if (!hasLocationPermission.value) {
      await checkLocationPermission();
      if (!hasLocationPermission.value) return;
    }

    try {
      isLocationLoading(true);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      currentLatitude(position.latitude);
      currentLongitude(position.longitude);

      // Get address from coordinates using geocoding
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          print(placemarks.first);
          Placemark place = placemarks.first;
          // Format the address in a readable way
          String formattedAddress = _formatAddress(place);
          currentAddress(formattedAddress);
        } else {
          // Fallback to coordinates if no placemark found
          currentAddress(
            'Location: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
          );
        }
      } catch (geocodeError) {
        print('Error getting address: $geocodeError');
        // Fallback to coordinates if geocoding fails
        currentAddress(
          'Location: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
        );
      }
    } catch (e) {
      print('Error getting current location: $e');
      locationErrorMessage('Failed to get current location');
    } finally {
      isLocationLoading(false);
    }
  }

// Helper function to format the address in a human-readable way
  String _formatAddress(Placemark place) {
    // Build address components list, only including non-empty values
    List<String> addressComponents = [
      if (place.name != null && place.name!.isNotEmpty) place.name!,
      if (place.street != null && place.street!.isNotEmpty) place.street!,
      if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty)
        place.thoroughfare!,
      if (place.subLocality != null && place.subLocality!.isNotEmpty)
        place.subLocality!,
      if (place.locality != null && place.locality!.isNotEmpty) place.locality!,
      if (place.postalCode != null && place.postalCode!.isNotEmpty)
        place.postalCode!,
      if (place.administrativeArea != null &&
          place.administrativeArea!.isNotEmpty)
        place.administrativeArea!,
      if (place.country != null && place.country!.isNotEmpty) place.country!,
    ];

    // Join non-empty components with commas
    String formattedAddress = addressComponents.join(', ');

    // If we couldn't get any address components, fall back to coordinates
    if (formattedAddress.isEmpty) {
      return 'Unknown location';
    }

    return formattedAddress;
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized(true);
    } catch (e) {
      print('Error initializing camera: $e');
      Get.snackbar(
        'Camera Error',
        'Failed to initialize camera. Please check permissions.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadAttendanceHistory() async {
    try {
      isLoading(true);

      final response = await apiclient.getR(
        ApiEndpoints.attendancedayData,
      );

      if (response is List && response.isNotEmpty) {
        final records =
            response.map((json) => AttendanceRecord.fromJson(json)).toList();
        attendanceRecords.value = records;

        // Check for ongoing session
        checkForOngoingSession();
        calculateTotalHoursToday();
      } else {
        attendanceRecords.clear();
        currentRecord.value = null;
      }
    } catch (e) {
      print('Error loading attendance history: $e');
      Get.snackbar(
        'Error',
        'Failed to load attendance history. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void checkForOngoingSession() {
    final today = DateTime.now();
    final todayRecords = attendanceRecords.where((record) {
      return record.checkInTime.year == today.year &&
          record.checkInTime.month == today.month &&
          record.checkInTime.day == today.day;
    }).toList();

    if (todayRecords.isNotEmpty) {
      todayRecords.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));

      for (var record in todayRecords) {
        print(record.checkout);
        if (record.checkout == "") {
          print("found ${record.toString()}");
          currentRecord(record);
          return;
        }
      }
      // No ongoing session found
      currentRecord(null);
    } else {
      currentRecord(null);
    }
  }

  void calculateTotalHoursToday() {
    final today = DateTime.now();
    final todayRecords = attendanceRecords.where((record) {
      return record.checkInTime.year == today.year &&
          record.checkInTime.month == today.month &&
          record.checkInTime.day == today.day;
    }).toList();

    double total = 0;
    for (var record in todayRecords) {
      if (record.checkout == "1") {
        // Completed session
        if (record.checkOutTime != null) {
          // Calculate time difference between check-in and check-out
          final difference =
              record.checkOutTime!.difference(record.checkInTime);
          final hours = difference.inSeconds / 3600; // Convert seconds to hours
          total += hours;
          print('Record ID ${record.id}: ${hours.toStringAsFixed(2)} hours');
        }
      } else {
        // Ongoing session (no checkout yet)
        final difference = DateTime.now().difference(record.checkInTime);
        final hours = difference.inSeconds / 3600; // Convert seconds to hours
        total += hours;
        print(
            'Ongoing Record ID ${record.id}: ${hours.toStringAsFixed(2)} hours (ongoing)');
      }
    }

    // Round to 2 decimal places for better display
    total = double.parse(total.toStringAsFixed(2));
    totalHoursToday(total);

    print('Total hours worked today: $total');
  }

  Future<void> handleAttendance() async {
    // Validation checks
    if (capturedImagePath.isEmpty) {
      Get.snackbar(
        'Error',
        'Please take a photo first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Get current location before proceeding
    if (!isLocationLoading.value) {
      await getCurrentLocation();
    }

    if (!hasLocationPermission.value) {
      Get.snackbar(
        'Location Required',
        'Please enable location services to mark attendance',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        icon: Icon(Icons.location_off, color: Colors.red[900]),
      );
      return;
    }

    try {
      isProcessing(true);

      // Convert image to base64 for API
      final File imageFile = File(capturedImagePath.value);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found');
      }

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Handle Check-In
      if (currentRecord.value == null) {
        final requestData = {
          "Id": "0",
          "UserId": box.read(StorageTags.userId),
          "Vdate": today,
          "Location": currentAddress.value,
          "Latitude": currentLatitude.value,
          "Longitude": currentLongitude.value,
          "Attendance": "1",
          "AttendanceType": "CHECKIN",
          "ImageBase64": "data:image/jpeg;base64,${base64Image}",
        };

        final response = await apiclient.postg(
          ApiEndpoints.checkinAttendance,
          data: requestData,
        );

        if (response is List &&
            response.isNotEmpty &&
            response[0]['status'] == 'success') {
          await loadAttendanceHistory();
          // final responseData = response[0];
          // final newRecord = AttendanceRecord(
          //   id: responseData['id'].toString(),
          //   checkInTime:
          //       DateFormat('M/d/yyyy h:mm:ss a').parse(responseData['date']),
          //   photoPath: capturedImagePath.value,
          //   status: responseData['status'],
          //   latitude:
          //       double.tryParse(responseData['checkinLatitude'].toString()),
          //   longitude:
          //       double.tryParse(responseData['checkinLongitude'].toString()),
          //   address: responseData['checkinLocation'],
          //   checkinImageUrl: responseData['checkinImageUrl'],
          //   dayOfWeek: responseData['dayOfWeek'],
          //   checkout: responseData['checkout']?.toString() ?? '',
          // );
          //
          // currentRecord(newRecord);
          // attendanceRecords.add(newRecord);
          calculateTotalHoursToday();

          // Show success animation or notification
          Get.snackbar(
            'Check-In Successful',
            'You have successfully checked in at ${DateFormat('hh:mm a').format(DateTime.now())}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
            duration: Duration(seconds: 3),
            icon: Icon(Icons.check_circle, color: Colors.green[900]),
          );

          // Clear image after successful check-in
          capturedImagePath('');
        } else {
          throw Exception('Server returned an invalid response for check-in');
        }
      }
      // Handle Check-Out
      else {
        final requestData = {
          "Id": currentRecord.value!.id,
          "UserId": box.read(StorageTags.userId),
          "Vdate": today,
          "Location": currentAddress.value,
          "Latitude": currentLatitude.value,
          "Longitude": currentLongitude.value,
          "AttendanceType": "CHECKOUT",
          "ImageBase64": "data:image/jpeg;base64,${base64Image}",
        };

        final response = await apiclient.postg(
          ApiEndpoints.checkinAttendance,
          data: requestData,
        );

        if (response is List &&
            response.isNotEmpty &&
            response[0]['status'] == 'success') {
          // Calculate hours worked for immediate UI update
          final now = DateTime.now();
          final difference = now.difference(currentRecord.value!.checkInTime);
          final hoursWorked = difference.inMinutes / 60;

          capturedImagePath('');

          calculateTotalHoursToday();
          print("checkedout");
          Get.back();

          Get.snackbar(
            'Check-Out Successfulllyyy',
            'You have successfully checked out. Total time: ${hoursWorked.toStringAsFixed(1)} hours',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.blue[100],
            colorText: Colors.blue[900],
            duration: Duration(seconds: 3),
            icon: Icon(Icons.check_circle, color: Colors.blue[900]),
          );

          // Show success notification

          // Clear image after successful check-out
        } else {
          throw Exception('Server returned an invalid response for check-out');
        }
      }
    } catch (e, stackTrace) {
      print('Error handling attendance: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        'Attendance Error',
        'Failed to process your attendance. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: Duration(seconds: 4),
        icon: Icon(Icons.error_outline, color: Colors.red[900]),
      );
    } finally {
      isProcessing(false);
    }
  }

  double calculateHoursWorked(DateTime checkInTime) {
    final now = DateTime.now();
    final difference = now.difference(checkInTime);
    return difference.inMinutes / 60;
  }

  // Camera related methods
  void openCamera() {
    showCamera(true);
    capturedImagePath('');
  }

  void closeCamera() {
    showCamera(false);
  }

  void retakePhoto() {
    capturedImagePath('');
    openCamera();
  }

  Future<void> captureImage() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        final XFile image = await cameraController!.takePicture();
        final Directory appDirectory = await getApplicationDocumentsDirectory();
        final String imagePath =
            '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await image.saveTo(imagePath);
        capturedImagePath(imagePath);
        showCamera(false);
      } catch (e) {
        print('Error capturing image: $e');
        Get.snackbar(
          'Camera Error',
          'Failed to capture image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    }
  }
}
