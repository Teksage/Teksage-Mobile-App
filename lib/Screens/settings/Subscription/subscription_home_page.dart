import 'dart:io';

import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/subscription_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/settings/Subscription/paymentSummary.dart';
import 'package:astro_prompt/Screens/settings/settings_page.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SubscriptionLandingPage extends StatefulWidget {
  final Subscription subscriptionData;
  final PlanDetails planData;
  final bool fromSettingPage;
  final String currency;
  const SubscriptionLandingPage(
      {super.key,
      required this.subscriptionData,
      required this.planData,
      required this.fromSettingPage,
      required this.currency});

  @override
  State<SubscriptionLandingPage> createState() =>
      _SubscriptionLandingPageState();
}

class _SubscriptionLandingPageState extends State<SubscriptionLandingPage> {
  int pendingDays = 0;
  double convertPercentage = 0.0;

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
    true
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
  List<SubscriptionPlanModel> currentPlans = [];
  List<SubscriptionPlanModel> allPlans = [];
  int? recommendedPlanId;
  int selectedIndex = 0;
  String tenureValue = '';
  String tenureUnit = '';

  @override
  void initState() {
    super.initState();
    getPendingDays();
    getAllPlans();
  }

  void getPendingDays() {
    final tValue = widget.planData.tenureValue.toString();
    final tUnit = widget.planData.tenureCount[0].toUpperCase() +
        widget.planData.tenureCount.toString().substring(1);
    final startDate =
        DateTime.parse(widget.subscriptionData.subscriptionStartDate);
    final endDate = DateTime.parse(widget.subscriptionData.subscriptionEndDate);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(startDate.year, startDate.month, startDate.day);
    final endDay = DateTime(endDate.year, endDate.month, endDate.day);

    final totalDuration = endDay.difference(startDay).inDays;
    // final elapsed = today.difference(startDay).inDays;
    final elapsed = today.difference(startDay).inDays.clamp(0, totalDuration);
    final remaining = endDay.difference(today).inDays;
    double percentage = 0.0;
    if (totalDuration > 0) {
      percentage = (1 - (elapsed / totalDuration)).clamp(0.0, 1.0);
    }
    if (int.parse(tValue) != 1) {
      setState(() {
        tenureValue = tValue;
        tenureUnit = '${tUnit}s';
      });
    } else {
      tenureValue = tValue;
      tenureUnit = tUnit;
    }
    setState(() {
      pendingDays = remaining > 0 ? remaining : 0;
      convertPercentage = percentage;
    });
  }

  void getAllPlans() async {
    currentPlans = await AstrologerConsultationService().fetchPremiumPlans();
    if (widget.currency == 'INR') {
      currentPlans.sort((a, b) => a.localPlanPrice.compareTo(b.localPlanPrice));
    } else {
      currentPlans
          .sort((a, b) => a.foreignPlanPrice.compareTo(b.foreignPlanPrice));
    }

    double selectedPlanPrice = 0.0;
    if (currentPlans.isNotEmpty) {
      int initialMiddleIndex = currentPlans.length ~/ 2;
      selectedIndex = initialMiddleIndex;
      final selectedPlan = currentPlans[selectedIndex];
      selectedPlanPrice = widget.currency == 'INR'
          ? selectedPlan.localPlanPrice
          : selectedPlan.foreignPlanPrice;

      recommendedPlanId = selectedPlan.planId;
    }
    setState(() {
      allPlans = currentPlans
          .where((plan) => plan.planId != widget.subscriptionData.planId)
          .toList();
      final otherPlanPrices = allPlans.map((plan) => widget.currency == 'INR'
          ? plan.localPlanPrice
          : plan.foreignPlanPrice);
      final hasHigher =
          otherPlanPrices.any((price) => price > selectedPlanPrice);

      if (!hasHigher) {
        recommendedPlanId = null;
        selectedIndex = -1;
      } else {
        final validIndex =
            allPlans.indexWhere((plan) => plan.planId == recommendedPlanId);
        if (validIndex == -1 && allPlans.isNotEmpty) {
          int fallbackMiddleIndex = allPlans.length ~/ 2;
          recommendedPlanId = allPlans[fallbackMiddleIndex].planId;
          selectedIndex = fallbackMiddleIndex;
        }
      }
    });
  }

  String _getRenewalText() {
    print('status,${widget.planData.planId}');
    final isMonthlyPlan =
        (widget.subscriptionData.autoPayStatus != "cancelled" &&
                widget.subscriptionData.autoPayStatus != "halted") &&
            widget.subscriptionData.isAutoPay != null &&
            widget.planData.planId == 1;

    if (isMonthlyPlan) {
      if (widget.subscriptionData.subscriptionEndDate == null ||
          widget.subscriptionData.subscriptionEndDate.isEmpty) {
        return '';
      }

      final endDate =
          DateTime.tryParse(widget.subscriptionData.subscriptionEndDate);

      if (endDate == null) return '';

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final formatted =
          '${endDate.day} ${months[endDate.month - 1]} ${endDate.year}';

      return '${'Auto Renews on'.tr}\n$formatted';
    }

    return '$pendingDays ${'days left'.tr}';
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      backgroundColor: blackColor,
      body: Stack(
        children: [
          Positioned(
              top: 48,
              child: Image.asset(
                subscriptionBg,
                width: util.width,
              )),
          Column(
            children: [
              AppBar(
                elevation: 0,
                scrolledUnderElevation: 0.0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  'Subscription'.tr,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.bold),
                      fontSize: util.fontSize20,
                      height: 1.0,
                      color: whiteColor),
                ),
                leading: IconButton(
                  onPressed: () {
                    final status = widget.subscriptionData.planStatus
                        .toString()
                        .toLowerCase()
                        .trim();
                    if (widget.fromSettingPage == true && status == 'expired') {
                      Get.to(() => SettingsPage());
                    } else if (widget.fromSettingPage) {
                      Get.back();
                    } else {
                      Get.to(() => BottomNavigationScreen());
                    }
                  },
                  icon: SvgPicture.asset(backButton,
                      colorFilter:
                          ColorFilter.mode(whiteColor, BlendMode.srcIn)),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: util.width20),
                        padding: EdgeInsets.only(
                            right: 20, left: 20, top: 25, bottom: 15),
                        decoration: BoxDecoration(
                            color: whiteColor.withValues(alpha: 0.04),
                            border: Border.all(
                                color: whiteColor.withValues(alpha: 0.12)),
                            borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(subscriptionPro),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Text('Your Current Plan'.tr,
                                        style: TextStyle(
                                            fontFamily: 'FontSemiBold',
                                            fontSize: util.fontSize18,
                                            height: 1.0,
                                            color: whiteColor)),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: whiteColor.withValues(alpha: 0.12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.currency == 'INR'
                                            ? '₹${widget.planData.localPlanPrice.toInt().toString()}'
                                            : '\$${widget.planData.foreignPlanPrice.toInt().toString()}',
                                        style: TextStyle(
                                            fontFamily: 'FontSemiBold',
                                            fontSize: 25,
                                            color: whiteColor,
                                            height: 1.0),
                                      ),
                                      SizedBox(
                                        height: util.height10,
                                      ),
                                      Text(
                                        '$tenureValue ${tenureUnit == 'Months' || tenureUnit == 'months' || tenureUnit == 'month' || tenureUnit == 'Month' ? "month_plan".tr : tenureUnit.tr} ${'Plan'.tr}',
                                        style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            fontSize: 12,
                                            color: whiteColor.withValues(
                                                alpha: 0.6),
                                            height: 1.0),
                                      ),
                                      SizedBox(
                                        height: util.height10,
                                      ),
                                      LinearPercentIndicator(
                                        width: 100,
                                        animation: true,
                                        lineHeight: 5,
                                        animationDuration: 1000,
                                        percent: convertPercentage,
                                        barRadius: Radius.circular(15),
                                        backgroundColor:
                                            whiteColor.withValues(alpha: 0.12),
                                        // progressColor: convertPercentage > 0.7 ? errorColor : whiteColor,
                                        progressColor: convertPercentage < 0.1
                                            ? Colors.red
                                            : whiteColor,
                                      ),
                                      SizedBox(
                                        height: util.height10,
                                      ),
                                      Text(
                                        _getRenewalText(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'FonrMedium',
                                            fontSize: util.fontSize10,
                                            // height: 1.0,

                                            color: whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: util.height20,
                            ),
                            DashedLine(
                              width: MyUtility(context).width,
                              color: whiteColor.withValues(alpha: 0.5),
                              dashWidth: 2,
                            ),
                            SizedBox(
                              height: util.height10,
                            ),
                            ...List.generate(
                                PlatformTextConfig.planFeatures.length,
                                (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                PlatformTextConfig
                                                    .planFeatures[index].tr,
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.medium),
                                                    fontSize: MyUtility(context)
                                                        .fontSize14,
                                                    height: 1.0,
                                                    color:
                                                        whiteColor.withValues(
                                                            alpha: 0.5)))),
                                        widget.planData.planName == 'Premium'
                                            ? Icon(
                                                proFeatures[index]
                                                    ? Icons.check_box
                                                    : Icons
                                                        .indeterminate_check_box,
                                                color: mainColor,
                                                size: 20)
                                            : Icon(
                                                freeFeatures[index]
                                                    ? Icons.check_box
                                                    : Icons
                                                        .indeterminate_check_box,
                                                color: freeFeatures[index]
                                                    ? mainColor
                                                    : Color(0xff8A8A8A),
                                                size: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: util.width20,
                            left: util.width20,
                            top: 10,
                            bottom: 10),
                        child: Row(
                          children: [
                            for (int i = 0; i < allPlans.length; i++) ...[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = i;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 106,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            // color: i == selectedIndex ? mainColor : Colors.transparent,
                                            color: i == selectedIndex &&
                                                    recommendedPlanId != null
                                                ? mainColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: whiteColor.withValues(
                                                  alpha: 0.2),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.currency == 'INR'
                                                    ? '₹${allPlans[i].localPlanPrice.toInt()}'
                                                    : '\$${allPlans[i].foreignPlanPrice.toInt()}',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontFamily: 'FontSemiBold',
                                                    color: Colors.white,
                                                    height: 1.0),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                '${allPlans[i].durationValue} ${allPlans[i].durationUnit}',
                                                style: TextStyle(
                                                    fontFamily: AppFont.get(
                                                        FontType.medium),
                                                    fontSize: util.fontSize14,
                                                    color: whiteColor
                                                        .withValues(alpha: 0.6),
                                                    height: 1.0),
                                              ),
                                              const SizedBox(height: 6),
                                              allPlans[i].planId ==
                                                      recommendedPlanId
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        'Recommended'.tr,
                                                        style: TextStyle(
                                                            fontFamily: AppFont
                                                                .get(FontType
                                                                    .semiBold),
                                                            fontSize:
                                                                util.fontSize9,
                                                            color: mainColor,
                                                            height: 1.0),
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      i == selectedIndex &&
                                              recommendedPlanId != null
                                          ? Positioned(
                                              right: 0,
                                              top: 5,
                                              child:
                                                  SvgPicture.asset(subSelect))
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ),
                              if (i != allPlans.length - 1) SizedBox(width: 10),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        height: util.height10,
                      ),
                      if (allPlans.isNotEmpty &&
                          selectedIndex >= 0 &&
                          selectedIndex < allPlans.length &&
                          allPlans[selectedIndex].localPlanPrice >
                              widget.planData.localPlanPrice)
                        GestureDetector(
                          onTap: () {
                            // print('Index: ${allPlans[selectedIndex].planName}');
                            // print('Currency: ${widget.currency}');
                            // if (Platform.isIOS) {
                            //   Get.to(
                            //     () => IosSubscriptionPaymentSummaryPage(premiumPlan: allPlans[selectedIndex]),
                            //     transition: Transition.rightToLeftWithFade,
                            //     duration: const Duration(milliseconds: 400),
                            //     curve: Curves.easeInOut,
                            //   );
                            // } else {
                            Get.to(
                              () => SubscriptionPaymentSummaryPage(
                                currency: widget.currency,
                                premiumPlan: allPlans[selectedIndex],
                              ),
                              transition: Transition.rightToLeftWithFade,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                            // }

                            // Get.to(
                            //   () => SubscriptionPaymentSummaryPage(
                            //     currency: widget.currency,
                            //     premiumPlan: allPlans[selectedIndex],
                            //   ),
                            //   transition: Transition.rightToLeftWithFade,
                            //   duration: const Duration(milliseconds: 400),
                            //   curve: Curves.easeInOut,
                            // );
                          },
                          child: Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: util.width20),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            width: MyUtility(context).width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: whiteColor),
                            child: Text(
                              'Upgrade Plan'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: MyUtility(context).fontSize18,
                                  color: mainColor,
                                  height: 1.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
