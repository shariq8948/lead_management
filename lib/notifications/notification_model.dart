class AppNotification {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  bool isRead;
  final String navigationTarget;
  final String navigationId; // Changed back to String type
  final String? imageUrl;
  final String? notificationType;
  final String? notificationAction;
  final String? isCalendar;
  final String? location;
  final String? startDate;
  final String? endDate;
  final String? userId;
  final String? priority;
  final String? popupDataActionId;
  final String? popupDataActionType;
  final String? popupDataRemark;
  final String? popupAdditionalData;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    this.navigationTarget = "",
    this.navigationId = "",
    this.imageUrl,
    this.notificationType,
    this.notificationAction,
    this.isCalendar,
    this.location,
    this.startDate,
    this.endDate,
    this.userId,
    this.priority,
    this.popupDataActionId,
    this.popupDataActionType,
    this.popupDataRemark,
    this.popupAdditionalData,
  });

  // Convert a AppNotification into a Map for sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'navigationTarget': navigationTarget,
      'navigationId': navigationId,
      'imageUrl': imageUrl,
      'notificationType': notificationType,
      'notificationAction': notificationAction,
      'isCalendar': isCalendar,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'userId': userId,
      'priority': priority,
      'popupDataActionId': popupDataActionId,
      'popupDataActionType': popupDataActionType,
      'popupDataRemark': popupDataRemark,
      'popupAdditionalData': popupAdditionalData,
    };
  }

  // Convert a Map into a AppNotification
  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] == 1,
      navigationTarget: map['navigationTarget'] ?? "",
      navigationId: map['navigationId'] ?? "",
      imageUrl: map['imageUrl'],
      notificationType: map['notificationType'],
      notificationAction: map['notificationAction'],
      isCalendar: map['isCalendar'],
      location: map['location'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      userId: map['userId'],
      priority: map['priority'],
      popupDataActionId: map['popupDataActionId'],
      popupDataActionType: map['popupDataActionType'],
      popupDataRemark: map['popupDataRemark'],
      popupAdditionalData: map['popupAdditionalData'],
    );
  }

  // Format timestamp for display
  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
