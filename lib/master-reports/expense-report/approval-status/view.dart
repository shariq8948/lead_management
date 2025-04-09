// Models

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:leads/utils/constants.dart';

import '../categorization/controllers/controller.dart';
import 'controllers/controller.dart';

// UI Components
class ExpenseApprovalScreen extends StatelessWidget {
  ExpenseApprovalScreen({Key? key}) : super(key: key);

  final ApprovalController controller = Get.put(ApprovalController());

  // Define consistent color scheme and styles
  final Color primaryColor = Colors.deepPurple.shade700;
  final Color secondaryColor = Colors.deepPurple.shade50;
  final Color surfaceColor = Colors.white;
  final Color dividerColor = Colors.grey.shade200;
  final double borderRadius = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Subtle background color
      appBar: AppBar(
        title: Text(
          'Expense Approvals',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        // backgroundColor: primary1Color,
        // foregroundColor: Colors.white,
        elevation: 0, // Modern flat design
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter expenses',
            onPressed: () {
              // Show filter options
              _showFilterOptions(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh data',
            onPressed: () {
              controller.fetchApprovalData();
              Get.snackbar(
                'Refreshing',
                'Updating expense data...',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.deepPurple.shade100,
                colorText: primaryColor,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 1),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildApprovalTabs(context),
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildSearchBar(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading expenses...',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final expenses = controller.getExpensesByStatus();
              if (expenses.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // await controller.fetchApprovalData();
                },
                color: primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    return _buildExpenseCard(expenses[index], context);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        // Only show FAB for managers to create guidance notes
        if (controller.isManager.value) {
          return FloatingActionButton(
            onPressed: () => _showCreateGuidanceDialog(context),
            backgroundColor: primaryColor,
            child: const Icon(Icons.lightbulb_outline),
            tooltip: 'Create expense guidance',
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          // Filter expenses based on search text
          // controller.searchExpenses(value);
        },
        decoration: InputDecoration(
          hintText: 'Search expenses...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade400,
          ),
          suffixIcon: Icon(
            Icons.tune,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildApprovalTabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 4,
        child: Obx(() {
          // Sync DefaultTabController with the GetX state when it changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (DefaultTabController.of(context) != null &&
                DefaultTabController.of(context)!.index !=
                    controller.selectedTab.value) {
              DefaultTabController.of(context)!
                  .animateTo(controller.selectedTab.value);
            }
          });

          return TabBar(
            onTap: (index) => controller.selectedTab.value = index,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
            unselectedLabelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: [
              Tab(
                text: 'Pending',
                icon: Badge(
                  label: Text(
                    '${controller.pendingExpenses.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  isLabelVisible: controller.pendingExpenses.isNotEmpty,
                  backgroundColor: Colors.orange.shade600,
                  child: Icon(
                    Icons.hourglass_top,
                    color: controller.selectedTab.value == 0
                        ? primaryColor
                        : Colors.grey.shade500,
                    size: 20,
                  ),
                ),
              ),
              Tab(
                text: 'Approved',
                icon: Icon(
                  Icons.check_circle_outline,
                  color: controller.selectedTab.value == 1
                      ? Colors.green.shade600
                      : Colors.grey.shade500,
                  size: 20,
                ),
              ),
              Tab(
                text: 'Rejected',
                icon: Icon(
                  Icons.cancel_outlined,
                  color: controller.selectedTab.value == 2
                      ? Colors.red.shade600
                      : Colors.grey.shade500,
                  size: 20,
                ),
              ),
              Tab(
                text: 'Info Needed',
                icon: Badge(
                  label: Text(
                    '${controller.requestInfoExpenses.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  isLabelVisible: controller.requestInfoExpenses.isNotEmpty,
                  backgroundColor: Colors.blue.shade600,
                  child: Icon(
                    Icons.help_outline,
                    color: controller.selectedTab.value == 3
                        ? Colors.blue.shade600
                        : Colors.grey.shade500,
                    size: 20,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    Widget actionButton = const SizedBox.shrink();

    switch (controller.selectedTab.value) {
      case 0:
        message = 'No pending expenses to approve';
        icon = Icons.check_circle_outline;
        if (controller.isManager.value) {
          actionButton = TextButton.icon(
            onPressed: () {
              // Show expense policy or guidance
              _showExpenseGuidance(controller.currentUser.value);
            },
            icon: const Icon(Icons.article_outlined),
            label: const Text('View Expense Policy'),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
            ),
          );
        }
        break;
      case 1:
        message = 'No approved expenses yet';
        icon = Icons.thumb_up_outlined;
        break;
      case 2:
        message = 'No rejected expenses';
        icon = Icons.thumb_down_outlined;
        break;
      case 3:
        message = 'No expenses need additional information';
        icon = Icons.help_outline;
        break;
      default:
        message = 'No expenses found';
        icon = Icons.receipt_long;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 72,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          actionButton,
        ],
      ),
    );
  }

  Widget _buildExpenseCard(ExtendedExpenseData expense, BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM dd, yyyy');
    final statusColor = ApprovalStatus.getStatusColor(expense.status);
    final statusIcon = ApprovalStatus.getStatusIcon(expense.status);

    // Add priority coloring
    final bool isHighPriority = expense.amount > 1000;
    // (expense.metadata != null && expense.metadata['priority'] == 'high');
    final bool isUrgent = expense.date.difference(DateTime.now()).inDays < 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: isHighPriority ? Colors.orange.shade200 : Colors.grey.shade200,
          width: isHighPriority ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Priority banner for high priority items
          if (isHighPriority || isUrgent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isUrgent ? Colors.red.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isUrgent ? Icons.timer : Icons.priority_high,
                    size: 16,
                    color:
                        isUrgent ? Colors.red.shade700 : Colors.orange.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isUrgent
                        ? 'Urgent: Review Required'
                        : 'High Priority Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isUrgent
                          ? Colors.red.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    expense.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        expense.status,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    expense.category,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    textColor: primaryColor,
                    icon: _getCategoryIcon(expense.category),
                  ),
                  _buildInfoChip(
                    dateFormat.format(expense.date),
                    backgroundColor: Colors.grey.shade100,
                    textColor: Colors.grey.shade700,
                    icon: Icons.event_note,
                  ),
                  _buildInfoChip(
                    expense.paymentMethod,
                    backgroundColor: Colors.grey.shade100,
                    textColor: Colors.grey.shade700,
                    icon: _getPaymentMethodIcon(expense.paymentMethod),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Amount info with card-like design
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(expense.amount),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Submitter info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Submitted by',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: primaryColor.withOpacity(0.2),
                          child: Text(
                            expense.submittedBy.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          expense.submittedBy,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Timeline display for expense history
          if (expense.comments.isNotEmpty || expense.rejectionReason != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: _buildExpenseTimeline(expense),
            ),

          // Rejection reason (if rejected)
          if (expense.rejectionReason != null &&
              expense.rejectionReason!.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        size: 16,
                        color: Colors.red.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Reason for rejection:',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    expense.rejectionReason!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),

          // Comments section
          if (expense.comments.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(color: dividerColor),
                ),
                borderRadius: expense.rejectionReason == null
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )
                    : BorderRadius.zero,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Comments (${expense.comments.where((comment) => !comment.isPrivate || controller.isManager.value).length})',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...expense.comments
                      .where((comment) =>
                          !comment.isPrivate || controller.isManager.value)
                      .map((comment) => _buildCommentItem(comment))
                      .toList(),

                  // Add comment option
                  TextButton.icon(
                    onPressed: () => _showAddCommentDialog(context, expense),
                    icon: const Icon(Icons.add_comment_outlined, size: 16),
                    label: Text(
                      'Add comment',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),

          // Action buttons - Only show for managers on pending items
          if (controller.selectedTab.value == 0 && controller.isManager.value)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(
                  top: BorderSide(color: dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRequestInfoDialog(context, expense),
                      icon: const Icon(Icons.help_outline, size: 18),
                      label: const Text('Request Info'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRejectDialog(context, expense),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showApproveDialog(context, expense),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Action buttons for requesting more info status
          if (controller.selectedTab.value == 3 &&
              expense.submittedBy == controller.currentUser.value)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(
                  top: BorderSide(color: dividerColor),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () => _showAddInfoDialog(context, expense),
                icon: const Icon(Icons.reply, size: 18),
                label: const Text('Add Information'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpenseTimeline(ExtendedExpenseData expense) {
    final List<Widget> timelineItems = [];
    final DateFormat timeFormat = DateFormat('MMM d, h:mm a');

    // Create timeline items from comments
    for (var i = 0; i < expense.comments.length; i++) {
      final comment = expense.comments[i];

      if (comment.isPrivate && !controller.isManager.value) continue;

      timelineItems.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (i < expense.comments.length - 1 ||
                    expense.rejectionReason != null)
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.author,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '· ${timeFormat.format(comment.timestamp)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (comment.isPrivate) ...[
                        const SizedBox(width: 4),
                        Tooltip(
                          message: 'Only visible to managers',
                          child: Icon(
                            Icons.visibility_off,
                            size: 14,
                            color: Colors.amber.shade800,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.message,
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Add rejection reason to timeline if present
    if (expense.rejectionReason != null &&
        expense.rejectionReason!.isNotEmpty) {
      timelineItems.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Expense Rejected',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(children: timelineItems);
  }

  Widget _buildInfoChip(
    String label, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: textColor ?? Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(ApprovalComment comment) {
    final timeFormat = DateFormat('MMM d, h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: comment.isPrivate ? Colors.yellow.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              comment.isPrivate ? Colors.yellow.shade200 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: comment.author == controller.currentUser.value
                    ? primaryColor
                    : Colors.grey.shade600,
                child: Text(
                  comment.author.substring(0, 1).toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.author,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                timeFormat.format(comment.timestamp),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment.message,
            style: GoogleFonts.poppins(
              fontSize: 13,
            ),
          ),
          if (comment.isPrivate) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.visibility_off,
                  size: 14,
                  color: Colors.amber.shade800,
                ),
                const SizedBox(width: 4),
                Text(
                  'Private note (only visible to managers)',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'travel':
        return Icons.flight_outlined;
      case 'meals':
        return Icons.restaurant_outlined;
      case 'office supplies':
        return Icons.shopping_bag_outlined;
      case 'software':
        return Icons.computer_outlined;
      case 'equipment':
        return Icons.devices_outlined;
      case 'training':
        return Icons.school_outlined;
      case 'entertainment':
        return Icons.celebration_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
        return Icons.credit_card_outlined;
      case 'company card':
        return Icons.corporate_fare_outlined;
      case 'cash':
        return Icons.payments_outlined;
      case 'bank transfer':
        return Icons.account_balance_outlined;
      case 'paypal':
        return Icons.payment_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Wrap(
          children: [
            Row(
              children: [
                Text(
                  'Filter Expenses',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filter options
            _buildFilterSection('Date Range', [
              'All Time',
              'This Week',
              'This Month',
              'Last Month',
              'Custom Range',
            ]),
            const Divider(),
            _buildFilterSection('Categories', [
              'All Categories',
              'Travel',
              'Meals',
              'Office Supplies',
              'Software',
              'Equipment',
              'Training',
              'Entertainment',
            ]),
            const Divider(),
            _buildFilterSection('Amount Range', [
              'All Amounts',
              'Under \$100',
              '\$100 - \$500',
              '\$500 - \$1000',
              'Over \$1000',
            ]),
            const Divider(),
            _buildFilterSection('Submitted By', [
              'All Employees',
              'My Team Only',
            ]),
            const SizedBox(height: 24),
            // Apply and Reset buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // controller.resetFilters();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: primaryColor),
                    ),
                    child: Text(
                      'Reset',
                      style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Apply filters
                      // controller.applyFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            // final isSelected = controller.currentFilters.contains(option);
            final isSelected = true;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  // controller.addFilter(option);
                } else {
                  // controller.removeFilter(option);
                }
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: primaryColor.withOpacity(0.2),
              checkmarkColor: primaryColor,
              labelStyle: GoogleFonts.poppins(
                color: isSelected ? primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showApproveDialog(BuildContext context, ExtendedExpenseData expense) {
    final commentController = TextEditingController();
    bool addPrivateNote = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Approve Expense',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are approving: ${expense.description}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Amount: \$${expense.amount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 24),
              Text(
                'Add comment (optional):',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Enter comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Private note option
              Row(
                children: [
                  Checkbox(
                    value: addPrivateNote,
                    onChanged: (value) {
                      setState(() {
                        addPrivateNote = value ?? false;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          addPrivateNote = !addPrivateNote;
                        });
                      },
                      child: Text(
                        'Add as private note (only visible to other managers)',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Approve the expense
                // controller.approveExpense(
                //   expense.id,
                //   commentController.text,
                //   addPrivateNote,
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
              ),
              child: Text(
                'Approve',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, ExtendedExpenseData expense) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reject Expense',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are rejecting: ${expense.description}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Reason for rejection:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText:
                    reasonController.text.isEmpty ? 'Reason is required' : null,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                // Show error
                return;
              }
              Navigator.of(context).pop();
              // Reject the expense
              // controller.rejectExpense(
              //   expense.id,
              //   reasonController.text,
              // );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: Text(
              'Reject',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestInfoDialog(
      BuildContext context, ExtendedExpenseData expense) {
    final requestController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Request Additional Information',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense: ${expense.description}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Information needed:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: requestController,
              decoration: InputDecoration(
                hintText: 'Specify what information you need...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (requestController.text.isEmpty) {
                // Show error
                return;
              }
              Navigator.of(context).pop();
              // Request information
              // controller.requestInfoForExpense(
              //   expense.id,
              //   requestController.text,
              // );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
            ),
            child: Text(
              'Request Info',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddInfoDialog(BuildContext context, ExtendedExpenseData expense) {
    final infoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Provide Additional Information',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense: ${expense.description}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your response:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: infoController,
              decoration: InputDecoration(
                hintText: 'Provide the requested information...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (infoController.text.isEmpty) {
                // Show error
                return;
              }
              Navigator.of(context).pop();
              // Provide information
              // controller.provideAdditionalInfo(
              //   expense.id,
              //   infoController.text,
              // );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
            ),
            child: Text(
              'Submit',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCommentDialog(
      BuildContext context, ExtendedExpenseData expense) {
    final commentController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Add Comment',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Enter your comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 4,
              ),
              if (controller.isManager.value) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isPrivate,
                      onChanged: (value) {
                        setState(() {
                          isPrivate = value ?? false;
                        });
                      },
                      activeColor: primaryColor,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPrivate = !isPrivate;
                          });
                        },
                        child: Text(
                          'Private comment (only visible to managers)',
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (commentController.text.isEmpty) {
                  // Show error
                  return;
                }
                Navigator.of(context).pop();
                // Add comment
                // controller.addComment(
                //   // expense.id,
                //   commentController.text,
                //   // isPrivate,
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              child: Text(
                'Add Comment',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateGuidanceDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create Expense Policy Guidance',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'e.g., Meal Expense Limits',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Guidance Content:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: 'Enter policy guidance details...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  contentController.text.isEmpty) {
                // Show error
                return;
              }
              Navigator.of(context).pop();
              // Create guidance
              // controller.createGuidance(
              //   titleController.text,
              //   contentController.text,
              // );

              Get.snackbar(
                'Guidance Created',
                'New expense policy guidance has been added',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade100,
                colorText: Colors.green.shade800,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: Text(
              'Create Guidance',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExpenseGuidance(String username) {
    // Show expense policy guidance based on user role
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.article_outlined,
                    color: primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Expense Policy Guidelines',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const ExpensePolicyContent(),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Got it',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A separate widget for the expense policy content
class ExpensePolicyContent extends StatelessWidget {
  const ExpensePolicyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicySection(
            'General Guidelines',
            'All expenses must be business-related and have appropriate documentation. '
                'Receipts are required for all expenses over \$25. '
                'Submit expenses within 30 days of incurring them.',
            Icons.description_outlined,
          ),
          const SizedBox(height: 16),
          _buildPolicySection(
            'Travel Expenses',
            'Book economy class for flights unless specifically approved. '
                'Hotel stays should not exceed \$250 per night in standard locations. '
                'Use company travel portal for bookings when possible.',
            Icons.flight_outlined,
          ),
          const SizedBox(height: 16),
          _buildPolicySection(
            'Meal Allowances',
            'Breakfast: Up to \$15\n'
                'Lunch: Up to \$25\n'
                'Dinner: Up to \$50\n'
                'Alcohol is not reimbursable except for client entertainment.',
            Icons.restaurant_outlined,
          ),
          const SizedBox(height: 16),
          _buildPolicySection(
            'Approval Process',
            'All expenses require manager approval.\n'
                'Expenses over \$1,000 require director level approval.\n'
                'International travel requires VP approval.',
            Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.deepPurple.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// This class is used for status colors and icons
class ExpenseDetailScreen extends StatelessWidget {
  final ExtendedExpenseData expense;

  const ExpenseDetailScreen({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Details',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        ),
        // backgroundColor: primary1Color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: ApprovalStatus.getStatusColor(expense.status)
                  .withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        ApprovalStatus.getStatusIcon(expense.status),
                        color: ApprovalStatus.getStatusColor(expense.status),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        expense.status,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ApprovalStatus.getStatusColor(expense.status),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    expense.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(expense.amount),
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.deepPurple.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Expense details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense Details',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem('Category', expense.category),
                  _buildDetailItem('Date', dateFormat.format(expense.date)),
                  _buildDetailItem('Payment Method', expense.paymentMethod),
                  _buildDetailItem('Submitted By', expense.submittedBy),

                  if (expense.approver != null)
                    _buildDetailItem('Approver', expense.approver!),

                  if (expense.approvalDate != null)
                    _buildDetailItem(
                      'Approval Date',
                      '${dateFormat.format(expense.approvalDate!)} at ${timeFormat.format(expense.approvalDate!)}',
                    ),

                  const SizedBox(height: 24),

                  // Audit trail/activity log
                  Text(
                    'Activity Log',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        expense.comments.length + 1, // +1 for submission entry
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildActivityItem(
                          'Expense submitted by ${expense.submittedBy}',
                          expense.date,
                          Icons.add_circle_outline,
                          Colors.green.shade700,
                        );
                      }

                      final comment = expense.comments[index - 1];
                      IconData icon;
                      Color iconColor;

                      if (comment.message.contains('Rejection:')) {
                        icon = Icons.cancel_outlined;
                        iconColor = Colors.red.shade700;
                      } else if (comment.message.contains('Approved')) {
                        icon = Icons.check_circle_outline;
                        iconColor = Colors.green.shade700;
                      } else {
                        icon = Icons.comment_outlined;
                        iconColor = Colors.blue.shade700;
                      }

                      return _buildActivityItem(
                        '${comment.author}: ${comment.message}',
                        comment.timestamp,
                        icon,
                        iconColor,
                        isPrivate: comment.isPrivate,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String text,
    DateTime timestamp,
    IconData icon,
    Color iconColor, {
    bool isPrivate = false,
  }) {
    final dateFormat = DateFormat('MMM d, yyyy - h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrivate ? Colors.yellow.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrivate ? Colors.yellow.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: GoogleFonts.montserrat(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(timestamp),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (isPrivate) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_off,
                        size: 12,
                        color: Colors.amber.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Private note (visible to managers only)',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
