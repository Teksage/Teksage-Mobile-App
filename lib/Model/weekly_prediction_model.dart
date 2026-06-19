class WeeklyPredictionModel {
  final String day;
  final String shortPrediction;
  final String longPrediction;
  final bool isPositiveDay;
  final int tharaBala;
  final int chandraBala;

  WeeklyPredictionModel({
    required this.day,
    required this.shortPrediction,
    required this.longPrediction,
    required this.isPositiveDay,
    required this.tharaBala,
    required this.chandraBala,
  });

  factory WeeklyPredictionModel.fromJson(String day, Map<String, dynamic> json) {
    return WeeklyPredictionModel(
      day: capitalizeFirstLetter(day),
      shortPrediction: json['short_prediction'],
      longPrediction: json['long_prediction'],
      isPositiveDay: json['is_positive_day'],
      tharaBala: json['thara_bala'],
      chandraBala: json['chandra_bala'],
    );
  }

  static String capitalizeFirstLetter(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}
