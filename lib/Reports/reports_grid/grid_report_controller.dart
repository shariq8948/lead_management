import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Reports/Marketing_reports/leade_analysis/lead_anylisis_page.dart';
import 'package:leads/utils/routes.dart';

import '../Expense_report/expense_report_page.dart';
import '../Marketing_reports/msr/MSR_screen.dart';
import '../Marketing_reports/visits/daily_visits/daily_visit_page.dart';
import '../Marketing_reports/visits/monthly_visit/monthly_visit_page.dart';
import '../Marketing_reports/visits/state_wise_visit/state_wise_visit_page.dart';
import '../activity_report/activity_report_page.dart';
import '../attendance/attendance_report_page.dart';
import '../login_history/login_report_page.dart';
import '../payement_report/daily_collection/daily_collection_page.dart';
import '../payement_report/monthly_collection/monthly_collection_page.dart';
import '../pipeline_reports/binding.dart';
import '../pipeline_reports/pipeline_reports_page.dart';
import 'subcategories_page.dart';

class ReportsController extends GetxController {
  final searchController = TextEditingController();
  final isSearching = false.obs;
  final filteredReportCategories = <ReportCategory>[].obs;

  // Original categories list
  final List<ReportCategory> reportCategories = [
    ReportCategory(
      label: "Payment Reports",
      icon: Icons.money,
      onTap: () => Get.to(() => SubcategoriesPage(), arguments: [
        Subcategory(
            label: "Daily Collection",
            icon: Icons.calendar_today,
            onTap: () => Get.to(() => DailyCollectionPage())),
        Subcategory(
            label: "Monthly Collection",
            icon: Icons.date_range,
            onTap: () => Get.to(() => MonthlyCollectionPage())),
        Subcategory(
            label: "MR Daily Collection",
            icon: Icons.account_balance,
            onTap: () => Get.toNamed(Routes.COLLECTION_REPORT)),
        Subcategory(
            label: "MR Monthly Collection", icon: Icons.account_balance_wallet),
      ]),
    ),
    ReportCategory(
      label: "Expense Reports",
      icon: Icons.money,
      onTap: () => Get.to(() => ExpensesScreen()),
    ),
    ReportCategory(
      label: "Marketing Reports",
      icon: Icons.trending_up,
      onTap: () => Get.to(() => SubcategoriesPage(), arguments: [
        Subcategory(
            label: "Leads Analysis",
            icon: Icons.analytics,
            onTap: () => Get.to(() => LeadAnalysisPage())),
        Subcategory(label: "Campaign Performance", icon: Icons.campaign),
        Subcategory(
            label: "Daily Visits",
            icon: Icons.calendar_view_day,
            onTap: () => Get.to(() => DailyVisitPage())),
        Subcategory(
            label: "Monthly Visits",
            icon: Icons.calendar_view_day,
            onTap: () => Get.to(() => MonthlyVisitPage())),
        Subcategory(
            label: "State wise Visits",
            icon: Icons.calendar_view_day,
            onTap: () => Get.to(() => StateWiseVisitPage())),
        Subcategory(
            label: "Promotional activity",
            icon: Icons.calendar_view_day,
            onTap: () => Get.to(() => DailyVisitPage())),
        Subcategory(
            label: "Daily planner",
            icon: Icons.calendar_view_day,
            onTap: () => Get.to(() => DailyVisitPage())),
        Subcategory(
            label: "Monthly planner",
            icon: Icons.calendar_view_day,
            onTap: () => Get.toNamed(Routes.MONTHLY_PLANNER)),
        Subcategory(
            label: "Monthly Attendance",
            icon: Icons.calendar_view_day,
            onTap: () => Get.to(() => DailyVisitPage())),
        Subcategory(
            label: "Calls(DSR)",
            icon: Icons.calendar_view_day,
            onTap: () => Get.to(() => DailyVisitPage())),
        Subcategory(
            label: "MSR Reports",
            icon: Icons.calendar_view_day,
            onTap: () => Get.toNamed(Routes.MSR_REPORT)),
      ]),
    ),
    ReportCategory(
        label: "Order Reports",
        icon: Icons.receipt,
        onTap: () => Get.toNamed(Routes.ORDER_REPORT)),
    ReportCategory(
      label: "Daily Attendance",
      icon: Icons.access_time,
      onTap: () => Get.to(() => AttendanceReportPage()),
    ),
    ReportCategory(
      label: "Pipeline Report",
      icon: Icons.timeline,
      onTap: () => Get.to(
        () => const PipelineReportPage(),
        binding: PipelineBindings(),
      ),
    ),
    ReportCategory(
      label: "Activity Report",
      icon: Icons.timeline,
      onTap: () => Get.to(() => ActivityReportPage()),
    ),
    ReportCategory(
      label: "Login History",
      icon: Icons.history,
      onTap: () => Get.to(() => LoginHistoryPage()),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize filtered list with all categories
    filteredReportCategories.value = reportCategories;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      filteredReportCategories.value = reportCategories;
    }
  }

  void filterReports(String query) {
    if (query.isEmpty) {
      filteredReportCategories.value = reportCategories;
    } else {
      filteredReportCategories.value = reportCategories
          .where((report) =>
              report.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

class Subcategory {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  Subcategory({required this.label, required this.icon, this.onTap});
}

class ReportCategory {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  ReportCategory({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
