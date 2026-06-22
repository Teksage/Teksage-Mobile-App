import 'dart:io';

import 'package:astro_prompt/Components/Astrologer/ask_answer_voice_input.dart';
import 'package:astro_prompt/Components/Common/voice_answer_player.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Services/AskAstrologerService/astrologerAskService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskAstrologerRequestCard extends StatefulWidget {
  final AskAstrologerRequest request;
  final VoidCallback onAnswered;

  const AskAstrologerRequestCard({
    super.key,
    required this.request,
    required this.onAnswered,
  });

  @override
  State<AskAstrologerRequestCard> createState() =>
      _AskAstrologerRequestCardState();
}

class _AskAstrologerRequestCardState extends State<AskAstrologerRequestCard> {
  bool _expanded = false;
  bool _submitting = false;
  String _answerText = '';
  File? _voiceFile;
  int? _voiceDurationSec;
  final _service = AstrologerAskService();

  String get _statusLabel {
    if (widget.request.status == 'assigned') return 'Awaiting answer'.tr;
    if (widget.request.status == 'answered') return 'Answered'.tr;
    return widget.request.status;
  }

  Future<void> _submit() async {
    if (_answerText.trim().isEmpty && _voiceFile == null) {
      showErrorSnackBar(context, 'Provide an answer (text and/or voice).'.tr);
      return;
    }
    setState(() => _submitting = true);
    CustomLoader.show(context);
    final ok = await _service.submitAnswer(
      requestId: widget.request.id,
      answerText: _answerText,
      voiceFile: _voiceFile,
      voiceDurationSec: _voiceDurationSec,
    );
    CustomLoader.hide();
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) {
      showSuccessSnackBar(context, 'Answer submitted'.tr);
      widget.onAnswered();
    } else {
      showErrorSnackBar(context, 'Submit failed. Please try again.'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final req = widget.request;
    final langs = req.preferredLanguages
        .map((id) => AskAstrologerLanguages.labelFor(id).tr)
        .join(', ');

    return Container(
      margin: EdgeInsets.only(bottom: util.height20),
      padding: EdgeInsets.all(util.width20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blackColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Request #${req.id}',
                        style: TextStyle(
                            fontSize: 11,
                            color: blackColor.withValues(alpha: 0.45),
                            fontFamily: AppFont.get(FontType.semiBold))),
                    SizedBox(height: 6),
                    Text(req.userQuestion,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize15)),
                  ],
                ),
              ),
              if (req.status == 'assigned')
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? 'Cancel'.tr : 'Answer'.tr),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(_statusLabel,
              style: TextStyle(
                  fontSize: 12,
                  color: req.status == 'answered' ? mainColor : Colors.amber.shade800,
                  fontFamily: AppFont.get(FontType.semiBold))),
          Divider(height: 24, color: blackColor.withValues(alpha: 0.1)),
          _detailSection('Client details'.tr, [
            if (req.customerName != null) _detailRow('Name'.tr, req.customerName!),
            if (req.dateOfBirth != null) _detailRow('DOB'.tr, req.dateOfBirth!),
            if (req.timeOfBirth != null) _detailRow('TOB'.tr, req.timeOfBirth!),
            if (req.placeOfBirth != null) _detailRow('POB'.tr, req.placeOfBirth!),
            if (req.rashi != null) _detailRow('Rasi'.tr, req.rashi!),
            if (req.nakshatra != null) _detailRow('Nakshatra'.tr, req.nakshatra!),
            if (langs.isNotEmpty) _detailRow('Language'.tr, langs),
          ]),
          Divider(height: 24, color: blackColor.withValues(alpha: 0.1)),
          Text('AI Answer (for reference)'.tr,
              style: TextStyle(fontFamily: AppFont.get(FontType.semiBold))),
          SizedBox(height: 8),
          Text(req.aiResponse,
              style: TextStyle(
                  fontSize: util.fontSize14,
                  color: blackColor.withValues(alpha: 0.75),
                  height: 1.4)),
          if (req.status == 'answered') ...[
            Divider(height: 24, color: blackColor.withValues(alpha: 0.1)),
            Text('Your Answer'.tr,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    color: mainColor)),
            if (req.answerText != null && req.answerText!.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(req.answerText!),
            ],
            if (req.answerVoiceUrl != null) ...[
              SizedBox(height: 8),
              Text('Voice answer'.tr,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      color: mainColor)),
              SizedBox(height: 8),
              VoiceAnswerPlayer(
                audioUrl: req.answerVoiceUrl!,
                durationSec: req.answerVoiceDurationSec,
              ),
            ],
          ],
          if (_expanded && req.status == 'assigned') ...[
            Divider(height: 24, color: blackColor.withValues(alpha: 0.1)),
            Text('Record your answer (recommended)'.tr,
                style: TextStyle(fontFamily: AppFont.get(FontType.semiBold))),
            SizedBox(height: 8),
            Text(
              'Tap Record voice and share your personalized reply. You may add optional written notes below.'
                  .tr,
              style: TextStyle(
                  fontSize: util.fontSize13,
                  color: blackColor.withValues(alpha: 0.65)),
            ),
            SizedBox(height: 12),
            AskAnswerVoiceInput(
              voiceFile: _voiceFile,
              voiceDurationSec: _voiceDurationSec,
              disabled: _submitting,
              onVoiceChanged: (file) => setState(() => _voiceFile = file),
              onDurationChanged: (sec) =>
                  setState(() => _voiceDurationSec = sec),
            ),
            SizedBox(height: 16),
            Text('Optional written notes'.tr,
                style: TextStyle(fontFamily: AppFont.get(FontType.semiBold))),
            SizedBox(height: 8),
            TextField(
              maxLines: 4,
              onChanged: (v) => _answerText = v,
              decoration: InputDecoration(
                hintText: 'Type your answer here…'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  _submitting ? 'Submitting…'.tr : 'Submit Answer'.tr,
                  style: TextStyle(
                      color: whiteColor,
                      fontFamily: AppFont.get(FontType.semiBold)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailSection(String title, List<Widget> rows) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold))),
        SizedBox(height: 8),
        ...rows,
      ],
    );
  }

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12, color: blackColor.withValues(alpha: 0.5))),
            ),
            Expanded(
              child: Text(value,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.medium),
                      fontSize: 13)),
            ),
          ],
        ),
      );
}
