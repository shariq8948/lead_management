import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final bool hasActiveMeeting;
  final bool isActive;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final VoidCallback onNavigate;
  final VoidCallback onCall;
  final VoidCallback onReschedule;

  const MeetingCard({
    Key? key,
    required this.meeting,
    required this.hasActiveMeeting,
    required this.isActive,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.onNavigate,
    required this.onCall,
    required this.onReschedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = meeting.checkin == "1" && meeting.checkout == "1";
    final bool isDisabled = hasActiveMeeting && !isActive;
    final ThemeData theme = Theme.of(context);

    // Format the date and time for display
    DateTime meetingDateTime;
    String formattedDate = '';
    String formattedTime = '';

    try {
      if (meeting.vdate.contains("AM") || meeting.vdate.contains("PM")) {
        meetingDateTime = DateFormat("M/d/yyyy h:mm:ss a").parse(meeting.vdate);
        formattedDate = DateFormat("MMM d, yyyy").format(meetingDateTime);
        formattedTime = DateFormat("h:mm a").format(meetingDateTime);
      } else {
        meetingDateTime = DateFormat("M/d/yyyy").parse(meeting.vdate);
        formattedDate = DateFormat("MMM d, yyyy").format(meetingDateTime);
        formattedTime = "All day";
      }
    } catch (e) {
      formattedDate = meeting.vdate;
      formattedTime = "";
    }

    final CardStatus status = _getStatus();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        elevation: isActive ? 4 : 1,
        shadowColor:
            isActive ? theme.colorScheme.primary.withOpacity(0.4) : null,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: isActive
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
            borderRadius: BorderRadius.circular(16),
            color: isCompleted ? Color(0xFFF5F5F5) : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status header
              _buildStatusHeader(status, formattedTime, theme),

              // Meeting details
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and time indicator
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            meeting.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted ? Colors.grey[600] : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isCompleted) _buildTimeChip(formattedTime, theme),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Contact information
                    _buildDetailRow(
                      icon: Icons.person,
                      text: meeting.cname,
                      theme: theme,
                      isCompleted: isCompleted,
                    ),

                    // Location with navigation button if available
                    if (meeting.address.isNotEmpty)
                      _buildAddressRow(
                          meeting.address, theme, isCompleted, isDisabled),

                    // Date information
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      text: formattedDate,
                      theme: theme,
                      isCompleted: isCompleted,
                    ),

                    // Description if available
                    if (meeting.description.isNotEmpty)
                      _buildDetailRow(
                        icon: Icons.description,
                        text: meeting.description,
                        theme: theme,
                        isCompleted: isCompleted,
                      ),

                    // Remarks if available
                    if (meeting.remark.isNotEmpty)
                      _buildDetailRow(
                        icon: Icons.comment,
                        text: meeting.remark,
                        theme: theme,
                        isCompleted: isCompleted,
                        iconColor: theme.colorScheme.secondary,
                      ),
                  ],
                ),
              ),

              // Action buttons
              if (!isCompleted) _buildActionButtons(isDisabled, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(
      CardStatus status, String formattedTime, ThemeData theme) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case CardStatus.active:
        statusColor = Colors.green[700]!;
        statusText = "Active";
        statusIcon = Icons.check_circle;
        break;
      case CardStatus.completed:
        statusColor = Colors.grey[600]!;
        statusText = "Completed";
        statusIcon = Icons.task_alt;
        break;
      case CardStatus.overdue:
        statusColor = Colors.red[700]!;
        statusText = "Overdue";
        statusIcon = Icons.warning_amber;
        break;
      case CardStatus.today:
        statusColor = Colors.orange[700]!;
        statusText = "Today";
        statusIcon = Icons.today;
        break;
      case CardStatus.upcoming:
        statusColor = Colors.blue[700]!;
        statusText = "Upcoming";
        statusIcon = Icons.event;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            statusText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          if (formattedTime.isNotEmpty &&
              status != CardStatus.active &&
              status != CardStatus.completed)
            Text(
              formattedTime,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String formattedTime, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        formattedTime,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    required ThemeData theme,
    required bool isCompleted,
    Color? iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isCompleted
                ? Colors.grey[500]
                : (iconColor ?? theme.colorScheme.primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isCompleted ? Colors.grey[600] : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(
      String address, ThemeData theme, bool isCompleted, bool isDisabled) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            size: 18,
            color: isCompleted ? Colors.grey[500] : theme.colorScheme.primary,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              address,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isCompleted ? Colors.grey[600] : null,
              ),
            ),
          ),
          if (!isCompleted)
            IconButton(
              constraints: BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.directions, size: 18),
              color: isDisabled ? Colors.grey[400] : theme.colorScheme.primary,
              onPressed: isDisabled ? null : onNavigate,
              tooltip: "Navigate",
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDisabled, ThemeData theme) {
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: theme.colorScheme.onPrimary,
      backgroundColor: theme.colorScheme.primary,
      disabledForegroundColor: Colors.grey[400],
      disabledBackgroundColor: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
    );

    final secondaryButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
      disabledForegroundColor: Colors.grey[400],
      disabledBackgroundColor: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
    );

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Primary action button (Check-in/Check-out)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: buttonStyle,
              icon: Icon(isActive ? Icons.logout : Icons.login, size: 18),
              label: Text(isActive ? 'CHECK OUT' : 'CHECK IN'),
              onPressed:
                  isDisabled ? null : (isActive ? onCheckOut : onCheckIn),
            ),
          ),

          SizedBox(height: 10),

          // Secondary action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: secondaryButtonStyle,
                  icon: Icon(Icons.call, size: 16),
                  label: Text('CALL'),
                  onPressed: isDisabled ? null : onCall,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: secondaryButtonStyle,
                  icon: Icon(Icons.calendar_month, size: 16),
                  label: Text('RESCHEDULE'),
                  onPressed: isDisabled ? null : onReschedule,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CardStatus _getStatus() {
    if (isActive) {
      return CardStatus.active;
    } else if (meeting.checkin == "1" && meeting.checkout == "1") {
      return CardStatus.completed;
    }

    try {
      final DateTime meetingDate = DateFormat("M/d/yyyy").parse(meeting.vdate);
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);

      if (meetingDate.isBefore(today)) {
        return CardStatus.overdue;
      } else if (meetingDate.isAtSameMomentAs(today)) {
        return CardStatus.today;
      } else {
        return CardStatus.upcoming;
      }
    } catch (e) {
      return CardStatus.upcoming;
    }
  }
}

enum CardStatus {
  active,
  completed,
  overdue,
  today,
  upcoming,
}
