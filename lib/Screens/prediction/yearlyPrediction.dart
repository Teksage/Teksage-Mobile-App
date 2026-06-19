import 'dart:io';
import 'package:astro_prompt/Components/YearlyPredictions/categorizedPredictionWidget.dart';
import 'package:astro_prompt/Components/YearlyPredictions/planetTransitsWidget.dart';
import 'package:astro_prompt/Components/YearlyPredictions/remediesWidget.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userCategory.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userConsultationHomePage.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/customToolTip.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class YearlyPredictionPage extends StatefulWidget {
  final YearlyPredictionModel predictionData;
  const YearlyPredictionPage({super.key, required this.predictionData});

  @override
  State<YearlyPredictionPage> createState() => _YearlyPredictionPageState();
}

class _YearlyPredictionPageState extends State<YearlyPredictionPage> {
  late YearlyPredictionModel predictionData;
  bool isLoading = false;
  final PredictionService predictionService = PredictionService();
  final ScrollController scrollController = ScrollController();
  List<AstroConsultationEventModel> eventGetData = [];
  int userId = 0;

  Future<void> fetchUserId() async {
    int? id = await getUserId();
    setState(() {
      userId = id!;
    });
    fetchAstroUserEventService();
  }

  Future<void> fetchAstroUserEventService() async {
    try {
      var fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId);
      var data = fetchEventData
          .where((e) => e.status == 'confirmed' || e.status == 'completed')
          .toList()
        ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
      setState(() {
        eventGetData = data;
      });
    } catch (e) {
      print("Error fetching Astro User Event list: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    predictionData = widget.predictionData;
    fetchUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> regeneratePrediction() async {
    if (isLoading) return; // prevent duplicate taps
    setState(() {
      isLoading = true;
    });

    try {
      YearlyPredictionModel? newPredictionData =
          await predictionService.regenerateYearlyPrediction();

      if (!mounted) return;

      if (newPredictionData == null) {
        setState(() {
          isLoading = false;
        });
        showErrorSnackBar(
            context, 'Failed to regenerate prediction. Please try again.');
        return;
      }

      setState(() {
        predictionData = newPredictionData;
        isLoading = false;
      });

      // give user feedback
      showLoginSuccessSnackBar(context, 'Prediction regenerated successfully');

      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
      showErrorSnackBar(
          context, 'An error occurred while regenerating. Please try again.');
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.032)}');
    // print('Height: ${util.responsiveHeight(0.0444)}');
    // print('FontSize: ${util.responsiveFontSize(0.0371)}');

    void showDropdownModal(BuildContext context) {
      final util = MyUtility(context);

      showGeneralDialog(
        barrierLabel: '',
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 350),
        context: context,
        pageBuilder: (context, _, __) {
          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () async {
                  final currentContext = context;
                  Get.back();
                  CustomLoader.show(currentContext,
                      loaderColor: yearlyTopGradient);
                  try {
                    final predictionId = predictionData.predictionId;
                    final yearlyPdfFile = await PredictionService()
                        .shareYearlyPrediction(predictionId!);
                    CustomLoader.hide();
                    if (yearlyPdfFile != null) {
                      final directory = await getTemporaryDirectory();
                      final pdfPath =
                          '${directory.path}/${PlatformTextConfig.yearlyFileSave}.pdf';
                      final file = File(pdfPath);
                      await file.writeAsBytes(yearlyPdfFile);

                      final params = ShareParams(
                        text: PlatformTextConfig.yearlyParam,
                        files: [XFile(pdfPath)],
                      );

                      await SharePlus.instance.share(params);
                      if (currentContext.mounted) {
                        showLoginSuccessSnackBar(currentContext,
                            PlatformTextConfig.yearlyShareSuccessMessage);
                      }
                    } else {
                      if (currentContext.mounted) {
                        showErrorSnackBar(currentContext,
                            PlatformTextConfig.yearlyShareErrorMessage);
                      }
                    }
                  } catch (e) {
                    print("❌ Sharing error: $e");
                    if (context.mounted) {
                      showErrorSnackBar(context,
                          'An unexpected error occurred while sharing. Please try again.');
                    }
                  }
                },
                child: Container(
                  width: util.responsiveWidth(0.6),
                  // height: util.responsiveHeight(0.1306),
                  margin: EdgeInsets.only(
                      top: util.responsiveHeight(0.1195),
                      left: util.responsiveWidth(0.346),
                      right: util.width20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withValues(alpha: 0.17),
                        blurRadius: 23,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: util.width20, vertical: util.height20),
                    child: Row(
                      spacing: util.width10,
                      children: [
                        SvgPicture.asset(
                          share,
                          colorFilter: ColorFilter.mode(
                              yearlyTopGradient, BlendMode.srcIn),
                        ),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontSize: util.fontSize16,
                            fontFamily: AppFont.get(FontType.medium),
                            height: util.lineHeight19_2 / util.fontSize16,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(anim),
            child: child,
          );
        },
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            Get.to(() => BottomNavigationScreen());
          });
        }
      },
      child: Scaffold(
        body: Container(
          width: util.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                yearlyTopGradient,
                yearlyBottomGradient,
              ],
              stops: [0.1598, 0.7685],
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: util.responsiveHeight(0.0616),
                ),
                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                        width: util.width,
                        padding: EdgeInsets.only(
                            left: util.width10, right: util.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag: 'BackButton',
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  appBackButton,
                                ),
                                onPressed: () {
                                  Get.to(() => BottomNavigationScreen());
                                },
                              ),
                            ),
                            // IconButton(
                            //   icon: SvgPicture.asset(actionIcon),
                            //   onPressed: () => showDropdownModal(context),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Hero(
                        tag: "yearlyDecoLogoHero",
                        child: SvgPicture.asset(
                          yearlyDecoLogo,
                          alignment: Alignment.center,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: util.width20),
                      child: Column(
                        children: [
                          //Title
                          Hero(
                            tag: "predictionTitleHero",
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    PlatformTextConfig.yearlyTitle.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.bold),
                                      fontSize: util.fontSize20,
                                      height: 1.0,
                                      color: whiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  if (predictionData.general.isNotEmpty)
                                    CustomToolTip(
                                      message: PlatformTextConfig.infoText,
                                      // offsetX: util.responsiveWidth(0.21),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: util.responsiveHeight(0.0148),
                          ),
                          //Description
                          Hero(
                            tag: "predictionDescHero",
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                predictionData.general,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize16,
                                  height: util.lineHeight24 / util.fontSize16,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: util.responsiveHeight(0.0296),
                          ),
                          DashedLine(color: whiteColor),
                          SizedBox(
                            height: util.responsiveHeight(0.0395),
                          ),
                        ],
                      ),
                    ),

                    ///Planetary Transits
                    Column(
                      children: [
                        Text(
                          'Planetary Transits'.tr,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.bold),
                              fontSize: util.fontSize24,
                              height: 1.0,
                              color: whiteColor),
                        ),
                        SizedBox(
                          height: util.responsiveHeight(0.0296),
                        ),
                        PlanetTransitsWidget(
                            planetTransits: predictionData.planetTransits),
                        SizedBox(height: util.responsiveHeight(0.0395)),
                      ],
                    ),

                    ///Categorized Predictions
                    Column(
                      children: [
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: util.width20),
                                child: DashedLine(color: whiteColor)),
                            SizedBox(height: util.responsiveHeight(0.0395)),
                            Text(
                              'Categorized Predictions'.tr,textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.bold),
                                  fontSize: util.fontSize24,
                                  height: 1.0,
                                  color: whiteColor),
                            ),
                            SizedBox(
                              height: util.responsiveHeight(0.0296),
                            ),
                            CategorizedPredictionWidget(
                                prediction: predictionData.prediction),
                            SizedBox(height: util.responsiveHeight(0.0395)),
                          ],
                        ),
                      ],
                    ),

                    ///Categorized Predictions
                    Column(
                      children: [
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: util.width20),
                                child: DashedLine(color: whiteColor)),
                            SizedBox(height: util.responsiveHeight(0.0395)),
                            Text(
                              'Remedies'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.bold),
                                  fontSize: util.fontSize24,
                                  height: 1.0,
                                  color: whiteColor),
                            ),
                            SizedBox(
                              height: util.responsiveHeight(0.0296),
                            ),
                            RemediesWidget(remedies: predictionData.remedies),
                            SizedBox(height: util.responsiveHeight(0.0444)),
                          ],
                        ),
                      ],
                    ),

                    ///Regenerate Button
                    GestureDetector(
                      onTap: isLoading ? null : regeneratePrediction,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: util.width20),
                        padding: EdgeInsets.symmetric(vertical: util.width10),
                        width: util.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(util.width20),
                          color: whiteColor,
                        ),
                        child: AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: isLoading
                              ? LoadingAnimationWidget.halfTriangleDot(
                                  color: yearlyTopGradient,
                                  size: util.height20,
                                )
                              : Text(
                                  'Regenerate'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily:
                                          AppFont.get(FontType.semiBold),
                                      fontSize: util.fontSize18,
                                      height: 1.2,
                                      color: yearlyPredictionButtonText),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (eventGetData.isNotEmpty) {
                          Get.to(() => UserConsultationDetailsHome(
                                backButton: true,
                                eventData: eventGetData,
                              ));
                        } else {
                          Get.to(() => UserCategoryPage(
                                toHome: false,
                              ));
                        }
                      },
                      child: Container(
                        width: util.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: whiteColor),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          PlatformTextConfig.astrologerUserHomeTitle.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize18,
                              height: 1.0,
                              color: yearlyPredictionButtonText),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: util.height50,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
