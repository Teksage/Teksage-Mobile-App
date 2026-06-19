import 'dart:io';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';

class FullScreenNoInternet extends StatelessWidget {
  const FullScreenNoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Platform.isAndroid
                  ? SvgPicture.asset(
                      loginLogoIos,
                    )
                  : Image.asset(
                      newIosLogoPNG,
                    ),
              const SizedBox(height: 24),
              Text(
                'No Internet Connection'.tr,
                style: TextStyle(
                  color: errorColor,
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: MyUtility(context).fontSize20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please check your\nnetwork settings'.tr,
                style: TextStyle(
                  color: blackColor,
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: MyUtility(context).fontSize20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
