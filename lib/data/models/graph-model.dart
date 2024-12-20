// To parse this JSON data, do
//
//     final funnelGraph = funnelGraphFromJson(jsonString);

import 'dart:convert';

List<FunnelGraph> funnelGraphFromJson(String str) => List<FunnelGraph>.from(json.decode(str).map((x) => FunnelGraph.fromJson(x)));

String funnelGraphToJson(List<FunnelGraph> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FunnelGraph {
  int y;
  String label;

  FunnelGraph({
    required this.y,
    required this.label,
  });

  factory FunnelGraph.fromJson(Map<String, dynamic> json) => FunnelGraph(
    y: json["y"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "y": y,
    "label": label,
  };
  @override
  String toString() {
    return 'AllCountList(name: $y, count: $label)';
  }
}
class DealData {
  final String monthName;
  final double dealSizeAmount;
  final String year;

  DealData({
    required this.monthName,
    required this.dealSizeAmount,
    required this.year,
  });

  factory DealData.fromJson(Map<String, dynamic> json) {
    return DealData(
      monthName: json['monthName'] ?? '',
      dealSizeAmount: double.tryParse(json['dealSizeAmount'] ?? '0') ?? 0.0,
      year: json['year'] ?? '',
    );
  }
}
