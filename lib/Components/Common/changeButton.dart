import 'dart:io';

import 'package:astro_prompt/Screens/auth/password.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class ChangeButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isExist;
  final TextEditingController userData;
  final String title;
  final bool enableEdit;
  final ValueChanged<bool?>? onResult;
  final Map<String, String>? selectedCountry;
  final int? mobileLengthLimit;
  final bool showVerifyButton;

  const ChangeButton({
    super.key,
    required this.onTap,
    required this.isExist,
    required this.userData,
    required this.title,
    this.onResult,
    required this.enableEdit,
    this.selectedCountry,
    this.mobileLengthLimit,
    this.showVerifyButton = false,
  });

  @override
  State<ChangeButton> createState() => _ChangeButtonState();
}

class _ChangeButtonState extends State<ChangeButton> {
  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    String? keyValue;
    ProfileService profileService = ProfileService();
    String buttonText;

    if (widget.showVerifyButton) {
      buttonText = "Change";
    } else {
      if (!widget.enableEdit) {
        buttonText = "Verify";
      } else {
        if (widget.title == "Phone Number") {
          buttonText = "Verify";
        } else if (widget.title == "Email") {
          buttonText = "Change";
        } else {
          buttonText = "Verify";
        }
      }
    }

    bool isValidEmail(String email) {
      return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);
    }

    return Row(
      children: [
        Container(
          height: 21,
          width: 1,
          color: blackColor.withValues(alpha: 0.2),
        ),
        GestureDetector(
          onTap: () async {
            final dialCode = widget.selectedCountry?['dialCode'] ?? '';
            String rawText = widget.userData.text.trim();
            // Strip dial code prefix if it was prepended into the text field
            if (widget.title == 'Phone Number' && dialCode.isNotEmpty) {
              final prefix = dialCode.replaceAll('+', '');
              if (rawText.startsWith('+$prefix')) {
                rawText = rawText.substring('+$prefix'.length).trim();
              } else if (rawText.startsWith(prefix)) {
                rawText = rawText.substring(prefix.length).trim();
              }
            }

            if (widget.isExist == false) {
              if (rawText.isEmpty) {
                return;
              }

              if (widget.title == 'Email') {
                bool isInvalid = !isValidEmail(rawText);
                if (isInvalid) return;
              }

              if (widget.title == 'Phone Number') {
                if (dialCode.isEmpty ||
                    rawText.length != widget.mobileLengthLimit) {
                  showErrorSnackBar(
                      context, 'Select valid country code and number');
                  return;
                }
              }

              setState(() {
                keyValue = widget.title == 'Email' ? 'email' : 'mobile_number';
              });

              try {
                CustomLoader.show(context);
                var response =
                    await profileService.profileVerify(keyValue!, rawText);
                CustomLoader.hide();
                if (response['message'] == 'OTP sent successfully') {
                  showLoginSuccessSnackBar(
                    context,
                    'otp_response'.tr.replaceAll('(title)', widget.title),
                  );
                  var result = await Get.to(() => OTPScreen(
                        title: widget.title.contains('Email')
                            ? 'Verify Email'
                            : 'Verify Phone Number',
                        userInfo: rawText,
                        keyValue: keyValue!,
                        isMobileScreen: false,
                        verifyScreen: true,
                        isChange: false,
                        newVerify: true,
                        countryCode: widget.title == 'Phone Number'
                            ? dialCode.replaceAll('+', '')
                            : null,
                      ));
                  widget.onResult?.call(result);
                } else {
                  showErrorSnackBar(
                      context, response['message'] ?? 'Error in sending OTP');
                }
              } catch (e) {
                CustomLoader.hide();
                showErrorSnackBar(context, 'Please contact Teksage Admin');
                print('Error: $e');
              }
            } else {
              if (widget.title == 'Email') {
                bool isInvalid = !isValidEmail(rawText);
                if (isInvalid) return;
              }

              if (widget.title == 'Phone Number') {
                if (dialCode.isEmpty ||
                    rawText.length != widget.mobileLengthLimit) {
                  showErrorSnackBar(
                      context, 'Select valid country code and number');
                  return;
                }
              }

              setState(() {
                keyValue = widget.title == 'Email' ? 'email' : 'mobile_number';
              });

              try {
                CustomLoader.show(context);
                var response =
                    await profileService.profileVerify(keyValue!, rawText);
                CustomLoader.hide();
                if (response['message'] == 'OTP sent successfully') {
                  showLoginSuccessSnackBar(
                    context,
                    'otp_response'.tr.replaceAll('(title)', widget.title),
                  );
                  var result = await Get.to(() => OTPScreen(
                        title: widget.title.contains('Email')
                            ? 'Change Email'
                            : 'Change Phone Number',
                        userInfo: rawText,
                        keyValue: keyValue!,
                        isMobileScreen: false,
                        verifyScreen: true,
                        isChange: true,
                        newVerify: true,
                        countryCode: widget.title == 'Phone Number'
                            ? dialCode.replaceAll('+', '')
                            : null,
                      ));
                  widget.onResult?.call(result);
                } else {
                  showErrorSnackBar(
                      context, response['message'] ?? 'Error in sending OTP');
                }
              } catch (e) {
                CustomLoader.hide();
                showErrorSnackBar(context, 'Please contact Teksage Admin');
                print('Error: $e');
              }
            }
            widget.onTap?.call();
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.enableEdit ? whiteColor : notEditable,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            height: 45,
            padding: const EdgeInsets.only(left: 12, right: 18),
            child: Center(
              child: Text(
                // widget.isExist ? "Change" : "Verify",
                // widget.isExist ? "Verify" : "Change",
                buttonText.tr,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize14,
                  color: Platform.isAndroid ? mainColor : iosMainColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
