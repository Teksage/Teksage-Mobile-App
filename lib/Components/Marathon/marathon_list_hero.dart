import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonListHero extends StatelessWidget {
  const MarathonListHero({super.key});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          const Positioned.fill(
            child: ColoredBox(color: Color(0xffE7F6E3)),
          ),
          const Positioned.fill(
            child: Image(
              image: AssetImage(marathonHeroWheel),
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 96, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: whiteColor.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: mainColor),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Your Next Session'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize12,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Teksage Expert Hours'.tr,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.bold),
                    fontSize: util.fontSize16,
                    color: blackColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    _Tag(icon: Icons.verified_user_outlined, label: 'Better guidance'.tr, util: util),
                    _Tag(icon: Icons.auto_awesome, label: 'Brighter tomorrows'.tr, util: util),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label, required this.util});

  final IconData icon;
  final String label;
  final MyUtility util;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: mainColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.semiBold),
            fontSize: util.fontSize11,
            color: mainColor,
          ),
        ),
      ],
    );
  }
}
