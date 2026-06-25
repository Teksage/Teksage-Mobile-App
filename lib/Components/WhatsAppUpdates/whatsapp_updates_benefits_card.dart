import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WhatsAppUpdatesBenefitsCard extends StatelessWidget {
  const WhatsAppUpdatesBenefitsCard({super.key});

  static const _items = [
    (
      title: 'Major Planetary Transits',
      desc: 'Important movements that impact your life.',
      icon: waBenefitPlanet,
    ),
    (
      title: 'Favorable Periods',
      desc: 'Best times for important decisions and activities.',
      icon: waBenefitCalendar,
    ),
    (
      title: 'Personalized Horoscope Highlights',
      desc: 'Key insights based on your unique birth chart.',
      icon: profile,
    ),
    (
      title: 'Important Alerts',
      desc: 'Special days, events and astrological updates.',
      icon: notification,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(util.width20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blackColor.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: blackColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What You\'ll Receive'.tr,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.semiBold),
              fontSize: util.fontSize16,
              color: mainColor,
            ),
          ),
          SizedBox(height: util.height10),
          ...List.generate(_items.length, (index) {
            final item = _items[index];
            return Column(
              children: [
                if (index > 0)
                  Divider(height: 1, color: blackColor.withValues(alpha: 0.05)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: util.height10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: mainColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          item.icon,
                          width: 22,
                          height: 22,
                        ),
                      ),
                      SizedBox(width: util.width12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title.tr,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize14,
                                color: blackColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item.desc.tr,
                              style: TextStyle(
                                fontSize: util.fontSize13,
                                height: 1.4,
                                color: blackColor.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
