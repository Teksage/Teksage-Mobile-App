import 'package:astro_prompt/Components/AskAstrologer/ask_astrologer_answer_attribution.dart';
import 'package:astro_prompt/Components/Common/voice_answer_player.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Services/AskAstrologerService/askAstrologerService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AskAstrologerAnswerDialog extends StatefulWidget {
  final int requestId;
  const AskAstrologerAnswerDialog({super.key, required this.requestId});

  @override
  State<AskAstrologerAnswerDialog> createState() =>
      _AskAstrologerAnswerDialogState();
}

class _AskAstrologerAnswerDialogState extends State<AskAstrologerAnswerDialog> {
  AskAstrologerRequest? request;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data =
        await AskAstrologerService().fetchRequest(widget.requestId);
    if (mounted) {
      setState(() {
        request = data;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: loading
            ? SizedBox(
                height: 120,
                child: Center(
                    child: CircularProgressIndicator(color: mainColor)))
            : request == null
                ? Text('Could not load answer. Please try again.'.tr)
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Astrologer's Answer".tr,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.bold),
                                    fontSize: util.fontSize18)),
                            IconButton(
                              icon: SvgPicture.asset(closeButton),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text('Your question'.tr,
                            style: TextStyle(
                                fontSize: 12,
                                color: blackColor.withValues(alpha: 0.5))),
                        Text(request!.userQuestion,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium))),
                        SizedBox(height: 16),
                        if (request!.answerText != null &&
                            request!.answerText!.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: blackColor.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(request!.answerText!),
                          ),
                        if (request!.answerVoiceUrl != null) ...[
                          SizedBox(height: 12),
                          Text('Voice answer'.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize12,
                                  color: blackColor.withValues(alpha: 0.5))),
                          SizedBox(height: 8),
                          VoiceAnswerPlayer(
                            audioUrl: request!.answerVoiceUrl!,
                            durationSec: request!.answerVoiceDurationSec,
                          ),
                        ],
                        if (request!.answeredByAstrologerName != null &&
                            request!.answeredByAstrologerProfilePath != null)
                          AskAstrologerAnswerAttribution(
                            name: request!.answeredByAstrologerName!,
                            profilePath:
                                request!.answeredByAstrologerProfilePath!,
                          ),
                        if (request!.answeredAt != null)
                          AskAstrologerAnswerDateLabel(
                            answeredAt: request!.answeredAt!,
                          ),
                        if ((request!.answerText == null ||
                                request!.answerText!.isEmpty) &&
                            request!.answerVoiceUrl == null)
                          Text('No answer content available yet.'.tr),
                      ],
                    ),
                  ),
      ),
    );
  }
}

void showAskAstrologerAnswerDialog(BuildContext context, int requestId) {
  showDialog(
    context: context,
    builder: (_) => AskAstrologerAnswerDialog(requestId: requestId),
  );
}
