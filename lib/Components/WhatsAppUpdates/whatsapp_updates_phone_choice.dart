import 'package:astro_prompt/Components/Common/customCountryDropDown.dart';
import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Services/countryService/countryCodeService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:astro_prompt/config/whatsapp_consent_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum WhatsAppPhoneMode { profile, different }

class WhatsAppUpdatesPhoneChoice extends StatefulWidget {
  final WhatsAppPhoneMode mode;
  final String profileMasked;
  final String countryCode;
  final String mobile;
  final int mobileLength;
  final ValueChanged<WhatsAppPhoneMode> onModeChange;
  final ValueChanged<String> onCountryCodeChange;
  final ValueChanged<String> onMobileChange;
  final ValueChanged<int>? onMobileLengthChange;
  final String? validationError;

  const WhatsAppUpdatesPhoneChoice({
    super.key,
    required this.mode,
    required this.profileMasked,
    required this.countryCode,
    required this.mobile,
    this.mobileLength = LoginConstants.defaultMobileLength,
    required this.onModeChange,
    required this.onCountryCodeChange,
    required this.onMobileChange,
    this.onMobileLengthChange,
    this.validationError,
  });

  @override
  State<WhatsAppUpdatesPhoneChoice> createState() =>
      _WhatsAppUpdatesPhoneChoiceState();
}

class _WhatsAppUpdatesPhoneChoiceState
    extends State<WhatsAppUpdatesPhoneChoice> {
  List<Country> _countries = [];

  Future<void> _openCountryPicker() async {
    CustomLoader.show(context);
    try {
      if (_countries.isEmpty) {
        _countries = await CountryCodeService().fetchCountries();
      }
      CustomLoader.hide();
      if (!mounted) return;
      final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (_) => CountryDropdownDialog(countries: _countries),
      );
      if (result == null) return;
      final dial = result['dialCode'] ?? LoginConstants.defaultDialCode;
      final length = int.tryParse(result['mobileNumberLength'] ?? '') ??
          LoginConstants.defaultMobileLength;
      widget.onCountryCodeChange(dial.replaceAll('+', ''));
      widget.onMobileLengthChange?.call(length);
      widget.onMobileChange('');
    } catch (_) {
      CustomLoader.hide();
      if (!mounted) return;
      showErrorSnackBar(context, 'Error in Fetching Country code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final dialDigits =
        widget.countryCode.replaceAll(RegExp(r'\D'), '');
    final dialValue =
        '+${dialDigits.isEmpty ? LoginConstants.defaultCountryCodeNumeric : dialDigits}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _radioTile(
          util: util,
          selected: widget.mode == WhatsAppPhoneMode.profile,
          onTap: () => widget.onModeChange(WhatsAppPhoneMode.profile),
          title: 'Use my verified profile number'.tr,
          subtitle: widget.profileMasked,
        ),
        SizedBox(height: util.height10),
        _radioTile(
          util: util,
          selected: widget.mode == WhatsAppPhoneMode.different,
          onTap: () => widget.onModeChange(WhatsAppPhoneMode.different),
          title: 'Use a different WhatsApp number'.tr,
          child: widget.mode == WhatsAppPhoneMode.different
              ? Padding(
                  padding: EdgeInsets.only(top: util.height10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _openCountryPicker,
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: blackColor.withValues(alpha: 0.15)),
                            borderRadius: BorderRadius.circular(12),
                            color: whiteColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dialValue,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize14,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: util.fontSize18,
                                color: blackColor.withValues(alpha: 0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: util.width8),
                      Expanded(
                        child: TextField(
                          key: ValueKey(
                              '${widget.countryCode}-${widget.mobileLength}'),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                                widget.mobileLength),
                          ],
                          onChanged: widget.onMobileChange,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: LoginConstants.mobilePlaceholder.tr,
                            filled: true,
                            fillColor: whiteColor,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: blackColor.withValues(alpha: 0.15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: widget.validationError != null
                                      ? errorColor
                                      : blackColor.withValues(alpha: 0.15)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        ),
        if (widget.validationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(widget.validationError!.tr,
                style: TextStyle(color: errorColor, fontSize: 12)),
          ),
        if (widget.mode == WhatsAppPhoneMode.different &&
            widget.mobile.isNotEmpty &&
            !isValidWhatsAppMobile(widget.mobile, widget.mobileLength))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Enter a valid mobile number.'.tr,
                style: TextStyle(color: errorColor, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _radioTile({
    required MyUtility util,
    required bool selected,
    required VoidCallback onTap,
    required String title,
    String? subtitle,
    Widget? child,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(util.width20),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? mainColor.withValues(alpha: 0.35)
                : blackColor.withValues(alpha: 0.08),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? null
              : [
                  BoxShadow(
                    color: blackColor.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? mainColor : blackColor.withValues(alpha: 0.35),
                  size: 22,
                ),
                SizedBox(width: util.width8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize14,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: util.height10),
              Padding(
                padding: EdgeInsets.only(left: util.width20 + util.width8),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize12,
                    color: blackColor.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ],
            if (child != null) child,
          ],
        ),
      ),
    );
  }
}
