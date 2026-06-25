import 'dart:async';
import 'dart:io';
import 'package:astro_prompt/Components/Chat/successDialog.dart';
import 'package:astro_prompt/Components/Common/dashedContianer.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/coupon_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/subscription_model.dart';
import 'package:astro_prompt/Model/subscription_payment_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_home_page.dart';
import 'package:astro_prompt/Services/Astrologer-user/paymentService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/SubscriptionService/subscriptionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SubscriptionPaymentSummaryPage extends StatefulWidget {
  final SubscriptionPlanModel premiumPlan;
  final String currency;
  const SubscriptionPaymentSummaryPage({
    super.key,
    required this.premiumPlan,
    required this.currency,
  });

  @override
  State<SubscriptionPaymentSummaryPage> createState() =>
      _SubscriptionPaymentSummaryPageState();
}

class _SubscriptionPaymentSummaryPageState
    extends State<SubscriptionPaymentSummaryPage> {
  TextEditingController promoCodeController = TextEditingController();
  late Razorpay _razorpay;
  PaymentService paymentService = PaymentService();
  SubscriptionService subscriptionService = SubscriptionService();
  ProfileService profileService = ProfileService();
  late CouponModel newDiscountedAmount;
  double planCost = 0.0;
  double discountPrice = 0.0;
  double cgst = 0.0;
  double cgstPercentage = 0.0;
  double sgst = 0.0;
  double sgstPercentage = 0.0;
  double localTotalCost = 0.0;
  double foreignTotalCost = 0.0;
  String couponId = '';

  late double originalPlanCost;
  late double originalCGst;
  late double originalCGstPercentage;
  late double originalSGst;
  late double originalSGstPercentage;
  late double originalLocalTotalCost;
  late double originalForeignTotalCost;
  bool isINR = false;
  String rupeeSymbol = '₹';
  String dollarSymbol = '\$';
  bool isLoading = false;
  String email = '';
  String mobileNumber = '';

  @override
  void initState() {
    super.initState();
    // print('Currency Sub Page: ${widget.currency}');
    fetchProfileData();
    _initializeRazorpay();
    isINR = widget.currency == 'INR';
    originalPlanCost = isINR
        ? widget.premiumPlan.localPlanPrice
        : widget.premiumPlan.foreignPlanPrice;
    originalCGst = widget.premiumPlan.cgstAmount;
    originalCGstPercentage = widget.premiumPlan.cgstPercentage;
    originalSGst = widget.premiumPlan.sgstAmount;
    originalSGstPercentage = widget.premiumPlan.sgstPercentage;
    originalLocalTotalCost = widget.premiumPlan.localTotalAmount;
    originalForeignTotalCost = widget.premiumPlan.foreignTotalAmount;
    // print('Plan : $originalPlanCost');

    setState(() {
      planCost = isINR
          ? widget.premiumPlan.localPlanPrice
          : widget.premiumPlan.foreignPlanPrice;
      cgst = widget.premiumPlan.cgstAmount;
      cgstPercentage = widget.premiumPlan.cgstPercentage;
      sgst = widget.premiumPlan.sgstAmount;
      sgstPercentage = widget.premiumPlan.sgstPercentage;
      localTotalCost = widget.premiumPlan.localTotalAmount;
      foreignTotalCost = widget.premiumPlan.foreignTotalAmount;
    });
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    promoCodeController.clear();
    super.dispose();
  }

  void fetchProfileData() async {
    UserProfile? profileData = await profileService.fetchUserProfile();
    if (profileData != null) {
      setState(() {
        mobileNumber = profileData.mobileNumber;
        email = profileData.email;
      });
    } else {
      print("Profile data is null. Unable to update UI.");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    CustomLoader.show(context, loaderColor: mainColor);
    final subscriptionId =
        response.data?['razorpay_subscription_id'] as String?;
    // print(
    //     'Payment Success: paymentId=${response.paymentId}, orderId=${response.orderId}, subscriptionId=$subscriptionId, signature=${response.signature}');

    SubscriptionPaymentVerification? result;

    if (subscriptionId != null) {
      // Auto-recurring subscription payment
      result = await paymentService.subscriptionAutoVerifyPayment(
        subscriptionId: subscriptionId,
        paymentId: response.paymentId!,
        signature: response.signature ?? '',
      );
    } else {
      // One-time order payment
      result = await paymentService.subscriptionVerifyPayment(
        orderId: response.orderId!,
        paymentId: response.paymentId!,
        signature: response.signature!,
      );
    }

    CustomLoader.hide();
    if (result != null && result.status == 'success') {
      showLoginSuccessSnackBar(context, 'Payment successful!');
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DownloadSuccessDialog(
            title: 'Payment Successful',
          );
        },
      );

      await savePremiumUser(true);

      // Show loader while waiting for backend to propagate subscription data
      CustomLoader.show(context, loaderColor: mainColor);

      // Poll up to 10 times with 3-second gaps (max ~30s wait)
      ProfileService profileService = ProfileService();
      UserProfile? planData;
      const int maxAttempts = 10;
      const int retryDelaySeconds = 3;

      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        planData = await profileService.fetchUserProfile();
        // print(
        //     'planData attempt $attempt: $planData, subscription=${planData?.subscription}, planDetails=${planData?.planDetails}');
        if (planData != null &&
            planData.subscription != null &&
            planData.planDetails != null) {
          break;
        }
        if (attempt < maxAttempts) {
          await Future.delayed(Duration(seconds: retryDelaySeconds));
        }
      }

      CustomLoader.hide();

      if (planData != null &&
          planData.subscription != null &&
          planData.planDetails != null) {
        Get.offAll(() => BottomNavigationScreen());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.to(
            () => SubscriptionLandingPage(
              subscriptionData: planData!.subscription!,
              planData: planData.planDetails!,
              fromSettingPage: false,
              currency: widget.currency,
            ),
            preventDuplicates: false,
          );
        });
      } else {
        Get.offAll(() => BottomNavigationScreen());
      }
    } else {
      showErrorSnackBar(
          context, 'Payment verification failed. Please try again.');
      Get.offAll(() => BottomNavigationScreen());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showErrorSnackBar(context, 'Payment failed. Please try again.');
    Get.offAll(() => BottomNavigationScreen());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet selected: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('responsiveFontSize(0.049): ${util.responsiveFontSize(0.0436)}');
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
                  'Payment Summary'.tr,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.bold),
                      fontSize: util.fontSize20,
                      height: 1.0,
                      color: whiteColor),
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
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MyUtility(context).width30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 23,
                        ),
                        SvgPicture.asset(subscriptionPro),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          'Teksage Pro',
                          style: TextStyle(
                              fontFamily: 'FontSemiBold',
                              fontSize: util.responsiveFontSize(0.0473),
                              color: whiteColor,
                              height: 1.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                          decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 1.0,
                                colors: [
                                  Color.fromRGBO(16, 177, 0, 0.42),
                                  Color.fromRGBO(1, 1, 1, 0.42),
                                ],
                                stops: [0.0, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: whiteColor.withValues(alpha: 0.12),
                                  width: 1)),
                          child: Text(
                            '${widget.premiumPlan.durationValue}-${widget.premiumPlan.durationUnit} ${'membership'.tr}',
                            style: TextStyle(
                                fontFamily: 'FontSemiBold',
                                fontSize: util.fontSize14,
                                height: 1.0,
                                color: whiteColor),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (widget.premiumPlan.planId == 1)
                          Text(
                            'Auto-renews every month'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'FontSemiBold',
                                fontSize: util.fontSize14,
                                color: whiteColor,
                                height: 1.0),
                          ),
                        SizedBox(
                          height: 15,
                        ),
                        DashedLine(
                          width: MyUtility(context).width,
                          color: whiteColor.withValues(alpha: 0.5),
                          dashWidth: 2,
                        ),
                        SizedBox(
                          height: MyUtility(context).height20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Plan Cost'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: MyUtility(context).fontSize16,
                                  color: whiteColor.withValues(alpha: 0.5),
                                  height: 1.0),
                            ),
                            Text(
                              '${isINR ? rupeeSymbol : dollarSymbol}${planCost.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: MyUtility(context).fontSize16,
                                  color: whiteColor.withValues(alpha: 0.5),
                                  height: 1.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MyUtility(context).height20,
                        ),

                        if (discountPrice != 0.0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount'.tr,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: MyUtility(context).fontSize16,
                                    color: whiteColor.withValues(alpha: 0.5),
                                    height: 1.0),
                              ),
                              Text(
                                '${isINR ? rupeeSymbol : dollarSymbol}${discountPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: MyUtility(context).fontSize16,
                                    color: whiteColor.withValues(alpha: 0.5),
                                    height: 1.0),
                              )
                            ],
                          ),
                          SizedBox(
                            height: MyUtility(context).height20,
                          ),
                        ],

                        ///cgst
                        isINR
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'CGST Charges (${cgstPercentage.toInt()}%)',
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: MyUtility(context).fontSize16,
                                        color:
                                            whiteColor.withValues(alpha: 0.5),
                                        height: 1.0),
                                  ),
                                  Text(
                                    '₹${cgst.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: MyUtility(context).fontSize16,
                                        color:
                                            whiteColor.withValues(alpha: 0.5),
                                        height: 1.0),
                                  )
                                ],
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: MyUtility(context).height20,
                        ),

                        ///sgst
                        isINR
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SGST Charges (${sgstPercentage.toInt()}%)',
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: MyUtility(context).fontSize16,
                                        color:
                                            whiteColor.withValues(alpha: 0.5),
                                        height: 1.0),
                                  ),
                                  Text(
                                    '₹${sgst.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: MyUtility(context).fontSize16,
                                        color:
                                            whiteColor.withValues(alpha: 0.5),
                                        height: 1.0),
                                  )
                                ],
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: MyUtility(context).height20,
                        ),
                        if (widget.premiumPlan.planId != 1)
                          PromoCodeContainer(
                            couponType: 'subscription',
                            backgroundColor: whiteColor.withValues(alpha: 0.08),
                            applyBorderColor: mainColor.withValues(alpha: 0.8),
                            applyFontColor: mainColor,
                            fontColor: whiteColor.withValues(alpha: 0.5),
                            containerBorderColor: whiteColor,
                            planId: widget.premiumPlan.planId,
                            currency: widget.currency,
                            amount: isINR
                                ? widget.premiumPlan.localPlanPrice
                                : widget.premiumPlan.foreignPlanPrice,
                            onCouponApplied: (amount) {
                              print(
                                  'AmountPromo: ${amount?.planPrice} $originalPlanCost');
                              setState(() {
                                if (amount == null) {
                                  planCost = originalPlanCost;
                                  cgst = originalCGst;
                                  discountPrice = 0.0;
                                  cgstPercentage = originalCGstPercentage;
                                  sgst = originalSGst;
                                  sgstPercentage = originalSGstPercentage;
                                  localTotalCost = originalLocalTotalCost;
                                  foreignTotalCost = originalForeignTotalCost;
                                } else {
                                  var discount = double.parse(
                                      (amount.planPrice -
                                              amount.discountedPrice)
                                          .toStringAsFixed(2));
                                  planCost = amount.planPrice;
                                  discountPrice = discount;
                                  cgst = amount.cgstAmount;
                                  cgstPercentage = amount.cgstPercentage;
                                  sgst = amount.sgstAmount;
                                  sgstPercentage = amount.sgstPercentage;
                                  localTotalCost = amount.finalPrice;
                                  foreignTotalCost = amount.finalPrice;
                                  couponId = amount.couponId.toString();
                                }
                              });
                            },
                          ),
                        SizedBox(
                          height: MyUtility(context).height20,
                        ),
                        DashedLine(
                          width: MyUtility(context).width,
                          color: whiteColor.withValues(alpha: 0.5),
                          dashWidth: 2,
                        ),
                        SizedBox(
                          height: MyUtility(context).height20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Cost'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: MyUtility(context).fontSize16,
                                  height: 1.0,
                                  color: whiteColor.withValues(alpha: 0.5)),
                            ),
                            Text(
                              '${isINR ? rupeeSymbol : dollarSymbol}${isINR ? localTotalCost.toStringAsFixed(2) : foreignTotalCost.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontFamily: 'FontSemiBold',
                                  fontSize: util.responsiveFontSize(0.0436),
                                  height: 1.0,
                                  color: whiteColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // if (isLoading) return;
                            // setState(() => isLoading = true);
                            CustomLoader.show(context, loaderColor: mainColor);

                            var planId = widget.premiumPlan.planId;
                            // var amount = isINR ? localTotalCost : foreignTotalCost;
                            var amount = planCost - discountPrice;
                            var currency = isINR ? 'INR' : 'USD';
                            bool isMonthlyPlan = widget.premiumPlan.planId == 1;
                            // print(
                            //     'durationUnit: ${widget.premiumPlan.durationUnit},${widget.premiumPlan.planId}');
                            try {
                              if (isMonthlyPlan) {
                                // Auto-recurring subscription for 1-month plan
                                var response = await subscriptionService
                                    .autoSubscriptionPaymentInitiate(
                                        planId: planId,
                                        paymentAmount: double.parse(
                                            amount.toStringAsFixed(2)),
                                        currency: currency,
                                        couponId: couponId);

                                // print({
                                //   'key': response?.key,
                                //   'subscription_id': response?.subscription_id,
                                //   'name': 'Teksage',
                                //   'description':
                                //       'Monthly Auto Subscription Payment',
                                //   'prefill': {
                                //     'contact': mobileNumber,
                                //     'email': email
                                //   },
                                // });

                                if (email.isNotEmpty && response != null) {
                                  var options = {
                                    'key': response.key,
                                    'subscription_id': response.subscription_id,
                                    'name': 'Teksage',
                                    'description':
                                        'Monthly Auto Subscription Payment',
                                    'prefill': {
                                      'contact': mobileNumber,
                                      'email': email
                                    },
                                  };
                                  CustomLoader.hide();
                                  _razorpay.open(options);
                                } else {
                                  CustomLoader.hide();
                                  showErrorSnackBar(
                                      context, 'Please Contact Support team!');
                                  setState(() => isLoading = false);
                                }
                              } else {
                                // One-time payment for other plans
                                var response = await subscriptionService
                                    .subscriptionPaymentInitiate(
                                        planId: planId,
                                        paymentAmount: double.parse(
                                            amount.toStringAsFixed(2)),
                                        currency: currency,
                                        couponId: couponId);

                                // print({
                                //   'key': response?.key,
                                //   'amount': response?.amount,
                                //   'currency': response?.currency,
                                //   'name': 'Teksage',
                                //   'description': 'Subscription Payment',
                                //   'order_id': response?.id,
                                //   'prefill': {
                                //     'contact': mobileNumber,
                                //     'email': email
                                //   },
                                // });

                                if (email.isNotEmpty && response != null) {
                                  var options = {
                                    'key': response.key,
                                    'amount': response.amount,
                                    'currency': response.currency,
                                    'name': 'Teksage',
                                    'description': 'Subscription Payment',
                                    'order_id': response.id,
                                    'prefill': {
                                      'contact': mobileNumber,
                                      'email': email
                                    },
                                  };
                                  CustomLoader.hide();
                                  _razorpay.open(options);
                                } else {
                                  CustomLoader.hide();
                                  showErrorSnackBar(
                                      context, 'Please Contact Support team!');
                                  setState(() => isLoading = false);
                                }
                              }
                            } catch (e) {
                              CustomLoader.hide();
                              showErrorSnackBar(context,
                                  'Payment Error, Contact Support team!.');
                              setState(() => isLoading = false);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            width: MyUtility(context).width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: whiteColor),
                            child: isLoading
                                ? LoadingAnimationWidget.halfTriangleDot(
                                    color: mainColor,
                                    size: util.fontSize18,
                                  )
                                : Text(
                                    'Pay Now'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'FontSemiBold',
                                        fontSize: util.fontSize18,
                                        color: mainColor,
                                        height: 1.0),
                                  ),
                          ),
                        ),
                      ],
                    ),
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
