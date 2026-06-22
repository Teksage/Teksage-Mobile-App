import 'dart:async';

import 'package:astro_prompt/Components/WhatsAppUpdates/whatsapp_updates_send_section.dart';
import 'package:astro_prompt/Model/whatsapp_consent_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/whatsapp_consent_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WhatsAppUpdatesPendingCard extends StatefulWidget {
  final WhatsAppConsentState consent;
  final bool sending;
  final bool startingOver;
  final bool showPhoneChoice;
  final String profileCountryCode;
  final String profileMobile;
  final Future<void> Function({
    required bool useProfilePhone,
    String? countryCode,
    String? mobileNumber,
  }) onResend;
  final VoidCallback onChangeNumber;
  final Future<void> Function() onStartOver;

  const WhatsAppUpdatesPendingCard({
    super.key,
    required this.consent,
    required this.sending,
    required this.startingOver,
    required this.showPhoneChoice,
    required this.profileCountryCode,
    required this.profileMobile,
    required this.onResend,
    required this.onChangeNumber,
    required this.onStartOver,
  });

  @override
  State<WhatsAppUpdatesPendingCard> createState() =>
      _WhatsAppUpdatesPendingCardState();
}

class _WhatsAppUpdatesPendingCardState extends State<WhatsAppUpdatesPendingCard> {
  Timer? _countdownTimer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _tickCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tickCountdown();
    });
  }

  @override
  void didUpdateWidget(covariant WhatsAppUpdatesPendingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.consent.consentSentAt != widget.consent.consentSentAt ||
        oldWidget.consent.resendAvailableAt != widget.consent.resendAvailableAt) {
      _tickCountdown();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _tickCountdown() {
    final next = getResendSecondsRemaining(
      consentSentAt: widget.consent.consentSentAt,
      resendAvailableAt: widget.consent.resendAvailableAt,
    );
    if (mounted && next != _secondsLeft) {
      setState(() => _secondsLeft = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final onCooldown = _secondsLeft > 0;
    final canResend = !onCooldown && widget.consent.canResend;

    if (widget.showPhoneChoice) {
      return _shell(
        util,
        child: Column(
          children: [
            _header(util),
            WhatsAppUpdatesSendSection(
              profileCountryCode: widget.profileCountryCode,
              profileMobile: widget.profileMobile,
              loading: widget.sending,
              ctaLabel: 'Resend message'.tr,
              showStopNote: false,
              onSend: widget.onResend,
            ),
          ],
        ),
      );
    }

    return _shell(
      util,
      child: Column(
        children: [
          _header(util),
          if (widget.consent.phoneMasked != null) ...[
            SizedBox(height: util.height20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: blackColor.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: blackColor.withValues(alpha: 0.05)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sent to'.tr,
                      style: TextStyle(
                          fontSize: 11,
                          color: blackColor.withValues(alpha: 0.4),
                          letterSpacing: 0.5)),
                  SizedBox(width: 8),
                  Text(widget.consent.phoneMasked!,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          fontSize: util.fontSize14)),
                ],
              ),
            ),
          ],
          if (onCooldown) ...[
            SizedBox(height: util.height20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text('Please wait a moment before resending'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: blackColor.withValues(alpha: 0.55))),
                  SizedBox(height: 4),
                  Text(
                    '${'Try again in'.tr} ${formatResendCountdown(_secondsLeft)}',
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize18,
                      color: mainColor,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: util.height20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: (!canResend || widget.sending)
                  ? null
                  : () => widget.onResend(useProfilePhone: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                disabledBackgroundColor: mainColor.withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
              ),
              child: widget.sending
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: whiteColor))
                  : Text('Resend message'.tr,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          color: whiteColor)),
            ),
          ),
          SizedBox(height: util.height10),
          Text(
            'Message still missing? Try another number or start over below.'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, color: blackColor.withValues(alpha: 0.45), height: 1.4),
          ),
          SizedBox(height: util.height20),
          Divider(color: blackColor.withValues(alpha: 0.05)),
          SizedBox(height: util.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: widget.onChangeNumber,
                child: Text('Use another number'.tr,
                    style: TextStyle(
                        color: mainColor,
                        fontFamily: AppFont.get(FontType.medium),
                        decoration: TextDecoration.underline)),
              ),
              Text('·', style: TextStyle(color: blackColor.withValues(alpha: 0.25))),
              TextButton(
                onPressed: (widget.sending || widget.startingOver)
                    ? null
                    : () => widget.onStartOver(),
                child: Text(
                  widget.startingOver ? 'Starting over…'.tr : 'Start over'.tr,
                  style: TextStyle(
                      color: mainColor,
                      fontFamily: AppFont.get(FontType.medium),
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shell(MyUtility util, {required Widget child}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: util.height20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: blackColor.withValues(alpha: 0.05)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: child,
      ),
    );
  }

  Widget _header(MyUtility util) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(waCtaWhatsapp, width: 28, height: 28),
        ),
        SizedBox(height: util.height20),
        Text('Confirm on WhatsApp'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize18)),
        SizedBox(height: 8),
        Text(
          'Open WhatsApp and reply to our message to turn on alerts.'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: util.fontSize14,
              color: blackColor.withValues(alpha: 0.6),
              height: 1.4),
        ),
      ],
    );
  }
}
