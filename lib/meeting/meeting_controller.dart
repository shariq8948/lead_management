import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:record/record.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

class MeetingController extends GetxController {
  var location = ''.obs; // Observable for location (address)
  var isCheckedIn = false.obs; // Observable for check-in/out state
  var checkInTime = ''.obs; // Observable for check-in time
  var checkOutTime = ''.obs; // Observable for check-out time
  var isRecording = false.obs; // Observable for recording state
  var isPaused = false.obs; // Observable to track pause state
  final AudioRecorder _recorder = AudioRecorder(); // Instance of the recorder

  // Recording time tracking
  var recordingDurationInSeconds = 0.obs; // Total recording time in seconds
  DateTime? recordingStartTime;
  DateTime? recordingPauseTime;
  var totalPausedTime = 0.obs; // Total time spent in paused state (seconds)

  Timer? _recordingTimer;

  // Flag to prevent redundant location fetch requests
  RxBool isFetchingLocation = false.obs;

  // Define a maximum recording duration (e.g., 10 minutes)
  Duration maxDuration = Duration(minutes: 10);
  Timer? _maxDurationTimer;

  // Fetch current location (latitude and longitude converted to address)
  Future<void> fetchLocation() async {
    if (isFetchingLocation.value)
      return; // Avoid fetching location if already in progress
    isFetchingLocation.value = true;

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      location.value = 'Location services are disabled.';
      isFetchingLocation.value = false;
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        location.value = 'Location permissions are denied.';
        isFetchingLocation.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      location.value = 'Location permissions are permanently denied.';
      isFetchingLocation.value = false;
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    // Reverse geocode: convert latitude and longitude to a human-readable address
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the address from the placemark
      Placemark place = placemarks[0];
      location.value =
          '${place.street}, ${place.subLocality} ${place.postalCode}, ${place.locality}, ${place.administrativeArea}, ${place.country}'; // Update observable with address
    } catch (e) {
      location.value = 'Unable to fetch address.';
    } finally {
      isFetchingLocation.value = false;
    }
  }

  // Toggle Check-In/Check-Out (now Start/End Meeting)
  Future<void> toggleCheckIn() async {
    if (isCheckedIn.value) {
      // End Meeting
      isCheckedIn.value = false;
      checkOutTime.value = _getCurrentTime();

      // If recording is active, stop it
      if (isRecording.value) {
        await stopRecording();
      }
    } else {
      // Start Meeting
      // Fetch location before setting checked-in state
      await fetchLocation();
      isCheckedIn.value = true;
      checkInTime.value = _getCurrentTime();
      checkOutTime.value = ''; // Reset check-out time

      // Reset recording-related values
      recordingDurationInSeconds.value = 0;
      totalPausedTime.value = 0;
    }
  }

  // Get current time as a formatted string
  String _getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }

  // Get formatted recording time (HH:MM:SS)
  String getRecordingTime() {
    int seconds = recordingDurationInSeconds.value;
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;

    minutes = minutes % 60;
    seconds = seconds % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // Start/stop audio recording
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      // Stop recording
      await stopRecording();
    } else {
      // Request permissions and start recording
      if (await _recorder.hasPermission()) {
        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc), // Configuration
          path:
              '/storage/emulated/0/Download/audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );
        isRecording.value = true;
        isPaused.value =
            false; // Reset the pause state when starting a new recording
        recordingStartTime = DateTime.now();
        recordingDurationInSeconds.value = 0;
        totalPausedTime.value = 0;

        // Start a timer to track recording duration
        _startRecordingTimer();

        // Start a timer to stop recording when the max duration is reached
        _startMaxDurationTimer();
      } else {
        Get.snackbar(
            'Permission Denied', 'Recording permission is not granted.');
      }
    }
  }

  // Start a timer to update recording duration every second
  void _startRecordingTimer() {
    _recordingTimer?.cancel(); // Cancel any previous timers
    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused.value) {
        recordingDurationInSeconds.value++;
      }
    });
  }

  // Pause/Resume the recording
  Future<void> togglePause() async {
    if (isRecording.value && !isPaused.value) {
      // Pause recording
      await _recorder.pause();
      isPaused.value = true;
      recordingPauseTime = DateTime.now();
    } else if (isRecording.value && isPaused.value) {
      // Resume recording
      await _recorder.resume();
      isPaused.value = false;
      recordingPauseTime = null;
    }
  }

  // Start a timer to stop recording after max duration
  void _startMaxDurationTimer() {
    _maxDurationTimer?.cancel(); // Cancel any previous timers
    _maxDurationTimer = Timer(maxDuration, () async {
      // Automatically stop recording when max duration is reached
      await stopRecording();
      Get.snackbar('Recording Stopped', 'Max recording duration reached.');
    });
  }

  // Stop recording
  Future<void> stopRecording() async {
    final path = await _recorder.stop();
    isRecording.value = false;
    isPaused.value = false;

    if (_recordingTimer != null) {
      _recordingTimer!.cancel();
      _recordingTimer = null;
    }

    _maxDurationTimer?.cancel();

    if (path != null) {
      Get.snackbar('Recording Saved', 'File saved at: $path');
    } else {
      Get.snackbar('Recording Stopped', 'No file was saved.');
    }

    recordingStartTime = null;
    recordingPauseTime = null;
  }

  // Calculate total meeting time
  String get totalHours {
    if (checkInTime.value.isEmpty) {
      return "00:00";
    }

    if (checkOutTime.value.isEmpty) {
      // Meeting still in progress, calculate time from check-in until now
      try {
        // Parse check-in time
        DateTime now = DateTime.now();
        DateTime checkIn = DateFormat("hh:mm a").parse(checkInTime.value);

        // Adjust check-in to today's date
        checkIn = DateTime(
            now.year, now.month, now.day, checkIn.hour, checkIn.minute);

        // Calculate the duration
        Duration difference = now.difference(checkIn);
        int hours = difference.inHours;
        int minutes = difference.inMinutes % 60;

        // Return formatted time
        return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
      } catch (e) {
        return "00:00"; // Fallback in case of parsing errors
      }
    } else {
      // Meeting completed, calculate time from check-in to check-out
      try {
        // Parse times into DateTime objects
        DateTime checkIn = DateFormat("hh:mm a").parse(checkInTime.value);
        DateTime checkOut = DateFormat("hh:mm a").parse(checkOutTime.value);

        // Handle cases where checkout is on the next day
        if (checkOut.isBefore(checkIn)) {
          checkOut = checkOut.add(Duration(hours: 24));
        }

        // Calculate the duration
        Duration difference = checkOut.difference(checkIn);
        int hours = difference.inHours;
        int minutes = difference.inMinutes % 60;

        // Return formatted time
        return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
      } catch (e) {
        return "00:00"; // Fallback in case of parsing errors
      }
    }
  }

  @override
  void onClose() {
    _recorder.dispose(); // Clean up resources
    _recordingTimer?.cancel(); // Cancel the recording time timer
    _maxDurationTimer?.cancel(); // Cancel the max duration timer
    super.onClose();
  }
}
