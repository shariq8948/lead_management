import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ConversionChannelData {
  final String channel;
  final double conversionRate;
  final IconData icon;
  final String description;
  final Color backgroundColor;
  final Color iconColor;

  ConversionChannelData({
    required this.channel,
    required this.conversionRate,
    required this.icon,
    required this.description,
    required this.backgroundColor,
    required this.iconColor,
  });
}

class TimeSeriesConversion {
  final DateTime time;
  final double conversionRate;
  final String channel;

  TimeSeriesConversion(this.time, this.conversionRate, this.channel);
}

class ConversionRatesController extends GetxController {
  final RxList<ConversionChannelData> conversionChannels = RxList([]);
  final RxList<TimeSeriesConversion> conversionTrends = RxList([]);
  final RxDouble totalConversionRate = 0.0.obs;
  final RxInt totalConversions = 0.obs;
  final RxBool isLoading = false.obs;

  final Map<String, IconData> channelIcons = {
    'Website': Icons.web,
    'Email Campaign': Icons.email,
    'Social Media': Icons.share,
    'Referral': Icons.people,
    'Direct': Icons.touch_app,
    'Justdial': Icons.touch_app,
  };

  final Map<String, List<Color>> channelColors = {
    'Website': [Colors.blue.shade50, Colors.blue.shade700],
    'Email Campaign': [Colors.green.shade50, Colors.green.shade700],
    'Social Media': [Colors.purple.shade50, Colors.purple.shade700],
    'Referral': [Colors.orange.shade50, Colors.orange.shade700],
    'Direct': [Colors.red.shade50, Colors.red.shade700],
    'Justdial': [Colors.pink.shade50, Colors.pink.shade700],
  };

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      // In a real app, you would use http package or dio for API calls
      // final response = await http.get(Uri.parse('your_api_endpoint/conversion_data'));
      // final jsonData = jsonDecode(response.body);

      // For demonstration, using simulated data
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      final jsonData = await simulateApiResponse();

      // Parse conversion metrics
      totalConversions.value = jsonData['total_conversions'];
      totalConversionRate.value = jsonData['total_conversion_rate'];

      // Parse channels data
      final List<dynamic> channelsData = jsonData['conversion_channels'];
      conversionChannels.value = channelsData.map((item) {
        String channel = item['channel'];
        return ConversionChannelData(
          channel: channel,
          conversionRate: item['conversionRate'],
          description: item['description'],
          icon: channelIcons[channel] ?? Icons.analytics,
          backgroundColor: channelColors[channel]?[0] ?? Colors.grey.shade50,
          iconColor: channelColors[channel]?[1] ?? Colors.grey.shade700,
        );
      }).toList();

      // Parse time series data
      final List<dynamic> trendsData = jsonData['conversion_trends'];
      conversionTrends.value = trendsData.map((item) {
        return TimeSeriesConversion(
          DateTime.parse(item['time']),
          item['conversionRate'],
          item['channel'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      // You could also add an error state here
    } finally {
      isLoading.value = false;
    }
  }

  // Simulate API response for demonstration
  Future<Map<String, dynamic>> simulateApiResponse() async {
    return {
      "total_conversions": 1250,
      "total_conversion_rate": 0.18,
      "conversion_channels": [
        {
          "channel": "Website",
          "conversionRate": 0.15,
          "description": "Direct organic traffic",
          "visits": 2000,
          "conversions": 300
        },
        {
          "channel": "Email Campaign",
          "conversionRate": 0.25,
          "description": "Targeted email marketing",
          "visits": 1200,
          "conversions": 300
        },
        {
          "channel": "Social Media",
          "conversionRate": 0.10,
          "description": "Social platform engagement",
          "visits": 2500,
          "conversions": 250
        },
        {
          "channel": "Referral",
          "conversionRate": 0.30,
          "description": "Word of mouth referrals",
          "visits": 800,
          "conversions": 240
        },
        {
          "channel": "Direct",
          "conversionRate": 0.20,
          "description": "Direct platform access",
          "visits": 700,
          "conversions": 140
        },
        {
          "channel": "Justdial",
          "conversionRate": 0.20,
          "description": "ONLINE iNQUIRES",
          "visits": 100,
          "conversions": 20
        }
      ],
      "conversion_trends": [
        {
          "time": "2024-01-01T00:00:00.000",
          "conversionRate": 0.12,
          "channel": "Website",
          "visits": 1500,
          "conversions": 180
        },
        {
          "time": "2024-02-01T00:00:00.000",
          "conversionRate": 0.15,
          "channel": "Email Campaign",
          "visits": 1000,
          "conversions": 150
        },
        {
          "time": "2024-03-01T00:00:00.000",
          "conversionRate": 0.18,
          "channel": "Social Media",
          "visits": 2000,
          "conversions": 360
        },
        {
          "time": "2024-04-01T00:00:00.000",
          "conversionRate": 0.22,
          "channel": "Referral",
          "visits": 600,
          "conversions": 132
        },
        {
          "time": "2024-05-01T00:00:00.000",
          "conversionRate": 0.25,
          "channel": "Direct",
          "visits": 500,
          "conversions": 125
        },
        {
          "time": "2024-05-01T00:00:00.000",
          "conversionRate": 0.08,
          "channel": "Just Dial",
          "visits": 80,
          "conversions": 6
        }
      ]
    };
  }

  void refreshData() {
    fetchData();
  }

  void updateConversionRate(String channel, double newRate,
      {String? description}) {
    final index =
        conversionChannels.indexWhere((data) => data.channel == channel);
    if (index != -1) {
      final currentData = conversionChannels[index];
      conversionChannels[index] = ConversionChannelData(
        channel: channel,
        conversionRate: newRate,
        icon: currentData.icon,
        description: description ?? currentData.description,
        backgroundColor: currentData.backgroundColor,
        iconColor: currentData.iconColor,
      );
    }
  }
}
