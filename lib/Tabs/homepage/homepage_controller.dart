import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedTab = 0.obs;
  RxBool isTaskSelected = true.obs; // Reactive variable for task selection
  var isExpanded = false.obs; // Reactive variable for FAB expansion

  void toggleTaskSelection() {
    isTaskSelected.value = !isTaskSelected.value;
  }

  void toggleFab() {
    isExpanded.value = !isExpanded.value;
  }

  void setSelectedTab(int index) {
    selectedTab.value = index;
  }
}
