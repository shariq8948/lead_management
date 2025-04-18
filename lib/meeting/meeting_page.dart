import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/custom_loader.dart';
import 'meeting_controller.dart';

class MeetingPage extends StatelessWidget {
  final MeetingController controller = Get.put(MeetingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting'),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.teal.shade50, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Digital Clock in Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StreamBuilder(
                        stream: Stream.periodic(Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          final currentTime = DateTime.now();
                          final formattedTime =
                              '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}';
                          final formattedDate =
                              '${currentTime.day.toString().padLeft(2, '0')} ${[
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ][currentTime.month - 1]} ${currentTime.year}';
                          return Column(
                            children: [
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueGrey[600],
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Start/End Meeting Button
                  Center(
                    child: GestureDetector(
                      onTap: () => controller.toggleCheckIn(),
                      child: Obx(() {
                        return Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isCheckedIn.value
                                ? Colors.redAccent
                                : Colors.teal,
                            boxShadow: [
                              BoxShadow(
                                color: (controller.isCheckedIn.value
                                        ? Colors.redAccent
                                        : Colors.teal)
                                    .withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: controller.isCheckedIn.value
                                  ? [Colors.red.shade300, Colors.red.shade700]
                                  : [
                                      Colors.teal.shade300,
                                      Colors.teal.shade700
                                    ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  controller.isCheckedIn.value
                                      ? Icons.stop_circle_outlined
                                      : Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 8),
                                Obx(() => Text(
                                      controller.isCheckedIn.value
                                          ? 'End Meeting'
                                          : 'Start Meeting',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Location Display
                  Obx(() {
                    return (controller.isCheckedIn.value)
                        ? Container(
                            padding: EdgeInsets.all(16.0),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 36,
                                  color: Colors.teal,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Location',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        controller.location.value.isEmpty
                                            ? 'Fetching location...'
                                            : controller.location.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  }),

                  SizedBox(height: 20),

                  // Meeting Times Cards
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Start Time
                        Expanded(
                          child: Obx(() => _buildTimeCard(
                                icon: Icons.login,
                                time: controller.checkInTime.value.isNotEmpty
                                    ? controller.checkInTime.value
                                    : "00:00",
                                label: "Start Time",
                                iconColor: Colors.teal,
                              )),
                        ),
                        // End Time
                        Expanded(
                          child: Obx(() => _buildTimeCard(
                                icon: Icons.logout,
                                time: controller.checkOutTime.value.isNotEmpty
                                    ? controller.checkOutTime.value
                                    : "00:00",
                                label: "End Time",
                                iconColor: Colors.redAccent,
                              )),
                        ),
                        // Total Duration
                        Expanded(
                          child: Obx(() => _buildTimeCard(
                                icon: Icons.access_time,
                                time: controller.totalHours.isNotEmpty
                                    ? controller.totalHours
                                    : "00:00",
                                label: "Duration",
                                iconColor: Colors.blueGrey,
                              )),
                        ),
                      ],
                    ),
                  ),

                  // Recording Timer Display (NEW)
                  Obx(() {
                    if (controller.isCheckedIn.value &&
                        controller.isRecording.value) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.isPaused.value
                                    ? Colors.orange
                                    : Colors.red,
                              ),
                              child: controller.isPaused.value
                                  ? null
                                  : StreamBuilder(
                                      stream: Stream.periodic(
                                          Duration(milliseconds: 500)),
                                      builder: (context, snapshot) {
                                        return AnimatedOpacity(
                                          opacity:
                                              (DateTime.now().millisecond > 500)
                                                  ? 1.0
                                                  : 0.3,
                                          duration: Duration(milliseconds: 300),
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            SizedBox(width: 16),
                            StreamBuilder(
                              stream: Stream.periodic(Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                // This would come from your controller in a real implementation
                                String recordingTime =
                                    controller.getRecordingTime();
                                return Text(
                                  'Recording: $recordingTime',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: controller.isPaused.value
                                        ? Colors.orange
                                        : Colors.red,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  Spacer(),

                  // Recording Controls (only appear after Meeting Start)
                  Obx(() {
                    if (controller.isCheckedIn.value) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Recording Controls",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Record/Stop Button
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        controller.toggleRecording(),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      backgroundColor: controller
                                              .isRecording.value
                                          ? Colors.red // Stop button color
                                          : Colors.teal, // Start button color
                                      elevation: 3,
                                    ),
                                    icon: Icon(
                                      controller.isRecording.value
                                          ? Icons.stop
                                          : Icons.fiber_manual_record,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      controller.isRecording.value
                                          ? "Stop"
                                          : "Record",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),

                                  // Pause/Resume Button (only visible when recording)
                                  if (controller.isRecording.value)
                                    ElevatedButton.icon(
                                      onPressed: () => controller.togglePause(),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        backgroundColor: controller
                                                .isPaused.value
                                            ? Colors
                                                .green // Resume button color
                                            : Colors
                                                .orange, // Pause button color
                                        elevation: 3,
                                      ),
                                      icon: Icon(
                                        controller.isPaused.value
                                            ? Icons.play_arrow
                                            : Icons.pause,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        controller.isPaused.value
                                            ? "Resume"
                                            : "Pause",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.meeting_room_outlined,
                              size: 48,
                              color: Colors.grey.shade500,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Start your meeting to access recording controls",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),

          // Show Loader if isFetchingLocation is true
          Obx(() {
            if (controller.isFetchingLocation.value) {
              return Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoader(size: 80),
                      SizedBox(height: 24),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Fetching Location',
                            textStyle: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                        totalRepeatCount: 4,
                        pause: const Duration(milliseconds: 100),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      )
                    ],
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildTimeCard({
    required IconData icon,
    required String time,
    required String label,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor,
            ),
            SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
