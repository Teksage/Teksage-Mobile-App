import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomMatchBirthField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final bool errorFlag;
  final String errorText;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomMatchBirthField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.errorFlag,
    required this.errorText,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title.tr,
              style: TextStyle(
                color: blackColor,
                fontSize: util.fontSize10,
                height: util.lineHeight12 / util.fontSize10,
                fontFamily: AppFont.get(FontType.medium),
              ),
            ),
            Text(
              '*',
              style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: 10,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            absorbing: onTap != null || readOnly,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: errorFlag ? errorColor : matchTopGradient.withValues(alpha: 0.35),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller,
                readOnly: readOnly || onTap != null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText.tr,
                  hintStyle: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize14,
                    color: Colors.grey,
                  ),
                ),
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize14,
                  color: blackColor,
                ),
              ),
            ),
          ),
        ),
        if (errorFlag)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText.tr,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: util.fontSize11,
                color: errorColor,
              ),
            ),
          ),
      ],
    );
  }
}
