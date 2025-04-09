class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;
  final Map<String, dynamic>? metadata;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final MediaStatus mediaStatus;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.text,
    this.metadata,
    this.mediaUrl,
    this.thumbnailUrl,
    this.mediaStatus = MediaStatus.none,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type'] ?? 'text'}',
        orElse: () => MessageType.text,
      ),
      metadata: json['metadata'],
      mediaUrl: json['mediaUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      mediaStatus: MediaStatus.values.firstWhere(
        (e) => e.toString() == 'MediaStatus.${json['mediaStatus'] ?? 'none'}',
        orElse: () => MediaStatus.none,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type.toString().split('.').last,
      'metadata': metadata,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'mediaStatus': mediaStatus.toString().split('.').last,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    MessageType? type,
    Map<String, dynamic>? metadata,
    String? mediaUrl,
    String? thumbnailUrl,
    MediaStatus? mediaStatus,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mediaStatus: mediaStatus ?? this.mediaStatus,
    );
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  location,
  contact,
  reply,
  system
}

enum MediaStatus { none, uploading, downloaded, downloading, error }

// Helper class for creating different types of messages
class MessageFactory {
  static ChatMessage createTextMessage({
    required String id,
    required String senderId,
    required String receiverId,
    required String message,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }

  static ChatMessage createMediaMessage({
    required String id,
    required String senderId,
    required String receiverId,
    required String message,
    required MessageType type,
    required String mediaUrl,
    String? thumbnailUrl,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
      type: type,
      mediaUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
      mediaStatus: MediaStatus.uploading,
    );
  }

  static ChatMessage createLocationMessage({
    required String id,
    required String senderId,
    required String receiverId,
    required double latitude,
    required double longitude,
    String? address,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: address ?? 'Location shared',
      timestamp: DateTime.now(),
      type: MessageType.location,
      metadata: {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      },
    );
  }

  static ChatMessage createReplyMessage({
    required String id,
    required String senderId,
    required String receiverId,
    required String message,
    required ChatMessage repliedTo,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
      type: MessageType.reply,
      metadata: {
        'repliedToId': repliedTo.id,
        'repliedToMessage': repliedTo.message,
        'repliedToSender': repliedTo.senderId,
        'repliedToType': repliedTo.type.toString(),
      },
    );
  }
}
