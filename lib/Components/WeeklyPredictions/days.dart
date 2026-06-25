import 'dart:convert';

import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class DaysWidget extends StatelessWidget {
  final List<String> days;
  final int highlightedIndex;
  final Function(int) onDayTap;

  const DaysWidget({
    super.key,
    required this.days,
    required this.highlightedIndex,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.asMap().entries.map((entry) {
        int index = entry.key;
        String day = entry.value;

        bool isSelected = index == highlightedIndex;
        return GestureDetector(
          onTap: () => onDayTap(index), // Calls scroll function on tap
          child: Container(
            width: util.responsiveWidth(0.1175),
            height: util.responsiveHeight(0.0321),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(util.responsiveWidth(0.016)),
              color: isSelected ? mainColor : whiteColor, // Change background
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize14,
                  height: util.lineHeight16_8 / util.fontSize14,
                  color: isSelected
                      ? whiteColor
                      : blackColor.withValues(alpha: 0.4), // Change text color
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
