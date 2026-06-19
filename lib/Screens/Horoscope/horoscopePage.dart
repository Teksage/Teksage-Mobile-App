import 'dart:io';
import 'package:astro_prompt/Components/Chat/successDialog.dart';
import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Components/Horoscope/comingSoon.dart';
import 'package:astro_prompt/Components/Horoscope/horoscopeChart.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/horoscope_model.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Services/HoroscopeService/fileStorageService.dart';
import 'package:astro_prompt/Services/HoroscopeService/horoscopeService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/customToolTip.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class HoroscopePage extends StatefulWidget {
  const HoroscopePage({
    super.key,
  });

  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  final BottomNavController controller = Get.find<BottomNavController>();
  Future<Horoscope>? horoscopeData;
  int selectedIndex = 0;
  bool premiumUser = false;
  String? currency;
  var path;
  final RxBool isChecking = true.obs;
  bool _hasCheckedAccess = false;
  bool _dialogShown = false;
  bool _debounced = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAccess();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ever(controller.currentIndex, (index) {
      if (!_debounced) {
        _debounced = true;
        Future.delayed(Duration(milliseconds: 100), () {
          _debounced = false;
        });
        if (index != 2) {
          _hasCheckedAccess = false;
          _dialogShown = false;
        } else if (!_hasCheckedAccess && !_dialogShown) {
          _checkAccess();
        }
      }
    });
    if (controller.currentIndex.value == 2 &&
        !_hasCheckedAccess &&
        !_dialogShown) {
      _checkAccess();
    }
  }

  Future<void> _checkAccess() async {
    _hasCheckedAccess = true;
    isChecking.value = true;
    await Future.delayed(Duration(milliseconds: 200));
    try {
      if (mounted) CustomLoader.show(context);
      final token = await getAccessToken();
      if (!mounted) return;

      if (token.isEmpty) {
        if (mounted) CustomLoader.hide();
        await _showAccessDialog(const LoginPromptDialog(reDirectHome: true));
        return;
      } else {
        setState(() {
          horoscopeData = HoroscopeService().getHoroscope();
        });
      }
    } catch (e) {
      print('❌ Access check exception: $e');
    } finally {
      if (mounted) {
        CustomLoader.hide();
        isChecking.value = false;
      }
    }
  }

  Future<void> _showAccessDialog(Widget dialog) async {
    if (_dialogShown || !mounted) return;
    _dialogShown = true;

    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(50),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.all(16),
        child: dialog,
      ),
    );
  }

  // Future<void> checkAccessToken() async {
  //   _hasCheckedAccess = true;
  //   await Future.delayed(Duration(milliseconds: 200));
  //   if (!mounted) return;
  //
  //   final token = await getAccessToken();
  //   if (!mounted) return;
  //
  //   if (token.isEmpty) {
  //     await showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       barrierColor: blackColor.withAlpha(50),
  //       builder: (ctx) => const LoginPromptDialog(reDirectHome: true),
  //     );
  //   } else {
  //     setState(() {
  //       horoscopeData = HoroscopeService().getHoroscope();
  //     });
  //   }
  // }

  Future<void> handleDownload() async {
    try {
      CustomLoader.show(context, loaderColor: panchangHeading);

      final horoscopePdfFile = await HoroscopeService().downloadHoroscope();
      CustomLoader.hide();

      if (horoscopePdfFile != null) {
        final fileName = 'Horoscope';
        final filePath =
            await FileStorage.savePdfToDownloads(horoscopePdfFile, fileName);
        final savedFileName = p.basename(filePath);

        if (context.mounted) {
          Future.microtask(() {
            showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.white.withValues(alpha: 0.5),
              builder: (ctx) => DownloadSuccessDialog(
                title: 'Horoscope downloaded Successfully',
                file: savedFileName,
              ),
            );
          });
        }

        print('📁 Horoscope PDF path: $savedFileName');
      } else {
        if (context.mounted) {
          showErrorSnackBar(
              context, 'We couldn’t fetch your horoscope. Please try again.');
        }
      }
    } catch (e) {
      CustomLoader.hide();
      print("❌ Download error: $e");
      showErrorSnackBar(context, "Download failed. Please try again.");
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
                  top: util.responsiveHeight(0.14),
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
                      onTap: () {
                        handleDownload();
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          spacing: util.width10,
                          children: [
                            SvgPicture.asset(
                              download,
                              colorFilter: ColorFilter.mode(
                                  panchangHeading, BlendMode.srcIn),
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
                        final currentContext = context;
                        Get.back();
                        CustomLoader.show(currentContext,
                            loaderColor: panchangHeading);
                        try {
                          final horoscopePdfFile =
                              await HoroscopeService().downloadHoroscope();
                          CustomLoader.hide();
                          if (horoscopePdfFile != null) {
                            final directory = await getTemporaryDirectory();
                            final pdfPath = '${directory.path}/Horoscope.pdf';
                            final file = File(pdfPath);
                            await file.writeAsBytes(horoscopePdfFile);

                            final params = ShareParams(
                              text: 'Here is my Horoscope!',
                              files: [XFile(pdfPath)],
                            );

                            await SharePlus.instance.share(params);
                            if (currentContext.mounted) {
                              showLoginSuccessSnackBar(currentContext,
                                  'Your Horoscope has been shared successfully. Thank you.');
                            }
                          } else {
                            if (currentContext.mounted) {
                              showErrorSnackBar(currentContext,
                                  'We encountered an issue while fetching your Horoscope. Please retry.');
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
                        padding: EdgeInsets.all(5),
                        child: Row(
                          spacing: util.width10,
                          children: [
                            SvgPicture.asset(
                              share,
                              colorFilter: ColorFilter.mode(
                                  panchangHeading, BlendMode.srcIn),
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
    // print('Width: ${util.responsiveWidth(0.45)}');
    // print('Height: ${util.responsiveHeight(0.0606)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            final controller = Get.find<BottomNavController>();
            controller.changeIndex(0);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                panchangHeading,
                horoscopeLightBg,
              ],
              stops: [0.5, 0.5],
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: util.responsiveHeight(0.4226),
                          decoration: BoxDecoration(
                            color: panchangHeading,
                          ),
                        ),
                        Container(
                          height: util.height,
                          color: horoscopeLightBg,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: util.width20,
                              ),
                              Text(
                                PlatformTextConfig.horoscope.tr,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.bold),
                                    fontSize: util.fontSize20,
                                    height: 1.0,
                                    color: whiteColor),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              if (premiumUser)
                                CustomToolTip(
                                  message: PlatformTextConfig.infoText,
                                ),
                            ],
                          ),
                          // actions: [
                          //   IconButton(
                          //     icon: SvgPicture.asset(actionIcon),
                          //     onPressed: () => showDropdownModal(context),
                          //   ),
                          // ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          child: Column(
                            children: [
                              SizedBox(height: util.responsiveHeight(0.0226)),
                              FutureBuilder(
                                  future: horoscopeData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox(
                                        height: util.height / 2,
                                        width: util.width,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: MyUtility(context)
                                                .responsiveWidth(0.2668),
                                            height: MyUtility(context)
                                                .responsiveHeight(0.1232),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: whiteColor.withValues(
                                                    alpha: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        util.width20),
                                              ),
                                              child: Center(
                                                child: LoadingAnimationWidget
                                                    .halfTriangleDot(
                                                  color: panchangHeading,
                                                  size: MyUtility(context)
                                                      .height30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      // print('Snap-Error: ${snapshot.error}');
                                      return Center(
                                          child: Text(
                                              "Failed to load data. Please try again."));
                                    } else if (!snapshot.hasData) {
                                      return Center(child: Text(""));
                                    }
                                    DateTime parsedDob = DateTime.parse(
                                        snapshot.data!.dateOfBirth);
                                    String formatedDob =
                                        DateFormat("MMM dd, yyyy")
                                            .format(parsedDob);

                                    DateTime parsedTob = DateFormat("HH:mm:ss")
                                        .parse(snapshot.data!.timeOfBirth);
                                    String formatedTob =
                                        DateFormat("hh:mm:ss a")
                                            .format(parsedTob);

                                    return Column(
                                      children: [
                                        ///Basic User Data
                                        Container(
                                          width: util.width,
                                          padding: EdgeInsets.all(util.width20),
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius: BorderRadius.circular(
                                                util.width20),
                                            border: Border.all(
                                                color: mainColor.withValues(
                                                    alpha: 0.3),
                                                width: 3),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: util.width10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: util.width / 3,
                                                      child: Text(
                                                        'Name'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontSemiBold',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color:
                                                                panchangHeading),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                            snapshot.data!
                                                                .firstName,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'FontMedium',
                                                                fontSize: util
                                                                    .fontSize14,
                                                                height: 1.2,
                                                                color:
                                                                    blackColor)))
                                                  ],
                                                ),
                                              ),
                                              DashedLine(
                                                dashWidth: 3,
                                                color: blackColor.withValues(
                                                    alpha: 0.3),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: util.width10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: util.width / 3,
                                                      child: Text(
                                                        'Date of Birth'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontSemiBold',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color:
                                                                panchangHeading),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(formatedDob,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'FontMedium',
                                                              fontSize: util
                                                                  .fontSize14,
                                                              height: 1.2,
                                                              color:
                                                                  blackColor)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              DashedLine(
                                                dashWidth: 3,
                                                color: blackColor.withValues(
                                                    alpha: 0.3),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: util.width10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: util.width / 3,
                                                      child: Text(
                                                        'Time of Birth'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontSemiBold',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color:
                                                                panchangHeading),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(formatedTob,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'FontMedium',
                                                              fontSize: util
                                                                  .fontSize14,
                                                              height: 1.2,
                                                              color:
                                                                  blackColor)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              DashedLine(
                                                dashWidth: 3,
                                                color: blackColor.withValues(
                                                    alpha: 0.3),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: util.width10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: util.width / 3,
                                                      child: Text(
                                                        'Place'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontSemiBold',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color:
                                                                panchangHeading),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          snapshot
                                                              .data!.birthLocation,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'FontMedium',
                                                              fontSize: util
                                                                  .fontSize14,
                                                              height: 1.2,
                                                              color:
                                                                  blackColor)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              DashedLine(
                                                dashWidth: 3,
                                                color: blackColor.withValues(
                                                    alpha: 0.3),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: util.width10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: util.width / 3,
                                                      child: Text(
                                                        'Rasi'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontSemiBold',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color:
                                                                panchangHeading),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          snapshot.data!.rashi,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'FontMedium',
                                                              fontSize: util
                                                                  .fontSize14,
                                                              height: 1.2,
                                                              color:
                                                                  blackColor)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              DashedLine(
                                                dashWidth: 3,
                                                color: blackColor.withValues(
                                                    alpha: 0.3),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: util.width10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: util.width / 3,
                                                      child: Text(
                                                        'Nakshatram'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontSemiBold',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color:
                                                                panchangHeading),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          snapshot
                                                              .data!.nakshatra,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'FontMedium',
                                                              fontSize: util
                                                                  .fontSize14,
                                                              height: 1.2,
                                                              color:
                                                                  blackColor)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              DashedLine(
                                                dashWidth: 3,
                                                color: blackColor.withValues(
                                                    alpha: 0.3),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: util.width10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: util.width / 3,
                                                      child: Text(
                                                        'Lagna'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontSemiBold',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color:
                                                                panchangHeading),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          snapshot.data!.lagna,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'FontMedium',
                                                              fontSize: util
                                                                  .fontSize14,
                                                              height: 1.2,
                                                              color:
                                                                  blackColor)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: util.responsiveHeight(0.0353),
                                        ),

                                        ///Horoscope Chart
                                        GestureDetector(
                                          onHorizontalDragUpdate: (details) {
                                            setState(() {
                                              if (details.primaryDelta! > 0) {
                                                selectedIndex = 1;
                                              } else if (details.primaryDelta! <
                                                  0) {
                                                selectedIndex = 0;
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: mainColor.withValues(
                                                      alpha: 0.5),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      util.width30),
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Stack(
                                              children: [
                                                AnimatedAlign(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  alignment: selectedIndex == 0
                                                      ? Alignment.centerLeft
                                                      : Alignment.centerRight,
                                                  child: Container(
                                                    // width: util.responsiveWidth(0.45),
                                                    width: util.width / 2 -
                                                        util.width20,
                                                    height:
                                                        util.responsiveHeight(
                                                            0.0606),
                                                    decoration: BoxDecoration(
                                                      color: mainColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              util.width30),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children:
                                                      List.generate(2, (index) {
                                                    List<String> tabLabels = [
                                                      "South Indian Chart",
                                                      "North Indian Chart"
                                                    ];

                                                    return Expanded(
                                                      child: GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex =
                                                                index;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: util
                                                              .responsiveHeight(
                                                                  0.0606),
                                                          alignment:
                                                              Alignment.center,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          child: Text(
                                                            tabLabels[index].tr,
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'FontSemiBold',
                                                              fontSize: util
                                                                  .fontSize14,
                                                              height: 1.0,
                                                              color: selectedIndex ==
                                                                      index
                                                                  ? whiteColor
                                                                  : blackColor
                                                                      .withValues(
                                                                          alpha:
                                                                              0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        AnimatedSwitcher(
                                          duration: Duration(
                                              milliseconds:
                                                  400), // Smooth transition time
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          child: selectedIndex == 0
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                      height: util.height20,
                                                    ),
                                                    ChartWidget(
                                                        htmlChart: snapshot
                                                            .data!.rashiChart),
                                                    SizedBox(
                                                      height: util.height20,
                                                    ),
                                                    ChartWidget(
                                                        htmlChart: snapshot
                                                            .data!
                                                            .navamsaChart),
                                                  ],
                                                )
                                              : ComingSoonContainer(),
                                        ),
                                      ],
                                    );
                                  }),
                              SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: util.width,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFBAE8B5)
                            .withValues(alpha: 0), // Transparent at the top
                        Color(0xFFBAE8B5), // Solid color at the bottom
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
