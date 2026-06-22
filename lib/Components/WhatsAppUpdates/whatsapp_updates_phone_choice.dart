import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/login_constants.dart';
import 'package:astro_prompt/config/whatsapp_consent_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum WhatsAppPhoneMode { profile, different }

class WhatsAppUpdatesPhoneChoice extends StatelessWidget {
  final WhatsAppPhoneMode mode;
  final String profileMasked;
  final String countryCode;
  final String mobile;
  final ValueChanged<WhatsAppPhoneMode> onModeChange;
  final ValueChanged<String> onCountryCodeChange;
  final ValueChanged<String> onMobileChange;
  final String? validationError;

  const WhatsAppUpdatesPhoneChoice({
    super.key,
    required this.mode,
    required this.profileMasked,
    required this.countryCode,
    required this.mobile,
    required this.onModeChange,
    required this.onCountryCodeChange,
    required this.onMobileChange,
    this.validationError,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final dialValue = LoginConstants.dialOptions
            .where((o) => o.countryCodeNumeric == countryCode.replaceAll(RegExp(r'\D'), ''))
            .map((o) => o.dialCode)
            .firstOrNull ??
        '+$countryCode';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _radioTile(
          util: util,
          selected: mode == WhatsAppPhoneMode.profile,
          onTap: () => onModeChange(WhatsAppPhoneMode.profile),
          title: 'Use my verified profile number'.tr,
          subtitle: profileMasked,
        ),
        SizedBox(height: util.height10),
        _radioTile(
          util: util,
          selected: mode == WhatsAppPhoneMode.different,
          onTap: () => onModeChange(WhatsAppPhoneMode.different),
          title: 'Use a different WhatsApp number'.tr,
          child: mode == WhatsAppPhoneMode.different
              ? Padding(
                  padding: EdgeInsets.only(top: util.height10),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: blackColor.withValues(alpha: 0.15)),
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dialValue,
                            items: LoginConstants.dialOptions
                                .map((o) => DropdownMenuItem(
                                      value: o.dialCode,
                                      child: Text(o.dialCode,
                                          style: TextStyle(
                                              fontFamily: AppFont.get(FontType.semiBold),
                                              fontSize: util.fontSize14)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              final match = LoginConstants.dialOptions
                                  .firstWhere((o) => o.dialCode == value);
                              onCountryCodeChange(match.countryCodeNumeric);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: util.width8),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 10,
                          onChanged: onMobileChange,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: LoginConstants.mobilePlaceholder.tr,
                            filled: true,
                            fillColor: whiteColor,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: blackColor.withValues(alpha: 0.15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: validationError != null
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
        if (validationError != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(validationError!.tr,
                style: TextStyle(color: errorColor, fontSize: 12)),
          ),
        if (mode == WhatsAppPhoneMode.different &&
            mobile.isNotEmpty &&
            !isValidWhatsAppMobile(mobile))
          Padding(
            padding: EdgeInsets.only(top: 8),
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
                    color: blackColor.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? mainColor : blackColor.withValues(alpha: 0.2),
                  width: 2,
                ),
                color: selected ? mainColor : whiteColor,
              ),
            ),
            SizedBox(width: util.width12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.medium),
                          fontSize: util.fontSize14)),
                  if (subtitle != null) ...[
                    SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: util.fontSize13,
                            color: blackColor.withValues(alpha: 0.65))),
                  ],
                  if (child != null) child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
