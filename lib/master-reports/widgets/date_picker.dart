import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';

class DateRangePickerController extends GetxController {
  final RxString selectedDateRangeText = 'Current Month'.obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);

  final List<Map<String, dynamic>> dateRangeOptions = [
    {'title': 'Current Month', 'icon': Icons.calendar_today_rounded},
    {'title': 'Last Month', 'icon': Icons.calendar_month_rounded},
    {'title': 'Last 3 Months', 'icon': Icons.view_week_rounded},
    {'title': 'Last 6 Months', 'icon': Icons.view_carousel_rounded},
    {'title': 'Custom Range', 'icon': Icons.date_range_rounded},
  ];

  @override
  void onInit() {
    super.onInit();
    calculateDateRange('Current Month');
  }

  void calculateDateRange(String option) {
    final now = DateTime.now();
    selectedDateRange.value = null;

    switch (option) {
      case 'Current Month':
        final currentMonthStart = DateTime(now.year, now.month, 1);
        final currentMonthEnd = DateTime(now.year, now.month + 1, 0);
        _setDateRange(currentMonthStart, currentMonthEnd, option);
        break;
      case 'Last Month':
        final lastMonthEnd = DateTime(now.year, now.month, 0);
        final lastMonthStart =
            DateTime(lastMonthEnd.year, lastMonthEnd.month, 1);
        _setDateRange(lastMonthStart, lastMonthEnd, option);
        break;
      case 'Last 3 Months':
        final threeMonthsAgoEnd = DateTime(now.year, now.month, 0);
        final threeMonthsAgoStart =
            DateTime(threeMonthsAgoEnd.year, threeMonthsAgoEnd.month - 2, 1);
        _setDateRange(threeMonthsAgoStart, threeMonthsAgoEnd, option);
        break;
      case 'Last 6 Months':
        final sixMonthsAgoEnd = DateTime(now.year, now.month, 0);
        final sixMonthsAgoStart =
            DateTime(sixMonthsAgoEnd.year, sixMonthsAgoEnd.month - 5, 1);
        _setDateRange(sixMonthsAgoStart, sixMonthsAgoEnd, option);
        break;
    }
  }

  void _setDateRange(DateTime start, DateTime end, String option) {
    final now = DateTime.now();
    final adjustedEnd = end.isAfter(now) ? now : end;

    selectedDateRange.value = DateTimeRange(start: start, end: adjustedEnd);
    selectedDateRangeText.value = option;
  }

  Future<void> selectCustomDateRange(BuildContext context) async {
    final now = DateTime.now();
    DateTimeRange? initialRange = selectedDateRange.value;

    if (initialRange != null && initialRange.end.isAfter(now)) {
      initialRange = DateTimeRange(
        start: initialRange.start,
        end: now,
      );
    }

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: now,
      initialDateRange: initialRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primary1Color,
              secondary: primary3Color,
              surface: Colors.white,
              background: Colors.white,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: quotation2,
              headerForegroundColor: primary2Color,
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: primary2Color,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: lightText,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDateRange.value = picked;
      selectedDateRangeText.value = _formatDateRange(picked);
    }
  }

  String _formatDateRange(DateTimeRange range) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return '${formatter.format(range.start)} - ${formatter.format(range.end)}';
  }
}

class ModernDateRangePicker extends StatelessWidget {
  final DateRangePickerController controller =
      Get.put(DateRangePickerController());
  final Function(DateTimeRange?) onDateRangeSelected;

  ModernDateRangePicker({Key? key, required this.onDateRangeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String dropdownValue = controller.selectedDateRangeText.value ==
              controller._formatDateRange(controller.selectedDateRange.value ??
                  DateTimeRange(start: DateTime.now(), end: DateTime.now()))
          ? 'Custom Range'
          : controller.selectedDateRangeText.value;

      return GestureDetector(
        onTap: () {
          _showDateRangeBottomSheet(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: quotation2,
            border:
                Border.all(color: primary3Color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: primary1Color.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: primary1Color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date Range',
                      style: TextStyle(
                        color: primary2Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      dropdownValue,
                      style: TextStyle(
                        color: popupColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: primary1Color,
                size: 30,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDateRangeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: screenbgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Date Range',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: popupColor,
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.dateRangeOptions.length,
                itemBuilder: (context, index) {
                  final option = controller.dateRangeOptions[index];
                  return ListTile(
                    leading: Icon(
                      option['icon'],
                      color: primary1Color,
                    ),
                    title: Text(
                      option['title'],
                      style: TextStyle(
                        color: popupColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (option['title'] == 'Custom Range') {
                        controller.selectCustomDateRange(context).then((_) {
                          onDateRangeSelected(
                              controller.selectedDateRange.value);
                        });
                      } else {
                        controller.calculateDateRange(option['title']);
                        onDateRangeSelected(controller.selectedDateRange.value);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
