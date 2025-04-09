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
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Digital Clock
                StreamBuilder(
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),

                // Check In/Check Out Button
                Center(
                  child: GestureDetector(
                    onTap: () => controller.toggleCheckIn(),
                    child: Obx(() {
                      return Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.isCheckedIn.value
                              ? Colors.red
                              : Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: (controller.isCheckedIn.value
                                      ? Colors.red
                                      : Colors.green)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.touch_app,
                                  color: Colors.white, size: 40),
                              Obx(() => Text(
                                    controller.isCheckedIn.value
                                        ? 'Check Out'
                                        : 'Check In',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),

                // Location Display
                Obx(() {
                  return (controller.isCheckedIn.value)
                      ? Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.teal, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(2, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 40,
                                color: Colors.teal,
                              ),
                              SizedBox(height: 10),
                              Text(
                                controller.location.value.isEmpty
                                    ? 'Tap Check In to get location'
                                    : 'Location:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              if (controller.location.value.isNotEmpty)
                                Text(
                                  controller.location.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : SizedBox.shrink();
                }),

                SizedBox(height: 20),

                // Check-In/Check-Out Times
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Check-In Card
                      Obx(() => _buildTimeCard(
                            icon: Icons.arrow_circle_down_outlined,
                            time: controller.checkInTime.value.isNotEmpty
                                ? controller.checkInTime.value
                                : "00:00",
                            label: "Check In",
                            iconColor: Colors.green,
                          )),
                      // Check-Out Card
                      Obx(() => _buildTimeCard(
                            icon: Icons.arrow_circle_up_outlined,
                            time: controller.checkOutTime.value.isNotEmpty
                                ? controller.checkOutTime.value
                                : "00:00",
                            label: "Check Out",
                            iconColor: Colors.red,
                          )),
                      // Total Hours Card
                      Obx(() => _buildTimeCard(
                            icon: Icons.access_time_outlined,
                            time: controller.totalHours.isNotEmpty
                                ? controller.totalHours
                                : "00:00",
                            label: "Total Hrs",
                            iconColor: Colors.teal,
                          )),
                    ],
                  ),
                ),
                Spacer(),

                // Recording Controls (only appear after Check-In)
                Obx(() {
                  if (controller.isCheckedIn.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Displaying current state (Recording, Paused, etc.)
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Icon(
                            controller.isRecording.value
                                ? (controller.isPaused.value
                                    ? Icons.pause_circle_filled
                                    : Icons.record_voice_over)
                                : null,
                            size: 50,
                            color: controller.isRecording.value
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () => controller.toggleRecording(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: controller.isRecording.value
                                ? Colors.red // Stop button color
                                : Colors.orange, // Start button color
                            elevation: 5, // Slight shadow for the button
                          ),
                          child: Obx(() => Icon(
                                controller.isRecording.value
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                size: 30,
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(height: 15),

                        // Pause/Resume Button
                        if (controller.isRecording.value)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => controller.togglePause(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.isPaused.value
                                      ? Colors.green // Resume button color
                                      : Colors.blue, // Pause button color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5, // Slight shadow
                                ),
                                child: Obx(() => Icon(
                                      controller.isPaused.value
                                          ? Icons.play_arrow
                                          : Icons.pause,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),

          // Show Loader if isFetchingLocation is true
          Obx(() {
            if (controller.isFetchingLocation.value) {
              return Container(
                color:
                    Colors.black.withOpacity(0.5), // Semi-transparent overlay
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoader(
                        size: 80,
                      ), // Loading spinner
                      SizedBox(height: 20),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Fetching Location',
                            textStyle: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
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
            return SizedBox.shrink(); // Empty space when not fetching location
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 40,
          color: iconColor,
        ),
        SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
    );
  }
}
