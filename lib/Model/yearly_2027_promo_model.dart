class Yearly2027Scores {
  final int career;
  final int relationship;
  final int finance;
  final int health;

  const Yearly2027Scores({
    required this.career,
    required this.relationship,
    required this.finance,
    required this.health,
  });

  factory Yearly2027Scores.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw const FormatException('scores missing');
    }
    int parse(String key) {
      final n = int.tryParse('${json[key]}');
      if (n == null || n < 1 || n > 5) {
        throw FormatException('invalid score $key');
      }
      return n;
    }

    return Yearly2027Scores(
      career: parse('career'),
      relationship: parse('relationship'),
      finance: parse('finance'),
      health: parse('health'),
    );
  }
}

class Yearly2027PromoStatus {
  final bool showBanner;
  final bool showSheet;
  final bool hiddenToday;
  final Yearly2027Scores? scores;
  final bool isPremium;
  final bool hasYearly;
  final bool generating;

  const Yearly2027PromoStatus({
    required this.showBanner,
    required this.showSheet,
    required this.hiddenToday,
    required this.scores,
    required this.isPremium,
    required this.hasYearly,
    required this.generating,
  });

  factory Yearly2027PromoStatus.fromJson(Map<String, dynamic> json) {
    Yearly2027Scores? scores;
    try {
      final raw = json['scores'];
      if (raw is Map<String, dynamic>) {
        scores = Yearly2027Scores.fromJson(raw);
      }
    } catch (_) {
      scores = null;
    }
    return Yearly2027PromoStatus(
      showBanner: json['show_banner'] as bool? ?? false,
      showSheet: json['show_sheet'] as bool? ?? false,
      hiddenToday: json['hidden_today'] as bool? ?? false,
      scores: scores,
      isPremium: json['is_premium'] as bool? ?? false,
      hasYearly: json['has_yearly'] as bool? ?? false,
      generating: json['generating'] as bool? ?? false,
    );
  }
}
