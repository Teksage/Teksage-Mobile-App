import 'package:astro_prompt/Utility/imageConstant.dart';

class LifePredictions {
  final String title;
  final String content;
  final String icon;

  LifePredictions({required this.title, required this.content, required this.icon});
}

class LifePredictionModel {
  final List<LifePredictions> predictions;
  final int? predictionId;

  LifePredictionModel({
    required this.predictions,
    this.predictionId,
  });

  factory LifePredictionModel.fromJson(Map<String, dynamic> json, {int? predictionId}) {
    return LifePredictionModel(
      predictions: [
        LifePredictions(title: 'General', content: json['general'], icon: lifeGeneral ?? ''),
        LifePredictions(title: 'Career', content: json['career'], icon: lifeCareer ?? ''),
        LifePredictions(title: 'Relationship', content: json['relationship'], icon: lifeRelation ?? ''),
        LifePredictions(title: 'Wealth', content: json['wealth'], icon: lifeWealth ?? ''),
        LifePredictions(title: 'Health', content: json['health'], icon: lifeHealth ?? ''),
        LifePredictions(title: 'Current Time Period', content: json['current_time_period'], icon: lifeCurrent ?? ''),
      ],
      predictionId: predictionId,
    );
  }
}
