import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'alarm.dart';

class AlarmDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alarm Manager Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await AlarmService.requestPermission(); // Request permission
                await AlarmService.scheduleOneTimeAlarm(Duration(seconds: 10));
                print('One-time alarm scheduled in 10 seconds.');
              },
              child: Text('Schedule One-Time Alarm'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AlarmService.schedulePeriodicAlarm(Duration(seconds: 5));
                print('Periodic alarm scheduled every 1 minute.');
              },
              child: Text('Schedule Periodic Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
