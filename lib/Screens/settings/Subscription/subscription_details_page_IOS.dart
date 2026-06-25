import 'dart:async';

import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_home_page_ios.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/SubscriptionService/subscriptionServiceIOS.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class SubscriptionDetailsPageIos extends StatefulWidget {
  final String? message;
  const SubscriptionDetailsPageIos({super.key, this.message});

  @override
  State<SubscriptionDetailsPageIos> createState() =>
      _SubscriptionDetailsPageIosState();
}

class _SubscriptionDetailsPageIosState
    extends State<SubscriptionDetailsPageIos> {
  final List<String> planFeatures = PlatformTextConfig.planFeatures;
  final List<bool> proFeatures = [true, true, true, true, true, true];
  final List<bool> freeFeatures = [true, true, false, false, false, false];

  String? _errorMessage;
  bool _isLoading = false;
  bool _hasActiveSubscription = false;
  late final SubscriptionIosService _service;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  var subscriptionData;

  @override
  void initState() {
    super.initState();
    _service = SubscriptionIosService();
    _service.errorNotifier.addListener(_errorListener);
    _service.loadingNotifier.addListener(_loadingListener);
    _updateSubscriptionStatus();
  }

  void _errorListener() {
    setState(() {
      _errorMessage = _service.errorNotifier.value;
      _updateSubscriptionStatus();
    });
  }

  void _loadingListener() {
    setState(() {
      _isLoading = _service.loadingNotifier.value;
      _updateSubscriptionStatus();
    });
  }

  void _updateSubscriptionStatus() {
    _hasActiveSubscription = _service.hasActiveSubscriptionLocal();
  }

  @override
  void dispose() {
    _service.errorNotifier.removeListener(_errorListener);
    _service.loadingNotifier.removeListener(_loadingListener);
    super.dispose();
  }

  Future<void> getProfileData({int retryCount = 0}) async {
    ProfileService profileService = ProfileService();

    try {
      UserProfile? profileData = await profileService.fetchUserProfile();
      if (!mounted) return;

      if (profileData == null || profileData.subscription == null) {
        if (kDebugMode) {
          print(
              'Profile data or subscription is null (Attempt ${retryCount + 1})');
        }

        if (retryCount < 3) {
          await Future.delayed(Duration(seconds: 1 + retryCount));
          await getProfileData(retryCount: retryCount + 1);
        }
        return;
      }

      setState(() {
        subscriptionData = profileData.subscription;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile data: $e (Attempt ${retryCount + 1})');
      }

      // Retry up to 3 times with increasing delays
      if (retryCount < 3) {
        await Future.delayed(Duration(seconds: 1 + retryCount));
        await getProfileData(retryCount: retryCount + 1);
      }
    }
  }

  void _initiatePaymentFlow() async {
    if (_service.hasActiveSubscriptionLocal()) {
      setState(() {
        _errorMessage = 'You already have an active subscription.';
      });
      return;
    }
    CustomLoader.show(context);
    try {
      await _service.init();
      final success = await _service.buySubscription();
      if (!success) {
        CustomLoader.hide();
        showErrorSnackBar(context, 'Failed to initiate purchase.');
        return;
      }
      // Listen for purchase updates
      _subscription = _service.iap.purchaseStream.listen((purchases) async {
        for (final purchase in purchases) {
          if (purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored) {
            final result = await _service.handleSuccessfulPurchase(purchase);
            if (result.success) {
              await savePremiumUser(true);
              await getProfileData();

              // Wait a bit more if data is still not available
              if (subscriptionData == null) {
                await Future.delayed(Duration(seconds: 2));
              }

              CustomLoader.hide();
              if (subscriptionData != null) {
                Get.to(() => SubscriptionLandingPageIos(
                      subscriptionData: subscriptionData,
                    ));
              } else {
                showErrorSnackBar(context,
                    'Failed to load subscription data. Please restart the app.');
              }
            } else {
              showErrorSnackBar(
                  context, result.errorMessage ?? 'Payment update failed');
            }
          } else if (purchase.status == PurchaseStatus.error) {
            CustomLoader.hide();
            showErrorSnackBar(
                context, purchase.error?.message ?? 'Purchase error');
          }
        }
      });
    } catch (e) {
      CustomLoader.hide();
      showErrorSnackBar(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print(util.responsiveFontSize(0.0473));

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
          AppBar(
            elevation: 0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Subscriptions'.tr,
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.bold),
                  fontSize: util.fontSize20,
                  height: 1.0,
                  color: whiteColor),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
                // Get.to(() => AIChatScreen());
              },
              icon: SvgPicture.asset(backButton,
                  colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn)),
            ),
          ),
          Positioned.fill(
            top: util.responsiveHeight(0.1282),
            right: 0,
            left: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  Image.asset(subscriptionProIos),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    'Try Premium Plan'.tr,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.responsiveFontSize(0.0473),
                        color: whiteColor,
                        height: 1.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Plans Row
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                right: 3, left: 3, top: 8),
                            width: 103,
                            height: 106,
                            decoration: BoxDecoration(
                              color: mainColor,
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
                                  '\$9',
                                  style: TextStyle(
                                      fontFamily:
                                          AppFont.get(FontType.semiBold),
                                      fontSize: 25,
                                      height: 1.0,
                                      color: whiteColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '1 Month'.tr,
                                  style: TextStyle(
                                      fontFamily:
                                          AppFont.get(FontType.semiBold),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: whiteColor.withValues(alpha: 0.6)),
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: 5,
                              child: SvgPicture.asset(subSelect)),
                        ],
                      ),
                      const SizedBox(height: 24),
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
                                            fontFamily:
                                                AppFont.get(FontType.semiBold),
                                            fontSize:
                                                MyUtility(context).fontSize20,
                                            height: 1.0,
                                            color: whiteColor))),
                                SizedBox(width: 16),
                                Text('Pro',
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: MyUtility(context).fontSize14,
                                        height: 1.0,
                                        color: whiteColor)),
                                SizedBox(width: 32),
                                Text('Free',
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(planFeatures[index],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'FontMedium',
                                                        fontSize:
                                                            MyUtility(context)
                                                                .fontSize14,
                                                        height: 1.0,
                                                        color: whiteColor
                                                            .withValues(
                                                                alpha: 0.5)))),
                                            SizedBox(width: 20),
                                            Icon(
                                                proFeatures[index]
                                                    ? Icons.check_box
                                                    : Icons
                                                        .indeterminate_check_box,
                                                color: mainColor,
                                                size: 20),
                                            SizedBox(width: 35),
                                            Icon(
                                                freeFeatures[index]
                                                    ? Icons.check_box
                                                    : Icons
                                                        .indeterminate_check_box,
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
                                if (_errorMessage != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: util.fontSize14,
                                          fontFamily:
                                              AppFont.get(FontType.medium)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                                if (_hasActiveSubscription) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'You already have an active subscription.',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: util.fontSize14,
                                          fontFamily:
                                              AppFont.get(FontType.medium)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                                GestureDetector(
                                  onTap: _initiatePaymentFlow,
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
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize:
                                              MyUtility(context).fontSize18,
                                          color: mainColor,
                                          height: 1.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                // ElevatedButton(
                                //   onPressed: () async {
                                //     await _service.restorePurchases();
                                //   },
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: mainColor,
                                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                //   ),
                                //   child: Text(
                                //     'Restore Purchases',
                                //     style: TextStyle(color: whiteColor, fontSize: util.fontSize14, fontFamily: AppFont.get(FontType.medium)),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: CircularProgressIndicator(color: mainColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
