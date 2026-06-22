import 'package:astro_prompt/Components/WhatsAppUpdates/whatsapp_updates_phone_choice.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/whatsapp_consent_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WhatsAppUpdatesSendSection extends StatefulWidget {
  final String profileCountryCode;
  final String profileMobile;
  final bool loading;
  final bool disabled;
  final String? ctaLabel;
  final String? hintText;
  final bool showStopNote;
  final Color? ctaBackgroundColor;
  final Future<void> Function({
    required bool useProfilePhone,
    String? countryCode,
    String? mobileNumber,
  }) onSend;

  const WhatsAppUpdatesSendSection({
    super.key,
    required this.profileCountryCode,
    required this.profileMobile,
    required this.onSend,
    this.loading = false,
    this.disabled = false,
    this.ctaLabel,
    this.hintText,
    this.showStopNote = true,
    this.ctaBackgroundColor,
  });

  @override
  State<WhatsAppUpdatesSendSection> createState() =>
      _WhatsAppUpdatesSendSectionState();
}

class _WhatsAppUpdatesSendSectionState extends State<WhatsAppUpdatesSendSection> {
  WhatsAppPhoneMode _mode = WhatsAppPhoneMode.profile;
  late String _countryCode;
  String _mobile = '';
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _countryCode = widget.profileCountryCode.replaceAll(RegExp(r'\D'), '');
    if (_countryCode.isEmpty) _countryCode = '91';
  }

  String get _profileMasked =>
      maskPhoneForDisplay(widget.profileCountryCode, widget.profileMobile);

  Future<void> _handleSend() async {
    if (widget.disabled || widget.loading) return;
    if (_mode == WhatsAppPhoneMode.profile) {
      await widget.onSend(useProfilePhone: true);
      return;
    }
    if (!isValidWhatsAppMobile(_mobile)) {
      setState(() => _validationError = 'Enter a valid mobile number.');
      return;
    }
    setState(() => _validationError = null);
    await widget.onSend(
      useProfilePhone: false,
      countryCode: _countryCode,
      mobileNumber: _mobile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final label = widget.loading
        ? 'Sending…'.tr
        : (widget.ctaLabel ?? 'Enable WhatsApp Astrology Alerts'.tr);
    final btnColor = widget.ctaBackgroundColor ?? mainColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WhatsAppUpdatesPhoneChoice(
          mode: _mode,
          profileMasked: _profileMasked,
          countryCode: _countryCode,
          mobile: _mobile,
          validationError: _validationError,
          onModeChange: (mode) => setState(() {
            _mode = mode;
            _validationError = null;
          }),
          onCountryCodeChange: (code) => setState(() => _countryCode = code),
          onMobileChange: (value) => setState(() {
            _mobile = value;
            _validationError = null;
          }),
        ),
        SizedBox(height: util.height20),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: (widget.disabled || widget.loading) ? null : _handleSend,
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              disabledBackgroundColor: btnColor.withValues(alpha: 0.45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  waCtaWhatsapp,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          color: whiteColor)),
                ),
                SvgPicture.asset(
                  rightArrow,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
        if (widget.hintText != null) ...[
          SizedBox(height: util.height10),
          Text(widget.hintText!.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: mainColor.withValues(alpha: 0.85))),
        ],
        if (widget.showStopNote) ...[
          SizedBox(height: util.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(verified, width: 14, height: 14),
              SizedBox(width: 4),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: 'You can unsubscribe anytime by sending '.tr,
                    style: TextStyle(fontSize: 12, color: mainColor.withValues(alpha: 0.85)),
                    children: [
                      TextSpan(
                        text: 'STOP'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' on WhatsApp.'.tr),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
