import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'attendance_controller.dart';

class AttendancePage extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => controller.showCamera.value
            ? _buildCameraView()
            : _buildAttendanceView()),
      ),
    );
  }

  Widget _buildAttendanceView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 30),
            _buildCurrentTime(),
            SizedBox(height: 40),
            _buildPhotoSection(),
            SizedBox(height: 40),
            _buildStatsCard(),
            SizedBox(height: 20),
            _buildAttendanceHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // 'Hey ${Get.find<UserController>().userName}',
              "Hey Shariq",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${getGreeting()}! Mark your attendance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Obx(() => Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Today: ${controller.totalHoursToday.value.toStringAsFixed(1)}h',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildCurrentTime() {
    return Column(
      children: [
        Text(
          DateFormat('hh:mm a').format(DateTime.now()),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${DateFormat('MMM dd, yyyy - EEEE').format(DateTime.now())}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Obx(() {
      if (controller.isProcessing.value) {
        return Center(child: CircularProgressIndicator());
      }

      return controller.capturedImagePath.value.isNotEmpty
          ? _buildCapturedPhotoView()
          : _buildCameraButton();
    });
  }

  Widget _buildCapturedPhotoView() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  _showImagePreview(controller.capturedImagePath.value),
              child: Hero(
                tag: 'capturedImage',
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 8,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          FileImage(File(controller.capturedImagePath.value)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tap to preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              onPressed: () => controller.retakePhoto(),
              icon: Icons.refresh,
              label: 'Retake',
              isRetake: true,
            ),
            SizedBox(width: 20),
            _buildActionButton(
              onPressed: () => controller.handleAttendance(),
              icon: Icons.check_circle_outline,
              label: controller.currentRecord.value == null
                  ? 'Check In'
                  : 'Check Out',
              isRetake: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: () => controller.openCamera(),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: controller.currentRecord.value == null
              ? Colors.green
              : Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (controller.currentRecord.value == null
                      ? Colors.green
                      : Colors.red)
                  .withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 64,
            ),
            SizedBox(height: 8),
            Text(
              controller.currentRecord.value == null ? 'Check In' : 'Check Out',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isRetake,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: isRetake
            ? BorderSide(color: Colors.grey.shade300)
            : BorderSide.none,
      ),
      color: isRetake
          ? Colors.white
          : (controller.currentRecord.value == null
              ? Colors.green
              : Colors.red),
      elevation: 0,
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isRetake ? Colors.grey : Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isRetake ? Colors.grey[800] : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Obx(() {
        final currentRecord = controller.currentRecord.value;
        final checkInTime = currentRecord?.checkInTime;
        final checkOutTime = currentRecord?.checkOutTime;
        final hoursWorked = controller.totalHoursToday.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeInfo(
              Icons.login,
              'Last Check In',
              checkInTime != null
                  ? DateFormat('hh:mm a').format(checkInTime)
                  : '--:--',
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey.shade300,
            ),
            _buildTimeInfo(
              Icons.logout,
              'Last Check Out',
              checkOutTime != null
                  ? DateFormat('hh:mm a').format(checkOutTime)
                  : '--:--',
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey.shade300,
            ),
            _buildTimeInfo(
              Icons.timer,
              'Hours Today',
              '${hoursWorked.toStringAsFixed(1)}h',
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAttendanceHistory() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.attendanceRecords.isEmpty) {
        return Center(
          child: Text(
            'No attendance records for today',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.attendanceRecords.length,
            itemBuilder: (context, index) {
              final record = controller.attendanceRecords[index];
              return _buildAttendanceCard(record);
            },
          ),
        ],
      );
    });
  }

  Widget _buildAttendanceCard(AttendanceRecord record) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: record.checkOutTime != null
                    ? Colors.green.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
              ),
              child: Icon(
                record.checkOutTime != null ? Icons.check_circle : Icons.timer,
                color: record.checkOutTime != null ? Colors.green : Colors.blue,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.checkOutTime != null
                        ? 'Complete Shift'
                        : 'Ongoing Shift',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${DateFormat('hh:mm a').format(record.checkInTime)} - ' +
                        (record.checkOutTime != null
                            ? DateFormat('hh:mm a').format(record.checkOutTime!)
                            : 'Ongoing'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (record.hoursWorked != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${record.hoursWorked!.toStringAsFixed(1)}h',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(IconData icon, String label, String time) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700]),
        SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCameraView() {
    return Obx(() {
      if (!controller.isCameraInitialized.value) {
        return Center(child: CircularProgressIndicator());
      }

      return Stack(
        children: [
          Container(
            height: Get.height,
            child: CameraPreview(controller.cameraController!),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () => controller.closeCamera(),
                    shape: CircleBorder(),
                    color: Colors.white.withOpacity(0.3),
                    padding: EdgeInsets.all(15),
                    child: Icon(Icons.close, size: 35, color: Colors.white),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: MaterialButton(
                      onPressed: () => controller.captureImage(),
                      shape: CircleBorder(),
                      child:
                          Icon(Icons.camera_alt, size: 40, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showImagePreview(String imagePath) {
    Get.dialog(
      Dialog.fullscreen(
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black87,
    );
  }

  String getGreeting() {
    int currentHour = DateTime.now().hour;
    if (currentHour < 12) {
      return 'Good morning';
    } else if (currentHour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}
