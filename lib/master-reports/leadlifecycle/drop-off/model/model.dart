// lib/services/dropoff_api_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/model.dart';

class DropoffApiService {
  final String baseUrl;

  DropoffApiService({
    this.baseUrl = 'https://api.example.com/v1',
  });

  Future<DropoffApiResponse> fetchDropoffData({
    DateTimeRange? dateRange,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};

      if (dateRange != null) {
        queryParams['start_date'] =
            dateRange.start.toIso8601String().split('T').first;
        queryParams['end_date'] =
            dateRange.end.toIso8601String().split('T').first;
      }

      // Add any additional filters
      if (filters != null && filters.isNotEmpty) {
        filters.forEach((key, value) {
          if (value != null) {
            queryParams[key] = value.toString();
          }
        });
      }

      final uri = Uri.parse('$baseUrl/analytics/dropoff').replace(
        queryParameters: queryParams,
      );

      // In a real implementation, you'd use your authentication method
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DropoffApiResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load dropoff data: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, return simulated data when an error occurs
      return _getSimulatedResponse(dateRange);
    }
  }

  // Simulated response for development/testing
  DropoffApiResponse _getSimulatedResponse(DateTimeRange? dateRange) {
    final now = DateTime.now();
    final startDate =
        dateRange?.start ?? now.subtract(const Duration(days: 30));
    final endDate = dateRange?.end ?? now;

    return DropoffApiResponse(
      success: true,
      message: "Simulated dropoff data retrieved successfully",
      data: DropoffData(
        timeframe: TimeFrame(
          startDate: startDate,
          endDate: endDate,
        ),
        summary: DropoffSummary(
          totalLeads: 245,
          droppedLeads: 378,
          dropoffRate: 30.4,
          conversionProgress: 0.7,
        ),
        insights: [
          Insight(
            type: 'warning',
            title: 'High Dropoff Risk',
            description: 'Initial contact stage has 40% dropoff rate',
          ),
          Insight(
            type: 'opportunity',
            title: 'Improvement Opportunity',
            description: 'Proposal stage conversion can be optimized',
          ),
          Insight(
            type: 'success',
            title: 'Strong Conversion',
            description: 'Closing stage shows promising conversion rates',
          ),
        ],
        trendData: [
          TrendData(stage: 'Initial Contact', dropoffRate: 40),
          TrendData(stage: 'Proposal Stage', dropoffRate: 25),
          TrendData(stage: 'Closing Stage', dropoffRate: 15),
        ],
        stages: [
          DropoffModel(
            stageName: 'Initial Contact',
            totalLeads: 145,
            droppedLeads: 498,
            dropoffRate: 40.0,
            reasons: [
              DropoffReason(reason: 'No Response', count: 199, percentage: 40),
              DropoffReason(
                  reason: 'Not Interested', count: 174, percentage: 35),
              DropoffReason(reason: 'Wrong Timing', count: 125, percentage: 25),
            ],
          ),
          DropoffModel(
            stageName: 'Proposal Stage',
            totalLeads: 747,
            droppedLeads: 187,
            dropoffRate: 25.0,
            reasons: [
              DropoffReason(reason: 'Price Concern', count: 84, percentage: 45),
              DropoffReason(
                  reason: 'Competitor Offer', count: 56, percentage: 30),
              DropoffReason(
                  reason: 'Internal Decision', count: 47, percentage: 25),
            ],
          ),
          DropoffModel(
            stageName: 'Closing Stage',
            totalLeads: 560,
            droppedLeads: 84,
            dropoffRate: 15.0,
            reasons: [
              DropoffReason(
                  reason: 'Budget Constraints', count: 34, percentage: 40),
              DropoffReason(
                  reason: 'Delay in Decision', count: 25, percentage: 30),
              DropoffReason(
                  reason: 'Requirements Changed', count: 25, percentage: 30),
            ],
          ),
        ],
        recommendations: [
          Recommendation(
            icon: 'call',
            title: 'Improve Initial Contact',
            description: 'Develop personalized follow-up strategies',
          ),
          Recommendation(
            icon: 'price_change',
            title: 'Address Pricing Concerns',
            description:
                'Create flexible pricing models and value propositions',
          ),
          Recommendation(
            icon: 'support_agent',
            title: 'Enhance Customer Support',
            description:
                'Implement proactive communication during proposal stage',
          ),
        ],
      ),
    );
  }
}
// lib/model/model.dart

class DropoffApiResponse {
  final bool success;
  final String message;
  final DropoffData data;

  DropoffApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DropoffApiResponse.fromJson(Map<String, dynamic> json) {
    return DropoffApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DropoffData.fromJson(json['data'] ?? {}),
    );
  }
}

class DropoffData {
  final TimeFrame timeframe;
  final DropoffSummary summary;
  final List<Insight> insights;
  final List<TrendData> trendData;
  final List<DropoffModel> stages;
  final List<Recommendation> recommendations;

  DropoffData({
    required this.timeframe,
    required this.summary,
    required this.insights,
    required this.trendData,
    required this.stages,
    required this.recommendations,
  });

  factory DropoffData.fromJson(Map<String, dynamic> json) {
    return DropoffData(
      timeframe: TimeFrame.fromJson(json['timeframe'] ?? {}),
      summary: DropoffSummary.fromJson(json['summary'] ?? {}),
      insights: (json['insights'] as List<dynamic>?)
              ?.map((item) => Insight.fromJson(item))
              .toList() ??
          [],
      trendData: (json['trend_data'] as List<dynamic>?)
              ?.map((item) => TrendData.fromJson(item))
              .toList() ??
          [],
      stages: (json['stages'] as List<dynamic>?)
              ?.map((stage) => DropoffModel.fromJson(stage))
              .toList() ??
          [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((item) => Recommendation.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class TimeFrame {
  final DateTime startDate;
  final DateTime endDate;

  TimeFrame({
    required this.startDate,
    required this.endDate,
  });

  factory TimeFrame.fromJson(Map<String, dynamic> json) {
    return TimeFrame(
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now().subtract(const Duration(days: 30)),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
    };
  }
}

class DropoffSummary {
  final int totalLeads;
  final int droppedLeads;
  final double dropoffRate;
  final double conversionProgress;

  DropoffSummary({
    required this.totalLeads,
    required this.droppedLeads,
    required this.dropoffRate,
    required this.conversionProgress,
  });

  factory DropoffSummary.fromJson(Map<String, dynamic> json) {
    return DropoffSummary(
      totalLeads: json['total_leads'] ?? 0,
      droppedLeads: json['dropped_leads'] ?? 0,
      dropoffRate: (json['dropoff_rate'] ?? 0.0).toDouble(),
      conversionProgress: (json['conversion_progress'] ?? 0.0).toDouble(),
    );
  }
}

class Insight {
  final String type;
  final String title;
  final String description;

  Insight({
    required this.type,
    required this.title,
    required this.description,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  IconData get icon {
    switch (type) {
      case 'warning':
        return Icons.warning;
      case 'opportunity':
        return Icons.trending_up;
      case 'success':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  Color get color {
    switch (type) {
      case 'warning':
        return Colors.red;
      case 'opportunity':
        return Colors.orange;
      case 'success':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}

class TrendData {
  final String stage;
  final double dropoffRate;

  TrendData({
    required this.stage,
    required this.dropoffRate,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      stage: json['stage'] ?? '',
      dropoffRate: (json['dropoff_rate'] ?? 0.0).toDouble(),
    );
  }
}

class DropoffModel {
  final String stageName;
  final int totalLeads;
  final int droppedLeads;
  final double dropoffRate;
  final List<DropoffReason> reasons;

  DropoffModel({
    required this.stageName,
    required this.totalLeads,
    required this.droppedLeads,
    required this.dropoffRate,
    required this.reasons,
  });

  factory DropoffModel.fromJson(Map<String, dynamic> json) {
    return DropoffModel(
      stageName: json['stage_name'] ?? '',
      totalLeads: json['total_leads'] ?? 0,
      droppedLeads: json['dropped_leads'] ?? 0,
      dropoffRate: (json['dropoff_rate'] ?? 0.0).toDouble(),
      reasons: (json['reasons'] as List<dynamic>?)
              ?.map((reason) => DropoffReason.fromJson(reason))
              .toList() ??
          [],
    );
  }
}

class DropoffReason {
  final String reason;
  final int count;
  final int percentage;

  DropoffReason({
    required this.reason,
    required this.count,
    required this.percentage,
  });

  factory DropoffReason.fromJson(Map<String, dynamic> json) {
    return DropoffReason(
      reason: json['reason'] ?? '',
      count: json['count'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}

class Recommendation {
  final String icon;
  final String title;
  final String description;

  Recommendation({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  IconData getIconData() {
    switch (icon) {
      case 'call':
        return Icons.call;
      case 'price_change':
        return Icons.price_change;
      case 'support_agent':
        return Icons.support_agent;
      default:
        return Icons.lightbulb;
    }
  }
}
