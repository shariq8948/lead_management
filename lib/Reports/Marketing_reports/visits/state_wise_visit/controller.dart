import 'package:get/get.dart';

class StateWiseVisitController extends GetxController {
  // Observable variables
  var totalVisits = 0.obs;
  var uniqueStates = 0.obs;

  var stateWiseVisitData = <StateWiseVisitData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStateWiseVisitData();
  }

  void fetchStateWiseVisitData() {
    // Simulating fetching data for states
    stateWiseVisitData.value = [
      StateWiseVisitData(
        stateName: 'Maharashtra',
        totalVisits: 120,
        uniqueVisitors: 50,
        topLocations: ['Mumbai', 'Pune', 'Nagpur'],
      ),
      StateWiseVisitData(
        stateName: 'Karnataka',
        totalVisits: 95,
        uniqueVisitors: 40,
        topLocations: ['Bangalore', 'Mysore', 'Hubli'],
      ),
      StateWiseVisitData(
        stateName: 'Uttar Pradesh',
        totalVisits: 80,
        uniqueVisitors: 35,
        topLocations: ['Lucknow', 'Kanpur', 'Varanasi'],
      ),
    ];

    // Calculating summary data
    totalVisits.value =
        stateWiseVisitData.map((e) => e.totalVisits).reduce((a, b) => a + b);
    uniqueStates.value = stateWiseVisitData.length;
  }
}

// Data model for a single state's visit summary
class StateWiseVisitData {
  final String stateName;
  final int totalVisits;
  final int uniqueVisitors;
  final List<String> topLocations;

  StateWiseVisitData({
    required this.stateName,
    required this.totalVisits,
    required this.uniqueVisitors,
    required this.topLocations,
  });
}
