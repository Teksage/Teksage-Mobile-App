import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class PredictionQuote extends StatelessWidget {
  final String quote;
  const PredictionQuote({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Column(
      children: [
        SizedBox(height: util.responsiveHeight(0.0207)),
        Text(
          quote,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: AppFont.get(FontType.semiBold),
              fontSize: util.fontSize16,
              height: util.lineHeight19_2 / util.fontSize16,
              color: blackColor.withValues(alpha: 0.7)),
        ),
        SizedBox(height: util.responsiveHeight(0.0207)),
      ],
    );
  }
}
