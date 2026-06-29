import 'package:astro_prompt/config/consultation_navigation.dart';
import 'package:astro_prompt/Screens/AskAstrologer/ask_astrologer_language_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessageActions extends StatelessWidget {
  final String userQuestion;
  final String aiResponse;

  const ChatMessageActions({
    super.key,
    required this.userQuestion,
    required this.aiResponse,
  });

  Future<void> _handleAskAstrologer() async {
    await writeAskAstrologerFlow(AskAstrologerFlowState(
      userQuestion: userQuestion,
      aiResponse: aiResponse,
    ));
    Get.to(() => AskAstrologerLanguagePage(userQuestion: userQuestion));
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // Align with bot bubble (avatar ~33px + gap) — mirrors website ChatMessageBubble layout.
    final actionLeadingInset = util.width8 + util.responsiveWidth(0.0855);

    return Padding(
      padding: EdgeInsets.only(
        left: actionLeadingInset,
        top: 4,
        bottom: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _handleAskAstrologer,
              style: OutlinedButton.styleFrom(
                foregroundColor: mainColor,
                side: BorderSide(color: mainColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Ask Astrologer'.tr,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize12,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: util.width8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => openBookConsultation(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: blackColor.withValues(alpha: 0.7),
                side: BorderSide(color: blackColor.withValues(alpha: 0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Book Consultation'.tr,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize12,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
