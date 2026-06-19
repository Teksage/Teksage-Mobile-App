import 'package:astro_prompt/Components/DailyPredictions/balaContainer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class WeeklyPredictionCard extends StatelessWidget {
  final String day;
  final String shortPrediction;
  final String longPrediction;
  final bool isPositiveDay;
  final int tharaBala;
  final int chandraBala;

  const WeeklyPredictionCard({
    super.key,
    required this.day,
    required this.shortPrediction,
    required this.longPrediction,
    required this.isPositiveDay,
    required this.tharaBala,
    required this.chandraBala,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: util.width,
          height: util.height50,
          decoration: BoxDecoration(
            color: weeklyPrediction,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(util.width20),
              topLeft: Radius.circular(util.width20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day.tr,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize20,
                  height: util.lineHeight24 / util.fontSize20,
                  color: whiteColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: util.width10,
                    vertical: util.responsiveHeight(0.0075)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(util.width20),
                  color: whiteColor,
                ),
                child: Text(
                  shortPrediction,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.bold),
                    fontSize: util.fontSize12,
                    height: util.lineHeight14_4 / util.fontSize12,
                    color: isPositiveDay ? predictionPositive : errorColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: util.width20, vertical: util.height20),
          width: util.width,
          color: whiteColor,
          // height: util.responsiveHeight(0.1971),
          child: Text(
            longPrediction,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.medium),
              fontSize: util.fontSize16,
              height: util.lineHeight19_2 / util.fontSize16,
              color: blackColor.withValues(alpha: 0.7),
            ),
          ),
        ),
        Container(
            width: util.width,
            // height: util.responsiveHeight(0.117),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(util.width20),
                bottomLeft: Radius.circular(util.width20),
              ),
            ),
            child: TharaBalaChandraBalaContainer(
                tharaBala: tharaBala.toString(),
                chandraBala: chandraBala.toString())),
        SizedBox(
          height: util.height20,
        ),
      ],
    );
  }
}
