import 'package:astro_prompt/config/login_constants.dart';
import 'package:astro_prompt/config/phone_national_lengths.dart';

class PhoneParts {
  final String countryCode;
  final String mobile;

  const PhoneParts({required this.countryCode, required this.mobile});
}

String digitsOnly(String? value) {
  return (value ?? '').replaceAll(RegExp(r'\D'), '');
}

int? _expectedNationalLength(String cc, int? override) {
  if (override != null && override > 0) return override;
  return phoneNationalLengthByDial[cc];
}

/// Strip dial code from mobile only when it is a combined paste, not national digits.
String stripRedundantDialPrefix(
  String cc,
  String mobile, {
  int? expectedNationalLength,
}) {
  if (cc.isEmpty || !mobile.startsWith(cc) || mobile.length <= cc.length) {
    return mobile;
  }

  final remainder = mobile.substring(cc.length);
  final expected = _expectedNationalLength(cc, expectedNationalLength);

  if (expected != null) {
    if (mobile.length == expected) return mobile;
    if (remainder.length == expected) return remainder;
    return mobile;
  }

  if (mobile.length > 12 && remainder.length >= 7 && remainder.length <= 12) {
    return remainder;
  }
  return mobile;
}

/// Canonical split for profile display and API payloads.
PhoneParts normalizePhoneParts(
  String? countryCode,
  String? mobile, {
  int? expectedNationalLength,
}) {
  final cc = digitsOnly(countryCode);
  var national = digitsOnly(mobile);

  if (national.isEmpty && cc.isEmpty) {
    return PhoneParts(
      countryCode: LoginConstants.defaultCountryCodeNumeric,
      mobile: '',
    );
  }

  national = stripRedundantDialPrefix(
    cc,
    national,
    expectedNationalLength: expectedNationalLength,
  );

  return PhoneParts(
    countryCode: cc.isEmpty ? LoginConstants.defaultCountryCodeNumeric : cc,
    mobile: national,
  );
}

/// Normalize user-entered mobile text before verify / change-contact API calls.
String normalizeEnteredMobileNumber(
  String dialCode,
  String rawText, {
  int? expectedNationalLength,
}) {
  final cc = digitsOnly(dialCode);
  final mobile = digitsOnly(rawText);
  if (cc.isEmpty) return mobile;
  return stripRedundantDialPrefix(
    cc,
    mobile,
    expectedNationalLength: expectedNationalLength,
  );
}
