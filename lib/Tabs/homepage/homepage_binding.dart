import 'package:get/get.dart';
import 'package:leads/auth/login/login_controller.dart';
import 'homepage_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LoginController>(() => LoginController());

  }
}
