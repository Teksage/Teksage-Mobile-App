import 'dart:io';

import 'package:astro_prompt/Components/LifePredictions/customCardSwiper.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/life_prediction_model.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class LifePredictionPage extends StatefulWidget {
  final LifePredictionModel predictionData;
  const LifePredictionPage({super.key, required this.predictionData});

  @override
  State<LifePredictionPage> createState() => _LifePredictionPageState();
}

class _LifePredictionPageState extends State<LifePredictionPage> {
  late LifePredictionModel predictionData;
  bool isLoading = false;
  final PredictionService predictionService = PredictionService();
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  int userId = 0;
  List<AstroConsultationEventModel> eventGetData = [];

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

  void _updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    predictionData = widget.predictionData;
    fetchUserId();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.032)}');
    // print('Height: ${util.responsiveHeight(0.0395)}');
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
                  Get.back();
                  CustomLoader.show(context, loaderColor: lifeTopGradient);
                  try {
                    final predictionId = predictionData.predictionId;
                    if (predictionId == null)
                      throw Exception("Prediction ID is null");

                    final lifePdfFile = await PredictionService()
                        .shareLifePrediction(predictionId);
                    CustomLoader.hide();

                    if (lifePdfFile == null) {
                      if (context.mounted) {
                        showErrorSnackBar(context,
                            'We encountered an issue while fetching your life prediction. Please retry.');
                      }
                    } else {
                      final directory = await getTemporaryDirectory();
                      final pdfPath = '${directory.path}/life_prediction.pdf';
                      final file = File(pdfPath);
                      await file.writeAsBytes(lifePdfFile);

                      final params = ShareParams(
                        text: 'Here is my Life prediction!',
                        files: [XFile(pdfPath)],
                      );
                      await SharePlus.instance.share(params);
                      if (context.mounted) {
                        showLoginSuccessSnackBar(context,
                            'Your life prediction has been shared successfully. Thank you.');
                      }
                    }
                  } catch (e) {
                    CustomLoader.hide();
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
                              lifeTopGradient, BlendMode.srcIn),
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
          height: util.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lifeTopGradient,
                lifeBottomGradient,
              ],
              stops: [0.1598, 0.7685],
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                          lifeDecoLogo,
                          alignment: Alignment.center,
                        ),
                      ),
                    )
                  ],
                ),

                ///Title
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
                                PlatformTextConfig.lifeTitle.tr,
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
                              if (predictionData.predictions.isNotEmpty)
                                CustomToolTip(
                                  message: PlatformTextConfig.infoText,
                                  // offsetX: util.responsiveWidth(0.18),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0148),
                      ),
                      //Intro
                      Hero(
                        tag: "predictionDescHero",
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.'.tr,
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
                      // SizedBox(
                      //   height: util.responsiveHeight(0.0296),
                      // ),
                      SizedBox(
                        height: util.responsiveHeight(0.0395),
                      ),
                    ],
                  ),
                ),

                ///Stacked Card
                CustomCardSwiper(
                  predictions: predictionData.predictions,
                  onIndexChanged: _updateIndex,
                ),

                ///Consult Astrologer
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
                        color: whiteColor.withValues(alpha: 0.3)),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      PlatformTextConfig.astrologerUserHomeTitle.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'FontSemiBold',
                          fontSize: util.fontSize18,
                          height: 1.0,
                          color: lifePredictionButtonText),
                    ),
                  ),
                ),
                SizedBox(
                  height: util.height50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
