import 'dart:math';
import 'package:astro_prompt/Model/life_prediction_model.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Screens/prediction/lifePrediction.dart';
import 'package:astro_prompt/Screens/prediction/yearlyPrediction.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class PredictionLandingPage extends StatefulWidget {
  final String title;
  final String icon;
  final Color gradientTop;
  final Color gradientBottom;
  const PredictionLandingPage(
      {super.key,
      required this.title,
      required this.gradientTop,
      required this.gradientBottom,
      required this.icon});

  @override
  State<PredictionLandingPage> createState() => _PredictionLandingPageState();
}

class _PredictionLandingPageState extends State<PredictionLandingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  late AnimationController slideController;
  late Animation<Offset> titleAnimation;
  late Animation<Offset> descriptionAnimation;
  late Animation<Offset> buttonAnimation;

  final PredictionService predictionService = PredictionService();
  bool isLoading = false;

  void fetchDataAndNavigate() async {
    if (widget.title == PlatformTextConfig.yearlyTitle) {
      setState(() {
        isLoading = true;
      });
      try {
        YearlyPredictionModel? predictionData =
            await predictionService.regenerateYearlyPrediction();
        setState(() {
          isLoading = false;
        });
        Get.to(() => YearlyPredictionPage(predictionData: predictionData!),
            transition: Transition.fade,
            fullscreenDialog: true,
            popGesture: false,
            duration: Duration(milliseconds: 700));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error fetching data: $e");
      }
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        LifePredictionModel? predictionData =
            await predictionService.regenerateLifePrediction();
        setState(() {
          isLoading = false;
        });
        Get.to(() => LifePredictionPage(predictionData: predictionData!));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error fetching data: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();

    slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    titleAnimation = Tween<Offset>(
      begin: Offset(0, -2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: slideController, curve: Curves.easeOut));

    descriptionAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: slideController, curve: Curves.easeOut));

    buttonAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: slideController, curve: Curves.easeOut));

    slideController.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    slideController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.7227)}');
    // print('Height: ${util.responsiveHeight(0.3338)}');
    // print('FontSize: ${util.responsiveFontSize(0.0153)}');

    print(
        '(widget.title == PlatformTextConfig.yearlyTitle): ${widget.title} Yearly Prediction');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            Get.back();
          });
        }
      },
      child: Scaffold(
        body: Container(
          width: util.width,
          height: util.height,
          padding: EdgeInsets.symmetric(horizontal: util.width20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.gradientTop,
                widget.gradientBottom,
              ],
              stops: [0.1598, 0.7685],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: util.responsiveHeight(0.1331),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: controller.value * 2 * pi,
                          child: child,
                        );
                      },
                      child: SvgPicture.asset(
                        (widget.title == PlatformTextConfig.yearlyTitle)
                            ? yearlyLandingDeco
                            : lifeLandingDeco,
                        width: util.responsiveWidth(0.7227),
                        height: util.responsiveHeight(0.3338),
                      ),
                    ),
                    Hero(
                      tag: "yearlyDecoLogoHero",
                      child: SvgPicture.asset(
                        widget.icon,
                      ),
                    ),
                  ],
                ),
              ),

              ///Title
              Positioned(
                top: util.responsiveHeight(0.4742),
                child: SlideTransition(
                  position: titleAnimation,
                  child: Hero(
                    tag: "predictionTitleHero",
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        widget.title.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize29,
                          height: 1.0,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ///Description
              Positioned(
                top: util.responsiveHeight(0.5321),
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: descriptionAnimation,
                  child: Hero(
                    tag: "predictionDescHero",
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        PlatformTextConfig.yearlyLifeDesc.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: util.fontSize18,
                          height: util.lineHeight24 / util.fontSize18,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// Generate Button
              Positioned(
                top: util.responsiveHeight(0.75),
                child: SlideTransition(
                  position: buttonAnimation,
                  child: GestureDetector(
                    onTap: () => fetchDataAndNavigate(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: util.width20,
                        vertical: util.width10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(util.width20),
                        color: whiteColor,
                      ),
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: isLoading
                            ? LoadingAnimationWidget.halfTriangleDot(
                                color: (widget.title ==
                                        PlatformTextConfig.yearlyTitle)
                                    ? yearlyTopGradient
                                    : lifeTopGradient,
                                size: util.height20,
                              )
                            : Text(
                                'Generate ${widget.title}'.tr,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize18,
                                  height: 1.0,
                                  color: (widget.title ==
                                          PlatformTextConfig.yearlyTitle)
                                      ? yearlyPredictionButtonText
                                      : lifePredictionButtonText,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: util.responsiveHeight(0.0641),
                  left: -util.width10,
                  child: Hero(
                    tag: 'BackButton',
                    child: IconButton(
                      icon: SvgPicture.asset(
                        appBackButton,
                        width: util.width20,
                        height: util.height20,
                        colorFilter:
                            (widget.title == PlatformTextConfig.yearlyTitle)
                                ? ColorFilter.mode(blackColor, BlendMode.srcIn)
                                : null,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
