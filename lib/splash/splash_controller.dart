import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/tags.dart';


class SplashController extends GetxController {
  RxBool animate = false.obs;

  // Get Launch Screen
  Future<String> getLaunchScreen() async {
    final GetStorage box = Get.find<GetStorage>(tag: StorageTags.tag);
    String? loggedIn = box.read(StorageTags.loggedIn);

    String finalRoute = loggedIn == "yes" ? "/main" : "/login";
    return finalRoute;
  }

  // Start animation
  void startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    final routeName = await getLaunchScreen();
    await Future.delayed(const Duration(milliseconds: 2500));
    Get.offAllNamed(routeName);
  }

  @override
  void onReady() {
    startAnimation();
    super.onReady();
  }
}
