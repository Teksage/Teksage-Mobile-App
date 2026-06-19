import 'dart:io';
import 'dart:ui';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RatingPromptDialog extends StatelessWidget {
  final VoidCallback onRateNow;
  const RatingPromptDialog({super.key, required this.onRateNow});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: util.responsiveWidth(0.8),
            child: Dialog(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(util.width12),
                  color: whiteColor,
                  image: Platform.isIOS
                      ? DecorationImage(
                    image: AssetImage(iosSettingBg),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                padding: EdgeInsets.all(util.width10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(closeButton),
                      ),
                    ),
                    // SvgPicture.asset(dashLogin),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    Text(
                      "Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: util.fontSize16, fontFamily: 'FontSemiBold', height: 1.5),
                    ),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    GestureDetector(
                      onTap: onRateNow,
                      child: Container(
                        width: util.width / 2,
                        padding: EdgeInsets.symmetric(horizontal: util.responsiveWidth(0.0375), vertical: util.responsiveWidth(0.0188)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(util.width30), color: Platform.isAndroid ? mainColor : iosMainColor),
                        child: Text(
                          'Rate Now'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize16, height: 1.0, color: whiteColor),
                        ),
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.02)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
