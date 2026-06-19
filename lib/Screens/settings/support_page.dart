import 'dart:io';

import 'package:astro_prompt/Services/SettingService/supportService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController controller;
  late Animation<double> heightFactor;
  TextEditingController textController = TextEditingController();
  bool enableButton = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    heightFactor = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  void toggleTextArea() {
    if (!isExpanded) {
      controller.forward();
    }
    setState(() {
      isExpanded = true;
    });
  }

  Future<void> handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!enableButton || textController.text.trim().isEmpty) return;

    setState(() => isLoading = true);
    // Show loader
    CustomLoader.show(context);

    try {
      await SupportMailService().submitSupportMail(textController.text.trim());
      CustomLoader.hide();
      showInfoSnackBarDual(context,
          "Thanks for reaching out! Your query has been received — our team will respond shortly.");
      setState(() {
        isExpanded = false;
        enableButton = false;
        textController.clear();
        controller.reverse();
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      CustomLoader.hide();
      showErrorSnackBar(context, "Something went wrong. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.2668)}');
    // print('Height: ${util.responsiveHeight(0.1971)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          centerTitle: true,
          title: Text(
            "Support".tr,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: util.fontSize20,
                height: 1.0,
                color: blackColor),
          ),
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Future.delayed(Duration(milliseconds: 300), () {
                Get.back();
              });
            },
            icon: SvgPicture.asset(
              backButton,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: util.width20),
          width: util.width,
          height: util.height / 1.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Got a question?\nOur support team is here to guide your path'
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
                height: util.height50,
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (widget, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: widget,
                  );
                },
                child: isExpanded
                    ? SizedBox.shrink() // Hide the placeholder
                    : GestureDetector(
                        onTap: toggleTextArea,
                        child: Container(
                          key: ValueKey('placeholder'),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Text(
                            'Enter feedback or query here...'.tr,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: 14,
                              height: 1.0,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
              ),
              SizeTransition(
                sizeFactor: heightFactor,
                axisAlignment: -1.0,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: textController,
                    maxLines: 5,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          enableButton = true;
                        });
                      } else {
                        setState(() {
                          enableButton = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter feedback or query here...'.tr,
                      hintStyle: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: 14,
                        height: 1.0,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Platform.isAndroid ? mainColor : iosMainColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Platform.isAndroid ? mainColor : iosMainColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Platform.isAndroid ? mainColor : iosMainColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: handleSubmit,
                child: Container(
                  width: util.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(util.width20),
                      color: !enableButton
                          ? supportSubmitButton
                          : Platform.isAndroid
                              ? mainColor
                              : iosMainColor),
                  child: Center(
                      child: Text(
                    'Submit'.tr,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize18,
                        height: 1.0,
                        color: enableButton
                            ? whiteColor
                            : blackColor.withValues(alpha: 0.5)),
                  )),
                ),
              ),
              SizedBox(
                height: util.height50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
