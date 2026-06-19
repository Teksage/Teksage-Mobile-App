import 'dart:io';
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


class LoginPageEmail extends StatefulWidget {
  const LoginPageEmail({super.key});

  @override
  State<LoginPageEmail> createState() => _LoginPageEmailState();
}

class _LoginPageEmailState extends State<LoginPageEmail> {
  bool containerColor = false;
  bool showEmail = false;
  String? errorMessage;
  TextEditingController emailController = TextEditingController();
  AuthService authService = AuthService();
  bool isLoading = false;
  bool isButtonEnabled = false;

  // Common color based on platform
  Color get platformColor => Platform.isAndroid ? mainColor : iosMainColor;

  bool isValidEmail(String email) {
    final v = email.trim();
    final result = RegExp(
      r"^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9.-]+\.[a-z]{2,}$",
      caseSensitive: false,
    ).hasMatch(v);
    return result;
  }

  void validateEmail(String value) {
    final v = value.trim().toLowerCase();
    final valid = isValidEmail(v);

    setState(() {
      if (v.isEmpty || !valid) {
        errorMessage = "Enter a valid email address";
        isButtonEnabled = false;
      } else {
        errorMessage = null;
        isButtonEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final email = emailController.text.trim();
    final canTap = isButtonEnabled && !isLoading;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            //Background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Platform.isAndroid
                  ? Container(
                      width: util.width,
                      height: util.responsiveHeight(0.5444),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFC2EDC0),
                            Color.fromRGBO(255, 255, 255, 0.5),
                          ],
                          stops: [-2.0206, 1.0],
                        ),
                      ))
                  : SizedBox(
                      width: util.width,
                      height: util.responsiveHeight(0.5444),
                      child: Image.asset(
                        iosBg,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: SizedBox(
                width: util.responsiveWidth(0.08),
                height: util.responsiveHeight(0.037),
                child: Platform.isAndroid
                    ? IconButton(
                        icon: SvgPicture.asset(appBackButton,
                            width: util.width20,
                            height: util.height20,
                            colorFilter: ColorFilter.mode(
                                Colors.black, BlendMode.srcIn)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : SizedBox.shrink(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: util.responsiveHeight(0.0248)),
              height: util.height,
              child: Column(
                children: [
                  SizedBox(
                    height: util.responsiveHeight(0.1218),
                  ),
                  //Logo
                  Platform.isAndroid
                      ? SvgPicture.asset(
                          loginLogoIos,
                          width: util.responsiveWidth(0.319),
                          height: util.responsiveHeight(0.1194),
                        )
                      : Image.asset(
                          newIosLogoPNG,
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
                  // Email
                  SizedBox(
                    width: util.responsiveWidth(0.989),
                    height: util.responsiveHeight(0.0567),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: validateEmail,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      enableSuggestions: false,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize18,
                          height: util.lineHeight21_6 / util.fontSize18),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(50),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return TextEditingValue(
                            text: newValue.text.toLowerCase(),
                            selection: newValue.selection,
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(util.width12),
                          borderSide: BorderSide(
                              color: blackColor.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(util.width12),
                          borderSide: BorderSide(
                              color: errorMessage != null
                                  ? errorColor
                                  : platformColor,
                              width: 2),
                        ),
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize18,
                            color: blackColor.withValues(alpha: 0.6),
                            height: util.responsiveHeight(0.0248) /
                                util.responsiveFontSize(0.0304)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: util.responsiveWidth(0.032),
                            horizontal: util.responsiveHeight(0.0248)),
                      ),
                    ),
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
                    onTap: canTap
                        ? () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              var response = await authService.login(
                                  'email', email.toLowerCase());
                              if (!mounted) return;
                              setState(() {
                                isLoading = false;
                              });
                              if (response['message'] ==
                                  'OTP sent successfully') {
                                showLoginSuccessSnackBar(
                                    context, response['message']);
                                Get.to(() => OTPScreen(
                                      keyValue: 'email',
                                      userInfo: emailController.text,
                                      isMobileScreen: false,
                                      verifyScreen: false,
                                      isChange: false,
                                    ));
                              } else {
                                showErrorSnackBar(
                                    context,
                                    response['error'] ??
                                        'Error: Contact Teksage.');
                              }
                            } catch (e) {
                              if (!mounted) return;
                              setState(() {
                                isLoading = false;
                              });
                              showErrorSnackBar(context,
                                  'Network error. Please check your connection and try again.');
                            }
                          }
                        : () {},
                    child: Opacity(
                      opacity: canTap ? 1 : 0.5,
                      child: IgnorePointer(
                        ignoring: !canTap,
                        child: Container(
                          width: util.width,
                          height: util.responsiveHeight(0.0518),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                util.responsiveWidth(0.0535)),
                            color: canTap
                                ? platformColor
                                : platformColor.withValues(alpha: 0.2),
                          ),
                          child: Center(
                              child: isLoading
                                  ? LoadingAnimationWidget.halfTriangleDot(
                                      color: platformColor, size: util.height30)
                                  : Text(
                                      'Continue',
                                      style: TextStyle(
                                          color: (isValidEmail(
                                                      emailController.text) &&
                                                  errorMessage == null)
                                              ? whiteColor
                                              : platformColor,
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize18,
                                          height: util.lineHeight21_6 /
                                              util.fontSize18),
                                    )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
