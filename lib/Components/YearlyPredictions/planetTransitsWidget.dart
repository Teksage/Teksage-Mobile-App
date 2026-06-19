import 'package:astro_prompt/Components/YearlyPredictions/planetCard.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';


class PlanetTransitsWidget extends StatelessWidget {
  final PlanetTransits planetTransits;

  const PlanetTransitsWidget({super.key, required this.planetTransits});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    final List<MapEntry<String, PlanetDetails>> transitEntries = [
      MapEntry("Jupiter", planetTransits.jupiter),
      MapEntry("Saturn", planetTransits.saturn),
      MapEntry("Rahu", planetTransits.rahu),
      MapEntry("Ketu", planetTransits.ketu),
      MapEntry("Current_Dasa", planetTransits.currentDasa),
    ];

    return Padding(
      padding: EdgeInsets.only(left: util.width20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              transitEntries.length,
              (index) => Padding(
                padding: EdgeInsets.only(right: util.width10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: util.responsiveWidth(0.8667),
                      maxWidth: util.responsiveWidth(0.8667)),
                  child: PlanetCard(
                    planet: transitEntries[index].key,
                    details: transitEntries[index].value,
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
