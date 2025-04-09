import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/page_wrapper.dart';
import '../controller/controller.dart';
import '../widgets/widgets.dart';

class MonthlyTargetComparisonPage extends StatelessWidget {
  const MonthlyTargetComparisonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MonthlyTargetComparisonController());

    return ReportPageWrapper(
      title: 'Monthly Targets Comparison',
      onDateRangeSelected: controller.setDateRange,
      showFilterIcon: true,
      onFilterTap: () {
        CustomFilterModal.show(
          context,
          filterWidgets: [
            Obx(() => SwitchListTile(
                  title: Text(
                    'Show Only Deficit Months',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Display only months where targets were not met',
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                  value: controller.showOnlyDeficit.value,
                  onChanged: (value) {
                    controller.showOnlyDeficit.value = value;
                    Navigator.pop(context);
                  },
                  activeColor: Colors.blue.shade700,
                )),
            const Divider(),
            Obx(() => RadioListTile<String>(
                  title: Text(
                    'Chart View',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                  ),
                  value: 'chart',
                  groupValue: controller.selectedView.value,
                  onChanged: (value) {
                    controller.selectedView.value = value!;
                    Navigator.pop(context);
                  },
                  activeColor: Colors.blue.shade700,
                )),
            Obx(() => RadioListTile<String>(
                  title: Text(
                    'Table View',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                  ),
                  value: 'table',
                  groupValue: controller.selectedView.value,
                  onChanged: (value) {
                    controller.selectedView.value = value!;
                    Navigator.pop(context);
                  },
                  activeColor: Colors.blue.shade700,
                )),
          ],
        );
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance overview card
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : PerformanceOverviewCard(controller: controller),
              )),

          const SizedBox(height: 24),

          // Toggle view buttons
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: controller.toggleView,
                    icon: Icon(
                      controller.selectedView.value == 'chart'
                          ? Icons.table_chart_outlined
                          : Icons.bar_chart,
                      size: 20,
                    ),
                    label: Text(
                      controller.selectedView.value == 'chart'
                          ? 'Table View'
                          : 'Chart View',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 16),

          // Chart or table
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: controller.isLoading.value
                    ? const SizedBox.shrink()
                    : controller.selectedView.value == 'chart'
                        ? TargetComparisonChart(controller: controller)
                        : TargetComparisonTable(controller: controller),
              )),

          const SizedBox(height: 24),

          // Action recommendations
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: controller.isLoading.value
                    ? const SizedBox.shrink()
                    : ActionRecommendations(controller: controller),
              )),
        ],
      ),
    );
  }
}
