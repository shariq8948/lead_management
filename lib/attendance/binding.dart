import 'package:get/get.dart';
import 'package:leads/attendance/attendance_controller.dart';
import 'package:leads/leads/leadlist/lead_list_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarkAttendanceController>(() => MarkAttendanceController());
  }
}
