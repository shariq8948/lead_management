import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AttendanceRecord {
  final String id;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String photoPath;
  final String status;
  final double? hoursWorked;

  AttendanceRecord({
    required this.id,
    required this.checkInTime,
    this.checkOutTime,
    required this.photoPath,
    required this.status,
    this.hoursWorked,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'checkInTime': checkInTime.toIso8601String(),
        'checkOutTime': checkOutTime?.toIso8601String(),
        'photoPath': photoPath,
        'status': status,
        'hoursWorked': hoursWorked,
      };

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      checkInTime: DateTime.parse(
          json['checkInTime'] ?? DateTime.now().toIso8601String()),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      photoPath: json['photoPath'] ?? '',
      status: json['status'] ?? '',
      hoursWorked: json['hoursWorked']?.toDouble(),
    );
  }
}

// Update the AttendanceService class in attendance_service.dart

class AttendanceService {
  Future<Map<String, dynamic>> checkIn(String photoPath) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    final now = DateTime.now();
    return {
      'status': 'success',
      'message': 'Checked in successfully',
      'data': {
        'id': now.millisecondsSinceEpoch.toString(),
        'checkInTime': now.toIso8601String(),
        'photoPath': photoPath,
        'status': 'checked_in'
      }
    };
  }

  Future<Map<String, dynamic>> checkOut(
      String id, String photoPath, double hoursWorked) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    final now = DateTime.now();
    return {
      'status': 'success',
      'message': 'Checked out successfully',
      'data': {
        'id': id,
        'checkOutTime': now.toIso8601String(),
        'photoPath': photoPath,
        'status': 'checked_out',
        'hoursWorked': hoursWorked
      }
    };
  }

  Future<List<Map<String, dynamic>>> getAttendanceHistory() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return []; // Return empty list initially
  }
}
// attendance_service.dart

// attendance_controller.dart
class AttendanceController extends GetxController {
  final AttendanceService _attendanceService = AttendanceService();
  CameraController? cameraController;

  final isCameraInitialized = false.obs;
  final showCamera = false.obs;
  final isLoading = false.obs;
  final capturedImagePath = ''.obs;

  final currentRecord = Rxn<AttendanceRecord>();
  final attendanceRecords = <AttendanceRecord>[].obs;

  final totalHoursToday = 0.0.obs;
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
    loadAttendanceHistory();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
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
      final response = await _attendanceService.getAttendanceHistory();
      attendanceRecords.value =
          response.map((json) => AttendanceRecord.fromJson(json)).toList();
      calculateTotalHoursToday();
    } catch (e) {
      print('Error loading attendance history: $e');
    } finally {
      isLoading(false);
    }
  }

  void calculateTotalHoursToday() {
    final today = DateTime.now();
    final todayRecords = attendanceRecords.where((record) {
      return record.checkInTime.year == today.year &&
          record.checkInTime.month == today.month &&
          record.checkInTime.day == today.day;
    });

    double total = 0;
    for (var record in todayRecords) {
      if (record.hoursWorked != null) {
        total += record.hoursWorked!;
      }
    }
    totalHoursToday(total);
  }

  Future<void> handleAttendance() async {
    if (capturedImagePath.isEmpty) {
      Get.snackbar(
        'Error',
        'Please take a photo first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isProcessing(true);

      if (currentRecord.value == null) {
        // Check In
        final response =
            await _attendanceService.checkIn(capturedImagePath.value);
        if (response['status'] == 'success' && response['data'] != null) {
          final newRecord = AttendanceRecord(
            id: response['data']['id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            checkInTime: DateTime.parse(response['data']['checkInTime']),
            photoPath: response['data']['photoPath'],
            status: response['data']['status'],
          );
          currentRecord(newRecord);
          attendanceRecords.add(newRecord);
        }
      } else {
        // Check Out
        final hoursWorked =
            calculateHoursWorked(currentRecord.value!.checkInTime);
        final response = await _attendanceService.checkOut(
          currentRecord.value!.id,
          capturedImagePath.value,
          hoursWorked,
        );

        if (response['status'] == 'success' && response['data'] != null) {
          final updatedRecord = AttendanceRecord(
            id: currentRecord.value!.id,
            checkInTime: currentRecord.value!.checkInTime,
            checkOutTime: DateTime.parse(response['data']['checkOutTime']),
            photoPath: response['data']['photoPath'],
            status: response['data']['status'],
            hoursWorked: response['data']['hoursWorked']?.toDouble(),
          );

          final index = attendanceRecords
              .indexWhere((record) => record.id == currentRecord.value!.id);
          if (index != -1) {
            attendanceRecords[index] = updatedRecord;
          }
          currentRecord(null);
          calculateTotalHoursToday();
        }
      }

      capturedImagePath('');
      Get.snackbar(
        'Success',
        currentRecord.value == null
            ? 'Checked out successfully'
            : 'Checked in successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      print('Error handling attendance: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Failed to process attendance. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
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

  // Camera related methods remain the same
  void openCamera() {
    showCamera(true);
    capturedImagePath('');
  }

  void closeCamera() {
    showCamera(false);
    if (capturedImagePath.isEmpty) {
      capturedImagePath('');
    }
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
          'Error',
          'Failed to capture image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
