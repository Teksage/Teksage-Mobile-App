import 'dart:io';

import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Components/Settings/customAccordion.dart';
import 'package:astro_prompt/Screens/settings/support_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool tokenExist = false;

  @override
  void initState() {
    super.initState();
    checkAccessToken();
  }

  Future<void> checkAccessToken() async {
    String? token = await getAccessToken();
    if (!mounted) return;
    setState(() {
      tokenExist = token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.2668)}');
    // print('Height: ${util.responsiveHeight(0.1971)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          "FAQs".tr,
          style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: util.fontSize20,
              height: 1.0,
              color: blackColor),
        ),
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Get.back();
          },
          icon: SvgPicture.asset(
            backButton,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: util.width20),
                width: util.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Find answers to common questions\nabout our astrology services.'
                            .tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: util.fontSize16,
                            height: 1.2,
                            color: blackColor.withValues(alpha: 0.5)),
                      ),
                    ),
                    SizedBox(
                      height: util.height30,
                    ),
                    CustomAccordion(),
                    SizedBox(
                      height: util.height20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 160,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notEditable,
              border: Border(
                top: BorderSide(
                    color: blackColor.withValues(alpha: 0.12), width: 1),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Still have questions?'.tr,
                    style: TextStyle(
                        fontSize: util.fontSize16,
                        fontFamily: AppFont.get(FontType.medium),
                        color: blackColor,
                        height: 1.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (tokenExist) {
                      Get.to(() => SupportPage());
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withValues(alpha: 0.5),
                        builder: (context) =>
                            const LoginPromptDialog(reDirectHome: false),
                      );
                    }
                  },
                  child: Container(
                    width: util.width,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(util.width20),
                        color: Platform.isAndroid ? mainColor : iosMainColor),
                    child: Center(
                        child: Text(
                      'Contact Support'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: util.fontSize18,
                          height: 1.0,
                          color: whiteColor),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
