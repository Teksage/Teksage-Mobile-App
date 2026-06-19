import 'dart:io';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/auth/login_with_email.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/onBoarding.dart';
import 'package:astro_prompt/config/languageSelectionDialog.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  final onboardingData = PlatformTextConfig.onboardingData;

  void skipOnboarding() async {
    await saveOnboardingStatus();

    // Check if language is already set
    String appLang = await getAppLanguage();

    if (appLang.isEmpty) {
      // Show language selection dialog first
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              LanguageSelectionDialog(isInitialSelection: true),
        );
      }
    }

    // Navigate after language selection (or skip if already set)
    if (Platform.isAndroid) {
      Get.offAll(() => BottomNavigationScreen(),
          transition: Transition.fade, duration: Duration(milliseconds: 500));
    } else {
      Get.offAll(() => LoginPageEmail(),
          transition: Transition.fade, duration: Duration(milliseconds: 500));
    }
  }

  void finishOnboarding() async {
    await saveOnboardingStatus();

    // Check if language is already set
    String appLang = await getAppLanguage();

    if (appLang.isEmpty) {
      // Show language selection dialog first
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              LanguageSelectionDialog(isInitialSelection: true),
        );
      }
    }

    // Navigate after language selection (or skip if already set)
    if (Platform.isAndroid) {
      Get.offAll(() => BottomNavigationScreen(),
          transition: Transition.fade, duration: Duration(milliseconds: 500));
    } else {
      Get.offAll(() => LoginPageEmail(),
          transition: Transition.fade, duration: Duration(milliseconds: 500));
    }
  }

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (currentPage == onboardingData.length - 1) {
      finishOnboarding();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.animateToPage(
        currentPage - 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.0268)}');
    // print('Height: ${util.responsiveHeight(0.482)}');
    // print('FontSize: ${util.responsiveFontSize(0.2135)}');
    return Scaffold(
      backgroundColor: Platform.isAndroid ? mainColor : iosMainColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => currentPage = index),
              itemBuilder: (context, index) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Stack(
                    key: ValueKey<int>(index),
                    children: [
                      Positioned(
                          top: index == 1 ? util.responsiveHeight(0.0818) : 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Platform.isAndroid
                                    ? util.responsiveWidth(0.0268)
                                    : util.responsiveWidth(0.055)),
                            child: Image.asset(onboardingData[index]["image"]!),
                          )),
                      Positioned(
                        top: util.responsiveHeight(
                            Platform.isAndroid ? 0.342 : 0.32),
                        right: 0,
                        left: 0,
                        child: Container(
                          height: util.responsiveHeight(0.6),
                          decoration: index == 1
                              ? Platform.isAndroid
                                  ? BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(16, 177, 0, 0.0),
                                          Color.fromRGBO(16, 177, 0, 0.8),
                                          Color(0xFF10B100),
                                        ],
                                        stops: [0.0433, 0.3054, 0.3585],
                                      ),
                                    )
                                  : BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(16, 129, 221, 0.0),
                                          Color.fromRGBO(16, 129, 221, 0.8),
                                          iosMainColor,
                                        ],
                                        stops: [0.1, 0.3, 0.5],
                                      ),
                                    )
                              : null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (Platform.isIOS) SizedBox(height: 30),
                              Text(onboardingData[index]["title"]!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: util.responsiveFontSize(0.0472),
                                      fontFamily: AppFont.get(FontType.bold),
                                      color: whiteColor,
                                      height: 33.6 /
                                          util.responsiveFontSize(0.0472))),
                              SizedBox(height: 20),
                              Text(onboardingData[index]["description"]!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: util.responsiveFontSize(0.0304),
                                      fontFamily: AppFont.get(FontType.medium),
                                      color: whiteColor,
                                      height: 21.6 /
                                          util.responsiveFontSize(0.0304))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Platform.isIOS
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Image.asset(
                    onboardIosBg,
                    width: util.width,
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox.shrink(),
          Positioned(
              bottom: util.responsiveHeight(0.1188),
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        previousPage();
                      },
                      child: Container(
                        width: util.responsiveWidth(0.2135),
                        height: util.responsiveHeight(0.0555),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: currentPage == 0
                                ? whiteColor.withValues(alpha: 0.2)
                                : whiteColor),
                        child: Center(
                            child: SvgPicture.asset(
                          back,
                          colorFilter: ColorFilter.mode(
                              Platform.isAndroid ? mainColor : iosMainColor,
                              BlendMode.srcIn),
                        )),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: onboardingData.length,
                      effect: SwapEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: whiteColor,
                        dotColor: whiteColor.withValues(alpha: 0.4),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        nextPage();
                      },
                      child: Container(
                        width: util.responsiveWidth(0.2135),
                        height: util.responsiveHeight(0.0555),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: whiteColor),
                        child: Center(
                            child: SvgPicture.asset(forward,
                                colorFilter: ColorFilter.mode(
                                    Platform.isAndroid
                                        ? mainColor
                                        : iosMainColor,
                                    BlendMode.srcIn))),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              left: 0,
              right: 0,
              bottom: util.responsiveHeight(0.05),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextButton(
                    onPressed: skipOnboarding,
                    child: Text("Skip Intro",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: AppFont.get(FontType.medium),
                            color: whiteColor))),
              )),
        ],
      ),
    );
  }
}
