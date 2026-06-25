import 'dart:io';
import 'dart:ui';
import 'package:astro_prompt/Components/Common/customArc.dart';
import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_details_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ScrollController _scrollController = ScrollController();
  Color _bgColor = mainColor;
  String currency = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && _bgColor != mainColor) {
      setState(() => _bgColor = mainColor);
    } else if (_scrollController.offset <= 0 && _bgColor != whiteColor) {
      setState(() => _bgColor = whiteColor);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.0268)}');
    // print('Height: ${util.responsiveHeight(0.2771)}');
    // print('FontSize: ${util.responsiveFontSize(0.2135)}');

    return Scaffold(
      backgroundColor: _bgColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: mainColor,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: CustomArc(),
                    child: Container(
                      height: util.responsiveHeight(0.35),
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: util.responsiveHeight(0.0986),
                    right: 0,
                    left: 0,
                    child: Text(
                      'Welcome to\nTeksage!'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontFamily: AppFont.get(FontType.bold),
                          color: mainColor),
                    ),
                  ),
                  Positioned(
                    top: util.responsiveHeight(0.22),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 67.5,
                        height: 67.5,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withValues(alpha: 0.25),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          welcomeLogo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Your 24/7 Personal Astrologer is here\n—now at just'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize16,
                    color: whiteColor),
              ),
              SizedBox(
                height: util.height20,
              ),
              SizedBox(
                height: util.responsiveHeight(0.1478),
                width: util.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                               TextSpan(
                                text: '₹',
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.extraBold),
                                    fontSize: 40,
                                    color: Colors.white,
                                    height: 1.0),
                              ),
                               TextSpan(
                                text: '99',
                                style: TextStyle(
                                    fontSize: 68,
                                    fontFamily: AppFont.get(FontType.extraBold),
                                    color: Colors.white,
                                    height: 1.0),
                              ),
                               TextSpan(
                                text: '/-',
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.extraBold),
                                    fontSize: 40,
                                    color: Colors.white,
                                    height: 1.0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'per month'.tr,
                          style: TextStyle(
                            fontSize: util.fontSize16,
                            color: Colors.white,
                            fontFamily: AppFont.get(FontType.medium),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: util.responsiveHeight(0.08),
                      right: 0,
                      left: 0,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 2,
                          sigmaY: 2,
                        ),
                        child: SvgPicture.asset(
                          welcomeBoxShadow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: util.height20,
              ),
              Text(
                'Unlock premium features'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.extraBold),
                    fontSize: util.fontSize20,
                    color: whiteColor),
              ),
              SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  Container(
                    width: util.width,
                    margin: EdgeInsets.symmetric(horizontal: 35),
                    padding: EdgeInsets.all(20),
                    // height: util.responsiveHeight(0.271),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                        border: Border.all(color: whiteColor, width: 1)),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SvgPicture.asset(welcomeCheckBox),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: Text(
                              'Unlimited AI voice chat in your own language'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize16,
                                  color: whiteColor),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SvgPicture.asset(welcomeCheckBox),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: Text(
                              'Yearly insights & life predictions'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize16,
                                  color: whiteColor),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SvgPicture.asset(welcomeCheckBox),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: Text(
                              'Personalised Panchang for your horoscope'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize16,
                                  color: whiteColor),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: util.height50,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () async {
                        if ((currency ?? '').isEmpty) {
                          final permissionGranted = await CurrencyService()
                              .requestPermission(context);
                          if (permissionGranted) {
                            currency =
                                await CurrencyService().getCurrency(context) ??
                                    '';
                          }
                        }

                        if ((currency ?? '').isNotEmpty) {
                          Get.to(() => SubscriptionDetailsPage(
                              selectedIndex: 1, currency: currency));
                        } else {
                          showErrorSnackBar(context,
                              'Please enable location access to view relevant subscription plans');
                        }
                      },
                      child: Container(
                        width: util.width,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Upgrade Plan'.tr,
                            style: TextStyle(
                                fontFamily: 'FontSemiBold',
                                fontSize: util.fontSize18,
                                color: mainColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    Get.off(
                      () => const BottomNavigationScreen(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 800),
                    );
                  } else {
                    Get.off(
                      () => const AIChatScreen(),
                      transition: Transition.fade,
                      duration: const Duration(milliseconds: 800),
                    );
                  }
                },
                child: Text(
                  'Skip'.tr,
                  style: TextStyle(
                      fontFamily: 'FontSemiBold',
                      fontSize: util.fontSize18,
                      color: whiteColor),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
