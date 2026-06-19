import 'package:astro_prompt/Components/Astrologer/dashBoardCard.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class AstrologerHomePage extends StatefulWidget {
  final List<AstroConsultationEventModel> eventData;
  const AstrologerHomePage({super.key, required this.eventData});

  @override
  State<AstrologerHomePage> createState() => _AstrologerHomePageState();
}

class _AstrologerHomePageState extends State<AstrologerHomePage> {
  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            Get.offAllNamed('/home');
          });
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SizedBox(
                        width: util.width,
                        child: Image.asset(astrologerHomeImage)),
                    SizedBox(
                      height: util.height30,
                    ),
                    SizedBox(
                      width: util.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(astroHomeDashLine),
                          Text(
                            'You logged in as Astrologer'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                height: 1.0,
                                color: blackColor.withValues(alpha: 0.5)),
                          ),
                          SvgPicture.asset(astroHomeDashLine),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: DashboardCards(
                        eventData: widget.eventData,
                      ),
                    )
                  ],
                )),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  title: Text("Astrologer Consultation".tr,
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: util.fontSize20,
                          fontFamily: AppFont.get(FontType.bold),
                          height: 1.0)),
                  leading: SizedBox(
                    width: util.responsiveWidth(0.08),
                    height: util.responsiveHeight(0.037),
                    child: IconButton(
                      icon: SvgPicture.asset(appBackButton,
                          width: util.width20, height: util.height20),
                      onPressed: () {
                        Get.to(() => BottomNavigationScreen());
                      },
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
