import 'dart:io';
import 'package:astro_prompt/Components/Chat/chatBanner.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Components/dailyPredictions/balaContainer.dart';
import 'package:astro_prompt/Components/dailyPredictions/predictionContainer.dart';
import 'package:astro_prompt/Components/dailyPredictions/predictionHeaderAnimation.dart';
import 'package:astro_prompt/Components/dailyPredictions/quote.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/customToolTip.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class DailyPrediction extends StatefulWidget {
  final bool premiumUser;
  final String? currency;
  final Map<String, dynamic> predictionsData;

  const DailyPrediction(
      {super.key,
      required this.predictionsData,
      required this.premiumUser,
      this.currency});

  @override
  State<DailyPrediction> createState() => _DailyPredictionState();
}

class _DailyPredictionState extends State<DailyPrediction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String currentTime = "";
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  var predictions;
  String tharaBala = '';
  String chandraBala = '';
  String quote = '';
  List<Map<String, dynamic>> dailyPredictions = [];
  String? currency;
  // final GlobalKey _screenshotKey = GlobalKey();

  final ScreenshotController screenshotController = ScreenshotController();

  String getCurrentTime() {
    final now = DateTime.now();
    final sixAMToday = DateTime(now.year, now.month, now.day, 6, 0);
    final dateToShow =
        now.isBefore(sixAMToday) ? now.subtract(Duration(days: 1)) : now;
    return DateFormat('E - MMM dd, yyyy').format(dateToShow);
  }

  @override
  void initState() {
    super.initState();
    predictions = widget.predictionsData;
    tharaBala = predictions['thara_bala'];
    chandraBala = predictions['chandra_bala'];
    quote = predictions['quote'];
    dailyPredictions = predictions['predictions'];
    currentTime = getCurrentTime();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();

    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

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
                  CustomLoader.show(currentContext, loaderColor: mainColor);
                  try {
                    final predictionId = predictions['predictionId'];
                    final dailyPdfFile = await PredictionService()
                        .shareDailyPrediction(predictionId);
                    CustomLoader.hide();
                    if (dailyPdfFile != null) {
                      final directory = await getTemporaryDirectory();
                      final pdfPath =
                          '${directory.path}/${PlatformTextConfig.dailyFileSave}.pdf';
                      final file = File(pdfPath);
                      await file.writeAsBytes(dailyPdfFile);

                      final params = ShareParams(
                        text: PlatformTextConfig.dailyParam,
                        files: [XFile(pdfPath)],
                      );

                      await SharePlus.instance.share(params);
                      if (currentContext.mounted) {
                        showLoginSuccessSnackBar(currentContext,
                            PlatformTextConfig.dailyShareSuccessMessage);
                      }
                    } else {
                      if (currentContext.mounted) {
                        showErrorSnackBar(currentContext,
                            PlatformTextConfig.dailyShareErrorMessage);
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
                        SvgPicture.asset(share),
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
        appBar: _isScrolled
            ? AppBar(
                backgroundColor: mainColor,
                elevation: 0,
                title: Text(PlatformTextConfig.dailyTitle.tr,
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: util.fontSize20,
                        fontFamily: AppFont.get(FontType.bold),
                        height: util.lineHeight24 / util.fontSize20)),
                leading: SizedBox(
                  width: util.responsiveWidth(0.08),
                  height: util.responsiveHeight(0.037),
                  child: IconButton(
                    icon: SvgPicture.asset(appBackButton,
                        width: util.width20, height: util.height20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                centerTitle: true,
              )
            : null,
        body: Stack(
          children: [
            Positioned(
              // duration: Duration(milliseconds: 500),
              top: _isScrolled ? -100 : 0,
              left: 0,
              right: 0,
              child: Opacity(
                // duration: Duration(milliseconds: 300),
                opacity: _isScrolled ? 0.0 : 1.0,
                child: Container(
                  height: util.height250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0DA602),
                        Color(0xFF10B100).withValues(alpha: 0.75)
                      ], // Matches SVG gradient
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // duration: Duration(milliseconds: 500),
              top: _isScrolled ? -100 : 0,
              left: 0,
              right: 0,
              child: Opacity(
                // duration: Duration(milliseconds: 300),
                opacity: _isScrolled ? 0.0 : 1.0,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(util.width, util.height250),
                      painter: ArcPainter(_controller.value),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              // duration: Duration(milliseconds: 500),
              top: _isScrolled ? -60 : 0,
              left: 0,
              right: 0,
              child: Opacity(
                // duration: Duration(milliseconds: 300),
                opacity: _isScrolled ? 0.0 : 1.0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(PlatformTextConfig.dailyTitle.tr,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: util.fontSize20,
                              fontFamily: AppFont.get(FontType.bold),
                              height: util.lineHeight24 / util.fontSize20)),
                      SizedBox(
                        width: 10,
                      ),
                      CustomToolTip(
                        message: PlatformTextConfig.infoText,
                        // offsetX: util.responsiveWidth(0.2),
                      ),
                    ],
                  ),
                  leading: SizedBox(
                    width: util.responsiveWidth(0.08),
                    height: util.responsiveHeight(0.037),
                    child: IconButton(
                      icon: SvgPicture.asset(appBackButton,
                          width: util.width20, height: util.height20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  centerTitle: true,
                  // actions: [
                  // IconButton(
                  //   icon: SvgPicture.asset(actionIcon),
                  //   onPressed: () => showDropdownModal(context),
                  // ),
                  // ],
                ),
              ),
            ),
            Positioned(
              // duration: Duration(milliseconds: 500),
              top: _isScrolled ? -100 : util.responsiveHeight(0.1282),
              left: 0,
              right: 0,
              child: Opacity(
                // duration: Duration(milliseconds: 300),
                opacity: _isScrolled ? 0.0 : 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: util.width20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (!widget.premiumUser) {
                            if (widget.currency != null) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black.withAlpha(128),
                                builder: (context) => SubscribePromptDialog(
                                  currency: widget.currency!,
                                  reDirectHome: false,
                                ),
                              );
                            } else {
                              await CurrencyHelper.fetchCurrencyIfNeeded(
                                context: context,
                                currentCurrency: currency!,
                                loaderColor: mainColor,
                                onCurrencyFetched: (fetchedCurrency) {
                                  setState(() {
                                    currency = fetchedCurrency;
                                  });
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierColor: Colors.black.withAlpha(128),
                                    builder: (context) => SubscribePromptDialog(
                                      currency: fetchedCurrency,
                                      reDirectHome: false,
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Container(
                          width: util.width,
                          height: util.responsiveHeight(0.0468),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(util.width12),
                            border: Border.all(
                                color: whiteColor.withValues(alpha: 0.6),
                                width: 1),
                          ),
                          child: Center(
                            child: Text(
                              widget.premiumUser
                                  ? 'Your daily predictions was scheduled for 6 AM'
                                      .tr
                                  : 'Upgrade to receive daily predictions at 6 AM'
                                      .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize14,
                                  height: util.lineHeight16_8 / util.fontSize14,
                                  color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveWidth(0.03695),
                      ),
                      Text(
                        currentTime,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize18,
                            height: util.lineHeight28 / util.fontSize18,
                            color: whiteColor),
                      ),
                      SizedBox(
                        height: util.responsiveWidth(0.03695),
                      ),
                      Column(
                        children: [
                          Container(
                              width: util.width,
                              height: util.responsiveHeight(0.117),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius:
                                    BorderRadius.circular(util.width20),
                              ),
                              child: TharaBalaChandraBalaContainer(
                                  tharaBala: tharaBala,
                                  chandraBala: chandraBala)),
                          PredictionQuote(quote: quote),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: _isScrolled ? util.height20 : util.responsiveHeight(0.45),
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.only(
                          left: util.width20,
                          right: util.width20,
                          bottom: util.width20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index < dailyPredictions.length) {
                              String title = dailyPredictions[index]['title'];
                              List<String> dataList = List<String>.from(
                                  dailyPredictions[index]['data']);

                              return PredictionContainer(
                                title: title,
                                data: dataList,
                              );
                            } else {
                              return Column(
                                children: [
                                  ChatBanner(fromChat: false),
                                  SizedBox(
                                    height: 100,
                                  )
                                ],
                              );
                            }
                          },
                          childCount: dailyPredictions.length + 1,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
