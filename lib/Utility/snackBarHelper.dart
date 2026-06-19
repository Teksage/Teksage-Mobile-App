import 'dart:io';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  customSnackBar(
    context: context,
    message: message.tr,
    backgroundColor:
        Platform.isAndroid ? const Color(0xFFC2EDC0) : const Color(0xFFD1E9FF),
    indicatorColor: Platform.isAndroid ? mainColor : iosMainColor,
    iconType: 'success',
  );
}

void showLoginSuccessSnackBar(BuildContext context, String message) {
  customSnackBar(
    context: context,
    message: message.tr,
    backgroundColor: Platform.isAndroid ? Color(0xfff4f8e5) : Color(0xffe1f0ff),
    indicatorColor: Platform.isAndroid ? mainColor : iosMainColor,
    iconType: 'success',
  );
}

void showInfoSnackBar(BuildContext context, String message) {
  customSnackBar(
    context: context,
    message: message.tr,
    backgroundColor: Platform.isAndroid ? horoscopeLightBg : Color(0xffd1e9ff),
    indicatorColor: Platform.isAndroid ? mainColor : iosMainColor,
    iconType: 'info',
  );
}

void showInfoSnackBarDual(BuildContext context, String message) {
  customSnackBar(
    context: context,
    message: message.tr,
    backgroundColor:
        Platform.isAndroid ? yearlyBottomGradient : Color(0xffd1e9ff),
    indicatorColor: Platform.isAndroid ? mainColor : iosMainColor,
    iconType: 'info',
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  customSnackBar(
    context: context,
    message: message.tr,
    backgroundColor: matchBottomGradient,
    indicatorColor: errorColor,
    iconType: 'error',
  );
}

void showLogoutSnackBar(BuildContext context, String message) {
  customSnackBar(
    context: context,
    message: message,
    backgroundColor: Platform.isAndroid ? Color(0xfff4f8e5) : Color(0xffe1f0ff),
    indicatorColor: Platform.isAndroid ? Color(0xff94C10D) : iosMainColor,
    iconType: 'error',
  );
}
