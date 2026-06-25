import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class RemediesCard extends StatelessWidget {
  final String title;
  final String description;
  const RemediesCard(
      {super.key, required this.title, required this.description});

  String getRemedyIcon(String title) {
    final Map<String, String> remedyIcons = {
      'chanting': chanting,
      'puja': puja,
      'charity': charity,
    };
    return remedyIcons[title.toLowerCase()] ?? career;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.8667)}');
    // print('Height: ${util.responsiveHeight(0.0198)}');
    // print('FontSize: ${util.responsiveFontSize(0.0371)}');

    return Container(
      width: util.responsiveWidth(0.8),
      padding: EdgeInsets.symmetric(
          horizontal: util.responsiveWidth(0.0667), vertical: util.height30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: whiteColor,
      ),
      child: Column(
        children: [
          SvgPicture.asset(getRemedyIcon(title)),
          SizedBox(
            height: util.responsiveHeight(0.0198),
          ),
          SvgPicture.asset(remedyDecoLine),
          SizedBox(
            height: util.responsiveHeight(0.0198),
          ),
          Text(
            title.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: util.fontSize22,
                height: 1.2,
                color: blackColor),
          ),
          SizedBox(
            height: util.responsiveHeight(0.0198),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: util.fontSize16,
                height: 1.3,
                color: blackColor.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}
