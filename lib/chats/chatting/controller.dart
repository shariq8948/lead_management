import 'dart:async';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'model.dart';

enum ConnectionStatus {
  connected,
  connecting,
  disconnected,
  reconnecting,
  failed
}

class ChatController extends GetxController {
  // Observable state variables
  final messages = <ChatMessage>[].obs;
  final isConnected = false.obs;
  final isTyping = false.obs;
  final connectionStatus = Rx<ConnectionStatus>(ConnectionStatus.disconnected);
  final connectionError = RxString('');
  final isLoading = false.obs;

  // Timers
  Timer? _typingTimer;
  Timer? _reconnectTimer;
  Timer? _messageRetryTimer;

  // Connection variables
  late HubConnection hubConnection;
  final String currentUserId;
  final String receiverId;
  final _logger = Logger();
  var count = 0;

  // Queue for failed messages
  final _messageQueue = <ChatMessage>[];
  final maxRetryAttempts = 3;

  ChatController({
    required this.currentUserId,
    required this.receiverId,
  }) {
    _initializeSignalR();
  }

  Future<void> _initializeSignalR() async {
    connectionStatus.value = ConnectionStatus.connecting;
    isLoading.value = true;

    try {
      hubConnection = HubConnectionBuilder()
          .withUrl(
        "https://lead.mumbaicrm.com/NotificationUserHub?userId=$currentUserId",
      )
          .withAutomaticReconnect(
        retryDelays: [2000, 5000, 10000, 20000], // Retry delays in milliseconds
      ).build();

      _setupConnectionHandlers();
      _setupMessageHandlers();

      // Add debug logging
      _logger.i("Starting connection to ${hubConnection.baseUrl}");

      await hubConnection.start();
      isConnected.value = true;
      connectionStatus.value = ConnectionStatus.connected;
      connectionError.value = '';

      // Test connection ID first
      await _testConnection();
      await Future.delayed(const Duration(milliseconds: 500));

      await _joinChat();
      _processPendingMessages();
    } catch (e) {
      _logger.e('Error connecting to SignalR: $e');
      connectionStatus.value = ConnectionStatus.failed;
      connectionError.value = e.toString();
      _handleReconnection();
      _showConnectionError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _testConnection() async {
    try {
      var connectionId = await hubConnection.invoke("GetConnectionId");
      _logger.i("✅ Got connection ID: $connectionId");
    } catch (e) {
      _logger.e('❌ Test connection failed: $e');
      throw Exception("Failed to verify connection: $e");
    }
  }

  void _setupConnectionHandlers() {
    hubConnection.onclose(({error}) {
      isConnected.value = false;
      connectionStatus.value = ConnectionStatus.disconnected;
      connectionError.value = error?.toString() ?? 'Connection closed';
      _handleReconnection();
    });

    hubConnection.onreconnecting(({error}) {
      connectionStatus.value = ConnectionStatus.reconnecting;
      connectionError.value = error?.toString() ?? 'Reconnecting...';
      _showConnectionStatus('Reconnecting to chat server...');
    });

    hubConnection.onreconnected(({connectionId}) {
      isConnected.value = true;
      connectionStatus.value = ConnectionStatus.connected;
      connectionError.value = '';
      _joinChat();
      _showConnectionStatus('Reconnected successfully!');
      _processPendingMessages();
    });
  }

  void _setupMessageHandlers() {
    hubConnection.on("ReceiveMessage", (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messageData = arguments[0] as Map<String, dynamic>;
          _logger.i("📩 Received message: $messageData");
          final message = ChatMessage.fromJson(messageData);
          messages.insert(0, message);
        } catch (e) {
          _logger.e('Error processing received message: $e');
        }
      }
    });

    hubConnection.on("UserTyping", (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final typingUserId = arguments[0] as String;
        _logger.i("👆 Typing notification from: $typingUserId");
        if (typingUserId == receiverId) {
          isTyping.value = true;
          Future.delayed(const Duration(seconds: 2), () {
            isTyping.value = false;
          });
        }
      }
    });

    // Add a general handler to catch any other messages
    hubConnection.on("Send", (List<Object?>? arguments) {
      _logger.i("📬 Received general message: $arguments");
    });
  }

  Future<void> _joinChat() async {
    try {
      Map<String, String> chatInfo = {
        "senderId": currentUserId,
        "receiverId": receiverId
      };

      _logger.i(
          "Attempting to join chat with senderId: $currentUserId, receiverId: $receiverId");
      await hubConnection.invoke("JoinChat", args: [chatInfo]);
      _logger.i("✅ Successfully joined chat");
    } catch (e) {
      _logger.e('Error joining chat: $e');
      _showConnectionError('Failed to join chat: ${e.toString()}');
    }
  }

  void _handleReconnection() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (connectionStatus.value != ConnectionStatus.connected) {
        _initializeSignalR();
      }
    });
  }

  Future<void> _processPendingMessages() async {
    if (_messageQueue.isEmpty) return;

    while (_messageQueue.isNotEmpty) {
      final message = _messageQueue.removeAt(0);
      try {
        _logger.i("Sending queued message: ${message.id}");
        await hubConnection.invoke("SendMessage",
            args: <Object>[_prepareMessageForServer(message)]);
      } catch (e) {
        _logger.e('Error sending queued message: $e');
        _messageQueue.insert(0, message);
        break;
      }
    }
  }

  void sendTypingNotification() {
    if (!isConnected.value) return;

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        _logger.i("Sending typing notification");
        Map<String, String> typingInfo = {
          "senderId": currentUserId,
          "receiverId": receiverId
        };

        await hubConnection.invoke("UserTyping", args: <Object>[typingInfo]);
      } catch (e) {
        _logger.e('Error sending typing notification: $e');
      }
    });
  }

  Map<String, dynamic> _prepareMessageForServer(ChatMessage message) {
    final messageType = _convertMessageTypeToServerEnum(message.type);
    final mediaStatus = _convertMediaStatusToServerEnum(message.mediaStatus);

    return {
      'Id': message.id,
      'SenderId': message.senderId,
      'ReceiverId': message.receiverId,
      'SenderName': 'Hello',
      'ReceiverName': 'Hi',
      'Message': message.message,
      'Timestamp': message.timestamp.toIso8601String(),
      'IsRead': message.isRead,
      'Type': messageType,
      'Metadata': message.metadata ?? {},
      'MediaUrl': message.mediaUrl ?? "",
      'ThumbnailUrl': message.thumbnailUrl ?? "",
      'MediaStatus': mediaStatus
    };
  }

  int _convertMessageTypeToServerEnum(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 0;
      case MessageType.image:
        return 1;
      case MessageType.video:
        return 2;
      case MessageType.audio:
        return 3;
      case MessageType.file:
        return 4;
      case MessageType.location:
        return 0;
      case MessageType.contact:
        return 0;
      case MessageType.reply:
        return 0;
      case MessageType.system:
        return 0;
    }
  }

  int _convertMediaStatusToServerEnum(MediaStatus status) {
    switch (status) {
      case MediaStatus.none:
        return 0;
      case MediaStatus.uploading:
        return 1;
      case MediaStatus.downloaded:
        return 2; // Map to Uploaded on server
      case MediaStatus.downloading:
        return 1; // Map to Uploading on server
      case MediaStatus.error:
        return 3;
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final message = ChatMessage(
      id: const Uuid().v4(),
      senderId: currentUserId,
      receiverId: receiverId,
      message: content,
      timestamp: DateTime.now(),
    );

    messages.insert(0, message);

    if (!isConnected.value) {
      _messageQueue.add(message);
      _showConnectionError('Message will be sent when connection is restored');
      return;
    }

    try {
      _logger.i("Sending message: ${message.id}");
      await hubConnection.invoke("SendMessage",
          args: <Object>[_prepareMessageForServer(message)]);
      _logger.i("✅ Message sent successfully");
    } catch (e) {
      _logger.e('Error sending message: $e');
      _messageQueue.add(message);
      _showConnectionError('Failed to send message. Will retry automatically.');
    }
  }

  void _showConnectionError(String error) {
    Get.snackbar(
      'Connection Error',
      error,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      duration: const Duration(seconds: 3),
    );
  }

  void _showConnectionStatus(String status) {
    Get.snackbar(
      'Connection Status',
      status,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade900,
      duration: const Duration(seconds: 2),
    );
  }

  // Public methods for connection management
  bool isConnectionActive() {
    return hubConnection.state == HubConnectionState.Connected;
  }

  Future<void> reconnect() async {
    if (connectionStatus.value != ConnectionStatus.connecting &&
        connectionStatus.value != ConnectionStatus.reconnecting) {
      await _initializeSignalR();
    }
  }

  Future<void> disconnect() async {
    try {
      await hubConnection.stop();
      isConnected.value = false;
      connectionStatus.value = ConnectionStatus.disconnected;
    } catch (e) {
      _logger.e('Error disconnecting: $e');
    }
  }

  String getConnectionStatusText() {
    switch (connectionStatus.value) {
      case ConnectionStatus.connected:
        return 'Connected';
      case ConnectionStatus.connecting:
        return 'Connecting...';
      case ConnectionStatus.reconnecting:
        return 'Reconnecting...';
      case ConnectionStatus.disconnected:
        return 'Disconnected';
      case ConnectionStatus.failed:
        return 'Connection Failed';
    }
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    _reconnectTimer?.cancel();
    _messageRetryTimer?.cancel();
    disconnect();
    super.onClose();
  }
}

class ChatJoinInfo {
  final String senderId;
  final String receiverId;

  ChatJoinInfo({required this.senderId, required this.receiverId});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }
}
