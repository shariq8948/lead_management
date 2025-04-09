class AppNotification {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  bool isRead;
  final String navigationTarget;
  final String? navigationId; // New key for navigation
  final String? imageUrl; // Optional field for an image URL

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    this.navigationTarget = "",
    this.navigationId, // Initialize new key
    this.imageUrl,
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
      'navigationId': navigationId, // Include new key
      'imageUrl': imageUrl,
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
      navigationTarget: map['navigationTarget'],
      navigationId: map['navigationId'], // Parse new key
      imageUrl: map['imageUrl'],
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
