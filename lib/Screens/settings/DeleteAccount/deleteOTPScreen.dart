import 'dart:async';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Services/SettingService/deleteAccountService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class DeleteOTPScreen extends StatefulWidget {
  final String deleteReason;
  final String email;

  const DeleteOTPScreen(
      {super.key, required this.deleteReason, required this.email});

  @override
  State<DeleteOTPScreen> createState() => _DeleteOTPScreenState();
}

class _DeleteOTPScreenState extends State<DeleteOTPScreen> {
  String? errorMessage;
  bool otpSent = false;
  int timerSeconds = 30;
  Timer? timer;
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> otpController =
      List.generate(6, (index) => TextEditingController());
  DeleteAccountService deleteService = DeleteAccountService();
  AuthService authService = AuthService();
  bool isVerifying = false;

  void startTimer() {
    setState(() {
      timerSeconds = 30;
      otpSent = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timerSeconds > 0) {
        setState(() {
          timerSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          otpSent = false;
        });
      }
    });
  }

  void verifyOtp() async {
    setState(() {
      isVerifying = true;
    });
    String otp = otpController.map((controller) => controller.text).join();
    if (otp.length == 6) {
      try {
        var result = await deleteService.deleteAccountVerifyOtp(
            otp, widget.deleteReason);
        showInfoSnackBar(context, result);
        Get.to(() => BottomNavigationScreen());
      } catch (e) {
        print('Error: $e');
        showErrorSnackBar(context,
            e.toString().replaceFirst('Exception: Error: Exception:', ''));
      }
    } else {
      showErrorSnackBar(context, "Please enter a valid OTP");
    }
    setState(() {
      isVerifying = false;
    });
    handleLogout(context);
  }

  void clearOtpFields() {
    for (var controller in otpController) {
      controller.clear();
    }
    for (var focusNode in focusNodes) {
      focusNode.unfocus();
    }
  }

  void handleLogout(BuildContext context) async {
    CustomLoader.show(context);
    await Future.delayed(Duration(seconds: 1));
    String? responseMessage = await authService.logout();
    CustomLoader.hide();
    showLogoutSnackBar(context, 'Thanks for using Teksage');
    Get.offAllNamed('/home');
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: SizedBox(
                width: util.responsiveWidth(0.08),
                height: util.responsiveHeight(0.037),
                child: IconButton(
                  icon: SvgPicture.asset(otpDown,
                      width: util.width30,
                      height: util.width30,
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.srcIn)),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              title: Text(
                'Verify Email'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.bold),
                    fontSize: util.fontSize20,
                    // height: 1.0,
                    color: blackColor),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: util.responsiveHeight(0.0248)),
              height: util.height,
              width: util.width,
              child: Column(
                children: [
                  SizedBox(
                    height: util.responsiveHeight(0.1218),
                  ),
                  SizedBox(height: util.responsiveHeight(0.2)),
                  Text(
                    'We have sent OTP to'.tr,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize18,
                        height: util.lineHeight28 / util.fontSize18,
                        color: blackColor.withValues(alpha: 0.6)),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.extraBold),
                        fontSize: util.fontSize18,
                        height: util.lineHeight28 / util.fontSize18,
                        color: blackColor.withValues(alpha: 0.6)),
                  ),
                  SizedBox(height: util.responsiveHeight(0.0533)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: util.responsiveWidth(0.134),
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: (event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey.backspace &&
                                otpController[index].text.isEmpty &&
                                index > 0) {
                              focusNodes[index - 1].requestFocus();
                            }
                          },
                          child: TextField(
                            focusNode: focusNodes[index],
                            controller: otpController[index],
                            keyboardType: TextInputType.number,
                            cursorColor: mainColor,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.bold),
                              fontSize: util.fontSize24,
                              height: util.lineHeight28_8 / util.fontSize24,
                              color: blackColor,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(util.width12),
                                borderSide: BorderSide(
                                    color: errorMessage != null
                                        ? errorColor
                                        : blackColor.withValues(alpha: 0.2)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(util.width12),
                                borderSide: BorderSide(
                                    color: errorMessage != null
                                        ? errorColor
                                        : mainColor,
                                    width: errorMessage != null ? 1 : 2),
                              ),
                              counterText: "",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: util.responsiveWidth(0.028)),
                            ),
                            onChanged: (value) {
                              setState(() {
                                errorMessage = null;
                              });
                              if (value.isNotEmpty && index < 5) {
                                focusNodes[index + 1].requestFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                focusNodes[index - 1].requestFocus();
                              }
                              if (index == 5 && value.isNotEmpty) {
                                verifyOtp();
                              }
                            },
                            textInputAction: index < 5
                                ? TextInputAction.next
                                : TextInputAction.done,
                          ),
                        ),
                      );
                    }),
                  ),
                  //ErrorMessage
                  if (errorMessage != null) ...[
                    SizedBox(
                      height: util.responsiveHeight(0.0092),
                    ),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: errorColor,
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize14,
                      ),
                    ),
                  ],
                  SizedBox(
                    height: errorMessage != null
                        ? util.responsiveHeight(0.0413)
                        : util.responsiveHeight(0.0413),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0.0, 0.5),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: otpSent
                        ? Text(
                            'resend_otp_in_seconds'.tr.replaceAll(
                                '{seconds}', timerSeconds.toString()),
                            textAlign: TextAlign.center,
                            key: ValueKey('timer'),
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize18,
                              height: util.lineHeight28 / util.fontSize18,
                              color: blackColor.withValues(alpha: 0.6),
                            ),
                          )
                        : GestureDetector(
                            key: ValueKey('resend'),
                            onTap: () async {
                              startTimer();
                              clearOtpFields();
                              CustomLoader.show(context);
                              try {
                                String message = await DeleteAccountService()
                                    .deleteAccountSendOtp();
                                CustomLoader.hide();
                                showInfoSnackBar(context, message);
                              } catch (e) {
                                CustomLoader.hide();
                                showErrorSnackBar(context, e.toString());
                              }
                            },
                            child: Text(
                              'Resend OTP'.tr,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize18,
                                height: util.lineHeight28 / util.fontSize18,
                                color: mainColor,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            if (isVerifying)
              Positioned.fill(
                child: Container(
                  color: blackColor.withValues(alpha: 0.2),
                  child: Center(
                    child: Container(
                      width: 100, height: 100,
                      // color: mainColor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              util.responsiveWidth(0.0535)),
                          color: mainColor),
                      child: LoadingAnimationWidget.halfTriangleDot(
                          color: whiteColor, size: util.height30),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
