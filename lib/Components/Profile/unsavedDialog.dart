import 'dart:io';
import 'dart:ui';

import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(false),
                        child: SvgPicture.asset(closeButton),
                      ),
                    ),
                    Text(
                      "Profile Details".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize20,
                          height: util.lineHeight24 / util.fontSize20,
                          color: blackColor),
                    ), // You can replace this with a warning icon
                    SizedBox(height: util.responsiveWidth(0.048)),
                    Text(
                      "You have unsaved changes.\nDo you want to discard them and go back?".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: util.fontSize16,
                        fontFamily: AppFont.get(FontType.semiBold),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        width: util.width / 2,
                        padding: EdgeInsets.symmetric(
                            horizontal: util.responsiveWidth(0.0375),
                            vertical: util.responsiveWidth(0.0188)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(util.width30),
                          color: Platform.isAndroid ? mainColor : iosMainColor,
                        ),
                        child: Text(
                          'Discard'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize16,
                            color: whiteColor,
                          ),
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
