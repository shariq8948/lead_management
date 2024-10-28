import 'package:get/get.dart';

import '../data/api/api_client.dart';
import '../data/api/internet_check.dart';

class DependencyInjection {
  static void init() async {
    // Api Client Initialisation
    Get.put<ApiClient>(
      ApiClient(),
    );
    Get.put<InternetCheckController>(
      InternetCheckController(),
    );
  }
}
