import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class PermissionHandlerScreen extends StatelessWidget {
  const PermissionHandlerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(util.width20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(util.width12),
          color: whiteColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(accessLocation),
            SizedBox(
              height: util.height20,
            ),
            Text(
              'Allow Location Access'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'FontSemiBold',
                  fontSize: util.fontSize20,
                  height: 1.0,
                  color: blackColor),
            ),
            SizedBox(
              height: util.height10,
            ),
            Text(
              'We need your location to get prices in your local currency (INR, USD, etc.)'
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize16,
                  height: 1.0,
                  color: blackColor.withValues(alpha: 0.7)),
            ),
            SizedBox(
              height: util.height20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Container(
                width: util.width,
                padding: EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), color: mainColor),
                child: Text(
                  'Allow'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'FontSemiBold',
                      fontSize: util.fontSize16,
                      height: 1.0,
                      color: whiteColor),
                ),
              ),
            ),
            SizedBox(
              height: util.height10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Container(
                width: util.width,
                padding: EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffEBEBEB)),
                child: Text(
                  'Not Allow'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'FontSemiBold',
                      fontSize: util.fontSize16,
                      height: 1.0,
                      color: blackColor.withValues(alpha: 0.7)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MandatoryPermissionScreen extends StatelessWidget {
  const MandatoryPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print('POp: $didPop');
        if (!didPop) {
          Future.microtask(() {
            Get.back();
            Get.find<BottomNavController>().changeIndex(0);
          });
        }
      },
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(util.width20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(util.width12),
            color: whiteColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(accessLocation),
              SizedBox(
                height: util.height20,
              ),
              Text(
                'Allow Location Access'.tr,
                style: TextStyle(
                    fontFamily: 'FontSemiBold',
                    fontSize: util.fontSize20,
                    height: 1.0,
                    color: blackColor),
              ),
              SizedBox(
                height: util.height10,
              ),
              Text(
                'We need your location to get prices in your local currency (INR, USD, etc.)'
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize16,
                    height: 1.0,
                    color: blackColor.withValues(alpha: 0.7)),
              ),
              SizedBox(
                height: util.height20,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openAppSettings();
                },
                child: Container(
                  width: util.width,
                  padding: EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: mainColor),
                  child: Text(
                    'Go to Settings'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'FontSemiBold',
                        fontSize: util.fontSize16,
                        height: 1.0,
                        color: whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
