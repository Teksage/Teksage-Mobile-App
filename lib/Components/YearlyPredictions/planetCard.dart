import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class PlanetCard extends StatelessWidget {
  final String planet;
  final PlanetDetails details;

  const PlanetCard({super.key, required this.planet, required this.details});

  String getPlanetIcon(String planet) {
    final Map<String, String> planetIcons = {
      'jupiter': jupiter,
      'saturn': saturn,
      'rahu': rahu,
      'ketu': ketu,
      'current_dasa': currentDasa,
    };
    return planetIcons[planet.toLowerCase()] ?? jupiter;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    int currentYear = DateTime.now().year;
    int changeYear = int.parse(details.year);

    return Container(
      width: util.responsiveWidth(0.8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Color(0xffFFF7C8),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Image.asset(
              yearlyContainerDeco,
              width: util.responsiveWidth(0.5067),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: util.responsiveWidth(0.0667),
                vertical: util.height30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        planet.tr,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.bold),
                            fontSize: util.fontSize22,
                            height: 1.0,
                            color: blackColor),
                      ),
                    ),
                    SvgPicture.asset(getPlanetIcon(planet),
                        width: util.responsiveWidth(0.1069),
                        height: util.responsiveHeight(0.0493)),
                  ],
                ),
                SizedBox(height: util.responsiveHeight(0.0173)),
                Text(
                  // 'Until ${details.endMonth} $changeYear:\n',
                  '${'First Half of'.tr} $changeYear:\n',
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize16,
                    height: 1.2,
                    color: blackColor.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  details.beforeDetails,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize16,
                    height: 1.2,
                    color: blackColor.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(
                  height: util.width30,
                ),
                // if (changeYear <= currentYear)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // 'From ${details.startMonth} $changeYear:\n',
                      '${'Second Half of'.tr} $changeYear:\n',
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize16,
                        height: 1.2,
                        color: blackColor.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      details.afterDetails,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize16,
                        height: 1.2,
                        color: blackColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
