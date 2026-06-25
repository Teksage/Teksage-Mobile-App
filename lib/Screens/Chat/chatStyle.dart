import 'dart:io';

import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class ChatStyle extends StatefulWidget {
  const ChatStyle({super.key});

  @override
  State<ChatStyle> createState() => _ChatStyleState();
}

class _ChatStyleState extends State<ChatStyle> {
  String? selectedStyle;

  Future<void> _saveStyle(String style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("chat_style", style);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: AppBar(
      //   backgroundColor: whiteColor,
      //   title: Text(
      //     'AI Chat',
      //     style: TextStyle( fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize20),
      //   ),
      //   leading: Platform.isAndroid ? IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: SvgPicture.asset(
      //       backButton,
      //     ),
      //   ) : SizedBox.shrink(),
      // ),
      body: Container(
        width: util.width,
        padding: EdgeInsets.symmetric(horizontal: util.width20),
        decoration: BoxDecoration(
          image: Platform.isIOS
              ? DecorationImage(
                  image: AssetImage(iosSettingBg), alignment: Alignment.topLeft)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'AI Chat'.tr,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.bold),
                    fontSize: util.fontSize20),
              ),
              leading: Platform.isAndroid
                  ? IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: SvgPicture.asset(
                        backButton,
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            Column(
              children: [
                // SizedBox(
                //   height: util.height50,
                // ),
                // SizedBox(
                //   height: util.height50,
                // ),
                Text(
                  'Choose how AI replies'.tr,
                  style: TextStyle(
                      fontFamily: 'FontSemiBold', fontSize: util.fontSize24),
                ),
                SizedBox(
                  height: util.height50,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => selectedStyle = "short");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                        color: Platform.isIOS ? whiteColor : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                            color: selectedStyle == "short"
                                ? (Platform.isAndroid
                                    ? mainColor
                                    : iosMainColor)
                                : blackColor.withValues(alpha: 0.12),
                            width: 1)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Concise'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize18,
                                  color: selectedStyle == "short"
                                      ? (Platform.isAndroid
                                          ? mainColor
                                          : iosMainColor)
                                      : blackColor),
                            ),
                            if (selectedStyle == "short")
                              SvgPicture.asset(
                                selectCheckBox,
                                colorFilter: ColorFilter.mode(
                                    Platform.isAndroid
                                        ? mainColor
                                        : iosMainColor,
                                    BlendMode.srcIn),
                              )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: util.width / 1.5,
                          child: Text(
                            'Quick, direct replies without extra details — ideal for instant answers.'
                                .tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                height: util.lineHeight21_6 / util.fontSize14,
                                color: blackColor.withValues(alpha: 0.6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => selectedStyle = "long");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: Platform.isIOS ? whiteColor : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                        color: selectedStyle == "long"
                            ? (Platform.isAndroid ? mainColor : iosMainColor)
                            : blackColor.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Explanatory'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize18,
                                  color: selectedStyle == "long"
                                      ? (Platform.isAndroid
                                          ? mainColor
                                          : iosMainColor)
                                      : blackColor),
                            ),
                            if (selectedStyle == "long")
                              SvgPicture.asset(
                                selectCheckBox,
                                colorFilter: ColorFilter.mode(
                                    Platform.isAndroid
                                        ? mainColor
                                        : iosMainColor,
                                    BlendMode.srcIn),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: util.width / 1.5,
                          child: Text(
                            'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.'
                                .tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                height: util.lineHeight21_6 / util.fontSize14,
                                color: blackColor.withValues(alpha: 0.6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: selectedStyle == null
                      ? null
                      : () async {
                          await _saveStyle(selectedStyle!);
                          Get.back(result: selectedStyle);
                        },
                  child: Container(
                    width: util.width,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: selectedStyle == null
                          ? blackColor.withValues(alpha: 0.2)
                          : (Platform.isAndroid ? mainColor : iosMainColor),
                    ),
                    child: Text(
                      'Continue'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'FontSemiBold',
                          fontSize: util.fontSize18,
                          color: whiteColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: util.height50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
