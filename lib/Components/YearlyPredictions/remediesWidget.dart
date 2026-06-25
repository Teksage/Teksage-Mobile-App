import 'package:astro_prompt/Components/YearlyPredictions/remediesCard.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';

class RemediesWidget extends StatelessWidget {
  final Remedies remedies;
  const RemediesWidget({super.key, required this.remedies});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    final List<MapEntry<String, String>> remedyEntries = [
      MapEntry("Chanting", remedies.chanting),
      MapEntry("Puja", remedies.puja),
      MapEntry("Charity", remedies.charity),
    ];

    return Padding(
      padding: EdgeInsets.only(left: util.width20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              remedyEntries.length,
                  (index) => Padding(
                padding: EdgeInsets.only(right: util.width10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: util.responsiveWidth(0.8667), maxWidth: util.responsiveWidth(0.8667)),
                  child: RemediesCard(
                    title: remedyEntries[index].key,
                    description: remedyEntries[index].value,
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
