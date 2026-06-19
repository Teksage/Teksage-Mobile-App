import 'dart:ui';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Screens/auth/login_with_email.dart';
import 'package:astro_prompt/Screens/auth/login_with_mobile.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPromptDialog extends StatefulWidget {
  final bool reDirectHome;
  const LoginPromptDialog({super.key, required this.reDirectHome});

  @override
  State<LoginPromptDialog> createState() => _LoginPromptDialogState();
}

class _LoginPromptDialogState extends State<LoginPromptDialog> {
  bool _isLoading = false;

  Future<void> _navigateToLogin(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final countries = await CountryCodeService().fetchCountries();
      setState(() => _isLoading = false);
      Get.to(() => LoginPageMobile(countries: countries));
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorSnackBar(context, 'Failed to fetch country list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.0375)}');
    // print('Height: ${util.responsiveHeight(0.339)}');
    // print('FontSize: ${util.responsiveFontSize(0.022)}');

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: util.responsiveWidth(0.8),
            child: Dialog(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(util.width12),
                  color: whiteColor,
                ),
                padding: EdgeInsets.all(util.width10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.reDirectHome) {
                          Get.find<BottomNavController>().changeIndex(0); // Navigate to Home Page
                          Get.back();
                        } else {
                          Get.back();
                        }
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(closeButton),
                      ),
                    ),
                    SvgPicture.asset(dashLogin),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    Text(
                      "Kindly login to use this feature",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: util.fontSize16, fontFamily: 'FontSemiBold', height: 1.0),
                    ),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => LoginPageEmail(), transition: Transition.rightToLeftWithFade, duration: Duration(milliseconds: 500));
                      },
                      // onTap: _isLoading ? null : () => _navigateToLogin(context),
                      child: Container(
                        width: util.width / 3,
                        padding: EdgeInsets.symmetric(horizontal: util.responsiveWidth(0.0375), vertical: util.responsiveWidth(0.0188)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(util.width30), color: mainColor),
                        child: _isLoading
                            ? LoadingAnimationWidget.halfTriangleDot(
                                color: whiteColor,
                                size: util.fontSize16,
                              )
                            : Text(
                                'Login Now',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize16, height: 1.0, color: whiteColor),
                              ),
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.02)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
