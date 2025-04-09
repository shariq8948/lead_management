import 'package:get/get.dart';

class PipelineController extends GetxController {
  final RxList<Map<String, dynamic>> stages = <Map<String, dynamic>>[
    {
      'name': 'New Leads',
      'count': 45,
      'value': 75000.0,
      'conversion': 68.5,
      'color': 0xFF4CAF50
    },
    {
      'name': 'Qualified',
      'count': 32,
      'value': 56000.0,
      'conversion': 55.2,
      'color': 0xFF2196F3
    },
    {
      'name': 'Proposal',
      'count': 18,
      'value': 42000.0,
      'conversion': 42.8,
      'color': 0xFF9C27B0
    },
    {
      'name': 'Negotiation',
      'count': 12,
      'value': 35000.0,
      'conversion': 28.5,
      'color': 0xFFFF9800
    },
    {
      'name': 'Closed Won',
      'count': 8,
      'value': 28000.0,
      'conversion': 15.2,
      'color': 0xFF4CAF50
    }
  ].obs;

  final RxString selectedPeriod = 'This Month'.obs;
  final RxString selectedView = 'Value'.obs;

  double get totalValue =>
      stages.fold(0, (sum, stage) => sum + (stage['value'] as double));

  int get totalLeads =>
      stages.fold(0, (sum, stage) => sum + (stage['count'] as int));

  double get averageConversion =>
      stages.fold(0.0, (sum, stage) => sum + (stage['conversion'] as double)) /
      stages.length;

  void updatePeriod(String period) {
    selectedPeriod.value = period;
    // Here you would typically fetch new data based on the selected period
    update();
  }

  void updateView(String view) {
    selectedView.value = view;
    update();
  }
}
