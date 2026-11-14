import 'package:astro_prompt/Components/Common/voice_answer_player.dart';
import 'package:astro_prompt/Components/EventPlanner/muhurtha_event_plan_accordion.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Model/muhurtha_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AskRequestPreviousQaSection extends StatefulWidget {
  final int count;
  final List<AskAstrologerPreviousQa> items;
  final bool loading;
  final VoidCallback? onExpand;

  const AskRequestPreviousQaSection({
    super.key,
    required this.count,
    required this.items,
    this.loading = false,
    this.onExpand,
  });

  @override
  State<AskRequestPreviousQaSection> createState() =>
      _AskRequestPreviousQaSectionState();
}

class _AskRequestPreviousQaSectionState
    extends State<AskRequestPreviousQaSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    if (widget.count <= 0) return const SizedBox.shrink();
    final util = MyUtility(context);
    final badge =
        'Previous · @count'.trParams({'count': widget.count.toString()});

    return Container(
      margin: EdgeInsets.only(bottom: util.height10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blackColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              final next = !_open;
              setState(() => _open = next);
              if (next) widget.onExpand?.call();
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: util.width12,
                vertical: util.height10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Previous consultations'.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize14,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: mainColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                badge,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  color: mainColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tap to review past Q&A'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: blackColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _open ? Icons.expand_less : Icons.expand_more,
                    color: blackColor.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
          if (_open) ...[
            Divider(height: 1, color: blackColor.withValues(alpha: 0.08)),
            if (widget.loading)
              Padding(
                padding: EdgeInsets.all(util.height20),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: mainColor,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.fromLTRB(
                  util.width12,
                  util.height10,
                  util.width12,
                  util.height10,
                ),
                child: Column(
                  children: widget.items
                      .map((item) => _PreviousQaCard(item: item))
                      .toList(),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _PreviousQaCard extends StatefulWidget {
  final AskAstrologerPreviousQa item;

  const _PreviousQaCard({required this.item});

  @override
  State<_PreviousQaCard> createState() => _PreviousQaCardState();
}

class _PreviousQaCardState extends State<_PreviousQaCard> {
  bool _expanded = false;

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('d MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final item = widget.item;
    final question = item.userQuestion.trim();
    final needsToggle = question.length > 160;
    final shown = !needsToggle || _expanded
        ? question
        : '${question.substring(0, 160).trimRight()}…';
    final kind = item.requestKind == 'event_planner'
        ? 'Event planner'.tr
        : 'Chat'.tr;
    final byName = (item.astrologerName ?? '').trim().isEmpty
        ? 'Client'.tr
        : item.astrologerName!.trim();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: util.height10),
      padding: EdgeInsets.all(util.width12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: blackColor.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_formatDate(item.answeredAt)} · $kind',
            style: TextStyle(
              fontSize: 11,
              color: blackColor.withValues(alpha: 0.5),
              fontFamily: AppFont.get(FontType.semiBold),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Answered by @name'.trParams({'name': byName}),
            style: TextStyle(
              fontSize: 12,
              color: blackColor.withValues(alpha: 0.55),
              fontFamily: AppFont.get(FontType.semiBold),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Question'.tr,
            style: TextStyle(
              fontSize: 11,
              color: blackColor.withValues(alpha: 0.4),
              fontFamily: AppFont.get(FontType.semiBold),
            ),
          ),
          SizedBox(height: 4),
          Text(shown, style: TextStyle(fontSize: util.fontSize13, height: 1.35)),
          if (needsToggle)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                (_expanded ? 'Show less' : 'Show more').tr,
                style: TextStyle(
                  fontSize: 12,
                  color: mainColor,
                  fontFamily: AppFont.get(FontType.semiBold),
                ),
              ),
            ),
          if (item.muhurthaResult != null &&
              item.muhurthaResult!.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              'Your event plan'.tr,
              style: TextStyle(
                fontSize: 11,
                color: mainColor,
                fontFamily: AppFont.get(FontType.semiBold),
              ),
            ),
            SizedBox(height: 8),
            MuhurthaEventPlanAccordion(
              result: MuhurthaResult.fromJson(item.muhurthaResult!),
            ),
          ],
          if (item.answerText != null && item.answerText!.trim().isNotEmpty) ...[
            SizedBox(height: 10),
            Text(
              'Answer'.tr,
              style: TextStyle(
                fontSize: 11,
                color: blackColor.withValues(alpha: 0.4),
                fontFamily: AppFont.get(FontType.semiBold),
              ),
            ),
            SizedBox(height: 4),
            Text(
              item.answerText!,
              style: TextStyle(fontSize: util.fontSize13, height: 1.35),
            ),
          ],
          if (item.answerVoiceUrl != null &&
              item.answerVoiceUrl!.isNotEmpty) ...[
            SizedBox(height: 10),
            VoiceAnswerPlayer(
              audioUrl: item.answerVoiceUrl!,
              durationSec: item.answerVoiceDurationSec,
            ),
          ],
        ],
      ),
    );
  }
}
