import 'dart:io';

import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Services/SubscriptionService/subscriptionServiceIOS.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SubscriptionLandingPageIos extends StatefulWidget {
  final Subscription subscriptionData;
  const SubscriptionLandingPageIos({super.key, required this.subscriptionData});

  @override
  State<SubscriptionLandingPageIos> createState() =>
      _SubscriptionLandingPageIosState();
}

class _SubscriptionLandingPageIosState
    extends State<SubscriptionLandingPageIos> {
  final SubscriptionIosService _service = SubscriptionIosService();
  bool _hasActiveSubscription = false;
  bool _isLoading = false;
  String? _errorMessage;

  final List<bool> proFeatures = [true, true, true, true, true, true];
  final List<bool> freeFeatures = [true, true, false, false, false, false];

  int pendingDays = 0;
  double convertPercentage = 0.0;
  String tenureValue = '1';
  String tenureUnit = 'Month';

  @override
  void initState() {
    super.initState();
    _service.errorNotifier.addListener(_onError);
    _service.loadingNotifier.addListener(_onLoading);
    getPendingDays();
    _updateStatus();
  }

  void getPendingDays() {
    print(
        'Subscription Start Date: ${widget.subscriptionData.subscriptionStartDate}');
    print(
        'Subscription End Date: ${widget.subscriptionData.subscriptionEndDate}');
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
    setState(() {
      pendingDays = remaining > 0 ? remaining : 0;
      convertPercentage = percentage;
    });
  }

  void _onError() {
    setState(() => _errorMessage = _service.errorNotifier.value);
  }

  void _onLoading() {
    setState(() => _isLoading = _service.loadingNotifier.value);
  }

  void _updateStatus() {
    setState(() {
      _hasActiveSubscription = _service.hasActiveSubscriptionLocal();
    });
  }

  @override
  void dispose() {
    _service.errorNotifier.removeListener(_onError);
    _service.loadingNotifier.removeListener(_onLoading);
    super.dispose();
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
            child: Image.asset(subscriptionBg, width: util.width),
          ),
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
                    color: whiteColor,
                    height: 1.0,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    Get.back();
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
                      /// Subscription Info Card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: util.width20),
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, top: 25, bottom: 15),
                        decoration: BoxDecoration(
                          color: whiteColor.withValues(alpha: 0.04),
                          border: Border.all(
                              color: whiteColor.withValues(alpha: 0.12)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(subscriptionProIos),
                                    const SizedBox(height: 18),
                                    Text(
                                      'Your Current Plan'.tr,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize18,
                                        color: whiteColor,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: whiteColor.withValues(alpha: 0.12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '\$9',
                                        style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize: 25,
                                          color: whiteColor,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '$tenureValue $tenureUnit Plan',
                                        style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: 12,
                                          color:
                                              whiteColor.withValues(alpha: 0.6),
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      LinearPercentIndicator(
                                        width: 100,
                                        animation: true,
                                        lineHeight: 5,
                                        animationDuration: 1000,
                                        percent: convertPercentage,
                                        barRadius: const Radius.circular(15),
                                        backgroundColor:
                                            whiteColor.withValues(alpha: 0.12),
                                        progressColor: convertPercentage < 0.1
                                            ? Colors.red
                                            : whiteColor,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '$pendingDays ${'days left'.tr}',
                                        style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize10,
                                          color: whiteColor,
                                          height: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            DashedLine(
                                width: util.width,
                                color: whiteColor.withValues(alpha: 0.5),
                                dashWidth: 2),
                            const SizedBox(height: 10),

                            /// Plan Features
                            ...List.generate(
                                PlatformTextConfig.planFeatures.length,
                                (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        PlatformTextConfig.planFeatures[index],
                                        style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize14,
                                          color:
                                              whiteColor.withValues(alpha: 0.5),
                                          height: 1.0,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      proFeatures[index]
                                          ? Icons.check_box
                                          : Icons.indeterminate_check_box,
                                      color: mainColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Messages
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      if (_hasActiveSubscription)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'You have an active subscription.',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// Loading Overlay
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: mainColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
