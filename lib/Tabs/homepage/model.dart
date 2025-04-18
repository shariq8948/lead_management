class DashboardData {
  final int newLeadCount;
  final int activeLeadCount;
  final int qualifiedLeadCount;
  final int disqualifiedLeadCount;
  final String qualifiedBudget;
  final String disqualifiedBudget;
  final String targetSale;
  final String actualSales;
  final String overallPerformance;
  final String completedTasksPercentage;
  final String leadGeneratedPercentage;
  final String salesAchievedPercentage;
  final int totalTasks;
  final int completedTasksCount;
  final int pendingTasksCount;
  final int overdueTasksCount;
  final LeadPriorityData leadPriorityData;
  final List<PerformanceTracking> performanceTracking;
  final ExpenseComparisonData expenseComparisonData; // Updated type
  final LeadStagesFunnelData leadStagesFunnelData;
  final TaskCompletionData taskCompletionData;

  DashboardData({
    required this.newLeadCount,
    required this.activeLeadCount,
    required this.qualifiedLeadCount,
    required this.disqualifiedLeadCount,
    required this.qualifiedBudget,
    required this.disqualifiedBudget,
    required this.targetSale,
    required this.actualSales,
    required this.overallPerformance,
    required this.completedTasksPercentage,
    required this.leadGeneratedPercentage,
    required this.salesAchievedPercentage,
    required this.totalTasks,
    required this.completedTasksCount,
    required this.pendingTasksCount,
    required this.overdueTasksCount,
    required this.leadPriorityData,
    required this.performanceTracking,
    required this.expenseComparisonData, // Now required
    required this.leadStagesFunnelData,
    required this.taskCompletionData,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      // Parse string values to integers
      newLeadCount: int.tryParse(json['newLeadCount']?.toString() ?? '0') ?? 0,
      activeLeadCount:
          int.tryParse(json['activeLeadCount']?.toString() ?? '0') ?? 0,
      qualifiedLeadCount:
          int.tryParse(json['qualifiedLeadCount']?.toString() ?? '0') ?? 0,
      disqualifiedLeadCount:
          int.tryParse(json['disqualifiedLeadCount']?.toString() ?? '0') ?? 0,
      qualifiedBudget: json['qualifiedBudget']?.toString() ?? "0.00",
      disqualifiedBudget: json['disqualifiedBudget']?.toString() ?? "0.00",
      targetSale: json['targetSale']?.toString() ?? "0.00",
      actualSales: json['actualSales']?.toString() ?? "0.00",
      overallPerformance: json['overallPerformance']?.toString() ?? "0.00",
      completedTasksPercentage:
          json['completedTasksPercentage']?.toString() ?? "0.00",
      leadGeneratedPercentage:
          json['leadGeneratedPercentage']?.toString() ?? "0.00",
      salesAchievedPercentage:
          json['salesAchievedPercentage']?.toString() ?? "0.00",
      totalTasks: int.tryParse(json['totalTasks']?.toString() ?? '0') ?? 0,
      completedTasksCount:
          int.tryParse(json['completedTasksCount']?.toString() ?? '0') ?? 0,
      pendingTasksCount:
          int.tryParse(json['pendingTasksCount']?.toString() ?? '0') ?? 0,
      overdueTasksCount:
          int.tryParse(json['overdueTasksCount']?.toString() ?? '0') ?? 0,
      leadPriorityData:
          LeadPriorityData.fromJson(json['leadPriorityData'] ?? {}),
      performanceTracking: (json['performanceTracking'] as List<dynamic>?)
              ?.map((item) => PerformanceTracking.fromJson(item))
              .toList() ??
          [],
      expenseComparisonData:
          ExpenseComparisonData.fromJson(json['expenseComparisonData'] ?? {}),
      leadStagesFunnelData:
          LeadStagesFunnelData.fromJson(json['leadStagesFunnelData'] ?? {}),
      taskCompletionData:
          TaskCompletionData.fromJson(json['taskCompletionData'] ?? {}),
    );
  }
}

// New class for expense comparison data
class ExpenseComparisonData {
  final List<String> labels;
  final List<double> allocatedBudget;
  final List<double> actualExpenses;
  final Map<String, String> colors;

  ExpenseComparisonData({
    required this.labels,
    required this.allocatedBudget,
    required this.actualExpenses,
    required this.colors,
  });

  factory ExpenseComparisonData.fromJson(Map<String, dynamic> json) {
    return ExpenseComparisonData(
      labels: List<String>.from(json['labels'] ?? []),
      allocatedBudget: (json['allocatedBudget'] as List<dynamic>?)
              ?.map((v) => double.tryParse(v.toString()) ?? 0.0)
              .toList() ??
          [],
      actualExpenses: (json['actualExpenses'] as List<dynamic>?)
              ?.map((v) => double.tryParse(v.toString()) ?? 0.0)
              .toList() ??
          [],
      colors: Map<String, String>.from(json['colors'] ?? {}),
    );
  }
}

class LeadPriorityData {
  final List<String> labels;
  final List<int> values;
  final Map<String, String> colors;

  LeadPriorityData({
    required this.labels,
    required this.values,
    required this.colors,
  });

  factory LeadPriorityData.fromJson(Map<String, dynamic> json) {
    return LeadPriorityData(
      labels: List<String>.from(json['labels'] ?? []),
      values: (json['values'] as List<dynamic>?)
              ?.map((v) => int.tryParse(v.toString()) ?? 0)
              .toList() ??
          [],
      colors: Map<String, String>.from(json['colors'] ?? {}),
    );
  }
}

class PerformanceTracking {
  final String activityName;
  final String target;
  final String achievement;

  PerformanceTracking({
    required this.activityName,
    required this.target,
    required this.achievement,
  });

  factory PerformanceTracking.fromJson(Map<String, dynamic> json) {
    return PerformanceTracking(
      activityName: json['activityName']?.toString() ?? '',
      target: json['target']?.toString() ?? '',
      achievement: json['achievement']?.toString() ?? '',
    );
  }
}

class LeadStagesFunnelData {
  final List<String> labels;
  final List<int> values;
  final List<String> colors;

  LeadStagesFunnelData({
    required this.labels,
    required this.values,
    required this.colors,
  });

  factory LeadStagesFunnelData.fromJson(Map<String, dynamic> json) {
    return LeadStagesFunnelData(
      labels: List<String>.from(json['labels'] ?? []),
      values: (json['values'] as List<dynamic>?)
              ?.map((v) => int.tryParse(v.toString()) ?? 0)
              .toList() ??
          [],
      colors: List<String>.from(json['colors'] ?? []),
    );
  }
}

class TaskCompletionData {
  final List<String> labels;
  final List<dynamic> values;
  final List<dynamic> colors;

  TaskCompletionData({
    required this.labels,
    required this.values,
    required this.colors,
  });

  factory TaskCompletionData.fromJson(Map<String, dynamic> json) {
    return TaskCompletionData(
      labels: List<String>.from(json['labels'] ?? []),
      values: List<dynamic>.from(json['values'] ?? []),
      colors: List<dynamic>.from(json['colors'] ?? []),
    );
  }
}
