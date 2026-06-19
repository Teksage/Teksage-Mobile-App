import 'dart:io';

import 'package:flutter/material.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';

class CustomTimePicker {
  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
    DateTime? dateOfBirth,
    required Function(String) onError,
  }) async {
    FocusScope.of(context).unfocus();

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Platform.isAndroid ? mainColor : iosMainColor,
              onPrimary: whiteColor,
              onSurface: blackColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Platform.isAndroid ? mainColor : iosMainColor,
              ),
            ),
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(primary: Platform.isAndroid ? mainColor : iosMainColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && dateOfBirth != null) {
      final nowDate = DateTime.now();
      final selectedDate = DateTime(
        dateOfBirth.year,
        dateOfBirth.month,
        dateOfBirth.day,
      );

      if (selectedDate.isAtSameMomentAs(DateTime(nowDate.year, nowDate.month, nowDate.day))) {
        final pickedDateTime = DateTime(
          nowDate.year,
          nowDate.month,
          nowDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (pickedDateTime.isAfter(DateTime.now())) {
          onError("Future time is not allowed for today's date.");
          return null;
        }
      }
    }

    return pickedTime;
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }
}
