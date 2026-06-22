class FeatureDiscoveryStatus {
  final int lifetimeChatCount;
  final bool dismissed;
  final bool shouldShowPopup;

  FeatureDiscoveryStatus({
    required this.lifetimeChatCount,
    required this.dismissed,
    required this.shouldShowPopup,
  });

  factory FeatureDiscoveryStatus.fromJson(Map<String, dynamic> json) {
    return FeatureDiscoveryStatus(
      lifetimeChatCount: json['lifetime_chat_count'] as int? ?? 0,
      dismissed: json['dismissed'] as bool? ?? false,
      shouldShowPopup: json['should_show_popup'] as bool? ?? false,
    );
  }
}
