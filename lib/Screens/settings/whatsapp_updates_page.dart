import 'dart:async';

import 'package:astro_prompt/Components/WhatsAppUpdates/whatsapp_updates_benefits_card.dart';
import 'package:astro_prompt/Components/WhatsAppUpdates/whatsapp_updates_pending_card.dart';
import 'package:astro_prompt/Components/WhatsAppUpdates/whatsapp_updates_send_section.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Model/whatsapp_consent_model.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/WhatsAppService/whatsappConsentService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WhatsAppUpdatesPage extends StatefulWidget {
  const WhatsAppUpdatesPage({super.key});

  @override
  State<WhatsAppUpdatesPage> createState() => _WhatsAppUpdatesPageState();
}

class _WhatsAppUpdatesPageState extends State<WhatsAppUpdatesPage> {
  final WhatsAppConsentService _service = WhatsAppConsentService();
  WhatsAppConsentState? consent;
  bool loading = true;
  bool sending = false;
  bool revoking = false;
  bool changingNumber = false;
  Timer? _pollTimer;
  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    profile = await ProfileService().fetchUserProfile();
    await _refresh();
  }

  Future<void> _refresh({bool silent = false}) async {
    final status = await _service.fetchStatus();
    if (!mounted) return;
    setState(() {
      consent = status;
      loading = false;
    });
    _pollTimer?.cancel();
    if (status?.isPending == true) {
      _pollTimer = Timer.periodic(
        Duration(milliseconds: whatsAppConsentPollMs),
        (_) => _refreshSilent(),
      );
    }
  }

  Future<void> _refreshSilent() async {
    final status = await _service.fetchStatus();
    if (!mounted || status == null) return;
    setState(() => consent = status);
    if (!status.isPending) _pollTimer?.cancel();
  }

  Future<void> _sendConsent({
    required bool useProfilePhone,
    String? countryCode,
    String? mobileNumber,
  }) async {
    setState(() => sending = true);
    final result = await _service.requestConsent(
      useProfilePhone: useProfilePhone,
      countryCode: countryCode,
      mobileNumber: mobileNumber,
    );
    if (!mounted) return;
    setState(() {
      sending = false;
      changingNumber = false;
    });
    if (result != null) {
      await _refresh(silent: true);
    } else if (mounted) {
      showErrorSnackBar(
          context, 'Could not send WhatsApp message. Try again later.'.tr);
    }
  }

  Future<void> _revoke() async {
    setState(() => revoking = true);
    CustomLoader.show(context);
    final ok = await _service.revokeConsent();
    CustomLoader.hide();
    if (!mounted) return;
    setState(() {
      revoking = false;
      changingNumber = false;
    });
    if (ok) {
      await _refresh();
    } else {
      showErrorSnackBar(
          context, 'Could not disable WhatsApp alerts. Try again later.'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final verified = profile?.mobileVerified == true;
    final granted = consent?.granted == true;
    final revoked = consent?.revokedAt != null && !granted;
    final pending = verified &&
        !granted &&
        consent?.isPending == true &&
        consent?.revokedAt == null;
    final showRevoked = verified && revoked;
    final showIdleSend = verified && !granted && !pending && !showRevoked;

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: lightGrey,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            appBackButton,
            colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('WhatsApp Updates'.tr,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: util.fontSize20,
                color: blackColor)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  util.width20, util.height10, util.width20, util.height30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.bold),
                        fontSize: util.fontSize22,
                        color: blackColor,
                        height: 1.25,
                      ),
                      children: [
                        TextSpan(text: '${'Never Miss an'.tr} '),
                        TextSpan(
                          text: 'Important Astrological Opportunity'.tr,
                          style: TextStyle(color: mainColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: util.height10),
                  Text(
                    'Get timely WhatsApp alerts about important planetary movements, favorable periods, and personalized horoscope updates that can help you make better decisions at the right time.'
                        .tr,
                    style: TextStyle(
                        fontSize: util.fontSize14,
                        height: 1.5,
                        color: blackColor.withValues(alpha: 0.75)),
                  ),
                  SizedBox(height: util.height20),
                  const WhatsAppUpdatesBenefitsCard(),
                  if (!verified) ...[
                    SizedBox(height: util.height20),
                    _statusBox(
                      util,
                      'Verify your mobile number'.tr,
                      'Verify your phone to receive the WhatsApp consent message.'.tr,
                      child: TextButton(
                        onPressed: () => Get.to(() => ProfilePage(
                              title: 'Profile Details'.tr,
                              isProfileUpdated: true,
                            )),
                        child: Text('Verify'.tr,
                            style: TextStyle(
                                color: mainColor,
                                fontFamily: AppFont.get(FontType.semiBold))),
                      ),
                    ),
                  ],
                  if (granted) ...[
                    SizedBox(height: util.height20),
                    _statusBox(
                      util,
                      'WhatsApp alerts enabled'.tr,
                      'You will receive astrology updates on WhatsApp.'.tr,
                      child: OutlinedButton(
                        onPressed: revoking ? null : _revoke,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: errorColor,
                          minimumSize: Size(double.infinity, 44),
                          side: BorderSide(
                              color: errorColor.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(revoking
                            ? 'Disabling…'.tr
                            : 'Disable WhatsApp Alerts'.tr),
                      ),
                    ),
                  ],
                  if (showRevoked) ...[
                    SizedBox(height: util.height20),
                    _statusBox(
                      util,
                      'WhatsApp alerts disabled'.tr,
                      'You will no longer receive astrology updates on WhatsApp. Tap the button below to enable alerts again.'
                          .tr,
                      child: WhatsAppUpdatesSendSection(
                        profileCountryCode: profile?.countryCode ?? '91',
                        profileMobile: profile?.mobileNumber ?? '',
                        loading: sending,
                        showStopNote: false,
                        hintText:
                            'We will send a new confirmation message on WhatsApp.',
                        onSend: _sendConsent,
                      ),
                    ),
                  ],
                  if (pending && consent != null)
                    WhatsAppUpdatesPendingCard(
                      consent: consent!,
                      sending: sending,
                      startingOver: revoking,
                      showPhoneChoice: changingNumber,
                      profileCountryCode: profile?.countryCode ?? '91',
                      profileMobile: profile?.mobileNumber ?? '',
                      onResend: _sendConsent,
                      onChangeNumber: () =>
                          setState(() => changingNumber = true),
                      onStartOver: _revoke,
                    ),
                  if (showIdleSend)
                    Padding(
                      padding: EdgeInsets.only(top: util.height20),
                      child: WhatsAppUpdatesSendSection(
                        profileCountryCode: profile?.countryCode ?? '91',
                        profileMobile: profile?.mobileNumber ?? '',
                        loading: sending,
                        disabled: !verified,
                        onSend: _sendConsent,
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _statusBox(
    MyUtility util,
    String title,
    String body, {
    required Widget child,
  }) =>
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(util.width20),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: blackColor.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontFamily: AppFont.get(FontType.semiBold))),
            SizedBox(height: 4),
            Text(body,
                style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: blackColor.withValues(alpha: 0.65))),
            SizedBox(height: util.height20),
            child,
          ],
        ),
      );
}
