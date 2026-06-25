import 'dart:convert';

class YearlyPredictionModel {
  final PlanetTransits planetTransits;
  final YearlyPrediction prediction;
  final Remedies remedies;
  final String general;
  final int? predictionId;

  YearlyPredictionModel({
    required this.planetTransits,
    required this.prediction,
    required this.remedies,
    required this.general,
    this.predictionId,
  });

  factory YearlyPredictionModel.fromJson(Map<String, dynamic> json, {int? predictionId}) {
    return YearlyPredictionModel(
      planetTransits: PlanetTransits.fromJson(json['planet_transits']),
      prediction: YearlyPrediction.fromJson(json['prediction']),
      remedies: Remedies.fromJson(json['remedies']),
      general: json['general'] ?? '',
      predictionId: predictionId,
    );
  }

  static YearlyPredictionModel fromRawJson(String str, {int? predictionId}) =>
      YearlyPredictionModel.fromJson(json.decode(str), predictionId: predictionId);
}

class PlanetTransits {
  final PlanetDetails jupiter;
  final PlanetDetails saturn;
  final PlanetDetails rahu;
  final PlanetDetails ketu;
  final PlanetDetails currentDasa;

  PlanetTransits({
    required this.jupiter,
    required this.saturn,
    required this.rahu,
    required this.ketu,
    required this.currentDasa,
  });

  factory PlanetTransits.fromJson(Map<String, dynamic> json) {
    return PlanetTransits(
      jupiter: PlanetDetails.fromJson(json['jupiter']),
      saturn: PlanetDetails.fromJson(json['saturn']),
      rahu: PlanetDetails.fromJson(json['rahu']),
      ketu: PlanetDetails.fromJson(json['ketu']),
      currentDasa: PlanetDetails.fromJson(json['current_dasa']),
    );
  }
}

class PlanetDetails {
  final String year;
  final String endMonth;
  final String startMonth;
  final String beforeDetails;
  final String afterDetails;

  PlanetDetails({
    required this.year,
    required this.endMonth,
    required this.startMonth,
    required this.beforeDetails,
    required this.afterDetails,
  });

  factory PlanetDetails.fromJson(Map<String, dynamic> json) {
    return PlanetDetails(
      year: json['change_year'] ?? '',
      endMonth: json['before_dasa_change']['end-month'] ?? '',
      startMonth: json['after_dasa_change']['start-month'] ?? '',
      beforeDetails: json['before_dasa_change']['details'] ?? '',
      afterDetails: json['after_dasa_change']['details'] ?? '',
    );
  }
}

class YearlyPrediction {
  final String career;
  final String finance;
  final String health;
  final String relationship;

  YearlyPrediction({
    required this.career,
    required this.finance,
    required this.health,
    required this.relationship,
  });

  factory YearlyPrediction.fromJson(Map<String, dynamic> json) {
    return YearlyPrediction(
      career: json['career'] ?? '',
      finance: json['finance'] ?? '',
      health: json['health'] ?? '',
      relationship: json['relationship'] ?? '',
    );
  }
}

class Remedies {
  final String chanting;
  final String puja;
  final String charity;

  Remedies({
    required this.chanting,
    required this.puja,
    required this.charity,
  });

  factory Remedies.fromJson(Map<String, dynamic> json) {
    return Remedies(
      chanting: json['chanting'] ?? '',
      puja: json['puja'] ?? '',
      charity: json['charity'] ?? '',
    );
  }
}
