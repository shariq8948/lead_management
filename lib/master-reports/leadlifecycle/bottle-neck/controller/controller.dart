import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/api_endpoints.dart';
import 'package:intl/intl.dart'; // Add this import for date parsing

// Model classes
enum LeadRiskCategory { low, moderate, high }

class SalesLead {
  final String leadId;
  final String leadName;
  final String mobile;
  final String currentStage;
  final int daysSinceLastActivity;
  final DateTime lastActivity;
  final String nextFollowup;
  final double potentialRevenue;
  final LeadRiskCategory riskLevel;

  const SalesLead({
    required this.leadId,
    required this.leadName,
    required this.mobile,
    required this.currentStage,
    required this.daysSinceLastActivity,
    required this.lastActivity,
    required this.nextFollowup,
    required this.potentialRevenue,
    required this.riskLevel,
  });

  factory SalesLead.fromJson(Map<String, dynamic> json) {
    // Parse date using DateFormat from intl package
    DateTime parsedDate;
    try {
      // Format: M/d/yyyy h:mm:ss a (e.g., 3/28/2025 2:21:48 PM)
      parsedDate = DateFormat('M/d/yyyy h:mm:ss a').parse(json['lastactivity']);
    } catch (e) {
      // Fallback to current date if parsing fails
      if (kDebugMode) {
        print('Error parsing date: ${json['lastactivity']}');
      }
      parsedDate = DateTime.now();
    }

    return SalesLead(
      leadId: json['leadid'],
      leadName: json['leadName'],
      mobile: json['mobile'],
      currentStage: json['currentstage'],
      daysSinceLastActivity: int.parse(json['dayssincelastactivity']),
      lastActivity: parsedDate,
      nextFollowup: json['nextfollowup'] ?? '',
      potentialRevenue: double.tryParse(json['potentialrevenue']) ?? 0.0,
      riskLevel: _parseRiskLevel(json['risklevel']),
    );
  }

  static LeadRiskCategory _parseRiskLevel(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return LeadRiskCategory.low;
      case 'moderate':
        return LeadRiskCategory.moderate;
      case 'high':
        return LeadRiskCategory.high;
      default:
        return LeadRiskCategory.low;
    }
  }

  /// Calculates the risk level based on stage and stagnation duration
  static LeadRiskCategory calculateRiskLevel(
      String stage, int daysSinceLastActivity) {
    switch (stage) {
      case 'Prospecting':
        return daysSinceLastActivity > 30
            ? LeadRiskCategory.high
            : daysSinceLastActivity > 15
                ? LeadRiskCategory.moderate
                : LeadRiskCategory.low;
      case 'Qualification':
        return daysSinceLastActivity > 25
            ? LeadRiskCategory.high
            : daysSinceLastActivity > 12
                ? LeadRiskCategory.moderate
                : LeadRiskCategory.low;
      case 'Proposal':
        return daysSinceLastActivity > 20
            ? LeadRiskCategory.high
            : daysSinceLastActivity > 10
                ? LeadRiskCategory.moderate
                : LeadRiskCategory.low;
      case 'Negotiation':
        return daysSinceLastActivity > 15
            ? LeadRiskCategory.high
            : daysSinceLastActivity > 7
                ? LeadRiskCategory.moderate
                : LeadRiskCategory.low;
      case 'No Stage':
        return daysSinceLastActivity > 15
            ? LeadRiskCategory.high
            : daysSinceLastActivity > 7
                ? LeadRiskCategory.moderate
                : LeadRiskCategory.low;
      default:
        return LeadRiskCategory.low;
    }
  }
}

// Stage bottleneck class
class StageBottleneck {
  final String stageName;
  final int recordCount;

  StageBottleneck({
    required this.stageName,
    required this.recordCount,
  });

  factory StageBottleneck.fromJson(Map<String, dynamic> json) {
    return StageBottleneck(
      stageName: json['stageName'],
      recordCount: int.parse(json['recordcount']),
    );
  }
}

// API Response models
class PipelineMetrics {
  final double averageLeadStagnationDays;
  final int totalBottleneckLeads;
  final List<StageBottleneck> stageBottleneckCount;
  final double totalPotentialRevenueAtRisk;

  PipelineMetrics({
    required this.averageLeadStagnationDays,
    required this.totalBottleneckLeads,
    required this.stageBottleneckCount,
    required this.totalPotentialRevenueAtRisk,
  });

  factory PipelineMetrics.fromJson(Map<String, dynamic> json) {
    return PipelineMetrics(
      averageLeadStagnationDays:
          double.parse(json['averageleadstagnationdays']),
      totalBottleneckLeads: int.parse(json['totalbottleneckLeads']),
      stageBottleneckCount: (json['stagebottleneckCount'] as List)
          .map((stage) => StageBottleneck.fromJson(stage))
          .toList(),
      totalPotentialRevenueAtRisk:
          double.parse(json['totalPotentialrevenueatrisk']),
    );
  }
}

class SalesPipelineResponse {
  final List<SalesLead> leadsAtBottleneck;
  final PipelineMetrics metrics;
  final List<String> insights;

  SalesPipelineResponse({
    required this.leadsAtBottleneck,
    required this.metrics,
    required this.insights,
  });

  factory SalesPipelineResponse.fromJson(Map<String, dynamic> json) {
    // Extract metrics data
    final metricsData = {
      'averageleadstagnationdays': json['averageleadstagnationdays'],
      'totalbottleneckLeads': json['totalbottleneckLeads'],
      'stagebottleneckCount': json['stagebottleneckCount'],
      'totalPotentialrevenueatrisk': json['totalPotentialrevenueatrisk'],
    };

    return SalesPipelineResponse(
      leadsAtBottleneck: (json['leadatbottleneck'] as List)
          .map((lead) => SalesLead.fromJson(lead))
          .toList(),
      metrics: PipelineMetrics.fromJson(metricsData),
      insights: List<String>.from(json['insights']),
    );
  }
}

// Controller with API integration
class SalesPipelineBottleneckController extends GetxController {
  // Reactive lists and observable variables
  final RxList<SalesLead> leadsAtBottleneck = <SalesLead>[].obs;
  final RxDouble averageLeadStagnationDays = 0.0.obs;
  final RxInt totalBottleneckLeads = 0.obs;
  final RxList<StageBottleneck> stageBottleneckCount = <StageBottleneck>[].obs;
  final RxDouble totalPotentialRevenueAtRisk = 0.0.obs;
  final RxList<String> insights = <String>[].obs;

  // Date range for API requests
  final Rx<DateTime> fromDate =
      DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> uptoDate = DateTime.now().obs;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPipelineData();
  }

  /// Update date range and refresh data
  void updateDateRange(DateTime from, DateTime upto) {
    fromDate.value = from;
    uptoDate.value = upto;
    fetchPipelineData();
  }

  /// Format date for API request
  String _formatDateForApi(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Fetch pipeline data from API
  Future<void> fetchPipelineData() async {
    try {
      print("fetching");

      isLoading.value = true;
      errorMessage.value = '';

      // Get data from API
      final apiResponse =
          await ApiClient().postg(ApiEndpoints.bottleNeck, data: {
        "Fromdate": _formatDateForApi(fromDate.value),
        "Uptodate": _formatDateForApi(uptoDate.value),
        "UserId": 4,
        "Syscompanyid": 4,
        "Sysbranchid": 4
      });

      // Important fix: apiResponse is already a Map from your ApiClient

      try {
        final pipelineData = SalesPipelineResponse.fromJson(apiResponse);

        // Update observable variables with API data
        leadsAtBottleneck.value = pipelineData.leadsAtBottleneck;
        averageLeadStagnationDays.value =
            pipelineData.metrics.averageLeadStagnationDays;
        totalBottleneckLeads.value = pipelineData.metrics.totalBottleneckLeads;
        stageBottleneckCount.value = pipelineData.metrics.stageBottleneckCount;
        totalPotentialRevenueAtRisk.value =
            pipelineData.metrics.totalPotentialRevenueAtRisk;
        insights.value = pipelineData.insights;
      } catch (parseError) {
        errorMessage.value = 'Error parsing response data';
        if (kDebugMode) {
          print('Parse Error: $parseError');
          print('API Response: $apiResponse');
        }
      }
    } catch (e) {
      errorMessage.value = 'Error fetching pipeline data';
      if (kDebugMode) {
        print('Exception: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data from API
  Future<void> refreshData() async {
    print("fetching");
    await fetchPipelineData();
  }

  /// Get leads by risk level
  List<SalesLead> getLeadsByRiskLevel(LeadRiskCategory riskLevel) {
    return leadsAtBottleneck
        .where((lead) => lead.riskLevel == riskLevel)
        .toList();
  }

  /// Get leads by stage
  List<SalesLead> getLeadsByStage(String stage) {
    return leadsAtBottleneck
        .where((lead) => lead.currentStage == stage)
        .toList();
  }

  /// Get total potential revenue at risk
  double getTotalPotentialRevenueAtRisk() {
    return leadsAtBottleneck.fold(
        0.0, (sum, lead) => sum + lead.potentialRevenue);
  }

  /// Get unique lead count (some leads might be duplicated in the API response)
  int getUniqueLeadCount() {
    final uniqueLeadIds = leadsAtBottleneck.map((lead) => lead.leadId).toSet();
    return uniqueLeadIds.length;
  }
}
