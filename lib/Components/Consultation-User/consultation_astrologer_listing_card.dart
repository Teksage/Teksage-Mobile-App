import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsultationAstrologerListingCard extends StatelessWidget {
  final String? picture;
  final String name;
  final String languages;
  final String feeAmount;
  final String currencyUnit;
  final VoidCallback onBookNow;

  const ConsultationAstrologerListingCard({
    super.key,
    required this.picture,
    required this.name,
    required this.languages,
    required this.feeAmount,
    required this.currencyUnit,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: blackColor.withValues(alpha: 0.12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: astroUserConsultBG,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: picture != null && picture!.isNotEmpty
                  ? Image.network(picture!, fit: BoxFit.cover)
                  : Container(
                      color: lightGrey,
                      child: Center(
                        child: Image.asset(dummyImage, width: 36, height: 36),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize14,
                    height: 1.1,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  languages,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize11,
                    height: 1.1,
                    color: blackColor.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currencyUnit,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: currencyUnit == '₹' ? util.fontSize18 : util.fontSize16,
                    height: 1.0,
                    color: astroUserConsultText,
                  ),
                ),
                Text(
                  feeAmount,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize18,
                    height: 1.0,
                    color: astroUserConsultText,
                  ),
                ),
                Text(
                  ' /30 min',
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize12,
                    height: 1.0,
                    color: blackColor.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onBookNow,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(util.width20),
                color: homeBanner,
              ),
              child: Text(
                'Book Now'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize12,
                  height: 1.0,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
