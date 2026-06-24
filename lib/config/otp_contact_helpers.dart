/// Masks contact info on OTP screens (mirrors website `OtpVerifyView`).
String maskMobileForOtpDisplay(String mobile) {
  final digits = mobile.replaceAll(RegExp(r'\D'), '');
  final match = RegExp(r'(\d{2})\d{6}(\d{2})').firstMatch(digits);
  if (match == null) return digits;
  return '${match.group(1)}xxxxxx${match.group(2)}';
}
String maskEmailForOtpDisplay(String email) {
  final match = RegExp(r'^(.{2}).*(@.*)$').firstMatch(email);
  if (match == null) return email;
  return '${match.group(1)}****${match.group(2)}';
}

String maskOtpContactForDisplay({
  required String contact,
  required bool isMobile,
}) {
  return isMobile
      ? maskMobileForOtpDisplay(contact)
      : maskEmailForOtpDisplay(contact);
}
