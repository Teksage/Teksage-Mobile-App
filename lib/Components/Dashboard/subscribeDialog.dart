import 'dart:ui';
import 'package:astro_prompt/Model/AstrologerUserConsult/subscription_model.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_details_page.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SubscribePromptDialog extends StatefulWidget {
  final bool reDirectHome;
  final String? currency;
  final String? planStatus;
  const SubscribePromptDialog(
      {super.key, required this.reDirectHome, this.currency, this.planStatus});

  @override
  State<SubscribePromptDialog> createState() => _SubscribePromptDialogState();
}

class _SubscribePromptDialogState extends State<SubscribePromptDialog> {
  int selectedIndex = 1;
  List<SubscriptionPlanModel> premiumPlans = [];
  bool isLoading = true;
  String rupeeSymbol = '₹';
  String dollarSymbol = '\$';
  String selectedPlan = '';
  String selectedDuration = '';
  String selectedPlanId = '';

  @override
  void initState() {
    super.initState();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      premiumPlans = await AstrologerConsultationService().fetchPremiumPlans();
      bool isINR = widget.currency == 'INR';
      premiumPlans.sort((a, b) {
        double priceA = isINR ? a.localPlanPrice : a.foreignPlanPrice;
        double priceB = isINR ? b.localPlanPrice : b.foreignPlanPrice;
        return priceA.compareTo(priceB);
      });
      if (premiumPlans.isNotEmpty) {
        selectedIndex = premiumPlans.length > 1 ? 1 : 0;
        double selectedPrice = isINR
            ? premiumPlans[selectedIndex].localPlanPrice
            : premiumPlans[selectedIndex].foreignPlanPrice;
        selectedPlan =
            '${isINR ? rupeeSymbol : dollarSymbol}${selectedPrice.toStringAsFixed(0)}';
        // selectedDuration = '${premiumPlans[selectedIndex].durationValue} ${premiumPlans[selectedIndex].durationUnit}';
        selectedDuration = '${premiumPlans[selectedIndex].durationValue} '
            '${premiumPlans[selectedIndex].durationValue == 1 ? premiumPlans[selectedIndex].durationUnit : '${premiumPlans[selectedIndex].durationUnit}s'}';
        selectedPlanId = premiumPlans[selectedIndex].planId.toString();
      }
    } catch (e) {
      print('Error fetching plans: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('widget.currency: ${widget.currency}');
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.2578)}');
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
          child: Container(
            width: util.width,
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  print('widget.reDirectHome: ${widget.reDirectHome}');
                  if (widget.reDirectHome) {
                    Get.back();
                    Get.find<BottomNavController>().changeIndex(0);
                  }
                }
              },
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero, // removes default padding
                child: SizedBox(
                  width: util.width * 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(util.width12),
                      color: Color(0xff010101),
                      image: DecorationImage(
                        image: AssetImage(subscriptionBg),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // padding: EdgeInsets.all(util.width10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.reDirectHome) {
                              Get.back();
                              Get.find<BottomNavController>()
                                  .changeIndex(0); // Navigate to Home Page
                              // Get.offAll(BottomNavigationScreen());
                            } else {
                              Get.back();
                            }
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 10, top: 10),
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
                        SvgPicture.asset(subscriptionPro),
                        SizedBox(height: util.height20),
                        Text(
                          widget.planStatus == 'expired'
                              ? 'Plan Expired'.tr
                              : "Premium Feature".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: util.fontSize20,
                              fontFamily: 'FontSemiBold',
                              height: 1.0,
                              color: whiteColor),
                        ),
                        Text(
                          "Unlock all features by choosing a plan".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: util.fontSize16,
                              fontFamily: 'FontSemiBold',
                              color: whiteColor.withValues(alpha: 0.9)),
                        ),
                        SizedBox(height: util.height20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(premiumPlans.length, (index) {
                            bool isINR = widget.currency == 'INR';
                            final isSelected = selectedIndex == index;
                            final plan = premiumPlans[index];
                            double amount = isINR
                                ? plan.localPlanPrice
                                : plan.foreignPlanPrice;
                            final price =
                                '${isINR ? rupeeSymbol : dollarSymbol}${amount.toStringAsFixed(0)}';
                            final duration =
                                '${plan.durationValue} ${plan.durationUnit}';
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  selectedPlan = price;
                                  selectedDuration = duration;
                                  selectedPlanId = plan.planId.toString();
                                });
                              },
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(
                                    begin: isSelected ? 1.0 : 0.9,
                                    end: isSelected ? 1.0 : 0.9),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          margin: const EdgeInsets.only(
                                              top: 8, right: 3),
                                          width: isSelected
                                              ? util.responsiveWidth(0.275)
                                              : util.responsiveWidth(0.225),
                                          height: isSelected
                                              ? util.responsiveWidth(0.2578)
                                              : util.responsiveWidth(0.197),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? mainColor
                                                : whiteColor.withValues(
                                                    alpha: 0.04),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: whiteColor.withValues(
                                                  alpha: 0.12),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                price,
                                                style: TextStyle(
                                                    fontFamily: 'FontSemiBold',
                                                    fontSize: 25,
                                                    height: 1.0,
                                                    color: whiteColor),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                duration,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.semiBold),
                                                    fontSize: util.fontSize12,
                                                    height: 1.0,
                                                    color:
                                                        whiteColor.withValues(
                                                            alpha: 0.6)),
                                              ),
                                              const SizedBox(height: 6),
                                              if (index == 1 && isSelected)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    "One-Time".tr,
                                                    style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.semiBold),
                                                        fontSize:
                                                            util.fontSize9,
                                                        color: mainColor,
                                                        height: 1.0),
                                                  ),
                                                ),
                                              if (index == 0 && isSelected)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    "Recurring".tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.semiBold),
                                                        fontSize:
                                                            util.fontSize9,
                                                        color: mainColor,
                                                        height: 1.0),
                                                  ),
                                                ),
                                              if (index == 2 && isSelected)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    "One-Time".tr,
                                                    style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.semiBold),
                                                        fontSize:
                                                            util.fontSize9,
                                                        color: mainColor,
                                                        height: 1.0),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        isSelected
                                            ? Positioned(
                                                right: 0,
                                                top: 0,
                                                child:
                                                    SvgPicture.asset(subSelect))
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: util.height20),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SubscriptionDetailsPage(
                                  selectedIndex: selectedIndex,
                                  currency: widget.currency!,
                                ));
                          },
                          child: Container(
                            width: util.width / 1.5,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(util.width30),
                                color: mainColor),
                            child: Text(
                              'Purchase Plan'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.fontSize16,
                                  height: 1.0,
                                  color: whiteColor),
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
