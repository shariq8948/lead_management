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
  var elapsedTime = 0.obs; // Time in seconds
  Timer? _timer;

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
          '${place.street},${place.subLocality}(${place.postalCode}),${place.locality},${place.administrativeArea},${place.country}'; // Update observable with address
    } catch (e) {
      location.value = 'Unable to fetch address.';
    } finally {
      isFetchingLocation.value = false;
    }
  }

  // Toggle Check-In/Check-Out
  Future<void> toggleCheckIn() async {
    if (isCheckedIn.value) {
      // Check Out
      isCheckedIn.value = false;
      checkOutTime.value = _getCurrentTime();
    } else {
      // Check In
      // Fetch location before setting checked-in state
      await fetchLocation();
      isCheckedIn.value = true;
      checkInTime.value = _getCurrentTime();
      checkOutTime.value = ''; // Reset check-out time
    }
  }

  // Get current time as a formatted string
  String _getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }

  // Start/stop audio recording
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      // Stop recording
      final path = await _recorder.stop();
      isRecording.value = false;

      if (path != null) {
        Get.snackbar('Recording Saved', 'File saved at: $path');
      } else {
        Get.snackbar('Recording Stopped', 'No file was saved.');
      }
      _maxDurationTimer
          ?.cancel(); // Cancel max duration timer when recording stops
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
        _startTimer(); // Start the timer for elapsed time tracking

        // Start a timer to stop recording when the max duration is reached
        _startMaxDurationTimer();
      } else {
        Get.snackbar(
            'Permission Denied', 'Recording permission is not granted.');
      }
    }
  }

  // Pause the recording
  Future<void> togglePause() async {
    if (isRecording.value && !isPaused.value) {
      await _recorder.pause();
      isPaused.value = true;
    } else if (isRecording.value && isPaused.value) {
      await _recorder.resume();
      isPaused.value = false;
    }
  }

  // Start a timer to track elapsed time
  void _startTimer() {
    _timer?.cancel(); // Cancel any previous timers
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      elapsedTime.value++;
    });
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
    await _recorder.stop();
    isRecording.value = false;
    isPaused.value = false;
    _timer?.cancel(); // Stop the timer
    _maxDurationTimer?.cancel(); // Cancel max duration timer
  }

  String get totalHours {
    if (checkInTime.value.isEmpty || checkOutTime.value.isEmpty) {
      return "00:00";
    }

    try {
      // Parse times into DateTime objects
      DateTime checkIn = DateFormat("HH:mm").parse(checkInTime.value);
      DateTime checkOut = DateFormat("HH:mm").parse(checkOutTime.value);

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

  @override
  void onClose() {
    _recorder.dispose(); // Clean up resources
    _timer?.cancel(); // Cancel the elapsed time timer
    _maxDurationTimer?.cancel(); // Cancel the max duration timer
    super.onClose();
  }
}
