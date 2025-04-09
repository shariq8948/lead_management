import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:leads/chats/chatting/model.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'controller.dart';
import 'handler.dart';

class ChatScreen extends StatelessWidget {
  final String customerId;
  final String customerName;
  final String? customerAvatar;
  final String currentUserId;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late final ChatController chatController;

  ChatScreen({
    Key? key,
    required this.customerId,
    required this.customerName,
    this.customerAvatar,
    required this.currentUserId,
  }) : super(key: key) {
    chatController = Get.put(
      ChatController(
        currentUserId: currentUserId,
        receiverId: customerId,
      ),
      tag: customerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildDateDivider(),
            Expanded(
              child: _buildMessageList(),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage: customerAvatar != null
                ? CachedNetworkImageProvider(customerAvatar!)
                : null,
            child: customerAvatar == null
                ? Text(
                    customerName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => chatController.isTyping.value
                      ? const Text(
                          'typing...',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : const Text(
                          'Online',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              ],
            ),
          ),
          Obx(() => Container(
                child: Column(
                  children: [
                    // Connection status indicator
                    Text('Status: ${chatController.getConnectionStatusText()}'),

                    // Loading indicator
                    if (chatController.isLoading.value)
                      CircularProgressIndicator(),

                    // Messages list

                    // Typing indicator
                  ],
                ),
              ))
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Colors.black87),
          onPressed: () {
            // Implement voice call functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
    );
  }

  Widget _buildDateDivider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Today',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Obx(
      () => ListView.builder(
        controller: _scrollController,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: chatController.messages.length,
        itemBuilder: (context, index) {
          final message = chatController.messages[index];
          final isMe = message.senderId == currentUserId;
          final showTimeForMessage = _shouldShowTimeForMessage(index);

          return Column(
            children: [
              if (showTimeForMessage) _buildTimeDivider(message.timestamp),
              _buildMessageBubble(message, isMe),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: ChatBubble(
              clipper: ChatBubbleClipper8(
                  type:
                      isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              margin: EdgeInsets.only(
                left: isMe ? 50 : 0,
                right: isMe ? 0 : 50,
              ),
              backGroundColor: isMe ? Colors.blue : Colors.white,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(Get.context!).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: isMe ? Colors.white70 : Colors.black45,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color:
                                message.isRead ? Colors.white : Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey[200],
      backgroundImage: customerAvatar != null
          ? CachedNetworkImageProvider(customerAvatar!)
          : null,
      child: customerAvatar == null
          ? Text(
              customerName[0].toUpperCase(),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            )
          : null,
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              color: Colors.grey[600],
              onPressed: () => _showAttachmentOptions(context),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                onChanged: (_) => chatController.sendTypingNotification(),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    color: Colors.grey[600],
                    onPressed: () {
                      // Implement emoji picker
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            MaterialButton(
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  chatController.sendMessage(_messageController.text);
                  _messageController.clear();
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
              shape: const CircleBorder(),
              color: Colors.blue,
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AttachmentOptions(
        attachmentHandler: AttachmentHandler(),
        onMessageCreated: (message) {
          // If message is a ChatMessage object, extract the text content
          if (message is ChatMessage) {
            chatController.sendMessage(message.message);
          } else {
            // If message is already a String, send it directly
            chatController.sendMessage(message.toString());
          }
        },
        currentUserId: currentUserId,
        receiverId: customerId,
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                // Implement search functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Mute notifications'),
              onTap: () {
                // Implement mute functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallpaper),
              title: const Text('Wallpaper'),
              onTap: () {
                // Implement wallpaper change
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text(
                'Block user',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // Implement block functionality
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDivider(DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            timeago.format(timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowTimeForMessage(int index) {
    if (index == chatController.messages.length - 1) return true;

    final currentMessage = chatController.messages[index];
    final previousMessage = chatController.messages[index + 1];

    final timeDifference =
        currentMessage.timestamp.difference(previousMessage.timestamp);
    return timeDifference.inMinutes >= 30;
  }
}
