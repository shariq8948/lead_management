import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/splash/splash_controller.dart';

import '../utils/tags.dart';


class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());

    // Get Storage Initialisation
    Get.putAsync<GetStorage>(() async {
      final box = GetStorage();
      return box;
    }, tag: StorageTags.tag, permanent: true);
  }
}
