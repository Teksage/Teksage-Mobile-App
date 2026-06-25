import 'dart:async';
import 'dart:io';
import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/auth/change_email_mobile.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Services/NotificationService/firebaseService.dart';
import 'package:astro_prompt/Services/NotificationService/notificationService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/chatLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/chatPreference.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/LocallySavedData/timezone.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/languageSelectionDialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/otp_contact_helpers.dart';

class OTPScreen extends StatefulWidget {
  final String userInfo;
  final String keyValue;
  final bool isMobileScreen;
  final bool verifyScreen;
  final String? title;
  final bool isChange;
  final bool? newVerify;
  final String? countryCode;
  const OTPScreen({
    super.key,
    required this.userInfo,
    required this.keyValue,
    required this.isMobileScreen,
    required this.verifyScreen,
    this.title,
    required this.isChange,
    this.newVerify,
    this.countryCode,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String? errorMessage;
  bool otpSent = false;
  int timerSeconds = 60;
  Timer? timer;
  String newTitle = '';
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> otpController =
      List.generate(6, (index) => TextEditingController());
  AuthService authService = AuthService();
  ProfileService profileService = ProfileService();
  bool isVerifying = false;
  String userName = '';
  String lastName = '';
  String timeZone = '';
  String chatFormat = '';
  String chatAvatar = '';
  String chatLanguage = '';
  bool userType = true;

  void startTimer() {
    setState(() {
      timerSeconds = 5 * 60;
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

  String cleanPhoneNumber(String phoneNumber) {
    return phoneNumber
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp(r'^91'), '');
  }

  // Future<void> passCountryList(BuildContext context) async {
  //   CustomLoader.show(context);
  //   try {
  //     final countries = await CountryCodeService().fetchCountries();
  //     CustomLoader.hide();
  //     Get.to(() => LoginPageMobile(countries: countries));
  //   } catch (e) {
  //     CustomLoader.hide();
  //     showErrorSnackBar(context, 'Failed to fetch country list');
  //   }
  // }

  void verifyOtp() async {
    setState(() {
      isVerifying = true;
    });

    try {
      String otp = otpController.map((controller) => controller.text).join();
      if (otp.length != 6) {
        showErrorSnackBar(context, "Please enter a valid OTP");
        setState(() {
          isVerifying = false;
        });
        return;
      }

      final isPhoneVerification =
          widget.isMobileScreen || widget.title == 'Phone Number';
      final userInfo = isPhoneVerification
          ? cleanPhoneNumber(widget.userInfo)
          : widget.userInfo;

      if (widget.verifyScreen) {
        await _handleVerifyScreenOtp(otp, userInfo);
      } else {
        await _handleLoginOtp(otp, userInfo);
      }
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, 'An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  Future<void> _handleVerifyScreenOtp(String otp, String userInfo) async {
    try {
      final bool isChange = widget.isChange == true;
      final bool useProfileVerification = !isChange;
      print(
          'valuse::::${widget.keyValue}${userInfo}${otp}${useProfileVerification}');
      final result = await profileService.profileVerifyOtp(
          widget.keyValue, userInfo, otp, useProfileVerification,
          countryCode: widget.countryCode);
      final countries = await CountryCodeService().fetchCountries();
      final changeTitle = widget.title!.toLowerCase().contains('email')
          ? 'Verify Existing Email'
          : 'Verify Existing Phone Number';

      if (!mounted) return;
      print('result:::$result,$isChange,${widget.newVerify}');

      if (result == 'success') {
        if (isChange && widget.newVerify == true) {
          print('inside if');
          Get.to(() => ChangeEmailMobile(
                verifyScreen: widget.verifyScreen,
                title: changeTitle,
                countries: countries,
              ));
        } else if (widget.newVerify == true) {
          print('else if');
          // Phone Number verification from profile completion form: just go back
          // so the onResult callback marks the field verified and the user stays
          // on the same form. Email change still needs the ProfilePage redirect.
          if (widget.title != null &&
              widget.title!.toLowerCase().contains('phone')) {
            Get.back(result: true);
          } else {
            print('else');
            Get.to(() => ProfilePage(
                  title: 'Profile Details',
                  isProfileUpdated: true,
                  fromChangePage: true,
                ));
          }
        } else {
          Get.back(result: true);
        }

        showLoginSuccessSnackBar(context, 'OTP Verified');
        showLoginSuccessSnackBar(
            context, '${widget.title!} Verified Successfully');
      } else {
        setState(() {
          errorMessage = "Incorrect OTP";
        });
        showErrorSnackBar(context, result);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Verification failed";
      });
      print('Exception in OTP verification1: $e');
      showErrorSnackBar(context,
          'Network error. Please check your connection and try again.');
    }
  }

  Future<void> _handleLoginOtp(String otp, String userInfo) async {
    try {
      Map<String, dynamic> result;

      if (widget.keyValue == 'email') {
        result = await authService.loginOTP(
          widget.keyValue,
          userInfo,
          otp,
        );
        if (result['name'] != null) {
          saveUserName(result['name']);
        }
      } else {
        final cleanCountryCode = widget.countryCode?.replaceAll('+', '') ?? '';
        result = await authService.loginOTP(
          widget.keyValue,
          userInfo,
          otp,
          cleanCountryCode,
        );
      }

      if (!mounted) return;

      if (result["status"] != 'success') {
        if (result['error'] == '400: Invalid OTP') {
          setState(() {
            errorMessage = "Incorrect OTP";
          });
          showErrorSnackBar(context, "Oops! That OTP didn't work");
        } else if (result['detail'] == 'Invalid OTP') {
          setState(() {
            errorMessage = "Incorrect OTP";
          });
          showErrorSnackBar(context, "Oops! That OTP didn't work");
        } else {
          showErrorSnackBar(context, 'Login failed. Please try again.');
        }
        return;
      }

      final bool profileUpdated = result["profile_updated"] ?? false;
      userName = result["name"] ?? '';
      lastName = result["lastName"] ?? '';
      userType = result["user_type"] == 'customer';
      timeZone = result['timeZone'] ?? '';
      chatFormat = result['format'] ?? '';
      chatAvatar = result['avatar'] ?? '';
      chatLanguage = result['chat_languages'] ?? '';

      print('chatFormat: $chatFormat, $chatAvatar, $chatLanguage');

      if (result['userId'] != null) {
        await saveUserId(result['userId']);
      }
      await saveUserName(userName);
      await saveLastName(lastName);
      await saveUserType(userType);
      if (result['premiumUser'] != null) {
        await savePremiumUser(result['premiumUser']);
      }
      if (result['userPlanId'] != null) {
        await savePremiumUserId(result['userPlanId']);
      }
      await saveChatPreference(chatFormat, chatAvatar, chatLanguage);
      await saveChatLanguage(chatLanguage);

      // 🔁 Check/update FCM token for Android
      if (Platform.isAndroid) {
        final String? serverFcmToken = result['fcmToken'];
        final String? localFcmToken =
            await FirebaseMessaging.instance.getToken();

        if (localFcmToken != null && localFcmToken.isNotEmpty) {
          if (serverFcmToken == null || serverFcmToken != localFcmToken) {
            try {
              final saveResult = await NotificationFirebaseService()
                  .saveFcmToken(localFcmToken);
              debugPrint(
                  'FCM Token updated. Save status: ${saveResult['status']}');
            } catch (e) {
              debugPrint('Failed to save FCM token: $e');
            }
          } else {
            debugPrint('FCM Token unchanged.');
          }
        } else {
          debugPrint(
              'Local FCM token is null or empty. Trying to regenerate...');
          try {
            await NotificationService.generateFcmToken();
          } catch (e) {
            debugPrint('Failed to generate FCM token: $e');
          }
        }
      } else {
        debugPrint('Skipping FCM setup on iOS.');
      }

      if (!mounted) return;

      final userData = {
        "name": result["name"],
        "lastName": result["lastName"],
        "email": result["email"],
        "mobile": result["mobile"],
        "countryCode": result['countryCode'],
        "isEmailVerified": result["isEmailVerified"],
        "isMobileVerified": result["isMobileVerified"],
      };

      // Get app_language from login response
      String? appLanguageFromResponse = result['app_language'];
      // print('app_language from login response: $appLanguageFromResponse');

      // Check saved language
      String savedLang = await getAppLanguage();
      // print('savedLang from local storage: $savedLang');

      // If app_language is empty, show language dialog first (regardless of profile status)
      // if (appLanguageFromResponse == null ||
      //     appLanguageFromResponse.isEmpty ||
      //     savedLang.isEmpty) {
      //   // print('app_language is empty - showing language selection dialog');

      //   // Show language selection dialog and wait for user to select
      //   await showDialog(
      //     context: context,
      //     barrierDismissible: true,
      //     builder: (context) =>
      //         LanguageSelectionDialog(isInitialSelection: false),
      //   );

      //   // After language selection, reload saved language
      //   savedLang = await getAppLanguage();
      //   // print('anguage selected: $savedLang');
      // }

      // Set app locale based on selected/saved language
      if (savedLang.isNotEmpty) {
        Locale newLocale;
        switch (savedLang.toLowerCase()) {
          case 'tamil':
            newLocale = Locale('ta');
            break;
          case 'hindi':
            newLocale = Locale('hi');
            break;
          case 'telugu':
            newLocale = Locale('te', 'IN');
            break;
          case 'kannada':
            newLocale = Locale('kn', 'IN');
            break;
          case 'malayalam':
            newLocale = Locale('ml', 'IN');
            break;
          case 'marathi':
            newLocale = Locale('mr', 'IN');
            break;
          default:
            newLocale = Locale('en', 'US');
        }
        Get.updateLocale(newLocale);

        // Sync the selected/saved language to backend if it differs from API response
        if (savedLang.isNotEmpty &&
            savedLang.toLowerCase() !=
                (appLanguageFromResponse ?? '').toLowerCase()) {
          final nameToCode = {
            'english': 'en_US',
            'tamil': 'ta',
            'hindi': 'hi',
            'telugu': 'te_IN',
            'kannada': 'kn_IN',
            'malayalam': 'ml_IN',
            'marathi': 'mr_IN',
          };
          String langCode = nameToCode[savedLang.toLowerCase()] ?? 'en_US';
          await authService.updateAppLanguage(langCode);
          // print('Synced language to backend: $savedLang ($langCode)');
        }
      }

      // Navigate based on profile status
      if (profileUpdated) {
        print('✅ Profile is complete - navigating to home');
        print('ZoneTime: $timeZone');
        await saveTimezone(timeZone);

        if (Platform.isAndroid) {
          Get.offAll(
            () => BottomNavigationScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          Get.off(
            () => const AIChatScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 800),
          );
        }
      } else {
        print('⚠️ Profile incomplete - navigating to Complete Profile screen');
        if (userType) {
          Get.offAll(() => ProfilePage(
                title: 'Complete Profile',
                isProfileUpdated: profileUpdated,
                userInfo: widget.userInfo,
                keyValue: widget.keyValue,
                fromChangePage: false,
                countryCode: result['countryCode'],
              ));
        } else {
          Get.offAll(() => ProfilePage(
                title: 'Complete Profile',
                isProfileUpdated: profileUpdated,
                fromChangePage: false,
                userData: userData,
              ));
        }
      }

      showLoginSuccessSnackBar(context, 'OTP Verified');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Login failed";
      });
      print('Exception in OTP verification2: $e');
      showErrorSnackBar(context,
          'Network error. Please check your connection and try again.');
    }
  }

  void clearOtpFields() {
    for (var controller in otpController) {
      controller.clear();
    }
    for (var focusNode in focusNodes) {
      focusNode.unfocus();
    }
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
    print('title:${widget.title}');
    final util = MyUtility(context);
    if (widget.isChange) {
      newTitle = widget.title!.toLowerCase();
    }
    // print('Width: ${util.responsiveWidth(0.0495)}');
    // print('Height: ${util.responsiveHeight(0.2)}');
    // print('FontSize: ${util.responsiveFontSize(0.0406)}');

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
              toolbarHeight: util.responsiveHeight(0.12),
              leading: SizedBox(
                width: util.responsiveWidth(0.08),
                height: util.responsiveHeight(0.037),
                child: IconButton(
                  icon: SvgPicture.asset(
                      widget.verifyScreen ? otpDown : appBackButton,
                      width: widget.verifyScreen ? util.width30 : util.width20,
                      height: widget.verifyScreen ? util.width30 : util.width20,
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.srcIn)),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              title: widget.verifyScreen
                  ? Text(
                      '${widget.title}'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize20,
                          // height: 1.7,
                          color: blackColor),
                      maxLines: 3,
                    )
                  : null,
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
                  //Logo
                  widget.verifyScreen
                      ? SizedBox.shrink()
                      : (Platform.isAndroid
                          ? SvgPicture.asset(
                              loginLogoIos,
                              width: util.responsiveWidth(0.319),
                              height: util.responsiveHeight(0.1194),
                            )
                          : Image.asset(
                              newIosLogoPNG,
                              width: util.responsiveWidth(0.319),
                              height: util.responsiveHeight(0.1194),
                            )),
                  SizedBox(
                      height: widget.verifyScreen
                          ? util.responsiveHeight(0.15)
                          : util.responsiveHeight(0.0679)),
                  widget.verifyScreen
                      ? (widget.isChange
                          ? Text(
                              newTitle.contains('email')
                                  ? 'For security reasons, kindly verify your existing email'
                                      .tr
                                  : 'For security reasons, kindly verify your existing phone number'
                                      .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize18,
                                  height: util.lineHeight28 / util.fontSize18,
                                  color: blackColor.withValues(alpha: 0.6)),
                            )
                          : Text(
                              'We have sent OTP to'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize18,
                                  height: util.lineHeight28 / util.fontSize18,
                                  color: blackColor.withValues(alpha: 0.6)),
                            ))
                      : Text(
                          'We have sent OTP to',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize18,
                              height: util.lineHeight28 / util.fontSize18,
                              color: blackColor.withValues(alpha: 0.6)),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.countryCode != null &&
                          widget.countryCode!.isNotEmpty)
                        Text(
                          '${widget.countryCode!} ',
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.extraBold),
                            fontSize: util.fontSize18,
                            height: util.lineHeight28 / util.fontSize18,
                            color: blackColor
                                .withAlpha(153), // Equivalent to alpha: 0.6
                          ),
                        ),
                      Flexible(
                        child: Text(
                          maskOtpContactForDisplay(
                            contact: widget.userInfo,
                            isMobile: widget.keyValue != 'email',
                          ),
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.extraBold),
                            fontSize: util.fontSize18,
                            height: util.lineHeight28 / util.fontSize18,
                            color: blackColor.withAlpha(153),
                          ),
                        ),
                      )
                    ],
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
                            cursorColor:
                                Platform.isAndroid ? mainColor : iosMainColor,
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
                                        : (Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor),
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
                      errorMessage!.tr,
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
                            widget.verifyScreen
                                ? 'OTP is valid for 5 Minutes.'.tr
                                : 'OTP is valid for 5 Minutes.',
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
                              try {
                                startTimer();
                                clearOtpFields();
                                setState(() {
                                  errorMessage = '';
                                });
                                var response = await authService.login(
                                    widget.keyValue, widget.userInfo);

                                if (!mounted) return;

                                if (response['message'] ==
                                    'OTP sent successfully') {
                                  showInfoSnackBar(
                                      context, response['message']);
                                } else {
                                  showErrorSnackBar(
                                      context,
                                      response['message'] ??
                                          'Failed to resend OTP');
                                }
                              } catch (e) {
                                if (!mounted) return;
                                setState(() {
                                  otpSent = false;
                                });
                                print('Exception in OTP verification3: $e');
                                showErrorSnackBar(context,
                                    'Network error. Please check your connection and try again.');
                              }
                            },
                            child: Text(
                              widget.verifyScreen
                                  ? 'Resend OTP'.tr
                                  : 'Resend OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize18,
                                height: util.lineHeight28 / util.fontSize18,
                                color: Platform.isAndroid
                                    ? mainColor
                                    : iosMainColor,
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
                          color: Platform.isAndroid ? mainColor : iosMainColor),
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
