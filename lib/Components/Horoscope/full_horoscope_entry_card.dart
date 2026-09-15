import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Soft mint entry strip — mirrors website `HoroscopeFullEntryCard`.
class FullHoroscopeEntryCard extends StatelessWidget {
  const FullHoroscopeEntryCard({super.key});

  static const _url = 'https://my.teksage.app/horoscope/full';
  static const _title = 'Full Horoscope';
  static const _hint = 'Dasa, Shadbala, Ashtavarga & more';
  static const _cta = 'Open';

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(_url);
    final ok = await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      showInfoSnackBar(context, 'Could not open Full Horoscope');
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: util.width20),
        padding: EdgeInsets.symmetric(
          horizontal: util.width20,
          vertical: util.responsiveHeight(0.016),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              eventPlannerBannerTop,
              eventPlannerBannerBottom,
            ],
          ),
          border: Border.all(color: eventPlannerBannerBorder),
          boxShadow: [
            BoxShadow(
              color: blackColor.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                size: 20,
                color: mainColor,
              ),
            ),
            SizedBox(width: util.width12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize14,
                      color: blackColor,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _hint.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: util.fontSize12,
                      color: panchangHeading,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _cta.tr,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize12,
                    color: mainColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16, color: mainColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
