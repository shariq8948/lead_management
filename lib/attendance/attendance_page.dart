import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../utils/tags.dart';
import 'attendance_controller.dart';

class AttendancePage extends StatelessWidget {
  final controller = Get.find<MarkAttendanceController>();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.loadAttendanceHistory();
              controller.getCurrentLocation();
            },
          ),
          // Obx(() => controller.isConnected.value
          //     ? SizedBox()
          //     : Padding(
          //         padding: const EdgeInsets.only(right: 16.0),
          //         child: Icon(Icons.cloud_off, color: Colors.red),
          //       )),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          // Check for connectivity first

          return controller.showCamera.value
              ? _buildCameraView()
              : _buildAttendanceView();
        }),
      ),
    );
  }

  Widget _buildOfflineModeBanner() {
    return Column(
      children: [
        Container(
          color: Colors.orange.withOpacity(0.2),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.orange[800]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You\'re offline. Some attendance records will sync when connection is restored.',
                  style: TextStyle(color: Colors.orange[800]),
                ),
              ),
              // TextButton(
              //   onPressed: () => controller.syncPendingAttendance(),
              //   child: Text('Retry'),
              // )
            ],
          ),
        ),
        Expanded(child: _buildAttendanceView()),
      ],
    );
  }

  Widget _buildAttendanceView() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadAttendanceHistory();
        await controller.getCurrentLocation();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 30),
// Usage with Obx for reactive state:
              Obx(() => HoursWidget(
                    totalHoursToday: controller.totalHoursToday.value,
                  )),
              SizedBox(height: 20),

              _buildCurrentTime(),
              SizedBox(height: 20),
              _buildLocationInfo(),
              SizedBox(height: 20),
              _buildPhotoSection(),
              SizedBox(height: 40),
              _buildStatsCard(),
              SizedBox(height: 20),
              _buildAttendanceHistory(),
              SizedBox(height: 50), // Extra space at bottom
            ],
          ),
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
              // Get actual username from storage
              "Hey ${controller.box.read(StorageTags.firstName) ?? 'User'}",
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
      ],
    );
  }

  Widget _buildCurrentTime() {
    return Column(
      children: [
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

  Widget _buildLocationInfo() {
    return Obx(() {
      if (controller.isLocationLoading.value) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Getting location...',
                  style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        );
      }

      if (controller.locationErrorMessage.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[100]!),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.locationErrorMessage.value,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ),
              TextButton(
                onPressed: () => controller.checkLocationPermission(),
                child: Text('Retry'),
              )
            ],
          ),
        );
      }

      if (controller.hasLocationPermission.value) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[100]!),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location: ${controller.currentLatitude.value.toStringAsFixed(6)}, ${controller.currentLongitude.value.toStringAsFixed(6)}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                    if (controller.currentAddress.isNotEmpty)
                      Text(
                        controller.currentAddress.value,
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 12),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.green),
                onPressed: () => controller.getCurrentLocation(),
              )
            ],
          ),
        );
      }

      // Default case - show button to get location
      return ElevatedButton.icon(
        onPressed: () => controller.checkLocationPermission(),
        icon: Icon(Icons.location_on),
        label: Text('Enable Location'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    });
  }

  Widget _buildPhotoSection() {
    return Obx(() {
      if (controller.isProcessing.value) {
        return Center(
            child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Processing your attendance...',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ));
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
              onPressed: () async {
                await controller.handleAttendance();
                // Clear the captured image after successful attendance handling
                if (!controller.isProcessing.value) {
                  controller.capturedImagePath('');
                }
              },
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
      onTap: () {
        if (!controller.hasLocationPermission.value) {
          controller.checkLocationPermission();
          Get.snackbar(
            'Location Required',
            'Please enable location to mark attendance',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        controller.openCamera();
      },
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
    // Create a simple RxInt that will be incremented each second to trigger rebuilds
    final clockTick = 0.obs;

    // Start the timer when the widget is built
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Create timer that updates clockTick every second
      Timer timer = Timer.periodic(Duration(seconds: 1), (_) {
        clockTick.value++;
      });

      // Store the timer reference for disposal (assuming controller has a timers list)
      try {
        if (controller.timers != null) {
          controller.timers.add(timer);
        }
      } catch (e) {
        // If controller doesn't have a timers list, we need another way to manage
        // the timer's lifecycle - one option would be to use ever() to cancel
        // when a specific value changes or the controller is disposed
        ever(
          Get.find<MarkAttendanceController>().isLoading,
          (_) {
            timer.cancel();
          },
        );
      }
    });

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
        // Listen to the clockTick to rebuild every second
        clockTick.value;

        final currentRecord = controller.currentRecord.value;
        final checkInTime = currentRecord?.checkInTime;
        final checkOutTime = currentRecord?.checkOutTime;

        // Find most recent check-in/check-out times if current record is null
        DateTime? lastCheckIn;
        DateTime? lastCheckOut;

        if (currentRecord == null) {
          final today = DateTime.now();
          final todayRecords = controller.attendanceRecords.where((record) {
            return record.checkInTime.year == today.year &&
                record.checkInTime.month == today.month &&
                record.checkInTime.day == today.day;
          }).toList();

          if (todayRecords.isNotEmpty) {
            // Sort by check-in time (latest first)
            todayRecords.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));
            lastCheckIn = todayRecords.first.checkInTime;

            // Find latest check-out
            for (var record in todayRecords) {
              if (record.checkOutTime != null) {
                lastCheckOut = record.checkOutTime;
                break;
              }
            }
          }
        }

        // Calculate session duration
        String sessionDuration = '--:--:--';
        String sessionLabel = 'Current Session';

        // Format duration as HH:MM:SS
        String formatDuration(Duration duration) {
          final hours = duration.inHours.toString().padLeft(2, '0');
          final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          return '$hours:$minutes:$seconds';
        }

        if (checkInTime != null) {
          if (checkOutTime != null) {
            // Last session (completed)
            final duration = checkOutTime.difference(checkInTime);
            sessionDuration = formatDuration(duration);
            sessionLabel = 'Last Session';
          } else {
            // Current session (ongoing) - updates every second thanks to clockTick
            final duration = DateTime.now().difference(checkInTime);
            sessionDuration = formatDuration(duration);
            sessionLabel = 'Current Session';
          }
        } else if (lastCheckIn != null && lastCheckOut != null) {
          // No current record, but we have past records for today
          final duration = lastCheckOut.difference(lastCheckIn);
          sessionDuration = formatDuration(duration);
          sessionLabel = 'Last Session';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeInfo2(
              Icons.login,
              'Last Check In',
              checkInTime != null
                  ? DateFormat('hh:mm a').format(checkInTime)
                  : lastCheckIn != null
                      ? DateFormat('hh:mm a').format(lastCheckIn)
                      : '--:--',
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey.shade300,
            ),
            _buildTimeInfo2(
              Icons.logout,
              'Last Check Out',
              checkOutTime != null
                  ? DateFormat('hh:mm a').format(checkOutTime)
                  : lastCheckOut != null
                      ? DateFormat('hh:mm a').format(lastCheckOut)
                      : '--:--',
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey.shade300,
            ),
            _buildTimeInfo2(
              Icons.timer,
              sessionLabel,
              sessionDuration,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAttendanceHistory() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading attendance records...'),
            ],
          ),
        );
      }

      // Filter records for today only
      final today = DateTime.now();
      final todayRecords = controller.attendanceRecords.where((record) {
        return record.checkInTime.year == today.year &&
            record.checkInTime.month == today.month &&
            record.checkInTime.day == today.day;
      }).toList();

      // Sort records by check-in time (latest first)
      todayRecords.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));

      if (todayRecords.isEmpty) {
        return Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[300]),
              SizedBox(height: 16),
              Text(
                'No attendance records for today',
                style: TextStyle(color: Colors.grey),
              ),
            ],
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
            itemCount: todayRecords.length,
            itemBuilder: (context, index) {
              final record = todayRecords[index];
              return buildAttendanceCard(record);
            },
          ),
        ],
      );
    });
  }

  Widget buildAttendanceCard(AttendanceRecord record) {
    // Check if this record is pending sync
    final isPendingSync = record.status == 'pending_sync';
    // Determine if record has checked out
    final hasCheckedOut = record.checkout != "0" && record.checkout != "";
    // Get status color and icon
    final statusColor = isPendingSync
        ? Colors.orange
        : hasCheckedOut
            ? Colors.green
            : Colors.blue;
    final statusIcon = isPendingSync
        ? Icons.sync
        : hasCheckedOut
            ? Icons.check_circle
            : Icons.timer;
    final statusText = isPendingSync
        ? 'Pending Sync'
        : hasCheckedOut
            ? 'Complete Shift'
            : 'Ongoing Shift';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header
          Container(
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor),
                SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeInfo(
                  Icons.login,
                  'Check In',
                  DateFormat('hh:mm a').format(record.checkInTime),
                  "${box.read(StorageTags.baseUrl)}${record.checkinImageUrl}",
                  Colors.blue,
                ),
                Container(
                  height: 70,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildTimeInfo(
                  Icons.logout,
                  'Check Out',
                  hasCheckedOut && record.checkOutTime != null
                      ? DateFormat('hh:mm a').format(record.checkOutTime!)
                      : hasCheckedOut
                          ? 'Checked out'
                          : '—',
                  "${box.read(StorageTags.baseUrl)}${record.checkoutImageUrl}",
                  hasCheckedOut ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ),

          // Hours counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Hours worked
                Expanded(
                  child: hasCheckedOut && record.hoursWorked != null
                      ? Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Hours: ',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              '${record.hoursWorked!.toStringAsFixed(1)}h',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        )
                      : !hasCheckedOut
                          ? StreamBuilder(
                              stream: Stream.periodic(
                                  Duration(minutes: 1), (_) => DateTime.now()),
                              initialData: DateTime.now(),
                              builder: (context, snapshot) {
                                final difference = snapshot.data!
                                    .difference(record.checkInTime);
                                final hours = difference.inMinutes / 60;
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Ongoing: ',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      '${hours.toStringAsFixed(1)}h',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Container(),
                ),

                // Location info
                if (record.latitude != null && record.longitude != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${record.latitude!.toStringAsFixed(4)}, ${record.longitude!.toStringAsFixed(4)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Address (if available)
          if (record.address != null && record.address!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.place,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      record.address!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(
      IconData icon, String label, String time, String? imageUrl, Color color) {
    return Column(
      children: [
        if (imageUrl != null && imageUrl.isNotEmpty)
          GestureDetector(
            onTap: () {
              // Use GetX to navigate to the image viewer
              Get.to(
                () => ImageViewerScreen(
                  imageUrl: imageUrl,
                  title: label,
                ),
                transition: Transition.zoom,
              );
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
        SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color == Colors.grey ? Colors.grey.shade400 : color,
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

  Widget _buildTimeInfo2(IconData icon, String label, String time) {
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Initializing camera...'),
            ],
          ),
        );
      }

      return Stack(
        children: [
          Container(
            height: Get.height,
            child: CameraPreview(controller.cameraController!),
          ),
          // Camera UI overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Text(
                'Please look at the camera',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Face outline guide
          Positioned.fill(
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
          // Camera controls
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
                  MaterialButton(
                    onPressed: () {
                      // Switch camera if available
                      // This could be implemented in the controller
                    },
                    shape: CircleBorder(),
                    color: Colors.white.withOpacity(0.3),
                    padding: EdgeInsets.all(15),
                    child: Icon(Icons.flip_camera_ios,
                        size: 35, color: Colors.white),
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

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ImageViewerScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Image could not be loaded',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class HoursWidget extends StatelessWidget {
  final double totalHoursToday;
  final String label;

  const HoursWidget({
    Key? key,
    required this.totalHoursToday,
    this.label = 'Today',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine color scheme and message based on hours
    Color borderColor;
    Color textColor;
    Color backgroundColor;
    String statusEmoji;
    String statusMessage;

    if (totalHoursToday < 4.0) {
      // Less than 4 hours - Red theme
      borderColor = Colors.red.shade400;
      textColor = Colors.red.shade700;
      backgroundColor = Colors.red.withOpacity(0.08);
      statusEmoji = '⚠️';
      statusMessage = "Need to pick up the pace!";
    } else if (totalHoursToday < 8.0) {
      // Between 4 and 8 hours - Blue theme
      borderColor = Colors.blue.shade400;
      textColor = Colors.blue.shade700;
      backgroundColor = Colors.blue.withOpacity(0.08);
      statusEmoji = '⏱️';
      statusMessage = "Making progress, keep going!";
    } else {
      // 8 or more hours - Green theme
      borderColor = Colors.green.shade400;
      textColor = Colors.green.shade700;
      backgroundColor = Colors.green.withOpacity(0.08);
      statusEmoji = '🌟';
      statusMessage = "Great job today!";
    }

    return Container(
      width: 280, // Making it wider
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.25),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: borderColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusEmoji,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hours Tracker",
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${totalHoursToday.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        ' hours',
                        style: TextStyle(
                          color: textColor.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              statusMessage,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: totalHoursToday / 8.0, // Using 8 hours as target
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(borderColor),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}
