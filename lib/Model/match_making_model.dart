class MatchMakingModel {
  final GetMatchMakingModel data;
  final int matchMakingId;

  MatchMakingModel({
    required this.data,
    required this.matchMakingId,
  });

  factory MatchMakingModel.fromJson(Map<String, dynamic> json) {
    return MatchMakingModel(
      data: GetMatchMakingModel.fromJson(json['data']),
      matchMakingId: json['match_making_id'],
    );
  }
}

class GetMatchMakingModel {
  final String boyName;
  final String girlName;
  final String boyRashi;
  final String girlRashi;
  final String boyNakshatram;
  final String girlNakshatram;
  final CompatibilityResult compatibilityResult;

  GetMatchMakingModel({
    required this.boyName,
    required this.girlName,
    required this.boyRashi,
    required this.girlRashi,
    required this.boyNakshatram,
    required this.girlNakshatram,
    required this.compatibilityResult,
  });

  factory GetMatchMakingModel.fromJson(Map<String, dynamic> json) {
    return GetMatchMakingModel(
      boyName: json['boy_name'],
      girlName: json['girl_name'],
      boyRashi: json["boy_rashi"],
      girlRashi: json["girl_rashi"],
      boyNakshatram: json["boy_nakshatra"],
      girlNakshatram: json["girl_nakshatra"],
      compatibilityResult: CompatibilityResult.fromJson(json["compatibility_result"]),
    );
  }
}

class GetNewMatchMakingModel {
  final CompatibilityResult compatibilityResult;
  final int matchMakingId;

  GetNewMatchMakingModel({
    required this.compatibilityResult,
    required this.matchMakingId,
  });

  factory GetNewMatchMakingModel.fromJson(Map<String, dynamic> json) {
    return GetNewMatchMakingModel(
      compatibilityResult: CompatibilityResult.fromJson(json['data']),
      matchMakingId: json['match_making_id'],
    );
  }
}

class CompatibilityResult {
  final int maxScore;
  final int gainedScore;
  final String generalDetails;
  final List<Kuta> kutas;

  CompatibilityResult({
    required this.maxScore,
    required this.gainedScore,
    required this.generalDetails,
    required this.kutas,
  });

  factory CompatibilityResult.fromJson(Map<String, dynamic> json) {
    return CompatibilityResult(
      maxScore: json["max_score"],
      gainedScore: json["gained"],
      generalDetails: json["general_details"],
      kutas: (json["kutas"] as List).map((e) => Kuta.fromJson(e)).toList(),
    );
  }
}

class Kuta {
  final String kuta;
  final int max;
  final int gained;
  final String details;
  final bool present;

  Kuta({
    required this.kuta,
    required this.max,
    required this.gained,
    required this.details,
    required this.present,
  });

  factory Kuta.fromJson(Map<String, dynamic> json) {
    return Kuta(
      kuta: json["kuta"],
      max: json["max"],
      gained: json["gained"],
      details: json["details"],
      present: json["present"],
    );
  }
}
