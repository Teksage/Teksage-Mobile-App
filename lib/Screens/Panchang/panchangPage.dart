import 'dart:io';
import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Model/panchang_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Services/PanchangService/panchangService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/customToolTip.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/currency.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class PanchangPage extends StatefulWidget {
  const PanchangPage({super.key});

  @override
  State<PanchangPage> createState() => _PanchangPageState();
}

class _PanchangPageState extends State<PanchangPage> {
  Future<PanchangModel>? panchangData;
  bool premiumUser = false;
  bool _isCheckingAccess = false;
  String? currency;
  bool _dialogShown = false;

  // @override
  // void initState() {
  //   super.initState();
  //   panchangData = PanchangService().getPanchang();
  //   // Future.microtask(() => checkAccessFlow());
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAccessFlow();
    });
  }

  Future<void> checkAccessFlow() async {
    if (!mounted || _isCheckingAccess || _dialogShown) return;
    _isCheckingAccess = true;

    try {
      final token = await getAccessToken();
      if (!mounted) return;

      if (token.isEmpty) {
        await _showDialog(const LoginPromptDialog(reDirectHome: true));
        return;
      }

      final isPremium = await getUserPremium();
      if (!mounted) return;
      print('isPremium,$isPremium');

      if (isPremium) {
        setState(() {
          premiumUser = true;
          panchangData = PanchangService().getPanchang();
        });
        return;
      }

      currency = await _getCurrency();
      if (!mounted) return;

      if (currency != null && currency!.isNotEmpty) {
        await _showDialog(
            SubscribePromptDialog(currency: currency!, reDirectHome: true));
      } else {
        // ❗ Redirecting user to Home Screen tab instead of using Get.offAll
        if (Get.isDialogOpen ?? false) Get.back(); // Close any open dialog
        Get.find<BottomNavController>().changeIndex(0);
      }
    } catch (e) {
      print('Error during access check: $e');
    } finally {
      _isCheckingAccess = false;
    }
  }

  Future<String?> _getCurrency() async {
    CustomLoader.show(context);

    try {
      final permissionGranted =
          await CurrencyService().requestPermission(context);
      if (!permissionGranted) return null;

      final currency = await CurrencyService().getCurrency(context);
      return currency;
    } catch (e) {
      print('Error fetching currency: $e');
      return null;
    } finally {
      CustomLoader.hide();
    }
  }

  Future<void> _showDialog(Widget dialog) async {
    if (_dialogShown || !mounted) return;
    _dialogShown = true;

    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(50),
      builder: (_) => dialog,
    );
    _dialogShown = false;
  }

  String convertTo12HourFormat(String time) {
    List<String> parts = time.split(":");
    int hours = int.parse(parts[0]) % 24;
    int minutes = int.parse(parts[1]);
    DateTime dateTime = DateTime(2024, 1, 1, hours, minutes);
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.989)}');
    // print('Height: ${util.responsiveHeight(0.0124)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    void showDropdownModal(BuildContext context, PanchangModel data) {
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
                child: GestureDetector(
                  onTap: () async {
                    final currentContext = context;
                    Get.back();
                    CustomLoader.show(currentContext,
                        loaderColor: Color(0xff0b121a));
                    try {
                      final predictionId = data.panchangId;
                      final panchangPdfFile = await PanchangService()
                          .sharePanchangPrediction(predictionId);

                      CustomLoader.hide();
                      if (panchangPdfFile != null) {
                        final directory = await getTemporaryDirectory();
                        final pdfPath = '${directory.path}/panchang.pdf';
                        final file = File(pdfPath);
                        await file.writeAsBytes(panchangPdfFile);

                        final params = ShareParams(
                          text: 'Here is the Panchang!',
                          files: [XFile(pdfPath)],
                        );

                        await SharePlus.instance.share(params);
                        if (currentContext.mounted) {
                          showLoginSuccessSnackBar(currentContext,
                              'Your Panchang has been shared successfully. Thank you.');
                        }
                      } else {
                        if (currentContext.mounted) {
                          CustomLoader.hide();
                          showErrorSnackBar(currentContext,
                              'We encountered an issue while fetching your Panchang. Please retry.');
                        }
                      }
                    } catch (e) {
                      print("❌ Sharing error: $e");
                      if (context.mounted) {
                        CustomLoader.hide();
                        showErrorSnackBar(context,
                            'An unexpected error occurred while sharing. Please try again.');
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: util.width20, vertical: util.height20),
                    child: Row(
                      spacing: util.width10,
                      children: [
                        SvgPicture.asset(
                          share,
                          colorFilter: ColorFilter.mode(
                              Color(0xff0b121a), BlendMode.srcIn),
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
            final controller = Get.find<BottomNavController>();
            controller.changeIndex(0);
          });
        }
      },
      child: Scaffold(
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xff0b121a), Color(0xff7ca2b9)])),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    panchangBG,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: util.height,
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: util.width,
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: panchangData,
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
                                        color:
                                            whiteColor.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: LoadingAnimationWidget
                                            .halfTriangleDot(
                                          color: Color(0xff0b121a),
                                          size: MyUtility(context).height30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      "Failed to load data. Please try again."));
                            } else if (!snapshot.hasData) {
                              return Center(
                                  child: Text("No Panchang available."));
                            }

                            String shortWeekday = snapshot
                                .data!.panchang.eng_weekday
                                .substring(0, 3);
                            String nakshatram = 'panchang_single_format'
                                .tr
                                .replaceAll('(name)',
                                    snapshot.data!.panchang.nakshathra.name)
                                .replaceAll(
                                    '(time)',
                                    convertTo12HourFormat(snapshot
                                        .data!.panchang.nakshathra.endTime))
                                .replaceAll('(next)',
                                    snapshot.data!.panchang.nakshathra.next);

                            String thithi = 'panchang_single_format'
                                .tr
                                .replaceAll('(name)',
                                    snapshot.data!.panchang.thithi.name)
                                .replaceAll(
                                    '(time)',
                                    convertTo12HourFormat(
                                        snapshot.data!.panchang.thithi.endTime))
                                .replaceAll('(next)',
                                    snapshot.data!.panchang.thithi.next);
                            String yoga = 'panchang_single_format'
                                .tr
                                .replaceAll(
                                    '(name)', snapshot.data!.panchang.yoga.name)
                                .replaceAll(
                                    '(time)',
                                    convertTo12HourFormat(
                                        snapshot.data!.panchang.yoga.endTime))
                                .replaceAll('(next)',
                                    snapshot.data!.panchang.yoga.next);
                            String karna =
                                '${'panchang_single_format'.tr.replaceAll('(name)', snapshot.data!.panchang.karna.first.name).replaceAll('(time)', convertTo12HourFormat(snapshot.data!.panchang.karna.first.endTime)).replaceAll('(next)', '')}'
                                ' '
                                '${'panchang_single_format'.tr.replaceAll('(name)', snapshot.data!.panchang.karna.second.name).replaceAll('(time)', convertTo12HourFormat(snapshot.data!.panchang.karna.second.endTime)).replaceAll('(next)', '')}';
                            var auspiciousTime =
                                snapshot.data!.panchang.auspiciousTime;

                            String amirthathiYoga = 'panchang_single_format'
                                .tr
                                .replaceAll('(name)',
                                    snapshot.data!.panchang.amirthathiYoga.name)
                                .replaceAll(
                                    '(time)',
                                    convertTo12HourFormat(snapshot
                                        .data!.panchang.amirthathiYoga.endTime))
                                .replaceAll(
                                    '(next)',
                                    snapshot
                                        .data!.panchang.amirthathiYoga.next);

                            int tharaBala =
                                snapshot.data!.panchang.tharaBala == 0
                                    ? 9
                                    : snapshot.data!.panchang.tharaBala;

                            return Column(
                              children: [
                                SizedBox(
                                  height: util.responsiveHeight(0.074),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: util.width20,
                                          ),
                                          Text(
                                            PlatformTextConfig
                                                .panchangPageTitle.tr,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFont.get(FontType.bold),
                                                fontSize: util.fontSize20,
                                                height: 1.0,
                                                color: whiteColor),
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          CustomToolTip(
                                            message:
                                                PlatformTextConfig.infoText,
                                            // offsetX: util.responsiveWidth(0.21),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // IconButton(
                                    //   icon: SvgPicture.asset(actionIcon),
                                    //   onPressed: () => showDropdownModal(context, snapshot.data!),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: util.responsiveHeight(0.02)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: util.width20),
                                  child: Column(
                                    children: [
                                      ///TimeContainer
                                      Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: util.width30),
                                              child: SvgPicture.asset(
                                                panchangTimeContainer,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 40),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: util.width20,
                                                vertical: util.width10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  shortWeekday,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: AppFont.get(
                                                          FontType.semiBold),
                                                      fontSize: util.fontSize14,
                                                      height: 1.0,
                                                      color: whiteColor),
                                                ),
                                                Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontFamily: AppFont.get(
                                                          FontType.semiBold),
                                                      fontSize: util.fontSize14,
                                                      height: 1.0,
                                                      color: whiteColor),
                                                ),
                                                Text(
                                                  snapshot.data!.panchang.date,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: AppFont.get(
                                                          FontType.semiBold),
                                                      fontSize: util.fontSize14,
                                                      height: 1.0,
                                                      color: whiteColor),
                                                ),
                                                Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontFamily: AppFont.get(
                                                          FontType.semiBold),
                                                      fontSize: util.fontSize14,
                                                      height: 1.0,
                                                      color: whiteColor),
                                                ),
                                                Text(
                                                  snapshot.data!.panchang.time,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: AppFont.get(
                                                          FontType.semiBold),
                                                      fontSize: util.fontSize14,
                                                      height: 1.0,
                                                      color: whiteColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      ///Details
                                      Container(
                                        width: util.width,
                                        padding: EdgeInsets.all(20),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'WeekDay'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
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
                                                              .panchang.weekday,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Nakshatram'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(nakshatram,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Thithi'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(thithi,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Karna'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(karna,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Yoga'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(yoga,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: util.height10,
                                      ),

                                      ///Thara Bala & chandra Bala
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: whiteColor,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Thara Bala'.tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'FontMedium',
                                                        fontSize:
                                                            util.fontSize14,
                                                        height: 1.0,
                                                        color: blackColor
                                                            .withValues(
                                                                alpha: 0.6)),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    tharaBala.toString(),
                                                    style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.semiBold),
                                                        fontSize:
                                                            util.fontSize16,
                                                        height: 1.0,
                                                        color: mainColor),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Image.asset(
                                                    snapshot.data!.panchang
                                                            .tharaBalaIsPositive
                                                        ? panchangUp
                                                        : panchangDown,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: whiteColor,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Chandra Bala'.tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'FontMedium',
                                                        fontSize:
                                                            util.fontSize14,
                                                        height: 1.0,
                                                        color: blackColor
                                                            .withValues(
                                                                alpha: 0.6)),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    snapshot.data!.panchang
                                                        .chandraBala
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.semiBold),
                                                        fontSize:
                                                            util.fontSize16,
                                                        height: 1.0,
                                                        color: mainColor),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Image.asset(
                                                    snapshot.data!.panchang
                                                            .chandraBalaIsPositive
                                                        ? panchangUp
                                                        : panchangDown,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: util.height10,
                                      ),

                                      ///Sunrise & Sunrise
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: whiteColor,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(sunrise),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        'Sunrise'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color: blackColor
                                                                .withValues(
                                                                    alpha:
                                                                        0.6)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  SvgPicture.asset(dashLine),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data!.panchang.sunrise,
                                                    style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.semiBold),
                                                        fontSize:
                                                            util.fontSize22,
                                                        height: 1.0,
                                                        color: mainColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: whiteColor,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(sunset),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        'Sunset'.tr,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.0,
                                                            color: blackColor
                                                                .withValues(
                                                                    alpha:
                                                                        0.6)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  SvgPicture.asset(dashLine),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data!.panchang.sunset,
                                                    style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.semiBold),
                                                        fontSize:
                                                            util.fontSize22,
                                                        height: 1.0,
                                                        color: mainColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: util.height10,
                                      ),

                                      ///Misc Data
                                      Container(
                                        width: util.width,
                                        padding: EdgeInsets.all(20),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Rahu Kalam'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
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
                                                              .data!
                                                              .panchang
                                                              .rahuKala,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Yama Kanda'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        snapshot.data!.panchang
                                                            .yamaKanda,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Auspicious Time'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        auspiciousTime
                                                            .join('\n'),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Paksha'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        snapshot.data!.panchang
                                                            .paksha,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: util.width / 3,
                                                    child: Text(
                                                      'Amirthathi Yoga'.tr,
                                                      style: TextStyle(
                                                          fontFamily: AppFont
                                                              .get(FontType
                                                                  .semiBold),
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color:
                                                              panchangHeading),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(amirthathiYoga,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'FontMedium',
                                                            fontSize:
                                                                util.fontSize14,
                                                            height: 1.2,
                                                            color: blackColor)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
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
                    Color(0xff2C4252)
                        .withValues(alpha: 0), // Transparent at the top
                    Color(0xff2C4252), // Solid color at the bottom
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
