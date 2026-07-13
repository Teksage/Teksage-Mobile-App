import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// Interactive date ribbon matching website `PanchangDateRibbon`.
class PanchangDateRibbon extends StatelessWidget {
  final String weekday;
  final String date;
  final String time;
  final VoidCallback onTap;

  const PanchangDateRibbon({
    super.key,
    required this.weekday,
    required this.date,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final short = weekday.length >= 3 ? weekday.substring(0, 3) : weekday;

    return Column(
      children: [
        Text(
          'Tap to change date'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.semiBold),
            fontSize: util.fontSize12,
            color: panchangHeading,
          ),
        ),
        SizedBox(height: util.responsiveHeight(0.008)),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: util.width30),
                  child: SvgPicture.asset(
                    panchangTimeContainer,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: whiteColor,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '$short - $date - $time',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          fontSize: util.fontSize14,
                          height: 1.0,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: whiteColor.withValues(alpha: 0.95),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
