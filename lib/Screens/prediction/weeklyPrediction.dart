import 'dart:io';
import 'package:astro_prompt/Components/Chat/chatBanner.dart';
import 'package:astro_prompt/Components/WeeklyPredictions/calculateHeight.dart'
    show HeightReportingWidget;
import 'package:astro_prompt/Components/WeeklyPredictions/rotaingImage.dart';
import 'package:astro_prompt/Components/weeklyPredictions/days.dart';
import 'package:astro_prompt/Components/weeklyPredictions/predictionContainer.dart';
import 'package:astro_prompt/Model/weekly_prediction_model.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/customToolTip.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class WeeklyPrediction extends StatefulWidget {
  final ({
    int predictionId,
    List<WeeklyPredictionModel> predictions
  }) weeklyPrediction;
  const WeeklyPrediction({super.key, required this.weeklyPrediction});

  @override
  State<WeeklyPrediction> createState() => _WeeklyPredictionState();
}

class _WeeklyPredictionState extends State<WeeklyPrediction>
    with WidgetsBindingObserver {
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  int selectedIndex = 0;
  final ScrollController scrollController = ScrollController();
  final Map<int, double> cardHeights = {};
  bool heightsCalculated = false;
  PredictionService predictionService = PredictionService();
  String userName = '';
  late Future<({int predictionId, List<WeeklyPredictionModel> predictions})>
      weeklyPredictions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    scrollController.addListener(_onScroll);
    weeklyPredictions = PredictionService().getWeeklyPredictions();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    String name = await getUserName();
    setState(() {
      userName = name;
    });
  }

  void _onDayTap(int index) {
    if (cardHeights.isEmpty) {
      print("❌ _onDayTap called before heights were calculated! Ignoring...");
      return;
    }

    double scrollOffset = 0.0;
    for (int i = 0; i < index; i++) {
      scrollOffset += cardHeights[i] ?? 220.0;
    }
    print("🔵 _onDayTap → Scrolling to Index: $index | Offset: $scrollOffset");
    scrollController.animateTo(
      scrollOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    setState(() {
      selectedIndex = index;
    });
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        !heightsCalculated ||
        cardHeights.isEmpty) {
      print(
          "❌ _onScroll ignored — Heights not calculated or cardHeights empty.");
      return;
    }

    double offset = scrollController.offset;
    double accumulatedHeight = 0;
    int newIndex = selectedIndex;

    for (int i = 0; i < cardHeights.length; i++) {
      accumulatedHeight += cardHeights[i] ?? 235.0;
      if (offset < accumulatedHeight - ((cardHeights[i] ?? 235.0) / 2)) {
        newIndex = i;
        break;
      }
    }

    if (newIndex != selectedIndex) {
      setState(() {
        selectedIndex = newIndex;
      });
      print("🟢 _onScroll → Updated selectedIndex: $newIndex");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        weeklyPredictions = PredictionService().getWeeklyPredictions();
        scrollController.jumpTo(0);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('PredictionId: ${widget.weeklyPrediction.predictionId}');

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
                      loaderColor: Color(0xff00B17F));
                  try {
                    final predictionId = widget.weeklyPrediction.predictionId;
                    final weeklyPdfFile = await PredictionService()
                        .shareWeeklyPrediction(predictionId);
                    CustomLoader.hide();
                    if (weeklyPdfFile != null) {
                      final directory = await getTemporaryDirectory();
                      final pdfPath =
                          '${directory.path}/${PlatformTextConfig.weeklyFileSave}.pdf';
                      final file = File(pdfPath);
                      await file.writeAsBytes(weeklyPdfFile);

                      final params = ShareParams(
                        text: PlatformTextConfig.weeklyParam,
                        files: [XFile(pdfPath)],
                      );

                      await SharePlus.instance.share(params);
                      if (currentContext.mounted) {
                        showLoginSuccessSnackBar(currentContext,
                            PlatformTextConfig.weeklyShareSuccessMessage);
                      }
                    } else {
                      if (currentContext.mounted) {
                        showErrorSnackBar(currentContext,
                            PlatformTextConfig.weeklyShareErrorMessage);
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
                              Color(0xff00B17F), BlendMode.srcIn),
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
            Get.back();
          });
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: util.width,
                    height: 347,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff00B17F),
                          Color(0x0000B15E),
                        ],
                        stops: [0.2854, 1],
                      ),
                    ),
                    child: Stack(
                      children: [
                        RotatingImage(
                          imagePath: weeklyBg,
                          width: util.width,
                        ),
                        Positioned(
                          top: 107,
                          right: 0,
                          left: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      PlatformTextConfig.weeklyTitle.tr,
                                      style: TextStyle(
                                        fontFamily: AppFont.get(FontType.bold),
                                        color: whiteColor,
                                        fontSize: util.fontSize20,
                                        height: 1.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    CustomToolTip(
                                      message: PlatformTextConfig.infoText,
                                      // offsetX: 0.0,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${'Good morning,'.tr} $userName!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize18,
                                      height:
                                          util.lineHeight24 / util.fontSize18,
                                      color: whiteColor),
                                ),
                                Text(
                                  "Hope you're having a wonderful start to your day."
                                      .tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize18,
                                      height:
                                          util.lineHeight24 / util.fontSize18,
                                      color: whiteColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: util.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: DaysWidget(
                              days: days,
                              highlightedIndex: selectedIndex,
                              onDayTap: _onDayTap,
                            ),
                          ),
                        ),
                        Positioned(
                            top: 41,
                            child: Container(
                              padding: EdgeInsets.only(right: 10),
                              width: util.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          backButton,
                                          colorFilter: const ColorFilter.mode(
                                              whiteColor, BlendMode.srcIn),
                                        )),
                                  ),
                                  // IconButton(
                                  //   icon: SvgPicture.asset(actionIcon),
                                  //   onPressed: () => showDropdownModal(context),
                                  // ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: 300,
              child: Padding(
                padding: EdgeInsets.only(top: util.responsiveHeight(0.07)),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount:
                            widget.weeklyPrediction.predictions.length + 1,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        itemBuilder: (context, index) {
                          if (index ==
                              widget.weeklyPrediction.predictions.length) {
                            return SizedBox(
                              height: util.responsiveHeight(0.370),
                              child: Column(
                                children: [
                                  ChatBanner(
                                    fromChat: false,
                                  ),
                                ],
                              ),
                            );
                          }
                          final prediction =
                              widget.weeklyPrediction.predictions[index];
                          return HeightReportingWidget(
                            onSizeChange: (height) {
                              if (!cardHeights.containsKey(index)) {
                                setState(() {
                                  cardHeights[index] = height;
                                  if (cardHeights.length ==
                                      widget.weeklyPrediction.predictions
                                          .length) {
                                    heightsCalculated = true;
                                    print(
                                        "✅ All card heights captured: $cardHeights");
                                  }
                                });
                              }
                            },
                            child: WeeklyPredictionCard(
                              day: prediction.day,
                              shortPrediction: prediction.shortPrediction,
                              longPrediction: prediction.longPrediction,
                              isPositiveDay: prediction.isPositiveDay,
                              tharaBala: prediction.tharaBala,
                              chandraBala: prediction.chandraBala,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
