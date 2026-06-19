import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class BulletPoints extends StatelessWidget {
  final String content;
  const BulletPoints({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Padding(
      padding: EdgeInsets.only(bottom: util.width12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: util.fontSize24,
              height: 1.0,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: util.width12),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.medium),
                fontSize: util.fontSize14,
                height: 1.5,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
