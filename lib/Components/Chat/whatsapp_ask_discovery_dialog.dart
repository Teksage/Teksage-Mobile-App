import 'dart:ui';

import 'package:astro_prompt/Screens/settings/whatsapp_updates_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatsAppAskDiscoveryDialog extends StatelessWidget {
  final VoidCallback onDismiss;

  const WhatsAppAskDiscoveryDialog({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),
        Dialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(util.width20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FeatureDiscoveryCopy.title,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize20,
                    color: blackColor,
                  ),
                ),
                SizedBox(height: util.height10),
                Text(
                  FeatureDiscoveryCopy.body,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize14,
                    height: 1.4,
                    color: blackColor.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: util.height20),
                _hintRow(util, FeatureDiscoveryCopy.whatsappHint),
                SizedBox(height: util.height10),
                _hintRow(util, FeatureDiscoveryCopy.askAstrologerHint),
                SizedBox(height: util.height20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => const WhatsAppUpdatesPage());
                  },
                  child: Text(
                    FeatureDiscoveryCopy.openWhatsAppSettings,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize14,
                      color: mainColor,
                    ),
                  ),
                ),
                SizedBox(height: util.height20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDismiss,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: homeBanner,
                      foregroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(util.width30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      FeatureDiscoveryCopy.gotIt,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _hintRow(MyUtility util, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, size: 18, color: mainColor),
        SizedBox(width: util.width8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.medium),
              fontSize: util.fontSize13,
              height: 1.3,
              color: blackColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
