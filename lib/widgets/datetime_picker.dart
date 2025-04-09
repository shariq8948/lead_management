import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import 'custom_button.dart';

class CustomDateTimePicker extends StatefulWidget {
  final void Function(String? dateTime) confirmHandler;
  final bool pastAllow;
  const CustomDateTimePicker({
    super.key,
    this.pastAllow = false,
    required this.confirmHandler,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now(); // Add time state
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
      height: Get.size.height * 0.55, // Increase height for time picker
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
                DateFormat("d MMM y").format(date) + " " + time.format(context),
                style: TextStyle(
                  fontSize: (Get.size.width * 0.05).roundToDouble(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // Date Picker
                  ScrollDatePicker(
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

                  // Time Picker (added)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: time,
                        );
                        if (pickedTime != null && pickedTime != time) {
                          setState(() {
                            time = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Select Time',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
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
                  Get.back();
                  String finalDateTime = DateFormat("y-MM-dd").format(date) +
                      " " +
                      time.format(context); // Combine date and time
                  widget.confirmHandler(finalDateTime);
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
