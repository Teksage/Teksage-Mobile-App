const whatsAppResendCooldownMs = 120000;

String maskPhoneForDisplay(String countryCode, String mobile) {
  final cc = countryCode.replaceAll(RegExp(r'\D'), '');
  final national = mobile.replaceAll(RegExp(r'\D'), '');
  if (national.isEmpty) return '+${cc.isEmpty ? '91' : cc}';
  if (national.length <= 4) return '+${cc.isEmpty ? '91' : cc} ****';
  return '+${cc.isEmpty ? '91' : cc} ${'*' * (national.length - 4)}${national.substring(national.length - 4)}';
}

String formatResendCountdown(int totalSeconds) {
  final safe = totalSeconds < 0 ? 0 : totalSeconds;
  final minutes = safe ~/ 60;
  final seconds = safe % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

int? _parseApiUtcMs(String? iso) {
  if (iso == null || iso.trim().isEmpty) return null;
  final trimmed = iso.trim();
  final hasZone = RegExp(r'[zZ]$|[+-]\d{2}:\d{2}$').hasMatch(trimmed);
  final normalized = hasZone ? trimmed : '${trimmed}Z';
  return DateTime.tryParse(normalized)?.millisecondsSinceEpoch;
}

int getResendSecondsRemaining({
  String? consentSentAt,
  String? resendAvailableAt,
  int nowMs = 0,
}) {
  final now = nowMs > 0 ? nowMs : DateTime.now().millisecondsSinceEpoch;
  final targetMs = _parseApiUtcMs(resendAvailableAt);
  if (targetMs != null) {
    return ((targetMs - now) / 1000).ceil().clamp(0, 999999);
  }
  final sentMs = _parseApiUtcMs(consentSentAt);
  if (sentMs == null) return 0;
  final elapsed = now - sentMs;
  return ((whatsAppResendCooldownMs - elapsed) / 1000).ceil().clamp(0, 999999);
}

bool isValidWhatsAppMobile(String mobile) {
  return RegExp(r'^[1-9]\d{9}$').hasMatch(mobile);
}
