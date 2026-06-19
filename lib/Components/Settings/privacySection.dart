import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class PrivacySection extends StatelessWidget {
  final String title;
  final String content;

  const PrivacySection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize16,
                height: 1.1,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: ' ', // space between title and content
              style: TextStyle(fontSize: util.fontSize16),
            ),
            TextSpan(
              text: content,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: util.fontSize14,
                height: 1.5,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
