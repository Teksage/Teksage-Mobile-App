import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class TermsContentSection extends StatelessWidget {
  final String title;
  final String content;

  const TermsContentSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.semiBold),
              fontSize: util.fontSize20,
              height: 1.1,
              color: Colors.black,
            ),
          ),
          SizedBox(height: util.width12),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.medium),
              fontSize: util.fontSize14,
              height: 1.5,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
