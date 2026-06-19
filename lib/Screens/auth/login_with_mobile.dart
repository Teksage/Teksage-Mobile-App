import 'dart:io';

import 'package:astro_prompt/Components/Common/customCountryDropDown.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Screens/auth/login_with_email.dart';
import 'package:astro_prompt/Screens/auth/password.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class LoginPageMobile extends StatefulWidget {
  final List<Country> countries;
  const LoginPageMobile({super.key, required this.countries});

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  bool containerColor = false;
  String? userInfo;
  String? errorMessage;
  TextEditingController mobileController = TextEditingController();
  AuthService authService = AuthService();
  bool isLoading = false;
  bool isButtonEnabled = false;
  Map<String, String> selectedCountry = {
    'countryFlag': '',
    'dialCode': '',
  };
  int? mobileLengthLimit;
  final FocusNode mobileFocusNode = FocusNode();

  bool isValidMobile(String mobile) {
    if (mobileLengthLimit == null) return false;
    return RegExp('^[1-9]\\d{${mobileLengthLimit! - 1}}\$').hasMatch(mobile);
  }

  void validateMobile(String value) {
    setState(() {
      if (value.isEmpty || !isValidMobile(value)) {
        errorMessage = "Enter a valid mobile number";
        isButtonEnabled = false;
        containerColor = false;
      } else {
        FocusScope.of(context).unfocus();
        errorMessage = null;
        isButtonEnabled = true;
        containerColor = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    mobileFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    mobileFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mobileFocusNode.hasFocus &&
        (selectedCountry['dialCode']?.isEmpty ?? true)) {
      setState(() {
        errorMessage = "Please select your country code";
        isButtonEnabled = false;
        containerColor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.989)}');
    // print('Height: ${util.responsiveHeight(0.0452)}');
    // print('FontSize: ${util.responsiveFontSize(0.022)}');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            //Background
            Container(
              width: util.width,
              height: util.responsiveHeight(0.5444),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFC2EDC0), // rgba(16, 177, 0, 0.5)
                    Color.fromRGBO(
                        255, 255, 255, 0.5), // rgba(255, 255, 255, 0.5)
                  ],
                  stops: [-2.0206, 1.0],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: util.responsiveHeight(0.0248)),
                height: util.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: util.responsiveHeight(0.1218),
                    ),
                    //Logo
                    SvgPicture.asset(
                      Platform.isAndroid ? loginLogo : loginLogoIos,
                      width: util.responsiveWidth(0.319),
                      height: util.responsiveHeight(0.1194),
                    ),
                    SizedBox(height: util.responsiveHeight(0.0679)),
                    //Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(dashLine),
                        Text(
                          'Login or Sign up',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.bold),
                              fontSize: util.fontSize20,
                              height: util.responsiveHeight(0.0296) /
                                  util.responsiveFontSize(0.0315)),
                        ),
                        SvgPicture.asset(dashLine),
                      ],
                    ),
                    SizedBox(height: util.responsiveHeight(0.0458)),
                    //MobileNumber
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result =
                                await showDialog<Map<String, String>>(
                              context: context,
                              builder: (_) => CountryDropdownDialog(
                                  countries: widget.countries),
                            );
                            if (result != null) {
                              setState(() {
                                selectedCountry = result;
                                mobileLengthLimit = int.tryParse(
                                    result['mobileNumberLength'] ?? '');
                                errorMessage = null;
                              });
                            }
                          },
                          child: Container(
                            // padding: EdgeInsets.all(util.responsiveWidth(0.03)),
                            padding: selectedCountry['countryFlag']!.isEmpty
                                ? EdgeInsets.zero
                                : EdgeInsets.symmetric(
                                    horizontal: util.width10),
                            width: util.responsiveWidth(0.2055),
                            height: util.responsiveHeight(0.0567),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(util.width12),
                              border: Border.all(
                                  color: blackColor.withValues(alpha: 0.2)),
                            ),
                            child: selectedCountry['countryFlag']!.isEmpty
                                ? Center(
                                    child: Text(
                                      'Select Country',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize16,
                                          color:
                                              blackColor.withValues(alpha: 0.6),
                                          height: util
                                                  .responsiveHeight(0.0248) /
                                              util.responsiveFontSize(0.0304)),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.network(
                                        selectedCountry['countryFlag'] ?? '',
                                        width: 22.5,
                                        height: 15,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.flag),
                                      ),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            selectedCountry['dialCode'] ?? '',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily:
                                                  AppFont.get(FontType.bold),
                                              fontSize: util.fontSize18,
                                              height: util.responsiveHeight(
                                                      0.0248) /
                                                  util.responsiveFontSize(
                                                      0.0304),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: util.responsiveWidth(0.667),
                          height: util.responsiveHeight(0.0567),
                          child: GestureDetector(
                            onTap: () {
                              if (mobileLengthLimit == null) {
                                setState(() {
                                  errorMessage =
                                      "Please select your country code";
                                  isButtonEnabled = false;
                                  containerColor = false;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              absorbing: mobileLengthLimit == null,
                              child: TextField(
                                focusNode: mobileFocusNode,
                                controller: mobileController,
                                keyboardType: TextInputType.number,
                                onChanged: validateMobile,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.bold),
                                    fontSize: util.fontSize18,
                                    height:
                                        util.lineHeight21_6 / util.fontSize18),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                      mobileLengthLimit),
                                ],
                                enabled: mobileLengthLimit != null,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(util.width12),
                                    borderSide: BorderSide(
                                        color:
                                            blackColor.withValues(alpha: 0.2)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(util.width12),
                                    borderSide: BorderSide(
                                        color: errorMessage != null
                                            ? errorColor
                                            : mainColor,
                                        width: 2),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(util.width12),
                                    borderSide: BorderSide(
                                        color:
                                            blackColor.withValues(alpha: 0.2)),
                                  ),
                                  hintText: 'Enter Mobile Number',
                                  hintStyle: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize18,
                                      color: blackColor.withValues(alpha: 0.6),
                                      height: util.responsiveHeight(0.0248) /
                                          util.responsiveFontSize(0.0304)),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: util.responsiveWidth(0.032),
                                      horizontal:
                                          util.responsiveHeight(0.0248)),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
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
                          ? util.responsiveHeight(0.0272)
                          : util.responsiveHeight(0.037),
                    ),
                    GestureDetector(
                      onTap: (isValidMobile(mobileController.text) &&
                              errorMessage == null)
                          ? () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                isLoading = true;
                                // userInfo = formatPhoneNumber(mobileController.text);
                                userInfo = mobileController.text;
                              });
                              var response = await authService.login(
                                'mobile_number',
                                mobileController.text,
                                countryCode: selectedCountry['dialCode']!
                                    .replaceAll('+', ''),
                              );

                              if (response['message'] ==
                                  'OTP sent successfully') {
                                setState(() {
                                  isLoading = false;
                                });
                                showSuccessSnackBar(
                                    context, response['message']);
                                Get.to(() => OTPScreen(
                                      keyValue: 'mobile_number',
                                      userInfo: userInfo!,
                                      isMobileScreen: true,
                                      verifyScreen: false,
                                      isChange: false,
                                      countryCode: selectedCountry['dialCode'],
                                    ));
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                print('ErrorLogin: ${response}');
                                showErrorSnackBar(
                                    context,
                                    response['error'] ??
                                        'Something went wrong');
                              }
                            }
                          : null,
                      child: Container(
                        width: util.width,
                        height: util.responsiveHeight(0.0518),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                util.responsiveWidth(0.0535)),
                            color: containerColor
                                ? mainColor
                                : mainColor.withValues(alpha: 0.2)),
                        child: Center(
                            child: isLoading
                                ? LoadingAnimationWidget.halfTriangleDot(
                                    color: whiteColor, size: util.height30)
                                : Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: containerColor
                                            ? whiteColor
                                            : mainColor,
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize18,
                                        height: util.lineHeight21_6 /
                                            util.fontSize18),
                                  )),
                      ),
                    ),
                    //or
                    SizedBox(
                      height: util.responsiveHeight(0.048),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(longDashLine),
                        Text(
                          'or',
                          style: TextStyle(
                              fontFamily: AppFont.get(FontType.bold),
                              fontSize: util.fontSize20,
                              height: util.lineHeight24 / util.fontSize20,
                              color: blackColor),
                        ),
                        SvgPicture.asset(longDashLine),
                      ],
                    ),
                    SizedBox(height: util.responsiveHeight(0.0452)),
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   showEmail = !showEmail;
                        // });
                        Get.to(() => LoginPageEmail(),
                            transition: Transition.rightToLeftWithFade,
                            duration: Duration(milliseconds: 500));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: util.width12),
                        width: util.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(util.width12),
                          border: Border.all(
                              color: blackColor.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue with Email',
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize18,
                                  height: util.lineHeight21_6 / util.fontSize18,
                                  color: blackColor.withValues(alpha: 0.6)),
                            ),
                            SizedBox(
                              width: util.width12,
                            ),
                            SvgPicture.asset(mail),
                          ],
                        ),
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
