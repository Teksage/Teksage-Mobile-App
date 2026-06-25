import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class TharaBalaChandraBalaContainer extends StatelessWidget {
  final String tharaBala;
  final String chandraBala;
  const TharaBalaChandraBalaContainer(
      {super.key, required this.tharaBala, required this.chandraBala});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tharaBala,
              style: TextStyle(
                  fontFamily: 'FontSemiBold',
                  fontSize: util.fontSize18,
                  height: util.lineHeight21_6 / util.fontSize18,
                  color: blackColor),
            ),
            SizedBox(height: util.responsiveHeight(0.0112)),
            Text(
              'Thara Bala'.tr,
              style: TextStyle(
                  fontFamily: 'FontSemiBold',
                  fontSize: util.fontSize12,
                  height: 1.0,
                  color: mainColor),
            )
          ],
        ),
        SvgPicture.asset(dailyDivider),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            chandraBala == '8'
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xffffe0e0),
                        ),
                        child: Text(
                          'Chandrashtama'.tr,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize10,
                            height: 1.0,
                            color: Color(0xffff3232),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  )
                : SizedBox.shrink(),
            Text(
              chandraBala,
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize18,
                  height: util.lineHeight21_6 / util.fontSize18,
                  color: chandraBala == '8' ? Color(0xffFF3232) : blackColor),
            ),
            SizedBox(height: util.responsiveHeight(0.0112)),
            Text(
              'Chandra Bala'.tr,
              style: TextStyle(
                  fontFamily: 'FontSemiBold',
                  fontSize: util.fontSize12,
                  height: 1.0,
                  color: mainColor),
            )
          ],
        )
      ],
    );
  }
}
