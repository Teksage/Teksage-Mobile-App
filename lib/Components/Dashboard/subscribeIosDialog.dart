import 'dart:ui';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_details_page.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_details_page_IOS.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SubscriptionIosPromptDialog extends StatefulWidget {
  const SubscriptionIosPromptDialog({super.key});

  @override
  State<SubscriptionIosPromptDialog> createState() =>
      _SubscriptionIosPromptDialogState();
}

class _SubscriptionIosPromptDialogState
    extends State<SubscriptionIosPromptDialog> {
  String dollarSymbol = '\$';
  String selectedPlan = '\$9';
  String selectedDuration = '1 Month';
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(color: Colors.black.withValues(alpha: 0.1)),
          ),
        ),
        Center(
          child: Container(
            width: util.width,
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  Get.back();
                }
              },
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                child: SizedBox(
                  width: util.width * 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(util.width12),
                      color: const Color(0xff010101),
                      image: DecorationImage(
                        image: AssetImage(subscriptionBg),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Close button
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10, top: 10),
                              width: util.width30,
                              height: util.height30,
                              child: SvgPicture.asset(
                                closeButton,
                                colorFilter: ColorFilter.mode(
                                  whiteColor.withValues(alpha: 0.6),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Header image
                        Image.asset(subscriptionProIos),
                        SizedBox(height: util.height20),

                        /// Title
                        Text(
                          "Premium Feature".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: util.fontSize20,
                            fontFamily: AppFont.get(FontType.semiBold),
                            height: 1.0,
                            color: whiteColor,
                          ),
                        ),
                        SizedBox(height: util.height20),

                        /// Single Plan Card
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: util.responsiveWidth(0.275),
                          height: util.responsiveWidth(0.2578),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: whiteColor.withValues(alpha: 0.12),
                              width: 1.5,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      selectedPlan,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: 25,
                                        height: 1.0,
                                        color: whiteColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectedDuration,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            whiteColor.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "Recommended".tr,
                                        style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize: util.fontSize9,
                                          color: mainColor,
                                          height: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: SvgPicture.asset(subSelect),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: util.height20),

                        /// Purchase Button
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SubscriptionDetailsPageIos());
                          },
                          child: Container(
                            width: util.width / 1.5,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(util.width30),
                              color: mainColor,
                            ),
                            child: Text(
                              'Purchase Plan'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize16,
                                height: 1.0,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: util.height20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
