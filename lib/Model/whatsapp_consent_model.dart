class WhatsAppConsentState {
  final bool granted;
  final String? phoneMasked;
  final String? consentSentAt;
  final String? grantedAt;
  final String? revokedAt;
  final bool canResend;
  final String? resendAvailableAt;

  const WhatsAppConsentState({
    required this.granted,
    this.phoneMasked,
    this.consentSentAt,
    this.grantedAt,
    this.revokedAt,
    this.canResend = true,
    this.resendAvailableAt,
  });

  factory WhatsAppConsentState.fromJson(Map<String, dynamic> json) {
    return WhatsAppConsentState(
      granted: json['granted'] == true,
      phoneMasked: json['phone_masked'] as String?,
      consentSentAt: json['consent_sent_at'] as String?,
      grantedAt: json['granted_at'] as String?,
      revokedAt: json['revoked_at'] as String?,
      canResend: json['can_resend'] != false,
      resendAvailableAt: json['resend_available_at'] as String?,
    );
  }

  bool get isPending =>
      consentSentAt != null && !granted && revokedAt == null;
}
