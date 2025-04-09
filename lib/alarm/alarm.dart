import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the alarm manager and notification plugin
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AndroidAlarmManager.initialize();
    await _initializeNotifications();
  }

  // Initialize flutter_local_notifications
  static Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Callback function to execute when the alarm triggers
  @pragma('vm:entry-point') // Ensure compatibility in release mode
  static void alarmCallback() {
    final DateTime now = DateTime.now();
    print(
        "Alarm triggered at $now! Hello from isolate: ${Isolate.current.hashCode}");

    // Trigger a notification with the default sound
    _showNotification();
  }

  // Show notification when the alarm triggers
  static Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'Channel for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // Use default notification sound
      enableVibration: true, // Enable vibration
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Alarm Triggered!',
      'This is your alarm notification with sound!',
      platformChannelSpecifics,
    );
  }

  // Request exact alarm permission
  static Future<void> requestPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  // Schedule a one-off alarm
  static Future<void> scheduleOneTimeAlarm(Duration delay) async {
    final int alarmId = 1; // Unique alarm ID
    await AndroidAlarmManager.oneShot(
      delay,
      alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  // Schedule a periodic alarm
  static Future<void> schedulePeriodicAlarm(Duration interval) async {
    final int alarmId = 2; // Unique alarm ID
    await AndroidAlarmManager.periodic(
      interval,
      alarmId,
      alarmCallback,
    );
  }
}
