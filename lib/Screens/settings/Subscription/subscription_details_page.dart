import 'package:astro_prompt/Components/Settings/subscriptionComponent.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  final int selectedIndex;
  final String currency;
  const SubscriptionDetailsPage(
      {super.key, required this.selectedIndex, required this.currency});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print(util.responsiveFontSize(0.0473));

    return Scaffold(
      backgroundColor: blackColor,
      body: Stack(
        children: [
          Positioned(
              top: 48,
              child: Image.asset(
                subscriptionBg,
                width: util.width,
              )),
          AppBar(
            elevation: 0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Subscriptions',
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.bold),
                  fontSize: util.fontSize20,
                  height: 1.0,
                  color: whiteColor),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
                Get.find<BottomNavController>().changeIndex(3);
              },
              icon: SvgPicture.asset(backButton,
                  colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn)),
            ),
          ),
          Positioned.fill(
            top: util.responsiveHeight(0.1282),
            right: 0,
            left: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  SvgPicture.asset(subscriptionPro),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    'Try Premium Plan'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'FontSemiBold',
                        fontSize: util.responsiveFontSize(0.0473),
                        color: whiteColor,
                        height: 1.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SubscriptionComponent(
                      selectedIndex: selectedIndex, currency: currency),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
