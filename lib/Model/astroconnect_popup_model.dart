class AstroConnectPopupEvent {
  final int id;
  final String name;
  final String? description;
  final String startsAt;
  final String endsAt;
  final List<String> categories;

  AstroConnectPopupEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.startsAt,
    required this.endsAt,
    required this.categories,
  });

  factory AstroConnectPopupEvent.fromJson(Map<String, dynamic> json) {
    return AstroConnectPopupEvent(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      description: json['description']?.toString(),
      startsAt: '${json['starts_at'] ?? ''}',
      endsAt: '${json['ends_at'] ?? ''}',
      categories: List<String>.from(json['categories'] ?? const []),
    );
  }
}

class AstroConnectPopupStatus {
  final bool shouldShow;
  final AstroConnectPopupEvent? event;

  AstroConnectPopupStatus({required this.shouldShow, required this.event});

  factory AstroConnectPopupStatus.fromJson(Map<String, dynamic> json) {
    final raw = json['event'];
    return AstroConnectPopupStatus(
      shouldShow: json['should_show'] == true,
      event: raw is Map<String, dynamic> ? AstroConnectPopupEvent.fromJson(raw) : null,
    );
  }
}
