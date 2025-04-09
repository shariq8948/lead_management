import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'notification_controller.dart';
import 'notification_model.dart';

class NotificationsPage extends StatelessWidget {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              Obx(() {
                final unreadCount = notificationController.notifications
                    .where((n) => !n.isRead)
                    .length;
                return Text(
                  unreadCount > 0
                      ? '${unreadCount} new updates'
                      : 'All notifications read',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          Obx(
            () => notificationController.notifications.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red[50],
                        ),
                        child: Icon(Icons.delete_sweep_rounded,
                            color: Colors.red[400], size: 26),
                      ),
                      onPressed: () => _showClearDialog(context),
                      tooltip: 'Clear All',
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        final notifications = notificationController.notifications;

        if (notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          onRefresh: notificationController.loadNotifications,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: notifications.length + 1,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader(notifications);
              }

              final notification = notifications[index - 1];
              return _buildNotificationCard(notification, context);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/empty-state.svg',
            height: 200,
            width: 200,
          ),
          SizedBox(height: 32),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'You’re all caught up! Check back later for new updates',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => notificationController.loadNotifications(),
            icon: Icon(Icons.refresh_rounded, size: 20),
            label:
                Text('Refresh', style: TextStyle(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 1,
              shadowColor: Colors.blue.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<AppNotification> notifications) {
    final today = notifications
        .where((n) => n.timestamp.day == DateTime.now().day)
        .length;

    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          Text(
            'Today • $today',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog(AppNotification notification) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                notification.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),

              // Description
              Text(
                notification.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 12),

              // Timestamp
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    timeago.format(notification.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text("Close", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      AppNotification notification, BuildContext context) {
    final hasImage =
        notification.imageUrl != null && notification.imageUrl!.isNotEmpty;

    return Slidable(
      key: Key(notification.id),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          if (!notification.isRead)
            SlidableAction(
              onPressed: (_) => notificationController
                  .markNotificationAsRead(notification.id),
              backgroundColor: Colors.blue[600]!,
              foregroundColor: Colors.white,
              icon: Icons.mark_email_read_rounded,
              label: 'Mark Read',
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          SlidableAction(
            onPressed: (_) => _showDeleteConfirmation(context, notification.id),
            backgroundColor: Colors.red[400]!,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              notificationController.markNotificationAsRead(notification.id);
              if (notification.navigationTarget.isNotEmpty) {
                if (notification.navigationTarget == "general") {
                  _showNotificationDialog(notification);
                } else {
                  _showNavigationAnimation(context, notification);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (!notification.isRead)
                    ? Colors.white
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  (!notification.isRead)
                      ? BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      : BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                ],
                border: Border.all(
                  color: notification.isRead
                      ? Colors.grey[200]!
                      : Colors.blue[100]!,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationIcon(notification, hasImage),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue[600],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          notification.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 6),
                            Text(
                              timeago.format(notification.timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            if (notification.navigationTarget.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
                                      color: Colors.blue[800],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(AppNotification notification, bool hasImage) {
    return Container(
      // width: 48,
      // height: 48,
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey[100] : Colors.blue[50],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: hasImage
            ? CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(notification.imageUrl!),
              )
            : Icon(
                notification.isRead
                    ? Icons.check_circle_rounded
                    : Icons.notifications_active_rounded,
                color:
                    notification.isRead ? Colors.grey[500] : Colors.blue[600],
                size: 48,
              ),
      ),
    );
  }

  void _showNavigationAnimation(
      BuildContext context, AppNotification notification) {
    notificationController.navigateToPage(
      notification.navigationTarget,
      notification.navigationId,
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: Colors.red[400], size: 28),
            SizedBox(width: 12),
            Text(
              'Delete Notification',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'This notification will be permanently removed from your history.',
          style: TextStyle(color: Colors.grey[600], height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notificationController.deleteNotification(id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange[400], size: 28),
            SizedBox(width: 12),
            Text(
              'Clear All Notifications',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'This will permanently remove all notifications. You won’t be able to undo this action.',
          style: TextStyle(color: Colors.grey[600], height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              notificationController.clearNotifications();
              Get.back();
            },
            icon: Icon(Icons.delete_forever_rounded, size: 20),
            label: Text('Clear All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
