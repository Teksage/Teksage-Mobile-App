import 'dart:io';

import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/subscription_model.dart';
import 'package:astro_prompt/Screens/settings/Subscription/paymentSummary.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SubscriptionComponent extends StatefulWidget {
  final int selectedIndex;
  final String currency;
  const SubscriptionComponent(
      {super.key, required this.selectedIndex, required this.currency});

  @override
  State<SubscriptionComponent> createState() => _SubscriptionComponentState();
}

class _SubscriptionComponentState extends State<SubscriptionComponent> {
  int selectedIndex = 0;
  List<SubscriptionPlanModel> premiumPlans = [];
  bool isLoading = true;
  String selectedPlan = '';
  String selectedDuration = '';
  String selectedPlanId = '';
  String rupeeSymbol = '₹';
  String dollarSymbol = '\$';
  bool isChecked = false;

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
        // selectedIndex = premiumPlans.length > 1 ? 1 : 0;
        selectedIndex = widget.selectedIndex;
        double selectedPrice = isINR
            ? premiumPlans[selectedIndex].localPlanPrice
            : premiumPlans[selectedIndex].foreignPlanPrice;
        selectedPlan =
            '${isINR ? rupeeSymbol : dollarSymbol}${selectedPrice.toStringAsFixed(0)}';
        selectedDuration =
            '${premiumPlans[selectedIndex].durationValue} ${premiumPlans[selectedIndex].durationUnit}';
        selectedPlanId = premiumPlans[selectedIndex].planId.toString();
      }
    } catch (e) {
      print('Error fetching plans: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final List<String> planFeatures = PlatformTextConfig.planFeatures;
  final List<bool> proFeatures = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ];
  final List<bool> freeFeatures = [
    true,
    true,
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    if (isLoading) {
      return Center(
        child: CustomLoader.inline(loaderColor: whiteColor),
      );
    }

    if (premiumPlans.isEmpty) {
      return Center(
          child: Text("No premium plans available",
              style: TextStyle(color: Colors.white)));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Plans Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(premiumPlans.length, (index) {
            bool isINR = widget.currency == 'INR';
            final isSelected = selectedIndex == index;
            final plan = premiumPlans[index];
            double amount = isINR ? plan.localPlanPrice : plan.foreignPlanPrice;
            final price =
                '${isINR ? rupeeSymbol : dollarSymbol}${amount.toStringAsFixed(0)}';
            final duration = '${plan.durationValue} ${plan.durationUnit}';

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
                    begin: isSelected ? 1.0 : 0.9, end: isSelected ? 1.0 : 0.9),
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
                          margin:
                              const EdgeInsets.only(right: 3, left: 3, top: 8),
                          width: 113,
                          height: isSelected ? 106 : 81,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? mainColor
                                : whiteColor.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: whiteColor.withValues(alpha: 0.12),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    fontSize: util.fontSize14,
                                    height: 1.0,
                                    color: whiteColor.withValues(alpha: 0.6)),
                              ),
                              const SizedBox(height: 6),
                              if (index == 1 && isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "One-Time".tr,
                                    style: TextStyle(
                                        fontFamily: 'FontSemiBold',
                                        fontSize: util.fontSize9,
                                        color: mainColor,
                                        height: 1.0),
                                  ),
                                ),
                              if (index == 0 && isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Recurring".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'FontSemiBold',
                                        fontSize: util.fontSize9,
                                        color: mainColor,
                                        height: 1.0),
                                  ),
                                ),
                              if (index == 2 && isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "One-Time".tr,
                                    style: TextStyle(
                                        fontFamily: 'FontSemiBold',
                                        fontSize: util.fontSize9,
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
                                top: 5,
                                child: SvgPicture.asset(subSelect))
                            : SizedBox.shrink(),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        if (selectedIndex == 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Auto-payment, Renews automatically every month".tr,
              style: TextStyle(
                fontFamily: 'FontSemiBold',
                fontSize: util.fontSize14,
                color: whiteColor,
              ),
            ),
          ),

        const SizedBox(height: 10),
        // Plan Details
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              DashedLine(
                width: MyUtility(context).width,
                color: whiteColor.withValues(alpha: 0.5),
                dashWidth: 2,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Compare the plans'.tr,
                          style: TextStyle(
                              fontFamily: 'FontSemiBold',
                              fontSize: MyUtility(context).fontSize20,
                              height: 1.0,
                              color: whiteColor))),
                  SizedBox(width: 16),
                  Text('Pro',
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: MyUtility(context).fontSize14,
                          height: 1.0,
                          color: whiteColor)),
                  SizedBox(width: 32),
                  Text('Free',
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: MyUtility(context).fontSize14,
                          height: 1.0,
                          color: whiteColor)),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              DashedLine(
                width: MyUtility(context).width,
                color: whiteColor.withValues(alpha: 0.5),
                dashWidth: 2,
              ),
              SizedBox(
                height: 11,
              ),
              Column(
                children: [
                  ...List.generate(planFeatures.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(planFeatures[index].tr,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize:
                                              MyUtility(context).fontSize14,
                                          height: 1.0,
                                          color: whiteColor.withValues(
                                              alpha: 0.5)))),
                              SizedBox(width: 20),
                              Icon(
                                  proFeatures[index]
                                      ? Icons.check_box
                                      : Icons.indeterminate_check_box,
                                  color: mainColor,
                                  size: 20),
                              SizedBox(width: 35),
                              Icon(
                                  freeFeatures[index]
                                      ? Icons.check_box
                                      : Icons.indeterminate_check_box,
                                  color: freeFeatures[index]
                                      ? mainColor
                                      : Color(0xff8A8A8A),
                                  size: 20),
                              SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  if (selectedIndex == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              activeColor: mainColor,
                              value: isChecked,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "I agree to recurring payments".tr,
                              style: TextStyle(
                                fontFamily: 'FontSemiBold',
                                fontSize: MyUtility(context).fontSize14,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      final plan = premiumPlans[selectedIndex];
                      // print('Plan: $plan');

                      if (selectedIndex == 0 && !isChecked) {
                        Get.snackbar(
                          'Recurring Payment Required',
                          'Please agree to recurring payments to continue',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: mainColor.withOpacity(0.8),
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                        );
                        return;
                      }

                      Get.to(() => SubscriptionPaymentSummaryPage(
                            currency: widget.currency,
                            premiumPlan: plan,
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      width: MyUtility(context).width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: whiteColor),
                      child: Text(
                        'Continue'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'FontSemiBold',
                            fontSize: MyUtility(context).fontSize18,
                            color: mainColor,
                            height: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
