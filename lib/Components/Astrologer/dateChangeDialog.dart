import 'dart:ui';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


Future<void> showClearSlotsConfirmationDialog({
  required BuildContext context,
  required VoidCallback onYesPressed,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),
          AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.all(20),
            title: Text(
              "Slots Selected".tr,
              style: TextStyle(
                  fontSize: MyUtility(context).fontSize18,
                  fontFamily: 'FontSemiBold',
                  color: blackColor),
            ),
            content: Text(
              "Selected slots will be lost if you change the date. Would you like to save them first?"
                  .tr,
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: MyUtility(context).fontSize16,
                  color: blackColor.withValues(alpha: 0.5)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  onYesPressed(); // YES callback
                },
                child: Text(
                  "No",
                  style: TextStyle(
                      fontFamily: 'FontSemiBold',
                      fontSize: MyUtility(context).fontSize13,
                      color: blackColor),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context), // NO
                style: ElevatedButton.styleFrom(backgroundColor: errorColor),
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontFamily: 'FontSemiBold',
                      fontSize: MyUtility(context).fontSize13,
                      color: whiteColor),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
