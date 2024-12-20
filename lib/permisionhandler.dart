import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await [
    Permission.phone,
    Permission.microphone,
    Permission.storage,
  ].request();
}
