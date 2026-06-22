import 'package:astro_prompt/Components/WhatsAppUpdates/whatsapp_updates_phone_choice.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Model/whatsapp_consent_model.dart';
import 'package:astro_prompt/Screens/AskAstrologer/ask_astrologer_confirmation_page.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Services/WhatsAppService/whatsappConsentService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/ask_astrologer_flow_screen.dart';
import 'package:astro_prompt/config/whatsapp_consent_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AskAstrologerWhatsappConsentPage extends StatefulWidget {
  const AskAstrologerWhatsappConsentPage({super.key});

  @override
  State<AskAstrologerWhatsappConsentPage> createState() =>
      _AskAstrologerWhatsappConsentPageState();
}

class _AskAstrologerWhatsappConsentPageState
    extends State<AskAstrologerWhatsappConsentPage>
    with AskAstrologerFlowScreenMixin {
  final WhatsAppConsentService _service = WhatsAppConsentService();
  WhatsAppConsentState? consent;
  UserProfile? profile;
  bool loading = true;
  bool sending = false;

  WhatsAppPhoneMode _phoneMode = WhatsAppPhoneMode.profile;
  late String _countryCode;
  String _mobile = '';
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    profile = await ProfileService().fetchUserProfile();
    _countryCode =
        (profile?.countryCode ?? '91').replaceAll(RegExp(r'\D'), '');
    if (_countryCode.isEmpty) _countryCode = '91';
    await _loadConsent();
  }

  Future<void> _loadConsent() async {
    final status = await _service.fetchStatus();
    if (!mounted) return;
    if (status?.granted == true) {
      Get.off(() => const AskAstrologerConfirmationPage());
      return;
    }
    setState(() {
      consent = status;
      loading = false;
    });
  }

  String get _profileMasked => maskPhoneForDisplay(
        profile?.countryCode ?? '91',
        profile?.mobileNumber ?? '',
      );

  Future<void> _sendConsent() async {
    if (sending || profile?.mobileVerified != true) return;

    if (_phoneMode == WhatsAppPhoneMode.different) {
      if (!isValidWhatsAppMobile(_mobile)) {
        setState(() => _validationError = 'Enter a valid mobile number.');
        return;
      }
      setState(() => _validationError = null);
    }

    setState(() => sending = true);
    CustomLoader.show(context);
    final result = await _service.requestConsent(
      useProfilePhone: _phoneMode == WhatsAppPhoneMode.profile,
      countryCode:
          _phoneMode == WhatsAppPhoneMode.profile ? null : _countryCode,
      mobileNumber: _phoneMode == WhatsAppPhoneMode.profile ? null : _mobile,
    );
    CustomLoader.hide();
    if (!mounted) return;
    setState(() => sending = false);

    if (result != null) {
      Get.off(() => const AskAstrologerConfirmationPage());
      return;
    }
    showErrorSnackBar(
        context, 'Could not send WhatsApp message. Try again later.'.tr);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final verified = profile?.mobileVerified == true;
    final showSend = verified && consent?.granted != true;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Get Updates on WhatsApp'.tr,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.bold),
            fontSize: util.fontSize20,
            color: blackColor,
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : SingleChildScrollView(
              padding: EdgeInsets.all(util.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'WhatsApp notifications'.tr,
                      style: TextStyle(
                        fontSize: util.fontSize12,
                        letterSpacing: 0.6,
                        color: blackColor.withValues(alpha: 0.45),
                        fontFamily: AppFont.get(FontType.semiBold),
                      ),
                    ),
                  ),
                  SizedBox(height: util.height20),
                  Text(
                    'Enable WhatsApp status updates'.tr,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We\'ll send a confirmation message to your WhatsApp. Reply to opt in for alerts.'
                        .tr,
                    style: TextStyle(
                      fontSize: util.fontSize14,
                      height: 1.45,
                      color: blackColor.withValues(alpha: 0.65),
                    ),
                  ),
                  SizedBox(height: util.height20),
                  _benefit(util, 'Alert when your astrologer\'s answer is ready'.tr),
                  _benefit(util, 'Updates when your request status changes'.tr),
                  if (!verified) ...[
                    SizedBox(height: util.height20),
                    _verifyPhoneGate(util),
                  ],
                  if (showSend) ...[
                    SizedBox(height: util.height20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(util.width20),
                      decoration: BoxDecoration(
                        color: blackColor.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: WhatsAppUpdatesPhoneChoice(
                        mode: _phoneMode,
                        profileMasked: _profileMasked,
                        countryCode: _countryCode,
                        mobile: _mobile,
                        validationError: _validationError,
                        onModeChange: (mode) => setState(() {
                          _phoneMode = mode;
                          _validationError = null;
                        }),
                        onCountryCodeChange: (code) =>
                            setState(() => _countryCode = code),
                        onMobileChange: (value) => setState(() {
                          _mobile = value;
                          _validationError = null;
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: loading
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(util.width20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showSend)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: sending ? null : _sendConsent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: homeBanner,
                            disabledBackgroundColor:
                                homeBanner.withValues(alpha: 0.45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                waCtaWhatsapp,
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                    whiteColor, BlendMode.srcIn),
                              ),
                              SizedBox(width: 8),
                              Text(
                                sending
                                    ? 'Sending…'.tr
                                    : 'Send confirmation message'.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () =>
                          Get.off(() => const AskAstrologerConfirmationPage()),
                      child: Text(
                        'Skip for now'.tr,
                        style: TextStyle(
                          color: blackColor.withValues(alpha: 0.6),
                          fontFamily: AppFont.get(FontType.medium),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _verifyPhoneGate(MyUtility util) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(util.width20),
      decoration: BoxDecoration(
        color: blackColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: blackColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify your mobile number'.tr,
            style: TextStyle(fontFamily: AppFont.get(FontType.semiBold)),
          ),
          SizedBox(height: 4),
          Text(
            'Verify your phone to receive the WhatsApp consent message.'.tr,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: blackColor.withValues(alpha: 0.65),
            ),
          ),
          SizedBox(height: util.height20),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                await Get.to(() => ProfilePage(
                      title: 'Profile Details'.tr,
                      isProfileUpdated: true,
                    ));
                await _init();
              },
              child: Text(
                'Verify'.tr,
                style: TextStyle(
                  color: mainColor,
                  fontFamily: AppFont.get(FontType.semiBold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefit(MyUtility util, String text) => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, color: mainColor, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: util.fontSize14,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
}
