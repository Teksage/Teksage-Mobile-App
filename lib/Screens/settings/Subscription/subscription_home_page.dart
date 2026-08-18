
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/subscription_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/settings/Subscription/paymentSummary.dart';
import 'package:astro_prompt/Screens/settings/settings_page.dart';
import 'package:astro_prompt/Services/Astrologer-user/userAstrologer.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/SubscriptionService/subscriptionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
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
  Subscription? _subscriptionOverride;
  bool _cancelBusy = false;

  Subscription get _subscription =>
      _subscriptionOverride ?? widget.subscriptionData;

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
        DateTime.parse(_subscription.subscriptionStartDate);
    final endDate = DateTime.parse(_subscription.subscriptionEndDate);

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
          .where((plan) => plan.planId != _subscription.planId)
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

  String _formatDateLabel(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    const months = [
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _isAutoPayActive() {
    return _subscription.isAutoPay == true &&
        (_subscription.autoPayStatus ?? '').toLowerCase() == 'active';
  }

  Future<void> _refreshSubscriptionFromProfile() async {
    final profile = await ProfileService().fetchUserProfile();
    if (profile?.subscription != null) {
      setState(() {
        _subscriptionOverride = profile!.subscription!;
      });
      getPendingDays();
    }
  }

  static const List<String> _cancelReasons = [
    'Too expensive',
    'Not using it enough',
    "Didn't find it useful",
    'Technical issues',
    'Switching to another service',
  ];
  static const String _otherReason = 'Other';

  Future<void> _onCancelAutoPayTap() async {
    if (_cancelBusy || !_isAutoPayActive()) return;
    final otherController = TextEditingController();
    String? selected;
    String? reasonError;

    final selectedReason = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            'Cancel auto-renew'.tr,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: MyUtility(context).fontSize18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stop automatic renewals? Your premium access will continue until the current period ends.'
                      .tr,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: MyUtility(context).fontSize14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Reason for cancellation'.tr,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: MyUtility(context).fontSize14,
                  ),
                ),
                ..._cancelReasons.map(
                  (reason) => RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: mainColor,
                    fillColor: WidgetStateProperty.all(mainColor),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    title: Text(reason.tr),
                    value: reason,
                    groupValue: selected,
                    onChanged: (value) {
                      setDialogState(() {
                        selected = value;
                        reasonError = null;
                        if (value != _otherReason) otherController.clear();
                      });
                    },
                  ),
                ),
                RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: mainColor,
                  fillColor: WidgetStateProperty.all(mainColor),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  title: Text(_otherReason.tr),
                  value: _otherReason,
                  groupValue: selected,
                  onChanged: (value) {
                    setDialogState(() {
                      selected = value;
                      reasonError = null;
                    });
                  },
                ),
                if (selected == _otherReason)
                  TextField(
                    controller: otherController,
                    maxLines: 3,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Tell us why you are cancelling auto-renew'.tr,
                      errorText: reasonError,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                if (selected != _otherReason && reasonError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      reasonError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Keep auto-renew'.tr,
                style: TextStyle(fontFamily: AppFont.get(FontType.medium)),
              ),
            ),
            TextButton(
              onPressed: selected == null
                  ? null
                  : () {
                      if (selected == _otherReason &&
                          otherController.text.trim().isEmpty) {
                        setDialogState(() {
                          reasonError = 'Please enter a reason for Other.'.tr;
                        });
                        return;
                      }
                      final reason = selected == _otherReason
                          ? '$_otherReason: ${otherController.text.trim()}'
                          : selected;
                      Navigator.pop(ctx, reason);
                    },
              child: Text(
                'Cancel auto-renew'.tr,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  color: selected == null ? null : mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    otherController.dispose();

    if (selectedReason == null || selectedReason.trim().isEmpty) return;
    if (!mounted) return;

    setState(() => _cancelBusy = true);
    CustomLoader.show(context, loaderColor: mainColor);
    final result = await SubscriptionService().cancelAutoPaySubscription(
      reason: selectedReason,
    );
    if (!mounted) return;
    CustomLoader.hide();
    setState(() => _cancelBusy = false);

    if (result != null && result['status'] == 'success') {
      await _refreshSubscriptionFromProfile();
      if (!mounted) return;
      final accessTill = _formatDateLabel(
        result['access_till']?.toString() ?? _subscription.subscriptionEndDate,
      );
      final message = accessTill.isNotEmpty
          ? 'Your premium access will continue until $accessTill.'
          : 'Auto-renew cancelled.'.tr;
      showLoginSuccessSnackBar(context, message);
    } else {
      showErrorSnackBar(
        context,
        'Could not cancel auto-renew. Please try again.'.tr,
      );
    }
  }

  String _buildPlanDurationLabel() {
    final unit = tenureUnit.toLowerCase();
    if (unit == 'month' || unit == 'months') {
      final monthKey = tenureValue == '1' ? 'month' : 'months';
      return '$tenureValue ${monthKey.tr}';
    }
    return '$tenureValue ${tenureUnit.tr} ${'Plan'.tr}';
  }

  String _getRenewalText() {
    print('status,${widget.planData.planId}');
    final isMonthlyPlan =
        (_subscription.autoPayStatus != "cancelled" &&
                _subscription.autoPayStatus != "halted") &&
            _subscription.isAutoPay != null &&
            widget.planData.planId == 1;

    if (isMonthlyPlan) {
      if (_subscription.subscriptionEndDate.isEmpty) {
        return '';
      }

      final endDate =
          DateTime.tryParse(_subscription.subscriptionEndDate);

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
                    final status = _subscription.planStatus
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
                                        _buildPlanDurationLabel(),
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
                                            color: whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (_isAutoPayActive()) ...[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: whiteColor.withValues(alpha: 0.05),
                                  border: Border.all(
                                    color: whiteColor.withValues(alpha: 0.15),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Auto-renewal is on'.tr,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize14,
                                        color: whiteColor,
                                        height: 1.2,
                                      ),
                                    ),
                                    if (_subscription
                                        .subscriptionEndDate.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        '${'Auto Renews on'.tr}\n${_formatDateLabel(_subscription.subscriptionEndDate)}',
                                        style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize12,
                                          color:
                                              whiteColor.withValues(alpha: 0.6),
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    GestureDetector(
                                      onTap:
                                          _cancelBusy ? null : _onCancelAutoPayTap,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                whiteColor.withValues(alpha: 0.3),
                                          ),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Text(
                                          'Cancel auto-renew'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.semiBold),
                                            fontSize: util.fontSize14,
                                            color: whiteColor,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
