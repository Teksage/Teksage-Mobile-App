class DailyPredictionModel {
  final List<String> career;
  final List<String> relationship;
  final List<String> wealth;
  final List<String> health;
  final String tharaBala;
  final String chandraBala;

  DailyPredictionModel({
    required this.career,
    required this.relationship,
    required this.wealth,
    required this.health,
    required this.tharaBala,
    required this.chandraBala,
  });

  factory DailyPredictionModel.fromJson(Map<String, dynamic> json) {
    return DailyPredictionModel(
      career: List<String>.from(json['career'] ?? []),
      relationship: List<String>.from(json['relationship'] ?? []),
      wealth: List<String>.from(json['wealth'] ?? []),
      health: List<String>.from(json['health'] ?? []),
      tharaBala: json['thara_bala']?.toString() ?? '',
      chandraBala: json['chandra_bala']?.toString() ?? '',
    );
  }
}
