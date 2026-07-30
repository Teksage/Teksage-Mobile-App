class MuhurthaDaySegment {
  final String period;
  final String? nakshatra;
  final int? tharaBala;
  final int? chandraBala;
  final String? amirthathiYoga;
  final bool isSuitable;
  final String? reasonCode;
  final List<String> reasonCodes;
  final String? rating;
  final String? window;
  final List<String> windows;

  MuhurthaDaySegment({
    required this.period,
    this.nakshatra,
    this.tharaBala,
    this.chandraBala,
    this.amirthathiYoga,
    required this.isSuitable,
    this.reasonCode,
    this.reasonCodes = const [],
    this.rating,
    this.window,
    this.windows = const [],
  });

  factory MuhurthaDaySegment.fromJson(Map<String, dynamic> json) {
    return MuhurthaDaySegment(
      period: json['period'] as String? ?? '',
      nakshatra: json['nakshatra'] as String?,
      tharaBala: json['thara_bala'] as int?,
      chandraBala: json['chandra_bala'] as int?,
      amirthathiYoga: json['amirthathi_yoga'] as String?,
      isSuitable: json['is_suitable'] == true,
      reasonCode: json['reason_code'] as String?,
      reasonCodes: List<String>.from(json['reason_codes'] ?? []),
      rating: json['rating'] as String?,
      window: json['window'] as String?,
      windows: List<String>.from(json['windows'] ?? []),
    );
  }
}

class MuhurthaDayResult {
  final String date;
  final String isoDate;
  final bool isSuitable;
  final String? reasonCode;
  final List<String> reasonCodes;
  final String? rating;
  final String? window;
  final List<String> windows;
  final String? weekday;
  final String? nakshatra;
  final String? thithi;
  final String? thithiEnds;
  final int? tharaBala;
  final int? chandraBala;
  final String? amirthathiYoga;
  final String? dayinfo;
  final List<MuhurthaDaySegment> segments;

  MuhurthaDayResult({
    required this.date,
    required this.isoDate,
    required this.isSuitable,
    this.reasonCode,
    this.reasonCodes = const [],
    this.rating,
    this.window,
    this.windows = const [],
    this.weekday,
    this.nakshatra,
    this.thithi,
    this.thithiEnds,
    this.tharaBala,
    this.chandraBala,
    this.amirthathiYoga,
    this.dayinfo,
    this.segments = const [],
  });

  factory MuhurthaDayResult.fromJson(Map<String, dynamic> json) {
    return MuhurthaDayResult(
      date: json['date'] as String? ?? '',
      isoDate: json['iso_date'] as String? ?? '',
      isSuitable: json['is_suitable'] == true,
      reasonCode: json['reason_code'] as String?,
      reasonCodes: List<String>.from(json['reason_codes'] ?? []),
      rating: json['rating'] as String?,
      window: json['window'] as String?,
      windows: List<String>.from(json['windows'] ?? []),
      weekday: json['weekday'] as String?,
      nakshatra: json['nakshatra'] as String?,
      thithi: json['thithi'] as String?,
      thithiEnds: json['thithi_ends'] as String?,
      tharaBala: json['thara_bala'] as int?,
      chandraBala: json['chandra_bala'] as int?,
      amirthathiYoga: json['amirthathi_yoga'] as String?,
      dayinfo: json['dayinfo'] as String?,
      segments: (json['segments'] as List<dynamic>?)
              ?.map((e) => MuhurthaDaySegment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'iso_date': isoDate,
        'is_suitable': isSuitable,
        if (reasonCode != null) 'reason_code': reasonCode,
        if (reasonCodes.isNotEmpty) 'reason_codes': reasonCodes,
        if (rating != null) 'rating': rating,
        if (window != null) 'window': window,
        if (windows.isNotEmpty) 'windows': windows,
        if (weekday != null) 'weekday': weekday,
        if (nakshatra != null) 'nakshatra': nakshatra,
        if (thithi != null) 'thithi': thithi,
        if (thithiEnds != null) 'thithi_ends': thithiEnds,
        if (tharaBala != null) 'thara_bala': tharaBala,
        if (chandraBala != null) 'chandra_bala': chandraBala,
        if (amirthathiYoga != null) 'amirthathi_yoga': amirthathiYoga,
        if (dayinfo != null) 'dayinfo': dayinfo,
        if (segments.isNotEmpty)
          'segments': segments
              .map((s) => {
                    'period': s.period,
                    'is_suitable': s.isSuitable,
                    if (s.reasonCode != null) 'reason_code': s.reasonCode,
                    if (s.reasonCodes.isNotEmpty) 'reason_codes': s.reasonCodes,
                    if (s.rating != null) 'rating': s.rating,
                    if (s.window != null) 'window': s.window,
                    if (s.windows.isNotEmpty) 'windows': s.windows,
                  })
              .toList(),
      };
}

class MuhurthaResult {
  final String event;
  final String startDate;
  final String endDate;
  final String location;
  final List<MuhurthaDayResult> days;
  final List<MuhurthaDayResult> dates;
  final String? summaryText;
  final String? message;

  MuhurthaResult({
    required this.event,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.days = const [],
    this.dates = const [],
    this.summaryText,
    this.message,
  });

  List<MuhurthaDayResult> get displayDays =>
      days.isNotEmpty ? days : dates;

  factory MuhurthaResult.fromJson(Map<String, dynamic> json) {
    List<MuhurthaDayResult> parseDays(String key) =>
        (json[key] as List<dynamic>?)
                ?.map((e) => MuhurthaDayResult.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
    return MuhurthaResult(
      event: json['event'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      days: parseDays('days'),
      dates: parseDays('dates'),
      summaryText: json['summary_text'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'event': event,
        'start_date': startDate,
        'end_date': endDate,
        'location': location,
        'days': displayDays.map((d) => d.toJson()).toList(),
        'dates': dates.map((d) => d.toJson()).toList(),
        if (summaryText != null) 'summary_text': summaryText,
        if (message != null) 'message': message,
      };
}

class MuhurthaPayload {
  final int muhurthaId;
  final MuhurthaResult result;

  MuhurthaPayload({required this.muhurthaId, required this.result});

  factory MuhurthaPayload.fromJson(Map<String, dynamic> json) {
    final id = json['event_planner_id'] ?? json['muhurtha_id'] ?? 0;
    final raw = json['data'];
    final resultJson = (raw is Map<String, dynamic>) ? raw : json;
    return MuhurthaPayload(
      muhurthaId: id is int ? id : int.tryParse('$id') ?? 0,
      result: MuhurthaResult.fromJson(resultJson),
    );
  }
}
