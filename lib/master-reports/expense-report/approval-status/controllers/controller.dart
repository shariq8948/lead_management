import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../categorization/controllers/controller.dart';

class ApprovalStatus {
  static const String pending = 'Pending';
  static const String approved = 'Approved';
  static const String rejected = 'Rejected';
  static const String requestInfo = 'More Info Needed';

  static Color getStatusColor(String status) {
    switch (status) {
      case pending:
        return Colors.amber.shade600;
      case approved:
        return Colors.green.shade600;
      case rejected:
        return Colors.red.shade600;
      case requestInfo:
        return Colors.blue.shade600;
      default:
        return Colors.grey;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status) {
      case pending:
        return Icons.hourglass_empty_outlined;
      case approved:
        return Icons.check_circle_outline;
      case rejected:
        return Icons.cancel_outlined;
      case requestInfo:
        return Icons.help_outline;
      default:
        return Icons.circle_outlined;
    }
  }
}

// Extend ExpenseData model with approval fields
class ExtendedExpenseData extends ExpenseData {
  final String status;
  final String? approver;
  final DateTime? approvalDate;
  final String? rejectionReason;
  final String submittedBy;
  final List<ApprovalComment> comments;

  ExtendedExpenseData({
    required String description,
    required String category,
    required double amount,
    required DateTime date,
    required String paymentMethod,
    required this.status,
    required this.submittedBy,
    this.approver,
    this.approvalDate,
    this.rejectionReason,
    this.comments = const [],
  }) : super(
          description: description,
          category: category,
          amount: amount,
          date: date,
          paymentMethod: paymentMethod,
        );
}

class ApprovalComment {
  final String author;
  final String message;
  final DateTime timestamp;
  final bool isPrivate;

  ApprovalComment({
    required this.author,
    required this.message,
    required this.timestamp,
    this.isPrivate = false,
  });
}

// Controller Extension
class ApprovalController extends GetxController {
  var pendingExpenses = <ExtendedExpenseData>[].obs;
  var approvedExpenses = <ExtendedExpenseData>[].obs;
  var rejectedExpenses = <ExtendedExpenseData>[].obs;
  var requestInfoExpenses = <ExtendedExpenseData>[].obs;

  var selectedTab = 0.obs;
  var isLoading = true.obs;
  var currentUser = "John Doe".obs; // In a real app, this would come from auth
  var isManager = true.obs; // For demo purposes

  @override
  void onInit() {
    super.onInit();
    fetchApprovalData();
  }

  void fetchApprovalData() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      pendingExpenses.value = [
        ExtendedExpenseData(
          description: "Client Dinner - ABC Corp",
          category: "Entertainment",
          amount: 245.00,
          date: DateTime.now().subtract(const Duration(days: 1)),
          paymentMethod: "Company Card",
          status: ApprovalStatus.pending,
          submittedBy: "Sarah Johnson",
        ),
        ExtendedExpenseData(
          description: "Office Supplies - Q1",
          category: "Office Supplies",
          amount: 687.50,
          date: DateTime.now().subtract(const Duration(days: 2)),
          paymentMethod: "Credit Card",
          status: ApprovalStatus.pending,
          submittedBy: "Michael Chen",
        ),
      ];

      approvedExpenses.value = [
        ExtendedExpenseData(
          description: "Team Building Event",
          category: "Operations",
          amount: 1250.00,
          date: DateTime.now().subtract(const Duration(days: 5)),
          paymentMethod: "Bank Transfer",
          status: ApprovalStatus.approved,
          submittedBy: "Sarah Johnson",
          approver: "John Doe",
          approvalDate: DateTime.now().subtract(const Duration(days: 3)),
          comments: [
            ApprovalComment(
              author: "John Doe",
              message: "Approved as per quarterly budget allocation",
              timestamp: DateTime.now().subtract(const Duration(days: 3)),
            ),
          ],
        ),
      ];

      rejectedExpenses.value = [
        ExtendedExpenseData(
          description: "Premium Software License",
          category: "Software",
          amount: 899.00,
          date: DateTime.now().subtract(const Duration(days: 7)),
          paymentMethod: "Credit Card",
          status: ApprovalStatus.rejected,
          submittedBy: "Michael Chen",
          approver: "John Doe",
          approvalDate: DateTime.now().subtract(const Duration(days: 6)),
          rejectionReason:
              "Please use the company-wide license we already purchased",
          comments: [
            ApprovalComment(
              author: "Michael Chen",
              message: "Need this for the new project",
              timestamp: DateTime.now().subtract(const Duration(days: 7)),
            ),
            ApprovalComment(
              author: "John Doe",
              message:
                  "We already have licenses available in the IT department",
              timestamp: DateTime.now().subtract(const Duration(days: 6)),
              isPrivate: true,
            ),
          ],
        ),
      ];

      requestInfoExpenses.value = [
        ExtendedExpenseData(
          description: "Marketing Conference Travel",
          category: "Travel",
          amount: 2450.00,
          date: DateTime.now().subtract(const Duration(days: 4)),
          paymentMethod: "Company Card",
          status: ApprovalStatus.requestInfo,
          submittedBy: "Emily Wilson",
          approver: "John Doe",
          comments: [
            ApprovalComment(
              author: "Emily Wilson",
              message:
                  "Requesting approval for marketing conference next month",
              timestamp: DateTime.now().subtract(const Duration(days: 4)),
            ),
            ApprovalComment(
              author: "John Doe",
              message:
                  "Please attach the conference agenda and expected outcomes",
              timestamp: DateTime.now().subtract(const Duration(days: 3)),
            ),
          ],
        ),
      ];

      isLoading.value = false;
    });
  }

  List<ExtendedExpenseData> getExpensesByStatus() {
    switch (selectedTab.value) {
      case 0:
        return pendingExpenses;
      case 1:
        return approvedExpenses;
      case 2:
        return rejectedExpenses;
      case 3:
        return requestInfoExpenses;
      default:
        return pendingExpenses;
    }
  }

  void changeExpenseStatus(ExtendedExpenseData expense, String newStatus,
      {String? comment, String? reason}) {
    // In real implementation, this would make an API call to update the backend

    // Remove from current list
    switch (expense.status) {
      case ApprovalStatus.pending:
        pendingExpenses.remove(expense);
        break;
      case ApprovalStatus.approved:
        approvedExpenses.remove(expense);
        break;
      case ApprovalStatus.rejected:
        rejectedExpenses.remove(expense);
        break;
      case ApprovalStatus.requestInfo:
        requestInfoExpenses.remove(expense);
        break;
    }

    // Create new expense object with updated status
    final updatedExpense = ExtendedExpenseData(
      description: expense.description,
      category: expense.category,
      amount: expense.amount,
      date: expense.date,
      paymentMethod: expense.paymentMethod,
      status: newStatus,
      submittedBy: expense.submittedBy,
      approver: currentUser.value,
      approvalDate: newStatus == ApprovalStatus.approved ||
              newStatus == ApprovalStatus.rejected
          ? DateTime.now()
          : null,
      rejectionReason: newStatus == ApprovalStatus.rejected ? reason : null,
      comments: [...expense.comments],
    );

    // Add the comment if provided
    if (comment != null && comment.isNotEmpty) {
      updatedExpense.comments.add(ApprovalComment(
        author: currentUser.value,
        message: comment,
        timestamp: DateTime.now(),
      ));
    }

    // Add to new list
    switch (newStatus) {
      case ApprovalStatus.pending:
        pendingExpenses.add(updatedExpense);
        break;
      case ApprovalStatus.approved:
        approvedExpenses.add(updatedExpense);
        break;
      case ApprovalStatus.rejected:
        rejectedExpenses.add(updatedExpense);
        break;
      case ApprovalStatus.requestInfo:
        requestInfoExpenses.add(updatedExpense);
        break;
    }

    // Refresh lists
    pendingExpenses.refresh();
    approvedExpenses.refresh();
    rejectedExpenses.refresh();
    requestInfoExpenses.refresh();
  }

  void addComment(ExtendedExpenseData expense, String message,
      {bool isPrivate = false}) {
    final comment = ApprovalComment(
      author: currentUser.value,
      message: message,
      timestamp: DateTime.now(),
      isPrivate: isPrivate,
    );

    expense.comments.add(comment);

    // Refresh the relevant list
    switch (expense.status) {
      case ApprovalStatus.pending:
        pendingExpenses.refresh();
        break;
      case ApprovalStatus.approved:
        approvedExpenses.refresh();
        break;
      case ApprovalStatus.rejected:
        rejectedExpenses.refresh();
        break;
      case ApprovalStatus.requestInfo:
        requestInfoExpenses.refresh();
        break;
    }
  }
}
