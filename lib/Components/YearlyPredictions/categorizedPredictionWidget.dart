import 'package:astro_prompt/Components/YearlyPredictions/overviewCard.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';

class CategorizedPredictionWidget extends StatelessWidget {
  final YearlyPrediction prediction;

  const CategorizedPredictionWidget({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    final List<MapEntry<String, String>> predictionEntries = [
      MapEntry("Career Overview", prediction.career),
      MapEntry("Finance Overview", prediction.finance),
      MapEntry("Health Overview", prediction.health),
      MapEntry("Marriage/Relationship Overview", prediction.relationship),
    ];

    return Padding(
      padding: EdgeInsets.only(left: util.width20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              predictionEntries.length,
                  (index) => Padding(
                padding: EdgeInsets.only(right: util.width10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: util.responsiveWidth(0.8667), maxWidth: util.responsiveWidth(0.8667)),
                  child: OverViewCard(
                    title: predictionEntries[index].key,
                    description: predictionEntries[index].value,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
