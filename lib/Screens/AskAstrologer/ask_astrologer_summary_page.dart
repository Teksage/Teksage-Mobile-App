import 'package:astro_prompt/Components/AskAstrologer/ask_astrologer_answer_attribution.dart';
import 'package:astro_prompt/Components/Common/voice_answer_player.dart';
import 'package:astro_prompt/Components/Consultation-User/consultation_review_card.dart';
import 'package:astro_prompt/Components/EventPlanner/muhurtha_event_plan_accordion.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Model/muhurtha_model.dart';
import 'package:astro_prompt/Services/AskAstrologerService/askAstrologerService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AskAstrologerSummaryPage extends StatefulWidget {
  final int requestId;
  const AskAstrologerSummaryPage({super.key, required this.requestId});

  @override
  State<AskAstrologerSummaryPage> createState() =>
      _AskAstrologerSummaryPageState();
}

class _AskAstrologerSummaryPageState extends State<AskAstrologerSummaryPage> {
  final _service = AskAstrologerService();
  AskAstrologerRequest? _item;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final data = await _service.fetchRequest(widget.requestId);
    if (!mounted) return;
    if (data == null) {
      setState(() {
        _loading = false;
        _error = 'Could not load this Ask request. Please try again.'.tr;
      });
      return;
    }
    setState(() {
      _item = data;
      _loading = false;
    });
    if (data.status == 'answered') {
      await _service.acknowledgeAnswerReady(widget.requestId);
    }
  }

  String _feeLabel(AskAstrologerRequest item) {
    if (item.basePrice == null) return '—';
    final cur = (item.currency ?? 'INR').toUpperCase();
    final symbol = cur == 'USD' ? '\$' : '₹';
    return '$symbol${item.basePrice}';
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final item = _item;
    final isAnswered = item?.status == 'answered';

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: blackColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Ask Details'.tr,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.semiBold),
            fontSize: util.fontSize18,
            color: blackColor,
          ),
        ),
      ),
      body: _loading && item == null
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: mainColor,
                size: 40,
              ),
            )
          : _error != null || item == null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(util.width20),
                    child: Text(
                      _error ??
                          'Could not load this Ask request. Please try again.'
                              .tr,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.all(util.width20),
                    children: [
                      Text(
                        isAnswered
                            ? 'Your answer is ready — you can leave a review below.'
                                .tr
                            : 'Your question, answer, and turnaround details.'
                                .tr,
                        style: TextStyle(
                          fontSize: util.fontSize13,
                          color: blackColor.withValues(alpha: 0.55),
                        ),
                      ),
                      SizedBox(height: util.height10),
                      _sectionCard(
                        util,
                        title: 'Request details'.tr,
                        child: Column(
                          children: [
                            _row(util, 'Answer within'.tr, '4 hours'.tr),
                            _row(
                              util,
                              'Language'.tr,
                              item.preferredLanguages.isEmpty
                                  ? '—'
                                  : item.preferredLanguages.join(', '),
                            ),
                            _row(util, 'Consultation fee'.tr, _feeLabel(item)),
                            if (item.answeredAt != null)
                              _row(
                                util,
                                'Answered on'.tr,
                                _formatAnswered(item.answeredAt!),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: util.height10),
                      _sectionCard(
                        util,
                        title: 'Your question'.tr,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.userQuestion,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize14,
                              ),
                            ),
                            if (item.muhurthaResult != null &&
                                item.muhurthaResult!.isNotEmpty) ...[
                              SizedBox(height: 12),
                              MuhurthaEventPlanAccordion(
                                result: MuhurthaResult.fromJson(
                                  item.muhurthaResult!,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: util.height10),
                      _sectionCard(
                        util,
                        title: "Astrologer's answer".tr,
                        child: !isAnswered
                            ? Text('In progress'.tr)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ((item.answerText ?? '')
                                      .trim()
                                      .isNotEmpty)
                                    Text(
                                      item.answerText!.trim(),
                                      style: TextStyle(
                                        fontSize: util.fontSize14,
                                        color: blackColor.withValues(
                                            alpha: 0.75),
                                      ),
                                    ),
                                  if (item.answerVoiceUrl != null) ...[
                                    if ((item.answerText ?? '')
                                        .trim()
                                        .isNotEmpty)
                                      SizedBox(height: 12),
                                    VoiceAnswerPlayer(
                                      audioUrl: item.answerVoiceUrl,
                                      durationSec: item.answerVoiceDurationSec,
                                    ),
                                  ],
                                  if (item.answeredByAstrologerName != null &&
                                      item.answeredByAstrologerProfilePath !=
                                          null) ...[
                                    SizedBox(height: 12),
                                    AskAstrologerAnswerAttribution(
                                      name: item.answeredByAstrologerName!,
                                      profilePath:
                                          item.answeredByAstrologerProfilePath!,
                                    ),
                                  ],
                                ],
                              ),
                      ),
                      if (isAnswered) ...[
                        SizedBox(height: util.height10),
                        ConsultationReviewCard(
                          eventId: item.id,
                          rating: item.rating?.toDouble(),
                          feedback: item.feedback,
                          reviewStatus: item.reviewStatus,
                          title: 'Rate your answer',
                          onUpdated: _load,
                          onSubmitReview: (body) async {
                            final next = await _service.submitReview(
                              item.id,
                              rating: body['rating'] as int,
                              feedback: body['feedback'] as String?,
                            );
                            return next != null;
                          },
                          onDeleteReview: () async {
                            final next = await _service.clearReview(item.id);
                            return next != null;
                          },
                        ),
                      ],
                      SizedBox(height: util.height20),
                    ],
                  ),
                ),
    );
  }

  String _formatAnswered(String iso) {
    try {
      return DateFormat('dd MMM, yyyy - h:mm a')
          .format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return iso;
    }
  }

  Widget _sectionCard(MyUtility util,
      {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xfff8f8f8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: blackColor.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize14,
                color: blackColor.withValues(alpha: 0.55),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _row(MyUtility util, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: util.fontSize13,
                color: blackColor.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
