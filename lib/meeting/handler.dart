// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart'; // Add this package
// import 'package:ffmpeg_kit_flutter/return_code.dart'; // Add this package
// import '../utils/tags.dart';
//
// class MeetingRecordingHandler extends GetxController {
//   // Singleton instance
//   static MeetingRecordingHandler get instance =>
//       Get.find<MeetingRecordingHandler>();
//
//   // Constants for storage
//   static const String RECORDING_ACTIVE = 'meeting_recording_active';
//   static const String RECORDING_PATH = 'meeting_recording_path';
//   static const String RECORDING_START_TIME = 'meeting_recording_start_time';
//   static const String ELAPSED_TIME = 'meeting_recording_elapsed_time';
//   static const String RECORDING_PAUSED = 'meeting_recording_paused';
//   static const String CHECK_IN_TIME = 'meeting_check_in_time';
//   static const String CHECK_OUT_TIME = 'meeting_check_out_time';
//   static const String IS_CHECKED_IN = 'meeting_is_checked_in';
//   static const String LOCATION_DATA = 'meeting_location_data';
//   static const String RECORDING_SEGMENTS = 'meeting_recording_segments';
//   static const String CURRENT_SESSION_ID = 'meeting_recording_session_id';
//
//   // Observable properties
//   final isRecording = false.obs;
//   final isPaused = false.obs;
//   final elapsedTime = 0.obs;
//   final recordingPath = RxString('');
//   final recordingSegments = <String>[].obs;
//   final currentSessionId = RxString('');
//
//   // Private members
//   final AudioRecorder _recorder = AudioRecorder();
//   Timer? _elapsedTimer;
//   Timer? _autoSaveTimer;
//   final box = GetStorage();
//   bool _isResuming = false;
//   bool _isProcessingSegments = false;
//
//   // Initialize the handler
//   static Future<void> init() async {
//     if (!GetStorage().hasData('initialized_recording_handler')) {
//       final tempDir = await getTemporaryDirectory();
//       final recordingsDir = Directory('${tempDir.path}/meeting_recordings');
//       if (!await recordingsDir.exists()) {
//         await recordingsDir.create(recursive: true);
//       }
//
//       await GetStorage().write('recording_save_directory', recordingsDir.path);
//       await GetStorage().write('initialized_recording_handler', true);
//     }
//
//     // Register the handler if not already registered
//     if (!Get.isRegistered<MeetingRecordingHandler>()) {
//       Get.put(MeetingRecordingHandler());
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadSavedState();
//     _startAutoSaveTimer();
//   }
//
//   @override
//   void onClose() {
//     _elapsedTimer?.cancel();
//     _autoSaveTimer?.cancel();
//     _recorder.dispose();
//     super.onClose();
//   }
//
//   // Generate a unique session ID
//   String _generateSessionId() {
//     return DateTime.now().millisecondsSinceEpoch.toString();
//   }
//
//   // Load saved recording state on init
//   Future<void> _loadSavedState() async {
//     try {
//       final isActive = box.read<bool>(RECORDING_ACTIVE) ?? false;
//       final path = box.read<String>(RECORDING_PATH);
//       final savedElapsedTime = box.read<int>(ELAPSED_TIME) ?? 0;
//       final wasPaused = box.read<bool>(RECORDING_PAUSED) ?? false;
//       final segments =
//           box.read<List<dynamic>>(RECORDING_SEGMENTS)?.cast<String>() ??
//               <String>[];
//       final sessionId = box.read<String>(CURRENT_SESSION_ID) ?? '';
//
//       recordingSegments.value = List<String>.from(segments);
//       elapsedTime.value = savedElapsedTime;
//       currentSessionId.value =
//           sessionId.isNotEmpty ? sessionId : _generateSessionId();
//
//       if (isActive && segments.isNotEmpty) {
//         // Set state properties but don't resume yet
//         isRecording.value = true;
//         isPaused.value = wasPaused;
//         recordingPath.value =
//             path ?? (segments.isNotEmpty ? segments.last : '');
//
//         // Start tracking elapsed time if recording was active
//         if (!wasPaused) {
//           _startElapsedTimer();
//         }
//
//         // If recording was active, show notification to the user
//         Get.snackbar(
//           'Recording Detected',
//           'Your previous meeting recording was interrupted. Tap to restore.',
//           duration: Duration(seconds: 7),
//           onTap: (_) => _handleRecordingRecovery(),
//         );
//       }
//     } catch (e) {
//       print('❌ Error loading recording state: $e');
//     }
//   }
//
//   // Handle recovery of interrupted recording
//   Future<void> _handleRecordingRecovery() async {
//     Get.dialog(
//       AlertDialog(
//         title: Text('Recording Recovery'),
//         content: Text(
//             'Your recording was interrupted (${recordingSegments.length} segments found). Would you like to continue from where you left off, discard, or save what you have?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back();
//               discardRecording();
//               startNewRecording();
//             },
//             child: Text('DISCARD & START NEW'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Get.back();
//               // Save and finalize the segments we have
//               final mergedPath = await mergeRecordingSegments();
//               if (mergedPath != null) {
//                 Get.snackbar(
//                   'Recording Saved',
//                   'Previous recording saved at: $mergedPath',
//                   duration: Duration(seconds: 5),
//                 );
//                 discardRecording();
//                 startNewRecording();
//               }
//             },
//             child: Text('SAVE & START NEW'),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               resumeRecordingAfterInterruption();
//             },
//             child: Text('CONTINUE RECORDING'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Start a periodic timer to save state
//   void _startAutoSaveTimer() {
//     _autoSaveTimer?.cancel();
//     _autoSaveTimer = Timer.periodic(Duration(seconds: 5), (_) {
//       if (isRecording.value) {
//         saveCurrentState();
//       }
//     });
//   }
//
//   // Save the current recording state to persistent storage
//   Future<void> saveCurrentState() async {
//     try {
//       await box.write(RECORDING_ACTIVE, isRecording.value);
//       await box.write(RECORDING_PATH, recordingPath.value);
//       await box.write(ELAPSED_TIME, elapsedTime.value);
//       await box.write(RECORDING_PAUSED, isPaused.value);
//       await box.write(RECORDING_SEGMENTS, recordingSegments.toList());
//       await box.write(CURRENT_SESSION_ID, currentSessionId.value);
//       print(
//           '💾 Saved recording state: active=${isRecording.value}, path=${recordingPath.value}, elapsed=${elapsedTime.value}s, segments=${recordingSegments.length}');
//     } catch (e) {
//       print('❌ Error saving recording state: $e');
//     }
//   }
//
//   // Save meeting check-in state
//   Future<void> saveCheckInState(bool isCheckedIn, String checkInTime,
//       String checkOutTime, String location) async {
//     try {
//       await box.write(IS_CHECKED_IN, isCheckedIn);
//       await box.write(CHECK_IN_TIME, checkInTime);
//       await box.write(CHECK_OUT_TIME, checkOutTime);
//       await box.write(LOCATION_DATA, location);
//     } catch (e) {
//       print('❌ Error saving check-in state: $e');
//     }
//   }
//
//   // Load meeting check-in state
//   Map<String, dynamic> loadCheckInState() {
//     try {
//       final isCheckedIn = box.read<bool>(IS_CHECKED_IN) ?? false;
//       final checkInTime = box.read<String>(CHECK_IN_TIME) ?? '';
//       final checkOutTime = box.read<String>(CHECK_OUT_TIME) ?? '';
//       final location = box.read<String>(LOCATION_DATA) ?? '';
//
//       return {
//         'isCheckedIn': isCheckedIn,
//         'checkInTime': checkInTime,
//         'checkOutTime': checkOutTime,
//         'location': location,
//       };
//     } catch (e) {
//       print('❌ Error loading check-in state: $e');
//       return {
//         'isCheckedIn': false,
//         'checkInTime': '',
//         'checkOutTime': '',
//         'location': '',
//       };
//     }
//   }
//
//   // Start a new recording
//   Future<void> startNewRecording() async {
//     try {
//       // Generate a new session ID
//       currentSessionId.value = _generateSessionId();
//
//       // Generate a new file path
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final saveDir = box.read<String>('recording_save_directory');
//       final newPath =
//           '$saveDir/meeting_${currentSessionId.value}_$timestamp.m4a';
//
//       // Check and request permissions
//       if (await _recorder.hasPermission()) {
//         await _recorder.start(
//           const RecordConfig(encoder: AudioEncoder.aacLc),
//           path: newPath,
//         );
//
//         // Update state
//         isRecording.value = true;
//         isPaused.value = false;
//         recordingPath.value = newPath;
//         elapsedTime.value = 0;
//
//         // Clear previous segments and add new one
//         recordingSegments.clear();
//         recordingSegments.add(newPath);
//
//         // Start elapsed timer
//         _startElapsedTimer();
//
//         // Save current state
//         await saveCurrentState();
//
//         return;
//       } else {
//         Get.snackbar(
//           'Permission Denied',
//           'Recording permission is not granted.',
//           duration: Duration(seconds: 3),
//         );
//       }
//     } catch (e) {
//       print('❌ Error starting recording: $e');
//       Get.snackbar(
//         'Recording Error',
//         'Failed to start recording. Please try again.',
//         duration: Duration(seconds: 3),
//       );
//     }
//   }
//
//   // Resume recording after app interruption
//   Future<void> resumeRecordingAfterInterruption() async {
//     if (_isResuming) return;
//     _isResuming = true;
//
//     try {
//       // Generate a new file path for continuation
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final saveDir = box.read<String>('recording_save_directory');
//       final continuationPath =
//           '$saveDir/meeting_${currentSessionId.value}_continued_$timestamp.m4a';
//
//       // Check permissions and start new recording segment
//       if (await _recorder.hasPermission()) {
//         await _recorder.start(
//           const RecordConfig(encoder: AudioEncoder.aacLc),
//           path: continuationPath,
//         );
//
//         // Update state
//         isRecording.value = true;
//         isPaused.value = false;
//         recordingPath.value = continuationPath;
//
//         // Add to segments list
//         if (!recordingSegments.contains(continuationPath)) {
//           recordingSegments.add(continuationPath);
//         }
//
//         // Start elapsed timer
//         _startElapsedTimer();
//
//         // Save current state
//         await saveCurrentState();
//
//         Get.snackbar(
//           'Recording Resumed',
//           'Your recording has been continued in a new segment.',
//           duration: Duration(seconds: 3),
//         );
//       } else {
//         Get.snackbar(
//           'Permission Denied',
//           'Recording permission is not granted.',
//           duration: Duration(seconds: 3),
//         );
//       }
//     } catch (e) {
//       print('❌ Error resuming recording: $e');
//       Get.snackbar(
//         'Recording Error',
//         'Failed to resume recording. Please try again.',
//         duration: Duration(seconds: 3),
//       );
//     } finally {
//       _isResuming = false;
//     }
//   }
//
//   // Pause recording
//   Future<void> pauseRecording() async {
//     if (!isRecording.value || isPaused.value) return;
//
//     try {
//       await _recorder.pause();
//       isPaused.value = true;
//       _elapsedTimer?.cancel();
//       await saveCurrentState();
//     } catch (e) {
//       print('❌ Error pausing recording: $e');
//       Get.snackbar(
//         'Recording Error',
//         'Failed to pause recording.',
//         duration: Duration(seconds: 3),
//       );
//     }
//   }
//
//   // Resume paused recording
//   Future<void> resumePausedRecording() async {
//     if (!isRecording.value || !isPaused.value) return;
//
//     try {
//       await _recorder.resume();
//       isPaused.value = false;
//       _startElapsedTimer();
//       await saveCurrentState();
//     } catch (e) {
//       print('❌ Error resuming paused recording: $e');
//       Get.snackbar(
//         'Recording Error',
//         'Failed to resume recording.',
//         duration: Duration(seconds: 3),
//       );
//     }
//   }
//
//   // Stop recording
//   Future<String?> stopRecording() async {
//     if (!isRecording.value) return null;
//
//     try {
//       final path = await _recorder.stop();
//       isRecording.value = false;
//       isPaused.value = false;
//       _elapsedTimer?.cancel();
//
//       // Process segments if multiple exist
//       String? finalPath = path;
//       if (recordingSegments.length > 1) {
//         Get.dialog(
//           AlertDialog(
//             title: Text('Processing Recording'),
//             content:
//                 Text('Please wait while we process your recording segments...'),
//           ),
//           barrierDismissible: false,
//         );
//
//         finalPath = await mergeRecordingSegments();
//
//         Get.back(); // Close the processing dialog
//       }
//
//       // Clear recording state from storage
//       await box.remove(RECORDING_ACTIVE);
//       await box.remove(RECORDING_PATH);
//       await box.remove(RECORDING_PAUSED);
//
//       return finalPath;
//     } catch (e) {
//       print('❌ Error stopping recording: $e');
//       Get.snackbar(
//         'Recording Error',
//         'Failed to stop recording properly.',
//         duration: Duration(seconds: 3),
//       );
//       return null;
//     }
//   }
//
//   // Discard current recording
//   Future<void> discardRecording() async {
//     try {
//       if (isRecording.value) {
//         await _recorder.stop();
//       }
//
//       isRecording.value = false;
//       isPaused.value = false;
//       _elapsedTimer?.cancel();
//       elapsedTime.value = 0;
//
//       // Delete all segments
//       for (final path in recordingSegments) {
//         try {
//           final file = File(path);
//           if (await file.exists()) {
//             await file.delete();
//             print('🗑️ Deleted recording segment: $path');
//           }
//         } catch (e) {
//           print('❌ Error deleting file $path: $e');
//         }
//       }
//
//       recordingSegments.clear();
//
//       // Clear recording state from storage
//       await box.remove(RECORDING_ACTIVE);
//       await box.remove(RECORDING_PATH);
//       await box.remove(RECORDING_PAUSED);
//       await box.remove(ELAPSED_TIME);
//       await box.remove(RECORDING_SEGMENTS);
//       await box.remove(CURRENT_SESSION_ID);
//
//       Get.snackbar(
//         'Recording Discarded',
//         'The recording has been discarded.',
//         duration: Duration(seconds: 3),
//       );
//     } catch (e) {
//       print('❌ Error discarding recording: $e');
//     }
//   }
//
//   // Handle app going to background
//   Future<void> handleAppBackground() async {
//     try {
//       if (isRecording.value && !isPaused.value) {
//         print('📱 Pausing recording due to app going to background');
//         await pauseRecording();
//
//         // Update state with reason
//         await box.write('recording_paused_reason', 'background');
//       }
//
//       // Make sure state is saved
//       await saveCurrentState();
//     } catch (e) {
//       print('❌ Error handling app background for recording: $e');
//     }
//   }
//
//   // Handle app coming to foreground
//   Future<void> handleAppForeground() async {
//     try {
//       final wasRecording = box.read<bool>(RECORDING_ACTIVE) ?? false;
//       final wasPaused = box.read<bool>(RECORDING_PAUSED) ?? false;
//       final pauseReason = box.read<String>('recording_paused_reason');
//
//       if (wasRecording && wasPaused && pauseReason == 'background') {
//         print('📱 App returned to foreground, asking to resume recording');
//
//         // Show dialog to resume recording
//         Get.dialog(
//           AlertDialog(
//             title: Text('Resume Recording?'),
//             content: Text(
//                 'Your recording was paused when the app went to background. Would you like to resume recording?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Get.back();
//                   discardRecording();
//                 },
//                 child: Text('DISCARD'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Get.back();
//                   resumePausedRecording(); // This is different from resumeRecordingAfterInterruption
//                 },
//                 child: Text('RESUME'),
//               ),
//             ],
//           ),
//         );
//
//         // Clear the pause reason
//         await box.remove('recording_paused_reason');
//       }
//     } catch (e) {
//       print('❌ Error handling app foreground for recording: $e');
//     }
//   }
//
//   // Merge multiple recording segments into a single file
//   Future<String?> mergeRecordingSegments() async {
//     if (recordingSegments.isEmpty) return null;
//     if (_isProcessingSegments) return null;
//
//     _isProcessingSegments = true;
//
//     try {
//       final saveDir = box.read<String>('recording_save_directory');
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final mergedPath =
//           '$saveDir/meeting_merged_${currentSessionId.value}_$timestamp.m4a';
//       final fileListPath = '$saveDir/filelist_$timestamp.txt';
//
//       // Check if segments exist
//       final existingSegments = <String>[];
//       for (final segment in recordingSegments) {
//         if (await File(segment).exists()) {
//           existingSegments.add(segment);
//         }
//       }
//
//       if (existingSegments.isEmpty) {
//         print('⚠️ No valid segments found to merge');
//         return null;
//       } else if (existingSegments.length == 1) {
//         // If only one segment exists, just copy it
//         await File(existingSegments[0]).copy(mergedPath);
//         print('📝 Only one segment found, copied to $mergedPath');
//         return mergedPath;
//       }
//
//       // Create a file list for FFmpeg
//       final fileListContent = existingSegments
//           .map((path) => "file '${path.replaceAll("'", "\\'")}'")
//           .join('\n');
//       await File(fileListPath).writeAsString(fileListContent);
//
//       // Execute FFmpeg command to concatenate files
//       final ffmpegCommand =
//           '-f concat -safe 0 -i $fileListPath -c copy $mergedPath';
//       print('🔄 Executing FFmpeg command: $ffmpegCommand');
//
//       final session = await FFmpegKit.execute(ffmpegCommand);
//       final returnCode = await session.getReturnCode();
//
//       // Delete the temporary file list
//       await File(fileListPath).delete();
//
//       if (ReturnCode.isSuccess(returnCode)) {
//         print(
//             '✅ Successfully merged ${existingSegments.length} segments into $mergedPath');
//         return mergedPath;
//       } else {
//         print('❌ FFmpeg returned error code: $returnCode');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error merging recording segments: $e');
//       return null;
//     } finally {
//       _isProcessingSegments = false;
//     }
//   }
//
//   // Start the elapsed timer
//   void _startElapsedTimer() {
//     _elapsedTimer?.cancel();
//     _elapsedTimer = Timer.periodic(Duration(seconds: 1), (_) {
//       elapsedTime.value++;
//       // Save elapsed time every 5 seconds to reduce writes
//       if (elapsedTime.value % 5 == 0) {
//         box.write(ELAPSED_TIME, elapsedTime.value);
//       }
//     });
//   }
//
//   // Format elapsed time as a string (MM:SS)
//   String getFormattedElapsedTime() {
//     final minutes = (elapsedTime.value ~/ 60).toString().padLeft(2, '0');
//     final seconds = (elapsedTime.value % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }
// }
