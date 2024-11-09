import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import 'custom_button.dart';

class CustomDatePicker extends StatefulWidget {
  final void Function(String? date) confirmHandler;
  final bool pastAllow;
  const CustomDatePicker({
    super.key,
    this.pastAllow = false,
    required this.confirmHandler,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime date = DateTime.now();
  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime.now().add(const Duration(
    days: 500,
  ));
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
      ),
      height: Get.size.height * 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 12,
              ),
              child: Text(
                DateFormat("d MMM y").format(date),
                style: TextStyle(
                  fontSize: (Get.size.width * 0.05).roundToDouble(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ScrollDatePicker(
                selectedDate: date,
                locale: const Locale('en'),
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    date = value;
                  });
                },
                scrollViewOptions: DatePickerScrollViewOptions(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  day: ScrollViewDetailOptions(
                    textStyle: TextStyle(
                      fontSize: (Get.size.width * 0.043).roundToDouble(),
                      fontWeight: FontWeight.w400,
                    ),
                    selectedTextStyle: TextStyle(
                      fontSize: (Get.size.width * 0.043).roundToDouble(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  month: ScrollViewDetailOptions(
                    textStyle: TextStyle(
                      fontSize: (Get.size.width * 0.043).roundToDouble(),
                      fontWeight: FontWeight.w400,
                    ),
                    selectedTextStyle: TextStyle(
                      fontSize: (Get.size.width * 0.043).roundToDouble(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  year: ScrollViewDetailOptions(
                    textStyle: TextStyle(
                      fontSize: (Get.size.width * 0.043).roundToDouble(),
                      fontWeight: FontWeight.w400,
                    ),
                    selectedTextStyle: TextStyle(
                      fontSize: (Get.size.width * 0.043).roundToDouble(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                maximumDate: widget.pastAllow ? minDate : maxDate,
                minimumDate: widget.pastAllow ? DateTime(2020) : minDate,
                viewType: const [
                  DatePickerViewType.day,
                  DatePickerViewType.month,
                  DatePickerViewType.year,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              child: CustomButton(
                onPressed: () async {
                  // HelperUtils.removeFocus(null);
                  Get.back();
                  String? finalDate = DateFormat("y-MM-dd").format(date);
                  widget.confirmHandler(finalDate);
                },
                buttonType: ButtonTypes.primary,
                width: Get.size.width * 0.6,
                text: "Confirm",
                enabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
