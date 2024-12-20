class ActivityModel {
  final String activityType; // Type of activity (e.g., "Update Status", "Comment", etc.)
  final String detail;       // Detailed description of the activity
  final String status;       // Status of the activity (e.g., "Pending", "Completed", "Cancel")
  final String assignedTo;   // Name of the person assigned
  final DateTime date;       // Date of the activity
  final String createdBy;    // Who created the activity (e.g., "HO")
  final String title;    // Who created the activity (e.g., "HO")

  ActivityModel({
    required this.activityType,
    required this.detail,
    required this.status,
    required this.assignedTo,
    required this.date,
    required this.createdBy, required this.title,
  });

  // Method to convert JSON data to an ActivityModel instance
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityType: json['activityType'] ?? '',
      detail: json['detail'] ?? '',
      status: json['status'] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      date: DateTime.parse(json['date']),
      createdBy: json['createdBy'] ?? '',
      title: json['title'] ?? '',
    );
  }

  // Method to convert an ActivityModel instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'activityType': activityType,
      'detail': detail,
      'status': status,
      'assignedTo': assignedTo,
      'date': date.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}
