import 'dart:io';
import 'dart:ui';
import 'package:astro_prompt/Components/Chat/successDialog.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/match_making_model.dart';
import 'package:astro_prompt/Model/rasi_model.dart';
import 'package:astro_prompt/config/consultation_navigation.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/MatchMaking/matchMakingPage.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Services/HoroscopeService/fileStorageService.dart';
import 'package:astro_prompt/Services/MatchService/matchService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/matchMaking.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class MatchMakingDetailsPage extends StatefulWidget {
  final GetNewMatchMakingModel? matchMakingData;
  final MatchMakingModel? getMatchMakingModel;
  final bool fromHomePage;

  const MatchMakingDetailsPage(
      {super.key,
      this.matchMakingData,
      this.getMatchMakingModel,
      required this.fromHomePage});

  @override
  State<MatchMakingDetailsPage> createState() => _MatchMakingDetailsPageState();
}

class _MatchMakingDetailsPageState extends State<MatchMakingDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;
  List<RasiModel> rasiList = [];
  String boyName = '';
  String girlName = '';
  String boyRasi = '';
  String girlRasi = '';
  String boyNakshatram = '';
  String girlNakshatram = '';
  int matchMakingID = 0;
  List<Kuta> kutas = [];
  var generalDetails;
  int gained = 0;
  int maxScore = 0;
  List<AstroConsultationEventModel> eventGetData = [];
  int userId = 0;

  late AnimationController _controller;
  bool _isOpen = false;

  late AnimationController fabController;
  late Animation<Offset> fabOffsetAnimation;

  Future<void> fetchRasiList() async {
    try {
      List<RasiModel> fetchedRashi = await MatchMakingService().getRashiList();
      setState(() {
        rasiList = fetchedRashi;
      });
    } catch (e) {
      print("Error fetching Rashi list: $e");
    }
  }

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

  void loadMatchMakingData() async {
    Map<String, String> matchData = await getMakingMaking();
    boyName = matchData["boyName"] ?? "";
    girlName = matchData["girlName"] ?? "";
    boyRasi = matchData["boyRasi"] ?? "";
    girlRasi = matchData["girlRasi"] ?? "";
    boyNakshatram = matchData['boyNakshatram'] ?? "";
    girlNakshatram = matchData['girlNakshatram'] ?? "";
  }

  void setData() {
    if (widget.fromHomePage) {
      setState(() {
        boyName = widget.getMatchMakingModel!.data.boyName;
        girlName = widget.getMatchMakingModel!.data.girlName;
        boyRasi = widget.getMatchMakingModel!.data.boyRashi;
        girlRasi = widget.getMatchMakingModel!.data.girlRashi;
        boyNakshatram = widget.getMatchMakingModel!.data.boyNakshatram;
        girlNakshatram = widget.getMatchMakingModel!.data.girlNakshatram;
        kutas = widget.getMatchMakingModel!.data.compatibilityResult.kutas;
        generalDetails =
            widget.getMatchMakingModel!.data.compatibilityResult.generalDetails;
        gained =
            widget.getMatchMakingModel!.data.compatibilityResult.gainedScore;
        maxScore =
            widget.getMatchMakingModel!.data.compatibilityResult.maxScore;
        matchMakingID = widget.getMatchMakingModel!.matchMakingId;
      });
    } else {
      loadMatchMakingData();
      setState(() {
        kutas = widget.matchMakingData!.compatibilityResult.kutas;
        generalDetails =
            widget.matchMakingData!.compatibilityResult.generalDetails;
        gained = widget.matchMakingData!.compatibilityResult.gainedScore;
        maxScore = widget.matchMakingData!.compatibilityResult.maxScore;
        matchMakingID = widget.matchMakingData!.matchMakingId;
      });
    }
  }

  void _toggleOptions() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
        fabController.forward();
      } else {
        _controller.reverse();
        fabController.reverse();
      }
    });
  }

  Widget _buildOption(String icon, String label) {
    return GestureDetector(
      onTap: () {
        _toggleOptions();
        if (label == 'Astrology Consultation' ||
            label == 'Expert Consultation') {
          openBookConsultation(context);
        } else {
          Get.to(() => MatchMakingPage(
                rasiList: rasiList,
              ));
        }
      },
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 10),
          Text(label.tr,
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: MyUtility(context).fontSize16,
                  height: 1.0,
                  color: blackColor)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    fabController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabOffsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: fabController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    fabController.forward();

    opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(controller);
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(controller);
    fetchUserId();
    fetchRasiList();
    setData();
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    fabController.dispose();
    super.dispose();
  }

  Future<void> handleDownload() async {
    try {
      CustomLoader.show(context, loaderColor: Color(0xffFC9C96));

      final matchMakingPdfFile =
          await MatchMakingService().shareMatchMakingPrediction(matchMakingID);
      CustomLoader.hide();

      if (matchMakingPdfFile != null) {
        final fileName = '${boyName}_${girlName}_matchMaking';
        final filePath =
            await FileStorage.savePdfToDownloads(matchMakingPdfFile, fileName);
        final savedFileName = p.basename(filePath);

        if (context.mounted) {
          Future.microtask(() {
            showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.white.withValues(alpha: 0.5),
              builder: (ctx) => DownloadSuccessDialog(
                title: 'MatchMaking downloaded Successfully',
                file: savedFileName,
              ),
            );
          });
        }

        print('📁 Chat PDF path: $savedFileName');
      } else {
        if (context.mounted) {
          showErrorSnackBar(
              context, 'We couldn’t fetch your chat. Please try again.');
        }
      }
    } catch (e) {
      CustomLoader.hide();
      showErrorSnackBar(context, "Download failed. Please try again.");
      print("❌ Download error: $e");
    }
  }

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
            child: Container(
              width: util.responsiveWidth(0.6),
              height: util.responsiveHeight(0.1306),
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
                padding: EdgeInsets.symmetric(horizontal: util.width20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: handleDownload,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          spacing: util.width10,
                          children: [
                            SvgPicture.asset(
                              download,
                              colorFilter: ColorFilter.mode(
                                  matchButtonText, BlendMode.srcIn),
                            ),
                            Text(
                              'Download',
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
                    GestureDetector(
                      onTap: () async {
                        try {
                          Get.back();
                          CustomLoader.show(context,
                              loaderColor: Color(0xffFC9C96));
                          final matchMakingPdfFile = await MatchMakingService()
                              .shareMatchMakingPrediction(matchMakingID);
                          CustomLoader.hide();

                          if (matchMakingPdfFile == null) {
                            if (context.mounted) {
                              showErrorSnackBar(context,
                                  'We couldn’t fetch your MatchMaking. Please try again.');
                            }
                          } else {
                            final directory = await getTemporaryDirectory();
                            final pdfPath =
                                '${directory.path}/$boyName & ${girlName}_match_making.pdf';
                            final file = File(pdfPath);
                            await file.writeAsBytes(matchMakingPdfFile);

                            final params = ShareParams(
                              text: 'Here is the match making!',
                              files: [XFile(pdfPath)],
                            );

                            await SharePlus.instance.share(params);
                            if (context.mounted) {
                              showLoginSuccessSnackBar(context,
                                  'Your $boyName & $girlName Match Making has been shared successfully. Thank you.');
                            }
                          }

                          // if (matchMakingPdfFile != null) {
                          //   final directory = await getTemporaryDirectory();
                          //   final pdfPath = '${directory.path}/$boyName & ${girlName}_match_making.pdf';
                          //   final file = File(pdfPath);
                          //   await file.writeAsBytes(matchMakingPdfFile);
                          //
                          //   final params = ShareParams(
                          //     text: 'Here is the match making!',
                          //     files: [XFile(pdfPath)],
                          //   );
                          //
                          //   await SharePlus.instance.share(params);
                          //   if (context.mounted) {
                          //     showLoginSuccessSnackBar(context, 'Your $boyName & $girlName Match Making has been shared successfully. Thank you.');
                          //   }
                          // } else {
                          //   if (context.mounted) {
                          //     showErrorSnackBar(context, 'We couldn’t fetch your MatchMaking. Please try again.');
                          //   }
                          // }
                        } catch (e) {
                          CustomLoader.hide();
                          if (context.mounted) {
                            showErrorSnackBar(context,
                                'An unexpected error occurred while sharing. Please try again.');
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          spacing: util.width10,
                          children: [
                            SvgPicture.asset(
                              share,
                              colorFilter: ColorFilter.mode(
                                  matchButtonText, BlendMode.srcIn),
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
                  ],
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

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.36)}');
    print('Height: ${util.responsiveHeight(0.4387)}');
    // print('FontSize: ${util.responsiveFontSize(0.0675)}');

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
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: _toggleOptions,
            backgroundColor: Color(0xffFC9C96),
            child: AnimatedRotation(
              turns: _isOpen ? 0.6 : 0,
              duration: Duration(milliseconds: 500),
              child: SvgPicture.asset(fabButton),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Image.asset(
                    matchMakingBG,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: util.height250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(247, 140, 140, 0.5),
                          Color.fromRGBO(255, 225, 212, 0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  title: Text("Marriage Match Making".tr,
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
                        // Get.to(() => MatchMakingPage(
                        //       rasiList: rasiList,
                        //     ));
                      },
                    ),
                  ),
                  // actions: [
                  //   IconButton(
                  //     icon: SvgPicture.asset(actionIcon),
                  //     onPressed: () => showDropdownModal(context),
                  //   ),
                  // ],
                  centerTitle: true,
                ),
              ),
            ),
            Positioned(
              top: util.height250,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: util.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffFAABA6),
                      Color(0xffff8B84),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: util.responsiveHeight(0.1355),
              right: 0,
              left: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: util.width20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          /// BACKGROUND + BORDER (DECORATION ONLY)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: matchHeadColor,
                                borderRadius:
                                    BorderRadius.circular(util.width20),
                                border: Border.all(
                                  color: whiteColor.withValues(alpha: 0.4),
                                  width: 5,
                                ),
                              ),
                            ),
                          ),

                          /// TOP DECOR
                          Align(
                            alignment: Alignment.topCenter,
                            child: ClipRRect(
                              child: SvgPicture.asset(matchTopDeco),
                            ),
                          ),

                          /// ANIMATED RING
                          Positioned(
                            top: util.responsiveHeight(0.015),
                            left: 0,
                            right: 0,
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: scaleAnimation.value,
                                  child: AnimatedOpacity(
                                    opacity: opacityAnimation.value,
                                    duration: const Duration(milliseconds: 500),
                                    child: SvgPicture.asset(bigRing),
                                  ),
                                );
                              },
                            ),
                          ),

                          /// 🔥 CONTENT — CONTROLS HEIGHT (NO FIXED HEIGHT)
                          Padding(
                            padding: EdgeInsets.only(
                              top: util.responsiveHeight(0.09),
                              left: util.responsiveWidth(0.064),
                              right: util.responsiveWidth(0.064),
                              bottom: util.height20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// BOY & GIRL DETAILS
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// BOY COLUMN
                                    Column(
                                      children: [
                                        SvgPicture.asset(boy),
                                        const SizedBox(height: 13),
                                        DashedLine(
                                          width: util.responsiveWidth(0.36),
                                          dashWidth: 3,
                                          color:
                                              blackColor.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 13),
                                        Text(
                                          'Boy Name'.tr,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize12,
                                            color: matchButtonText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          boyName,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize16,
                                            color: blackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 13),
                                        DashedLine(
                                          width: util.responsiveWidth(0.36),
                                          dashWidth: 3,
                                          color:
                                              blackColor.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 13),
                                        Text(
                                          'Rasi'.tr,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize12,
                                            color: matchButtonText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          boyRasi,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize16,
                                            color: blackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 13),
                                        DashedLine(
                                          width: util.responsiveWidth(0.36),
                                          dashWidth: 3,
                                          color:
                                              blackColor.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 13),
                                        Text(
                                          'Nakshatram'.tr,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize12,
                                            color: matchButtonText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          boyNakshatram,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize16,
                                            color: blackColor,
                                          ),
                                        ),
                                      ],
                                    ),

                                    /// GIRL COLUMN
                                    Column(
                                      children: [
                                        SvgPicture.asset(girl),
                                        const SizedBox(height: 13),
                                        DashedLine(
                                          width: util.responsiveWidth(0.36),
                                          dashWidth: 3,
                                          color:
                                              blackColor.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 13),
                                        Text(
                                          'Girl Name'.tr,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize12,
                                            color: matchButtonText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          girlName,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize16,
                                            color: blackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 13),
                                        DashedLine(
                                          width: util.responsiveWidth(0.36),
                                          dashWidth: 3,
                                          color:
                                              blackColor.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 13),
                                        Text(
                                          'Rasi'.tr,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize12,
                                            color: matchButtonText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          girlRasi,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize16,
                                            color: blackColor,
                                          ),
                                        ),
                                        const SizedBox(height: 13),
                                        DashedLine(
                                          width: util.responsiveWidth(0.36),
                                          dashWidth: 3,
                                          color:
                                              blackColor.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 13),
                                        Text(
                                          'Nakshatram'.tr,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize12,
                                            color: matchButtonText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          girlNakshatram,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: util.fontSize16,
                                            color: blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                DashedLine(
                                  width: util.width,
                                  dashWidth: 3,
                                  color: blackColor.withValues(alpha: 0.3),
                                ),

                                const SizedBox(height: 18),

                                /// SCORE
                                Text(
                                  '$gained/$maxScore',
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    fontSize: util.responsiveFontSize(0.06),
                                    color: blackColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Total Compatibility Score'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize16,
                                    color: matchButtonText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: util.responsiveWidth(0.04)),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              util.responsiveWidth(0.032)),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              util.responsiveWidth(0.032)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: util.responsiveHeight(0.053),
                                padding: EdgeInsets.only(left: util.width20),
                                decoration: BoxDecoration(
                                  color: matchHeadColor,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(
                                          util.responsiveWidth(0.032))),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text("Kuta".tr,
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize16,
                                              height: 1.0,
                                              color: matchButtonText)),
                                    ),
                                    Expanded(
                                      child: Text("Gained".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize16,
                                              height: 1.0,
                                              color: matchButtonText)),
                                    ),
                                    Expanded(
                                      child: Text("Max".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize16,
                                              height: 1.0,
                                              color: matchButtonText)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: util.height20,
                                    bottom: util.height20,
                                    left: util.width20),
                                child: Column(
                                  children: kutas.map((kuta) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              util.responsiveWidth(0.016)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(kuta.kuta,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.medium),
                                                    fontSize: util.fontSize16,
                                                    height: 1.0,
                                                    color: blackColor)),
                                          ),
                                          Expanded(
                                            child: Text(kuta.gained.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.medium),
                                                    fontSize: util.fontSize16,
                                                    height: 1.0,
                                                    color: blackColor)),
                                          ),
                                          Expanded(
                                            child: Text(kuta.max.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.medium),
                                                    fontSize: util.fontSize16,
                                                    height: 1.0,
                                                    color: blackColor)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: util.responsiveHeight(0.0161)),
                      Container(
                        width: util.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: util.responsiveWidth(0.0374),
                            vertical: util.height20),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(
                                util.responsiveWidth(0.032))),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: kutas.length,
                            itemBuilder: (context, index) {
                              final matchData = kutas[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        matchData.kuta,
                                        style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.bold),
                                            fontSize: util.fontSize18,
                                            height: 1.0,
                                            color: matchData.present
                                                ? mainColor
                                                : errorColor),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    util.responsiveWidth(0.016),
                                                vertical: util
                                                    .responsiveHeight(0.005)),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        util.responsiveWidth(
                                                            0.0215)),
                                                color: matchData.present
                                                    ? mainColor
                                                    : errorColor),
                                            child: Row(children: [
                                              Text(
                                                matchData.present
                                                    ? 'Present'.tr
                                                    : 'Absent'.tr,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.semiBold),
                                                    fontSize: util.fontSize12,
                                                    height: 1.0,
                                                    color: whiteColor),
                                              ),
                                              SizedBox(
                                                width:
                                                    util.responsiveWidth(0.016),
                                              ),
                                              SvgPicture.asset(matchData.present
                                                  ? present
                                                  : absent)
                                            ]),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: util.height10,
                                  ),
                                  Text(
                                    matchData.details,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.3,
                                        color:
                                            blackColor.withValues(alpha: 0.8)),
                                  ),
                                  if (index != kutas.length - 1) ...[
                                    SizedBox(height: util.height20),
                                    DashedLine(
                                      dashWidth: 3,
                                      color: blackColor.withValues(alpha: 0.2),
                                    ),
                                    SizedBox(height: util.height20),
                                  ]
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: util.height10,
                      ),
                      Container(
                        padding: EdgeInsets.all(util.width20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: whiteColor),
                        child: Text(
                          generalDetails,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize14,
                              height: 1.3,
                              color: blackColor.withValues(alpha: 0.8)),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      GestureDetector(
                        onTap: () => openBookConsultation(context),
                        child: Container(
                          width: util.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: whiteColor),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Expert Connect'.tr,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isOpen) ...[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ),
              ),
              Positioned(
                bottom: util.responsiveHeight(0.1601),
                right: 20,
                child: SlideTransition(
                  position: fabOffsetAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildOption(matchPerson,
                                PlatformTextConfig.astrologerUserHomeTitle),
                            SizedBox(height: 12),
                            _buildOption(matchRegenerate, 'Regenerate'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
