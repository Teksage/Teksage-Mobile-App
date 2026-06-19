import 'dart:io';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoader {
  static bool _isShowing = false;

  static void show(BuildContext context, {Color? backgroundColor, Color? loaderColor}) {
    if (_isShowing) return;
    _isShowing = true;
    Get.dialog(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Get.back();
            Get.find<BottomNavController>().changeIndex(0);
          }
        },
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MyUtility(context).responsiveWidth(0.2668),
            height: MyUtility(context).responsiveHeight(0.1232),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: loaderColor ?? (Platform.isAndroid ? mainColor : iosMainColor),
                  size: MyUtility(context).height30,
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (_isShowing && Get.isDialogOpen == true) {
      _isShowing = false;
      Get.back();
    }
    _isShowing = false;
  }

  static Widget inline({Color? backgroundColor, Color? loaderColor, double? size}) {
    return SizedBox(
      width: size ?? 30,
      height: size ?? 30,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: LoadingAnimationWidget.halfTriangleDot(
            color: loaderColor ?? (Platform.isAndroid ? mainColor : iosMainColor),
            size: size ?? 24,
          ),
        ),
      ),
    );
  }
}