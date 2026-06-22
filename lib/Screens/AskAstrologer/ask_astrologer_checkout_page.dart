import 'dart:io';

import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Screens/AskAstrologer/ask_astrologer_whatsapp_consent_page.dart';
import 'package:astro_prompt/Services/AskAstrologerService/askAstrologerService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:astro_prompt/config/ask_astrologer_flow_screen.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AskAstrologerCheckoutPage extends StatefulWidget {
  const AskAstrologerCheckoutPage({super.key});

  @override
  State<AskAstrologerCheckoutPage> createState() =>
      _AskAstrologerCheckoutPageState();
}

class _AskAstrologerCheckoutPageState extends State<AskAstrologerCheckoutPage>
    with AskAstrologerFlowScreenMixin {
  final AskAstrologerService _service = AskAstrologerService();
  AskAstrologerPricing? pricing;
  AskAstrologerFlowState? flow;
  String currency = 'INR';
  bool loading = true;
  bool paying = false;
  late Razorpay _razorpay;
  AskAstrologerOrderResponse? pendingOrder;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _loadData();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _loadData() async {
    flow = await readAskAstrologerFlow();
    if (flow?.preferredLanguages == null || flow!.preferredLanguages!.isEmpty) {
      Get.back();
      return;
    }
    if (Platform.isAndroid) {
      await CurrencyHelper.fetchCurrencyIfNeeded(
        context: context,
        currentCurrency: currency,
        onCurrencyFetched: (c) => currency = c,
      );
    }
    pricing = await _service.fetchPricing();
    if (mounted) setState(() => loading = false);
  }

  double get _total =>
      currency == 'INR' ? pricing!.inrTotal : pricing!.usdTotal;

  Future<void> _handlePay() async {
    if (pricing == null || flow == null || paying) return;
    setState(() => paying = true);
    CustomLoader.show(context);
    final order = await _service.createRequest(
      userQuestion: flow!.userQuestion,
      aiResponse: flow!.aiResponse,
      preferredLanguages: flow!.preferredLanguages!,
      currency: currency,
    );
    CustomLoader.hide();
    if (order == null) {
      setState(() => paying = false);
      showErrorSnackBar(context, 'Could not initiate payment. Please try again.'.tr);
      return;
    }
    pendingOrder = order;
    final profile = await ProfileService().fetchUserProfile();
    _razorpay.open({
      'key': order.key,
      'amount': order.amount,
      'currency': order.currency,
      'order_id': order.razorpayOrderId,
      'name': 'Teksage',
      'description': 'Ask Astrologer',
      'prefill': {
        'contact': profile?.mobileNumber ?? '',
        'email': profile?.email ?? '',
      },
    });
    setState(() => paying = false);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (pendingOrder == null) return;
    CustomLoader.show(context);
    final ok = await _service.verifyPayment(
      requestId: pendingOrder!.requestId,
      orderId: response.orderId!,
      paymentId: response.paymentId!,
      signature: response.signature!,
    );
    CustomLoader.hide();
    if (ok) {
      showSuccessSnackBar(context, 'Payment successful!'.tr);
      Get.off(() => AskAstrologerWhatsappConsentPage());
    } else {
      showErrorSnackBar(context, 'Verification failed. Please contact support.'.tr);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showErrorSnackBar(context, response.message ?? 'Payment failed'.tr);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    if (loading || flow == null) {
      return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: SvgPicture.asset(
              appBackButton,
              colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Booking Details'.tr,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: util.fontSize20,
              color: blackColor,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator(color: mainColor)),
      );
    }
    final langs = flow!.preferredLanguages!
        .map((id) => AskAstrologerLanguages.labelFor(id).tr)
        .join(', ');
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            appBackButton,
            colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Booking Details'.tr,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: util.fontSize20,
                color: blackColor)),
      ),
      body: pricing == null
          ? Center(
              child: Text('Could not load pricing. Please try again.'.tr,
                  style: TextStyle(color: errorColor)))
          : SingleChildScrollView(
              padding: EdgeInsets.all(util.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question details'.tr,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          fontSize: util.fontSize14,
                          color: blackColor.withValues(alpha: 0.5))),
                  SizedBox(height: 12),
                  _detailCard([
                    _row('Your question'.tr, flow!.userQuestion),
                    _row('Language'.tr, langs),
                    _row('Answer within'.tr, '4 hours'.tr),
                  ]),
                  SizedBox(height: 24),
                  Text('Payment summary'.tr,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          fontSize: util.fontSize14,
                          color: blackColor.withValues(alpha: 0.5))),
                  SizedBox(height: 12),
                  _detailCard([
                    _row('Consultation fee'.tr,
                        '${currency == 'INR' ? '₹' : '\$'}${pricing!.localPlanPrice.toStringAsFixed(currency == 'INR' ? 0 : 2)}'),
                    if (currency == 'INR') ...[
                      _row('CGST'.tr, '₹${pricing!.cgst.toStringAsFixed(2)}'),
                      _row('SGST'.tr, '₹${pricing!.sgst.toStringAsFixed(2)}'),
                    ],
                    _row('Total'.tr,
                        '${currency == 'INR' ? '₹' : '\$'}${_total.toStringAsFixed(currency == 'INR' ? 0 : 2)}',
                        bold: true),
                  ]),
                ],
              ),
            ),
      bottomNavigationBar: pricing == null
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(util.width20),
                child: ElevatedButton(
                  onPressed: paying ? null : _handlePay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: homeBanner,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    paying ? 'Processing…'.tr : 'Pay & Ask'.tr,
                    style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        color: whiteColor),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _detailCard(List<Widget> rows) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: blackColor.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: rows),
      );

  Widget _row(String label, String value, {bool bold = false}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        color: blackColor.withValues(alpha: 0.6)))),
            Expanded(
                flex: 3,
                child: Text(value,
                    style: TextStyle(
                        fontFamily: AppFont.get(
                            bold ? FontType.semiBold : FontType.medium),
                        fontSize: 14))),
          ],
        ),
      );
}
