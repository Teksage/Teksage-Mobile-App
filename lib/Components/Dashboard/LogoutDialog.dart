import 'dart:io';
import 'dart:ui';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LogoutPromptDialog extends StatefulWidget {
  const LogoutPromptDialog({super.key});

  @override
  State<LogoutPromptDialog> createState() => _LogoutPromptDialogState();
}

class _LogoutPromptDialogState extends State<LogoutPromptDialog> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                  image: Platform.isIOS
                      ? DecorationImage(
                    image: AssetImage(iosSettingBg),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                padding: EdgeInsets.all(util.width10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(closeButton),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: errorColor.withValues(alpha: 0.7), shape: BoxShape.circle, border: Border.all(color: errorColor, width: 2)),
                      child: Center(
                        child: SvgPicture.asset(logout, width: 30, height: 30, colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn)),
                      ),
                    ),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    Text(
                      "Are you sure you want to logout?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: util.fontSize16, fontFamily: 'FontSemiBold', height: 1.0),
                    ),
                    SizedBox(height: util.responsiveWidth(0.048)),
                    GestureDetector(
                      onTap: () async {
                        CustomLoader.show(context);
                        await Future.delayed(Duration(seconds: 1));
                        String? responseMessage = await authService.logout();
                        CustomLoader.hide();
                        if (responseMessage != null) {
                          showLogoutSnackBar(context, responseMessage);
                          if (Platform.isAndroid) {
                            Get.offAllNamed('/home');
                          } else {
                            Get.offAllNamed('/login');
                          }
                        } else {
                          showLogoutSnackBar(context, 'Logout failed. Please try again.');
                        }
                      },
                      child: Container(
                        width: util.width / 2,
                        padding: EdgeInsets.symmetric(horizontal: util.responsiveWidth(0.0375), vertical: util.responsiveWidth(0.0188)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(util.width30), color: errorColor.withValues(alpha: 0.7)),
                        child: Text(
                          'Logout',
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
