import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/ask_astrologer_answer_utils.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AskAstrologerAnswerAttribution extends StatelessWidget {
  final String name;
  final String profilePath;

  const AskAstrologerAnswerAttribution({
    super.key,
    required this.name,
    required this.profilePath,
  });

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final displayUrl = buildAstrologerPublicProfileDisplayUrl(profilePath);
    final profileUrl = buildAstrologerPublicProfileUrl(profilePath);
    final baseStyle = TextStyle(
      fontSize: util.fontSize14,
      color: blackColor.withValues(alpha: 0.7),
      fontFamily: AppFont.get(FontType.medium),
      height: 1.4,
    );
    final linkStyle = baseStyle.copyWith(
      color: mainColor,
      decoration: TextDecoration.underline,
      decorationColor: mainColor,
    );

    return Padding(
      padding: EdgeInsets.only(top: util.height10),
      child: Text.rich(
        TextSpan(
          style: baseStyle,
          children: [
            TextSpan(text: '${'Answered by:'.tr} '),
            TextSpan(text: name),
            TextSpan(text: AskAstrologerScreenCopy.answeredBySeparator),
            TextSpan(
              text: displayUrl,
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final uri = Uri.parse(profileUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}

class AskAstrologerAnswerDateLabel extends StatelessWidget {
  final String answeredAt;

  const AskAstrologerAnswerDateLabel({super.key, required this.answeredAt});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final label = formatAskAnswerDateTime(answeredAt);
    if (label == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: util.height10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: util.fontSize12,
          color: blackColor.withValues(alpha: 0.4),
          fontFamily: AppFont.get(FontType.medium),
        ),
      ),
    );
  }
}
