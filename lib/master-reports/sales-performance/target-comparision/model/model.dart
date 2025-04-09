import 'package:intl/intl.dart';

class MonthlyTargetData {
  final DateTime month;
  final double target;
  final double actual;

  MonthlyTargetData({
    required this.month,
    required this.target,
    required this.actual,
  });

  double get achievementPercentage => (actual / target) * 100;
  double get deficit => target - actual;
  bool get isDeficit => actual < target;
  String get monthName => DateFormat('MMM').format(month);
}
