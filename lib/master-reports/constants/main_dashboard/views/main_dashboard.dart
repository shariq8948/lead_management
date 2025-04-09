import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads/master-reports/customers/cac/view.dart';
import 'package:leads/master-reports/customers/repeated-purchase/view/view.dart';
import 'package:leads/master-reports/employee-performance/target-comparison/view.dart';
import 'package:leads/master-reports/expense-report/budget-variance/view.dart';
import 'package:leads/utils/routes.dart';

import '../../../collection-report/aging/view.dart';
import '../../../collection-report/outstandings/views/view.dart';
import '../../../collection-report/payement-method-analysis/views/view.dart';
import '../../../collection-report/payment-collection/view.dart';
import '../../../customers/lifetime-value/views/view.dart';
import '../../../customers/segmentation/views/view.dart';
import '../../../employee-performance/activity-metrics/view.dart';
import '../../../employee-performance/individual-metrics/view.dart';
import '../../../employee-performance/lead-handling-status/view/view.dart';
import '../../../expense-report/approval-status/view.dart';
import '../../../expense-report/categorization/views/view.dart';
import '../../../expense-report/roi/view.dart';
import '../../../financial-reports/comparison/view.dart';
import '../../../financial-reports/projected-vs-actual/view/view.dart';
import '../../../financial-reports/revenue/view.dart';
import '../../../financial-reports/seasonal-trends/view.dart';
import '../../../leadlifecycle/bottle-neck/view/view.dart';
import '../../../leadlifecycle/conversion_analytics/view/conversion_analytics.dart';
import '../../../leadlifecycle/lead_stage_duration/view/view.dart';
import '../../../order-and-quotation/average-quotationtime/view.dart';
import '../../../order-and-quotation/conversion-rate/view.dart';
import '../../../order-and-quotation/discount-analysis/view.dart';
import '../../../sales-performance/revenue-trend/view/view.dart';
import '../../../sales-performance/sales-breakdown/view/view.dart';
import '../../../sales-performance/target-comparision/view/comparison_screen.dart';
import '../../reports_constants.dart';

class ReportsDashboardController extends GetxController {
  final RxString selectedSection = 'Sales Performance'.obs;
  final RxBool isSidebarExpanded = true.obs;

  void changeSection(String section) {
    selectedSection.value = section;

    // Add navigation logic for specific sections
  }

  void navigation(String section) {
    switch (section) {
      case 'Conversion Rates':
        // Navigate to Conversion Rates screen
        Get.to(() => ConversionRatesScreen());
        break;
      case 'Average Stage Time':
        // Navigate to Conversion Rates screen
        Get.to(() => LeadStageDurationReport());
        break;
      case 'Bottleneck Identification':
        // Navigate to Conversion Rates screen
        Get.to(() => SalesPipelineBottleneckDashboard());
      case 'Drop-off Analysis':
        // Navigate to Conversion Rates screen
        // Get.to(() => DropoffAnalysisView());
        Get.toNamed(Routes.DDROP_OFF);
      case 'Revenue Trends':
        // Navigate to Conversion Rates screen
        Get.to(() => RevenueTrendsPage());
      case 'Sales by Category':
        // Navigate to Conversion Rates screen
        Get.to(() => CategorySalesReport());
      case 'Comparison to Targets':
        // Navigate to Conversion Rates screen
        Get.to(() => MonthlyTargetComparisonPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Acquisition Cost':
        // Navigate to Conversion Rates screen
        Get.to(() => CustomerAcquisitionCostReport());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Lifetime Value':
        // Navigate to Conversion Rates screen
        Get.to(() => SalesEstimationPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Repeat Purchase Patterns':
        // Navigate to Conversion Rates screen
        Get.to(() => RepeatedPurchasePatternsPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Customer Segmentation':
        // Navigate to Conversion Rates screen
        Get.to(() => CustomerSegmentationPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Lead Handling Stats':
        // Navigate to Conversion Rates screen
        Get.to(() => LeadHandlingStatusReport());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Individual Metrics':
        // Navigate to Conversion Rates screen
        Get.to(() => EmployeeConversionRatePage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Activity Metrics':
        // Navigate to Conversion Rates screen
        Get.to(() => ActivityMetricsPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Performance vs Targets':
        // Navigate to Conversion Rates screen
        Get.to(() => PerformanceTargetPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Quotation to Order Conversion':
        // Navigate to Conversion Rates screen
        Get.to(() => QuotationOrderConversionPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Average Quotation Time':
        // Navigate to Conversion Rates screen
        Get.to(() => QuotationOrderTimePage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Discount Analysis':
        // Navigate to Conversion Rates screen
        Get.to(() => DiscountAnalysisPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Revenue by Product/Segment/provinence':
        // Navigate to Conversion Rates screen
        Get.to(() => RevenueAnalysisPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Quarterly Comparisons':
        // Navigate to Conversion Rates screen
        Get.to(() => FinancialComparisonReportPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Projected vs Actual Revenue':
        // Navigate to Conversion Rates screen
        Get.to(() => ProjectedVsActualRevenuePage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Seasonal Trends':
        // Navigate to Conversion Rates screen
        Get.to(() => SeasonalTrendAnalysisPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Aging Receivables':
        // Navigate to Conversion Rates screen
        Get.to(() => PaymentCollectionStatusPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Payment Status':
        // Navigate to Conversion Rates screen
        Get.to(() => PaymentAgingPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Outstanding Payments':
        // Navigate to Conversion Rates screen
        Get.to(() => OutstandingPaymentsReport());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Payment Method Analysis':
        // Navigate to Conversion Rates screen
        Get.to(() => PaymentMethodAnalysisReport());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Expense Tracking':
        // Navigate to Conversion Rates screen
        Get.to(() => ExpenseTrackingReport());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Expense Approval Status':
        // Navigate to Conversion Rates screen
        Get.to(() => ExpenseApprovalScreen());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Marketing Expense ROI':
        // Navigate to Conversion Rates screen
        Get.to(() => ROIAnalysisPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
      case 'Budget Variance':
        // Navigate to Conversion Rates screen
        Get.to(() => BudgetVarianceReportPage());
        // Get.toNamed(Routes.DDROP_OFF);
        break;
    }
  }

  void toggleSidebar() {
    isSidebarExpanded.value = !isSidebarExpanded.value;
  }
}

class ReportsDashboardScreen extends StatelessWidget {
  final ReportsDashboardController controller =
      Get.put(ReportsDashboardController());

  ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: OrientationBuilder(
            builder: (context, orientation) {
              return _buildResponsiveLayout(context, constraints, orientation);
            },
          ),
        );
      },
    );
  }

  Widget _buildResponsiveLayout(BuildContext context,
      BoxConstraints constraints, Orientation orientation) {
    // Determine if we should show a mobile or desktop layout
    bool isMobile = constraints.maxWidth < 600;

    return isMobile
        ? _buildMobileLayout(context)
        : Row(
            children: [
              // Responsive Sidebar
              _buildReportSectionSidebar(context),

              // Main Content Area
              Expanded(
                child: _buildMainContent(context),
              ),
            ],
          );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildMobileSidebar(),
              );
            },
          ),
        ],
      ),
      body: _buildMainContent(context),
    );
  }

  Widget _buildMobileSidebar() {
    return Container(
      height: Get.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Report Sections',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ReportConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: ReportConstants.reportSections.length,
              itemBuilder: (context, index) {
                final section = ReportConstants.reportSections[index];
                return _buildMobileSidebarItem(section);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSidebarItem(String section) {
    return Obx(() {
      final isSelected = controller.selectedSection.value == section;

      return ListTile(
        leading: Icon(
          ReportConstants.sectionIcons[section] ?? Icons.dashboard,
          color: isSelected ? ReportConstants.primaryColor : Colors.grey,
        ),
        title: Text(
          section,
          style: GoogleFonts.poppins(
            color: isSelected ? ReportConstants.primaryColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: () {
          controller.changeSection(section);
          Navigator.pop(Get.context!);
        },
        selected: isSelected,
      );
    });
  }

  Widget _buildReportSectionSidebar(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: controller.isSidebarExpanded.value
              ? MediaQuery.of(context).size.width > 600
                  ? 280
                  : 200
              : 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(1, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with Collapse/Expand Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.isSidebarExpanded.value)
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Report Sections',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ReportConstants.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        controller.isSidebarExpanded.value
                            ? Icons.chevron_left
                            : Icons.chevron_right,
                        color: ReportConstants.primaryColor,
                      ),
                      onPressed: controller.toggleSidebar,
                    ),
                  ],
                ),
              ),

              // Sidebar Items
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: ReportConstants.reportSections.length,
                  itemBuilder: (context, index) {
                    final section = ReportConstants.reportSections[index];
                    return _buildSidebarItem(section);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSidebarItem(String section) {
    return Obx(() {
      final isSelected = controller.selectedSection.value == section;
      final isExpanded = controller.isSidebarExpanded.value;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? ReportConstants.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Icon(
            ReportConstants.sectionIcons[section] ?? Icons.dashboard,
            color: isSelected ? ReportConstants.primaryColor : Colors.grey,
          ),
          title: isExpanded
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    section,
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? ReportConstants.primaryColor
                          : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          onTap: () => controller.changeSection(section),
          selected: isSelected,
        ),
      );
    });
  }

  Widget _buildMainContent(BuildContext context) {
    return Obx(() => Container(
          color: ReportConstants.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Section Header
              _buildSectionHeader(),

              // Metrics Grid
              Expanded(
                child: _buildMetricsGrid(context),
              ),
            ],
          ),
        ));
  }

  Widget _buildSectionHeader() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        key: ValueKey(controller.selectedSection.value),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  controller.selectedSection.value,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ReportConstants.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    final metrics =
        ReportConstants.reportMetrics[controller.selectedSection.value] ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Advanced column calculation with more responsive breakpoints
        int crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: CustomScrollView(
            key: ValueKey(controller.selectedSection.value),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: _calculateChildAspectRatio(constraints),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: metrics.length,
                  itemBuilder: (context, index) {
                    return _buildAnimatedMetricCard(metrics[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1600) return 5;
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }

  double _calculateChildAspectRatio(BoxConstraints constraints) {
    // Responsive aspect ratio based on screen width
    if (constraints.maxWidth > 1200) return 2.8;
    if (constraints.maxWidth > 900) return 2.5;
    if (constraints.maxWidth > 600) return 2.2;
    return 3.5;
  }

  Widget _buildAnimatedMetricCard(String metric) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            controller.navigation(metric);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        metric,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View Details',
                      style: GoogleFonts.poppins(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.blue.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
