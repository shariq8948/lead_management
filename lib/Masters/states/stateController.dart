import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';

import '../../data/models/dropdown_list.model.dart';
import '../../utils/api_endpoints.dart';

class stateController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    fetchState();
  }

  final box = GetStorage();

  RxList<StateListDropdown> states = <StateListDropdown>[].obs;
  fetchState() async {
    try {
      final data = await ApiClient()
          .getStateList(box.read("userId"), ApiEndpoints.stateList);
      if (data.isNotEmpty) {
        states.assignAll(data);
      }
    } catch (e) {
      print(e);
    }
  }
}
