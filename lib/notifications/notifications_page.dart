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
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildFilters(context),
          Expanded(
            child: Obx(() {
              final notifications =
                  notificationController.filteredNotifications;
              if (notifications.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                color: Colors.blue[600],
                strokeWidth: 2.5,
                backgroundColor: Colors.white,
                onRefresh: notificationController.loadNotifications,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationCard(notification, context);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final unreadCount =
            notificationController.notifications.where((n) => !n.isRead).length;
        return unreadCount > 0
            ? FloatingActionButton(
                onPressed: () {
                  for (var notification in notificationController.notifications
                      .where((n) => !n.isRead)) {
                    notificationController
                        .markNotificationAsRead(notification.id);
                  }
                },
                backgroundColor: Colors.blue[600],
                child: Icon(Icons.done_all_rounded),
                tooltip: 'Mark all read',
              )
            : SizedBox.shrink();
      }),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Obx(() {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    'All',
                    notificationController.currentFilter.value == 'All',
                    () => notificationController.setFilter('All'),
                    icon: Icons.filter_list_rounded,
                  ),
                  _buildFilterChip(
                    'Unread',
                    notificationController.currentFilter.value == 'Unread',
                    () => notificationController.setFilter('Unread'),
                    icon: Icons.mark_email_unread_rounded,
                  ),
                  _buildFilterChip(
                    'Tasks',
                    notificationController.currentFilter.value == 'task',
                    () => notificationController.setFilter('task'),
                    icon: Icons.task_alt_rounded,
                  ),
                  _buildFilterChip(
                    'Alerts',
                    notificationController.currentFilter.value == 'alert',
                    () => notificationController.setFilter('alert'),
                    icon: Icons.warning_rounded,
                  ),
                  _buildFilterChip(
                    'Reminders',
                    notificationController.currentFilter.value == 'reminder',
                    () => notificationController.setFilter('reminder'),
                    icon: Icons.notification_important_rounded,
                  ),
                  _buildFilterChip(
                    'Approvals',
                    notificationController.currentFilter.value == 'approval',
                    () => notificationController.setFilter('approval'),
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ],
              ),
            ),

            // Stats row
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Text(
                    'Showing ${notificationController.filteredNotifications.length} notifications',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  notificationController.notifications.isNotEmpty
                      ? TextButton.icon(
                          onPressed: () => _showClearDialog(context),
                          icon: Icon(Icons.delete_sweep_rounded, size: 18),
                          label: Text('Clear All'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(String label, bool isSelected, Function() onTap,
      {IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          Obx(() {
            final unreadCount = notificationController.notifications
                .where((n) => !n.isRead)
                .length;
            return Text(
              unreadCount > 0 ? '${unreadCount} new updates' : 'All caught up',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            );
          }),
        ],
      ),
      actions: [
        Obx(
          () => notificationController.notifications.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.search_rounded, color: Colors.grey[800]),
                  onPressed: () => _showSearchDialog(context),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/empty-state.svg',
            height: 160,
            width: 160,
          ),
          SizedBox(height: 24),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "You're all caught up! Check back later for new updates",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => notificationController.loadNotifications(),
            icon: Icon(Icons.refresh_rounded, size: 18),
            label: Text('Refresh'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue[600],
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    AppNotification notification,
    BuildContext context,
  ) {
    final hasImage = notification.imageUrl?.isNotEmpty ?? false;
    final notificationType = notification.notificationType ?? '';
    final isPopup = notification.notificationAction == 'Popup';
    final unread = !notification.isRead;
    final Color typeColor = _getNotificationTypeColor(notificationType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        key: Key(notification.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if (unread)
              SlidableAction(
                onPressed: (_) => notificationController
                    .markNotificationAsRead(notification.id),
                backgroundColor: Colors.blue[600]!,
                foregroundColor: Colors.white,
                icon: Icons.mark_email_read_rounded,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            SlidableAction(
              onPressed: (_) =>
                  _showDeleteConfirmation(context, notification.id),
              backgroundColor: Colors.red[400]!,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              borderRadius: unread
                  ? const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : BorderRadius.circular(12),
            ),
          ],
        ),
        child: _buildNotificationCardContent(
          context,
          notification,
          unread,
          hasImage,
          notificationType,
          isPopup,
          typeColor,
          notificationController,
        ),
      ),
    );
  }

  Widget _buildNotificationCardContent(
    BuildContext context,
    AppNotification notification,
    bool unread,
    bool hasImage,
    String notificationType,
    bool isPopup,
    Color typeColor,
    NotificationController notificationController,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: unread ? typeColor.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      elevation: unread ? 1 : 0,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleNotificationTap(
            context, notification, notificationController),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(notification, hasImage, notificationType),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleRow(
                        notification, unread, notificationType, typeColor),
                    const SizedBox(height: 4),
                    _buildDescription(notification),
                    const SizedBox(height: 8),
                    _buildBottomRow(notification, notificationType, typeColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    AppNotification notification,
    NotificationController notificationController,
  ) {
    notificationController.markNotificationAsRead(notification.id);

    if (notification.notificationAction == 'Popup') {
      _showPopupNotification(notification);
    } else if (notification.navigationTarget.isNotEmpty) {
      if (notification.navigationTarget == "general") {
        _showNotificationDialog(notification, context);
      } else {
        _showNavigationAnimation(context, notification);
      }
    } else {
      _showNotificationDialog(notification, context);
    }
  }

  Widget _buildTitleRow(
    AppNotification notification,
    bool unread,
    String notificationType,
    Color typeColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            notification.title,
            style: TextStyle(
              fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
        if (unread)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: typeColor,
            ),
          ),
      ],
    );
  }

  Widget _buildDescription(AppNotification notification) {
    return Text(
      notification.description,
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[600],
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBottomRow(
    AppNotification notification,
    String notificationType,
    Color typeColor,
  ) {
    final bool hasAction = notification.navigationTarget.isNotEmpty ||
        notification.notificationAction == 'Popup';

    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 12,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          timeago.format(notification.timestamp),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
        const Spacer(),
        if (hasAction)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getActionText(notification),
              style: TextStyle(
                fontSize: 11,
                color: typeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  String _getActionText(AppNotification notification) {
    if (notification.notificationAction == 'Popup') {
      return 'Action Required';
    } else if (notification.navigationTarget.isNotEmpty) {
      return notification.navigationTarget == "general"
          ? 'View Details'
          : 'Open';
    }
    return 'View';
  }

  Widget _buildNotificationIcon(
    AppNotification notification,
    bool hasImage,
    String notificationType,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getNotificationTypeColor(notificationType).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  notification.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _getNotificationIconByType(
                          notificationType, notification.isRead),
                ),
              )
            : _getNotificationIconByType(notificationType, notification.isRead),
      ),
    );
  }

  Widget _getNotificationIconByType(String notificationType, bool isRead) {
    IconData iconData;
    Color iconColor = _getNotificationTypeColor(notificationType);

    switch (notificationType.toLowerCase()) {
      case 'task':
        iconData = Icons.task_alt_rounded;
        break;
      case 'alert':
        iconData = Icons.warning_rounded;
        break;
      case 'reminder':
        iconData = Icons.notification_important_rounded;
        break;
      case 'approval':
        iconData = Icons.check_circle_outline_rounded;
        break;
      case 'payment':
        iconData = Icons.payments_rounded;
        break;
      case 'expense':
        iconData = Icons.receipt_long_rounded;
        break;
      default:
        iconData = Icons.notifications_active_rounded;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 20,
    );
  }

  Color _getNotificationTypeColor(String notificationType) {
    switch (notificationType.toLowerCase()) {
      case 'task':
        return Colors.blue[600]!;
      case 'alert':
        return Colors.red[600]!;
      case 'reminder':
        return Colors.amber[700]!;
      case 'approval':
        return Colors.purple[600]!;
      case 'payment':
        return Colors.green[600]!;
      case 'expense':
        return Colors.orange[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  void _showNotificationDialog(
      AppNotification notification, BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.imageUrl != null &&
                  notification.imageUrl!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    notification.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        color: Colors.grey[200],
                        child: Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
              ],
              Text(
                notification.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                notification.description,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[700], height: 1.4),
              ),
              SizedBox(height: 12),
              if (notification.priority != null) ...[
                _buildDetailItem('Priority', notification.priority!,
                    _getPriorityColor(notification.priority!)),
                SizedBox(height: 8),
              ],
              if (notification.location != null &&
                  notification.location!.isNotEmpty) ...[
                _buildDetailItem(
                    'Location', notification.location!, Colors.blue[700]!),
                SizedBox(height: 8),
              ],
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    child: Text("Dismiss"),
                  ),
                  SizedBox(width: 8),
                  if (notification.navigationTarget.isNotEmpty &&
                      notification.navigationTarget != "general") ...[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        _showNavigationAnimation(context, notification);
                      },
                      child: Text("View Details"),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red[700]!;
      case 'medium':
        return Colors.orange[700]!;
      case 'low':
        return Colors.green[700]!;
      default:
        return Colors.blue[700]!;
    }
  }

  void _showPopupNotification(AppNotification notification) {
    final actionType = notification.popupDataActionType ?? "";
    final actionId = notification.popupDataActionId ?? "";
    final remark = notification.popupDataRemark ?? "";

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getActionTypeColor(actionType).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getActionTypeIcon(actionType),
                  color: _getActionTypeColor(actionType),
                  size: 28,
                ),
              ),
              SizedBox(height: 16),
              if (notification.imageUrl != null &&
                  notification.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    notification.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox();
                    },
                  ),
                ),
              SizedBox(height: 16),
              Text(
                notification.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                notification.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              if (remark.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      remark,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Dismiss',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handlePopupAction(
                          actionType,
                          actionId,
                          notification.popupAdditionalData ?? '',
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getActionTypeColor(actionType),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _getActionButtonText(actionType),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActionTypeIcon(String actionType) {
    switch (actionType) {
      case 'Approval':
        return Icons.check_circle_rounded;
      case 'PaymentCollection':
        return Icons.payment_rounded;
      case 'ExpenseApproval':
        return Icons.receipt_long_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getActionTypeColor(String actionType) {
    switch (actionType) {
      case 'Approval':
        return Colors.green[600]!;
      case 'PaymentCollection':
        return Colors.blue[600]!;
      case 'ExpenseApproval':
        return Colors.orange[600]!;
      default:
        return Colors.purple[600]!;
    }
  }

  String _getActionButtonText(String actionType) {
    switch (actionType) {
      case 'Approval':
        return 'Approve';
      case 'PaymentCollection':
        return 'Process Payment';
      case 'ExpenseApproval':
        return 'Review Expense';
      default:
        return 'Take Action';
    }
  }

  void _handlePopupAction(
    String actionType,
    String actionId,
    String additionalData,
  ) {
    notificationController.navigateToPage(
      actionType.toLowerCase(),
      actionId,
    );
  }

  void _showNavigationAnimation(
      BuildContext context, AppNotification notification) {
    notificationController.navigateToPage(
      notification.navigationTarget,
      notification.navigationId.toString(),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: Colors.red[400], size: 24),
            SizedBox(width: 10),
            Text(
              'Delete Notification',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'This notification will be permanently removed.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notificationController.deleteNotification(id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
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
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange[400], size: 24),
            SizedBox(width: 10),
            Text(
              'Clear All Notifications',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'Permanently remove all notifications?',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notificationController.clearNotifications();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text('Search Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or description',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              autofocus: true,
              onSubmitted: (value) {
                _performSearch(value);
                Get.back();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _performSearch(searchController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
            ),
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      notificationController.setFilter('All');
      return;
    }

    // Create a temporary filtered list based on search
    final searchResults = notificationController.notifications
        .where((notification) =>
            notification.title.toLowerCase().contains(query.toLowerCase()) ||
            notification.description
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();

    // Set the search results
    notificationController.setSearchResults(searchResults);
  }
}
