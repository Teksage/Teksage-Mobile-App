import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class FindConsultCard extends StatelessWidget {
  const FindConsultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    final profileImages = [
      astrologer1,
      astrologer2,
      astrologer3,
      astrologer4,
      astrologer5,
    ];

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E68D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile images
            SizedBox(
              width: 80,
              child: Stack(
                children: List.generate(profileImages.length, (index) {
                  return Positioned(
                    left: index * 11.0,
                    child: ClipOval(
                      child: Image.asset(
                        profileImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Text Section
            SizedBox(
              width: 9,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    PlatformTextConfig.astrologerUserCTA2.tr,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: util.fontSize16,
                        fontFamily: AppFont.get(FontType.semiBold),
                        height: 1.2,
                        color: blackColor),
                  ),
                  SizedBox(height: 4),
                  Text(
                    PlatformTextConfig.astrologerUserCTA3.tr,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: util.fontSize13,
                        fontFamily: AppFont.get(FontType.medium),
                        height: 1.2,
                        color: blackColor.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
