import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/model.dart';

class LeadStageDurationController extends GetxController {
  final RxList<LeadStageDuration> stageDurations = <LeadStageDuration>[].obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final RxList<String> dynamicInsights = <String>[].obs;
  final RxDouble totalLeadTime = 0.0.obs;
  final RxDouble conversionRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    stageDurations.value = [
      LeadStageDuration('Prospecting', 3.2, 85.0),
      LeadStageDuration('Qualification', 2.8, 65.0),
      LeadStageDuration('Proposal', 4.2, 50.0),
      LeadStageDuration('Negotiation', 3.9, 40.0),
      LeadStageDuration('Closing', 1.5, 30.0),
    ];
    _calculateMetrics();
    _generateDynamicInsights();
  }

  void filterDataByDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
    _calculateMetrics();
    _generateDynamicInsights();
  }

  void _calculateMetrics() {
    totalLeadTime.value =
        stageDurations.map((e) => e.averageDays).reduce((a, b) => a + b);

    conversionRate.value = stageDurations
            .map((e) => e.conversionProbability)
            .reduce((a, b) => a + b) /
        stageDurations.length;
  }

  void _generateDynamicInsights() {
    dynamicInsights.clear();

    var longestStage =
        stageDurations.reduce((a, b) => a.averageDays > b.averageDays ? a : b);
    var shortestStage =
        stageDurations.reduce((a, b) => a.averageDays < b.averageDays ? a : b);

    var averageStageTime = totalLeadTime.value / stageDurations.length;

    var criticalStage = stageDurations.reduce(
        (a, b) => a.conversionProbability < b.conversionProbability ? a : b);

    dynamicInsights.addAll([
      'Total lead time spans ${totalLeadTime.value.toStringAsFixed(1)} days across all stages.',
      'The ${longestStage.stage} stage takes the longest at ${longestStage.averageDays.toStringAsFixed(1)} days.',
      'Average stage duration is ${averageStageTime.toStringAsFixed(1)} days.',
      'Conversion probability drops to ${criticalStage.conversionProbability.toStringAsFixed(1)}% in the ${criticalStage.stage} stage.',
      'Potential time savings: Optimizing ${longestStage.stage} could reduce overall lead conversion time.',
    ]);
  }
}
