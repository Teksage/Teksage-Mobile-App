import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/enum/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


void customSnackBar({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
  required Color indicatorColor,
  required String iconType,
  SnackBarPosition position = SnackBarPosition.bottom,
  Duration duration = const Duration(seconds: 2),
}) {
  final IconData selectedIcon = snackBarIcons[iconType] ?? Icons.info;

  final EdgeInsetsGeometry margin = position == SnackBarPosition.top
      ? const EdgeInsets.only(top: 20, left: 16, right: 16)
      : const EdgeInsets.only(bottom: 20, left: 16, right: 16);

  final snackBar = SnackBar(
    elevation: 0,
    duration: duration,
    // margin: margin,
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    content: Container(
      width: MyUtility(context).width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 65,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Icon(selectedIcon, color: indicatorColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message.tr,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: MyUtility(context).fontSize14,
                height: 1.5,
                color: blackColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
