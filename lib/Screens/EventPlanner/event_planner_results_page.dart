import 'package:astro_prompt/Components/Common/app_floating_bottom_nav.dart';
import 'package:astro_prompt/Components/EventPlanner/event_planner_day_row.dart';
import 'package:astro_prompt/Components/EventPlanner/event_planner_header.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Model/muhurtha_model.dart';
import 'package:astro_prompt/Screens/AskAstrologer/ask_astrologer_language_page.dart';
import 'package:astro_prompt/Screens/EventPlanner/event_planner_form_page.dart';
import 'package:astro_prompt/Services/MuhurthaService/muhurthaService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:astro_prompt/config/LocallySavedData/eventPlannerCache.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventPlannerResultsPage extends StatefulWidget {
  final String event;
  final String startDate;
  final String location;

  const EventPlannerResultsPage({
    super.key,
    required this.event,
    required this.startDate,
    required this.location,
  });

  @override
  State<EventPlannerResultsPage> createState() =>
      _EventPlannerResultsPageState();
}

class _EventPlannerResultsPageState extends State<EventPlannerResultsPage> {
  MuhurthaPayload? _data;
  bool _loading = true;
  String? _error;
  int _retryToken = 0;

  static const _mintBg = Color(0xffECF8EB);

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

    final token = await getAccessToken();
    if (token.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    try {
      final profile = await ProfileService().fetchUserProfile();
      final planStatus =
          (profile?.subscription?.planStatus ?? '').toLowerCase().trim();
      final isPremium = planStatus == 'active';
      final hasProfile = (profile?.nakshatra.isNotEmpty == true) &&
          (profile?.rashi.isNotEmpty == true);
      if (!isPremium || !hasProfile) {
        setState(() => _loading = false);
        return;
      }

      final userId = '${await getUserId() ?? 'guest'}';
      final language = await currentEventPlannerLanguage();
      final cacheKey = eventPlannerCacheKey(
        userId: userId,
        event: widget.event,
        startDate: widget.startDate,
        location: widget.location,
        language: language,
      );

      if (_retryToken == 0) {
        final cached = await readEventPlannerCacheAsync(cacheKey);
        if (cached != null) {
          setState(() {
            _data = cached;
            _loading = false;
          });
          return;
        }
      }

      final payload = await MuhurthaService().fetchEventPlanner(
        event: widget.event,
        startDate: widget.startDate,
        location: widget.location,
      );
      await writeEventPlannerCache(cacheKey, payload);

      if (mounted) {
        setState(() {
          _data = payload;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load Event Planner'.tr;
          _loading = false;
        });
      }
    }
  }

  String _formatRange(String start, String end) {
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      final fmt = DateFormat('MMM d, yyyy');
      return '${fmt.format(s)} – ${fmt.format(e)}';
    } catch (_) {
      return '$start – $end';
    }
  }

  Future<void> _handleAskAstrologer() async {
    final result = _data?.result;
    if (result == null) return;
    final dateRange = result.startDate.isNotEmpty && result.endDate.isNotEmpty
        ? '${result.startDate} to ${result.endDate}'
        : result.startDate;
    final question =
        'Event Planner: ${result.event} — $dateRange — ${result.location}';
    await writeAskAstrologerFlow(AskAstrologerFlowState(
      userQuestion: question,
      aiResponse: '',
      muhurthaResult: result.toJson(),
    ));
    Get.to(() => AskAstrologerLanguagePage(
          userQuestion: question,
          isEventPlanner: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mintBg,
      extendBody: true,
      body: _buildBody(MyUtility(context)),
      bottomNavigationBar: const AppFloatingBottomNav(popToRootOnTap: true),
    );
  }

  Widget _buildBody(MyUtility util) {
    if (_loading) {
      return Column(
        children: [
          EventPlannerHeader(title: 'Event Planner (Muhurtha)'.tr),
          const Expanded(
              child: Center(child: CircularProgressIndicator(color: mainColor))),
        ],
      );
    }

    if (_error != null) {
      return Column(
        children: [
          EventPlannerHeader(title: 'Event Planner (Muhurtha)'.tr),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(util.width20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize16)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _retryToken++;
                        _load();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor),
                      child: Text('Try again'.tr,
                          style: const TextStyle(color: whiteColor)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (_data == null) {
      return Column(
        children: [
          EventPlannerHeader(title: 'Event Planner (Muhurtha)'.tr),
          const Expanded(child: SizedBox.shrink()),
        ],
      );
    }

    final result = _data!.result;
    final rows = result.displayDays;
    final hasSuitable = rows.any((d) => d.isSuitable);

    if (rows.isEmpty) {
      return Column(
        children: [
          EventPlannerHeader(title: 'Event Planner (Muhurtha)'.tr),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('No auspicious dates found'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: AppFont.get(FontType.bold),
                            fontSize: util.fontSize18)),
                    const SizedBox(height: 8),
                    Text(
                      'No days in this window passed all Vedic filters. Try another start date or event.'
                          .tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: util.fontSize14,
                          color: blackColor.withValues(alpha: 0.65)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          Get.off(() => const EventPlannerFormPage()),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor),
                      child: Text('New search'.tr,
                          style: const TextStyle(color: whiteColor)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      color: mainColor,
      onRefresh: () async {
        _retryToken++;
        await _load();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            EventPlannerHeader(title: 'Event Planner (Muhurtha)'.tr),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              child: Column(
                children: [
                  // Summary card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        Text(
                          '${'Event Planner results'.tr} — ${result.event.tr}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.bold),
                            fontSize: util.fontSize16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(_formatRange(
                                result.startDate, result.endDate)),
                            _chip(result.location),
                          ],
                        ),
                        if (!hasSuitable)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'No auspicious days found. Try another start date.'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: blackColor.withValues(alpha: 0.6)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Day table
                  Container(
                    decoration: _cardDecoration(),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          color: mainColor.withValues(alpha: 0.06),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Text('DATE'.tr,
                                      style: _colHeadStyle())),
                              Expanded(
                                  flex: 3,
                                  child: Text('STATUS'.tr,
                                      style: _colHeadStyle())),
                              Expanded(
                                  flex: 4,
                                  child: Text('DETAILS'.tr,
                                      textAlign: TextAlign.right,
                                      style: _colHeadStyle())),
                            ],
                          ),
                        ),
                        ...rows.map((d) => EventPlannerDayRow(day: d)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Actions — same row, right-aligned
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _handleAskAstrologer,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          side: const BorderSide(color: mainColor),
                          foregroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text('Ask Astrologer'.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize13)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () =>
                            Get.off(() => const EventPlannerFormPage()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text('New search'.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                color: whiteColor,
                                fontSize: util.fontSize13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: mainColor.withValues(alpha: 0.3), width: 2.5),
      );

  TextStyle _colHeadStyle() => TextStyle(
        fontSize: 10,
        fontFamily: AppFont.get(FontType.semiBold),
        letterSpacing: 0.4,
        color: blackColor.withValues(alpha: 0.5),
      );

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: mainColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: mainColor.withValues(alpha: 0.15)),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFont.get(FontType.medium),
                color: blackColor.withValues(alpha: 0.75))),
      );
}
