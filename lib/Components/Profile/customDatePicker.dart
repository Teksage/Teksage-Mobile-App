import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:intl/intl.dart';

class CustomDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? currentDateText,
  }) async {
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateTime parsedInitialDate = DateTime.now();

    if (currentDateText != null && currentDateText.isNotEmpty) {
      try {
        parsedInitialDate = inputFormat.parse(currentDateText);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to parse date: $currentDateText, using provided initialDate or today');
        }
        parsedInitialDate = initialDate ?? DateTime.now();
      }
    } else {
      parsedInitialDate = initialDate ?? DateTime.now();
    }
    FocusScope.of(context).unfocus();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: parsedInitialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
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
          ),
          child: child!,
        );
      },
    );

    return pickedDate;
  }

  static String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
