// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
//
// import '../../widgets/page_wrapper.dart';
//
// // Controller for managing the monthly target comparison data
// class MonthlyTargetComparisonController extends GetxController {
//   final RxBool isLoading = true.obs;
//   final RxList<MonthlyTargetData> monthlyData = <MonthlyTargetData>[].obs;
//   final Rx<DateTimeRange> selectedDateRange = DateTimeRange(
//     start: DateTime.now().subtract(const Duration(days: 365)),
//     end: DateTime.now(),
//   ).obs;
//
//   final RxString selectedView = 'chart'.obs; // 'chart' or 'table'
//   final RxBool showOnlyDeficit = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchData();
//   }
//
//   void setDateRange(DateTimeRange? range) {
//     if (range != null) {
//       selectedDateRange.value = range;
//       fetchData();
//     }
//   }
//
//   void toggleView() {
//     selectedView.value = selectedView.value == 'chart' ? 'table' : 'chart';
//   }
//
//   void toggleDeficitFilter() {
//     showOnlyDeficit.value = !showOnlyDeficit.value;
//   }
//
//   Future<void> fetchData() async {
//     isLoading.value = true;
//
//     try {
//       // Simulate API call
//       await Future.delayed(const Duration(milliseconds: 800));
//
//       // Generate sample data
//       final List<MonthlyTargetData> data = [];
//
//       final DateTime startDate = selectedDateRange.value.start;
//       final DateTime endDate = selectedDateRange.value.end;
//
//       DateTime currentDate = DateTime(startDate.year, startDate.month, 1);
//
//       while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
//         // Generate realistic random data
//         final double target = 50000 +
//             (currentDate.month * 5000) +
//             (Random().nextDouble() * 10000);
//         final double actual = target * (0.7 + (Random().nextDouble() * 0.6));
//
//         data.add(MonthlyTargetData(
//           month: DateTime(currentDate.year, currentDate.month),
//           target: target,
//           actual: actual,
//         ));
//
//         // Move to next month
//         currentDate = DateTime(
//           currentDate.month < 12 ? currentDate.year : currentDate.year + 1,
//           currentDate.month < 12 ? currentDate.month + 1 : 1,
//         );
//       }
//
//       monthlyData.value = data;
//     } catch (e) {
//       // Handle error
//       Get.snackbar(
//         'Error',
//         'Failed to load monthly comparison data',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   List<MonthlyTargetData> get filteredData {
//     if (showOnlyDeficit.value) {
//       return monthlyData.where((data) => data.actual < data.target).toList();
//     }
//     return monthlyData;
//   }
//
//   double get maxValue {
//     if (monthlyData.isEmpty) return 0;
//     final targetMax = monthlyData.map((e) => e.target).reduce(max);
//     final actualMax = monthlyData.map((e) => e.actual).reduce(max);
//     return max(targetMax, actualMax) * 1.1; // Add 10% margin
//   }
//
//   double max(double a, double b) => a > b ? a : b;
//
//   String get performanceSummary {
//     if (monthlyData.isEmpty) return "No data available";
//
//     final totalTarget =
//         monthlyData.fold<double>(0, (sum, item) => sum + item.target);
//     final totalActual =
//         monthlyData.fold<double>(0, (sum, item) => sum + item.actual);
//     final percentAchieved = (totalActual / totalTarget) * 100;
//
//     final deficitMonths =
//         monthlyData.where((data) => data.actual < data.target).length;
//     final surplusMonths =
//         monthlyData.where((data) => data.actual >= data.target).length;
//
//     return "Overall: ${percentAchieved.toStringAsFixed(1)}% of targets achieved\n$surplusMonths months exceeded targets, $deficitMonths months below target";
//   }
// }
//
// // Data model for monthly target comparison
// class MonthlyTargetData {
//   final DateTime month;
//   final double target;
//   final double actual;
//
//   MonthlyTargetData({
//     required this.month,
//     required this.target,
//     required this.actual,
//   });
//
//   double get achievementPercentage => (actual / target) * 100;
//   double get deficit => target - actual;
//   bool get isDeficit => actual < target;
//   String get monthName => DateFormat('MMM yyyy').format(month);
// }
//
// // The main page
// class MonthlyTargetComparisonPage extends StatelessWidget {
//   const MonthlyTargetComparisonPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MonthlyTargetComparisonController());
//
//     return ReportPageWrapper(
//       title: 'Monthly Targets Comparison',
//       onDateRangeSelected: controller.setDateRange,
//       showFilterIcon: true,
//       onFilterTap: () {
//         CustomFilterModal.show(
//           context,
//           filterWidgets: [
//             Obx(() => SwitchListTile(
//                   title: Text(
//                     'Show Only Deficit Months',
//                     style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
//                   ),
//                   subtitle: Text(
//                     'Display only months where targets were not met',
//                     style: GoogleFonts.montserrat(fontSize: 12),
//                   ),
//                   value: controller.showOnlyDeficit.value,
//                   onChanged: (value) {
//                     controller.showOnlyDeficit.value = value;
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.blue.shade700,
//                 )),
//             const Divider(),
//             Obx(() => RadioListTile<String>(
//                   title: Text(
//                     'Chart View',
//                     style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
//                   ),
//                   value: 'chart',
//                   groupValue: controller.selectedView.value,
//                   onChanged: (value) {
//                     controller.selectedView.value = value!;
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.blue.shade700,
//                 )),
//             Obx(() => RadioListTile<String>(
//                   title: Text(
//                     'Table View',
//                     style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
//                   ),
//                   value: 'table',
//                   groupValue: controller.selectedView.value,
//                   onChanged: (value) {
//                     controller.selectedView.value = value!;
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.blue.shade700,
//                 )),
//           ],
//         );
//       },
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Performance overview card
//           Obx(() => AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 400),
//                 child: controller.isLoading.value
//                     ? const Center(child: CircularProgressIndicator())
//                     : PerformanceOverviewCard(controller: controller),
//               )),
//
//           const SizedBox(height: 24),
//
//           // Toggle view buttons
//           Obx(() => Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton.icon(
//                     onPressed: controller.toggleView,
//                     icon: Icon(
//                       controller.selectedView.value == 'chart'
//                           ? Icons.table_chart_outlined
//                           : Icons.bar_chart,
//                       size: 20,
//                     ),
//                     label: Text(
//                       controller.selectedView.value == 'chart'
//                           ? 'Table View'
//                           : 'Chart View',
//                       style: GoogleFonts.montserrat(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                     ),
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.blue.shade700,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//
//           const SizedBox(height: 16),
//
//           // Chart or table
//           Obx(() => AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 400),
//                 child: controller.isLoading.value
//                     ? const SizedBox.shrink()
//                     : controller.selectedView.value == 'chart'
//                         ? TargetComparisonChart(controller: controller)
//                         : TargetComparisonTable(controller: controller),
//               )),
//
//           const SizedBox(height: 24),
//
//           // Action recommendations
//           Obx(() => AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 400),
//                 child: controller.isLoading.value
//                     ? const SizedBox.shrink()
//                     : ActionRecommendations(controller: controller),
//               )),
//         ],
//       ),
//     );
//   }
// }
//
// // Performance overview card
// class PerformanceOverviewCard extends StatelessWidget {
//   final MonthlyTargetComparisonController controller;
//
//   const PerformanceOverviewCard({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final totalTarget = controller.monthlyData
//         .fold<double>(0, (sum, item) => sum + item.target);
//     final totalActual = controller.monthlyData
//         .fold<double>(0, (sum, item) => sum + item.actual);
//     final percentAchieved = (totalActual / totalTarget) * 100;
//
//     final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
//
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade700, Colors.blue.shade900],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.shade200.withOpacity(0.4),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Performance Overview',
//               style: GoogleFonts.montserrat(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Total Target',
//                         style: GoogleFonts.montserrat(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.8),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         formatter.format(totalTarget),
//                         style: GoogleFonts.montserrat(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Actual Sales',
//                         style: GoogleFonts.montserrat(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.8),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         formatter.format(totalActual),
//                         style: GoogleFonts.montserrat(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             LinearProgressIndicator(
//               value: percentAchieved / 100,
//               backgroundColor: Colors.white.withOpacity(0.2),
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 percentAchieved >= 100 ? Colors.greenAccent : Colors.white,
//               ),
//               minHeight: 8,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${percentAchieved.toStringAsFixed(1)}% Achieved',
//                   style: GoogleFonts.montserrat(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Icon(
//                       percentAchieved >= 100
//                           ? Icons.arrow_upward
//                           : Icons.arrow_downward,
//                       color: percentAchieved >= 100
//                           ? Colors.greenAccent
//                           : Colors.redAccent,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       percentAchieved >= 100
//                           ? 'Exceeding Target'
//                           : '${(100 - percentAchieved).toStringAsFixed(1)}% Below Target',
//                       style: GoogleFonts.montserrat(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: percentAchieved >= 100
//                             ? Colors.greenAccent
//                             : Colors.redAccent,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Chart representation of target comparison
// class TargetComparisonChart extends StatelessWidget {
//   final MonthlyTargetComparisonController controller;
//
//   const TargetComparisonChart({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final data = controller.filteredData;
//     if (data.isEmpty) {
//       return Center(
//         child: Text(
//           'No data available for the selected period',
//           style: GoogleFonts.montserrat(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey.shade700,
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       height: 400,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Monthly Performance vs. Targets',
//             style: GoogleFonts.montserrat(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 16, bottom: 16),
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: controller.maxValue,
//                   barTouchData: BarTouchData(
//                     enabled: true,
//                     touchTooltipData: BarTouchTooltipData(
//                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                         final formatter = NumberFormat.currency(
//                             symbol: '\$', decimalDigits: 0);
//                         final month = data[groupIndex].monthName;
//
//                         String value = '';
//                         if (rodIndex == 0) {
//                           value =
//                               'Target: ${formatter.format(data[groupIndex].target)}';
//                         } else {
//                           value =
//                               'Actual: ${formatter.format(data[groupIndex].actual)}';
//                         }
//
//                         return BarTooltipItem(
//                           '$month\n$value',
//                           GoogleFonts.montserrat(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value.toInt() >= data.length ||
//                               value.toInt() < 0) {
//                             return const SizedBox.shrink();
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               data[value.toInt()].monthName,
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           );
//                         },
//                         reservedSize: 30,
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           final formatter = NumberFormat.compactCurrency(
//                             symbol: '\$',
//                             decimalDigits: 0,
//                           );
//                           return Text(
//                             formatter.format(value),
//                             style: GoogleFonts.montserrat(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           );
//                         },
//                         reservedSize: 40,
//                       ),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   gridData: FlGridData(
//                     show: true,
//                     horizontalInterval: controller.maxValue / 5,
//                     getDrawingHorizontalLine: (value) {
//                       return FlLine(
//                         color: Colors.grey.shade200,
//                         strokeWidth: 1,
//                       );
//                     },
//                     drawVerticalLine: false,
//                   ),
//                   barGroups: List.generate(
//                     data.length,
//                     (index) => BarChartGroupData(
//                       x: index,
//                       barRods: [
//                         BarChartRodData(
//                           toY: data[index].target,
//                           color: Colors.blue.shade200,
//                           width: 16,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4),
//                             topRight: Radius.circular(4),
//                           ),
//                         ),
//                         BarChartRodData(
//                           toY: data[index].actual,
//                           color: data[index].actual >= data[index].target
//                               ? Colors.green.shade400
//                               : Colors.red.shade400,
//                           width: 16,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4),
//                             topRight: Radius.circular(4),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildLegendItem('Target', Colors.blue.shade200),
//               const SizedBox(width: 24),
//               _buildLegendItem('Actual', Colors.green.shade400),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(String label, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           label,
//           style: GoogleFonts.montserrat(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Table representation of target comparison
// class TargetComparisonTable extends StatelessWidget {
//   final MonthlyTargetComparisonController controller;
//
//   const TargetComparisonTable({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final data = controller.filteredData;
//     if (data.isEmpty) {
//       return Center(
//         child: Text(
//           'No data available for the selected period',
//           style: GoogleFonts.montserrat(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey.shade700,
//           ),
//         ),
//       );
//     }
//
//     final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(16)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Text(
//                     'Month',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: Text(
//                     'Target',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: Text(
//                     'Actual',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Achievement',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final item = data[index];
//               return Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Colors.grey.shade200,
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Text(
//                         item.monthName,
//                         style: GoogleFonts.montserrat(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: Text(
//                         formatter.format(item.target),
//                         style: GoogleFonts.montserrat(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: Text(
//                         formatter.format(item.actual),
//                         style: GoogleFonts.montserrat(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: item.isDeficit
//                               ? Colors.red.shade600
//                               : Colors.green.shade600,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: item.isDeficit
//                               ? Colors.red.shade50
//                               : Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           '${item.achievementPercentage.toStringAsFixed(1)}%',
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.montserrat(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: item.isDeficit
//                                 ? Colors.red.shade600
//                                 : Colors.green.shade600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Action recommendations for improving performance
// class ActionRecommendations extends StatelessWidget {
//   final MonthlyTargetComparisonController controller;
//
//   const ActionRecommendations({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final data = controller.monthlyData;
//     final deficitMonths = data.where((item) => item.isDeficit).toList();
//
//     if (deficitMonths.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.green.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.green.shade200),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.check_circle,
//               color: Colors.green.shade600,
//               size: 40,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Great Performance!',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green.shade800,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'All targets are being met or exceeded. Keep up the excellent work!',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 14,
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.blue.shade100),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.lightbulb,
//                 color: Colors.blue.shade700,
//                 size: 24,
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Recommended Actions',
//                 style: GoogleFonts.montserrat(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.blue.shade800,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: deficitMonths.length > 3 ? 3 : deficitMonths.length,
//             itemBuilder: (context, index) {
//               final item = deficitMonths[index];
//               final formatter =
//                   NumberFormat.currency(symbol: '\$', decimalDigits: 0);
//               final deficit = formatter.format(item.deficit);
//
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 24,
//                       height: 24,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade700,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '${index + 1}',
//                         style: GoogleFonts.montserrat(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Address ${item.monthName} Performance Gap',
//                             style: GoogleFonts.montserrat(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Target missed by $deficit. Review sales strategies and identify opportunities for improvement.',
//                             style: GoogleFonts.montserrat(
//                               fontSize: 13,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           if (deficitMonths.length > 3)
//             TextButton(
//               onPressed: () {
//                 // Show all deficit months in a detailed view
//                 Get.to(() => DeficitDetailsPage(deficitMonths: deficitMonths));
//               },
//               child: Text(
//                 'View All ${deficitMonths.length} Underperforming Months',
//                 style: GoogleFonts.montserrat(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue.shade700,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// // Deficit details page
// class DeficitDetailsPage extends StatelessWidget {
//   final List<MonthlyTargetData> deficitMonths;
//
//   const DeficitDetailsPage({
//     Key? key,
//     required this.deficitMonths,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Underperforming Months',
//           style: GoogleFonts.montserrat(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: theme.colorScheme.surface,
//         foregroundColor: theme.colorScheme.onSurface,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list_rounded),
//             onPressed: () {
//               // Add filtering functionality
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.download_rounded),
//             onPressed: () {
//               // Add export functionality
//             },
//           ),
//         ],
//       ),
//       body: deficitMonths.isEmpty
//           ? _buildEmptyState(context)
//           : _buildDeficitList(context, formatter),
//     );
//   }
//
//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.check_circle_outline,
//             size: 80,
//             color: Colors.green.shade300,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No Underperforming Months',
//             style: GoogleFonts.montserrat(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'All targets have been met or exceeded.',
//             style: GoogleFonts.montserrat(
//               fontSize: 14,
//               color: Colors.black54,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDeficitList(BuildContext context, NumberFormat formatter) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: deficitMonths.length,
//       itemBuilder: (context, index) {
//         final item = deficitMonths[index];
//         final deficit = formatter.format(item.deficit.abs());
//
//         // Calculate achievement color based on percentage
//         final Color achievementColor =
//             _getAchievementColor(item.achievementPercentage);
//
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 2,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header section with gradient background
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         achievementColor.withOpacity(0.8),
//                         achievementColor.withOpacity(0.6),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             item.monthName,
//                             style: GoogleFonts.montserrat(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '${item.achievementPercentage.toStringAsFixed(1)}% of target',
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       _buildCircularProgress(item.achievementPercentage),
//                     ],
//                   ),
//                 ),
//                 // Details section
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Financial metrics section
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildMetricCard(
//                               title: 'Target',
//                               value: formatter.format(item.target),
//                               valueColor: Colors.blueGrey.shade800,
//                               icon: Icons.flag_rounded,
//                               iconColor: Colors.blue.shade700,
//                               backgroundColor: Colors.blue.shade50,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: _buildMetricCard(
//                               title: 'Actual',
//                               value: formatter.format(item.actual),
//                               valueColor: achievementColor,
//                               icon: Icons.payments_rounded,
//                               iconColor: achievementColor,
//                               backgroundColor:
//                                   achievementColor.withOpacity(0.1),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: _buildMetricCard(
//                               title: 'Deficit',
//                               value: deficit,
//                               valueColor: achievementColor,
//                               icon: Icons.trending_down_rounded,
//                               iconColor: achievementColor,
//                               backgroundColor:
//                                   achievementColor.withOpacity(0.1),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Progress visualization
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Progress to Target',
//                             style: GoogleFonts.montserrat(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(6),
//                             child: LinearProgressIndicator(
//                               value: item.achievementPercentage / 100,
//                               backgroundColor: Colors.grey.shade200,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                   achievementColor),
//                               minHeight: 10,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Action items section
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         padding: const EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.lightbulb_outline,
//                                   size: 16,
//                                   color: Colors.amber.shade700,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Recommended Actions',
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             _buildActionItem(
//                               icon: Icons.analytics_outlined,
//                               title: 'Analyze Sales Channels',
//                               description:
//                                   'Identify which channels underperformed during this period.',
//                               actionColor: Colors.indigo,
//                             ),
//                             const Divider(height: 16),
//                             _buildActionItem(
//                               icon: Icons.campaign_outlined,
//                               title: 'Review Marketing Campaigns',
//                               description:
//                                   'Check if there were gaps in marketing or promotion activities.',
//                               actionColor: Colors.teal,
//                             ),
//                             const Divider(height: 16),
//                             _buildActionItem(
//                               icon: Icons.compare_arrows_outlined,
//                               title: 'Competitor Analysis',
//                               description:
//                                   'Evaluate if competitors had any advantages during this period.',
//                               actionColor: Colors.deepPurple,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       // Action buttons
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: () {
//                                 // Add action plan functionality
//                               },
//                               icon: Icon(Icons.add_task_rounded),
//                               label: Text(
//                                 'Create Action Plan',
//                                 style: GoogleFonts.montserrat(
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           IconButton(
//                             onPressed: () {
//                               // Share functionality
//                             },
//                             icon: Icon(Icons.share_rounded),
//                             style: IconButton.styleFrom(
//                               backgroundColor: Colors.grey.shade200,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildCircularProgress(double percentage) {
//     final Color progressColor = _getAchievementColor(percentage);
//
//     return SizedBox(
//       width: 40,
//       height: 40,
//       child: Stack(
//         children: [
//           CircularProgressIndicator(
//             value: percentage / 100,
//             backgroundColor: Colors.white.withOpacity(0.3),
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//             strokeWidth: 5,
//           ),
//           Center(
//             child: Text(
//               '${percentage.toInt()}%',
//               style: GoogleFonts.montserrat(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMetricCard({
//     required String title,
//     required String value,
//     required Color valueColor,
//     required IconData icon,
//     required Color iconColor,
//     required Color backgroundColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 14,
//                 color: iconColor,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 title,
//                 style: GoogleFonts.montserrat(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: GoogleFonts.montserrat(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               color: valueColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionItem({
//     required IconData icon,
//     required String title,
//     required String description,
//     required Color actionColor,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: actionColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             size: 16,
//             color: actionColor,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: GoogleFonts.montserrat(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 description,
//                 style: GoogleFonts.montserrat(
//                   fontSize: 12,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             Icons.arrow_forward_ios_rounded,
//             size: 14,
//             color: Colors.grey,
//           ),
//           constraints: BoxConstraints.tightFor(
//             width: 24,
//             height: 24,
//           ),
//           padding: EdgeInsets.zero,
//           onPressed: () {
//             // Navigate to detailed action
//           },
//         ),
//       ],
//     );
//   }
//
//   Color _getAchievementColor(double percentage) {
//     if (percentage < 60) {
//       return Colors.red.shade700;
//     } else if (percentage < 80) {
//       return Colors.orange.shade700;
//     } else if (percentage < 90) {
//       return Colors.amber.shade700;
//     } else {
//       return Colors.green.shade700;
//     }
//   }
// }
