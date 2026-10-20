import 'package:astro_prompt/Components/Marathon/marathon_portal_card.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:astro_prompt/config/event_planner_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MarathonAstrologerBookingsPage extends StatefulWidget {
  const MarathonAstrologerBookingsPage({super.key, required this.marathonId});

  final int marathonId;

  @override
  State<MarathonAstrologerBookingsPage> createState() => _MarathonAstrologerBookingsPageState();
}

class _MarathonAstrologerBookingsPageState extends State<MarathonAstrologerBookingsPage> {
  final MarathonService _service = MarathonService();
  List<Map<String, dynamic>> rows = [];
  String title = '';
  String participants = '';
  bool loading = true;
  String? viewerZone;

  @override
  void initState() {
    super.initState();
    loadViewerTimezone().then((zone) {
      if (mounted) setState(() => viewerZone = zone);
    });
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _service.astrologerSeats();
      final drafts = await _service.astrologerDrafts();
      final waiting = List<Map<String, dynamic>>.from(data['waiting'] ?? []);
      final mine = List<Map<String, dynamic>>.from(data['mine'] ?? []);
      final next = [...waiting, ...mine].where((row) => row['marathon_id'] == widget.marathonId).toList();
      next.sort((left, right) => '${right['starts_at']}'.compareTo('${left['starts_at']}'));
      Map<String, dynamic>? event;
      for (final row in drafts) {
        if (row['id'] == widget.marathonId) event = row;
      }
      final fallback = next.isEmpty ? 'Teksage Expert Hours'.tr : '${next.first['event_name'] ?? ''}';
      final count = event?['participant_count'];
      final total = count is int ? count : int.tryParse('$count') ?? next.length;
      final end = DateTime.tryParse('${event?['ends_at'] ?? ''}');
      final owned = next.where((row) => row['status'] != 'paid');
      final completed = next.every((row) => row['status'] != 'paid') &&
          owned.isNotEmpty &&
          owned.every((row) => row['status'] == 'completed');
      final finished = event?['admin_ended'] == true || (end != null && !end.isAfter(DateTime.now())) || completed;
      final statusHint = completed
          ? 'Completed'.tr
          : event?['admin_ended'] == true
              ? 'Event ended by admin'.tr
              : '';
      final people = finished
          ? (total == 1 ? '1 participant'.tr : '@count participants'.trParams({'count': '$total'}))
          : '';
      if (!mounted) return;
      setState(() {
        rows = next;
        title = '${event?['name'] ?? fallback}';
        participants = [statusHint, people].where((part) => part.isNotEmpty).join(' · ');
        loading = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() => loading = false);
      showErrorSnackBar(context, err.toString().replaceFirst('Exception: ', ''));
    }
  }

  String _label(String status) {
    if (status == 'completed') return 'Completed'.tr;
    if (status == 'accepted') return 'Accepted'.tr;
    if (status == 'assigned') return 'Assigned'.tr;
    return 'Waiting'.tr;
  }

  bool _slotEnded(String endsAt) {
    final end = DateTime.tryParse(endsAt);
    if (end == null) return false;
    return !end.isAfter(DateTime.now());
  }

  Future<void> _complete(int id) async {
    try {
      await _service.complete(id);
      await _load();
    } catch (err) {
      if (!mounted) return;
      showErrorSnackBar(context, err.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _horoscope(int eventId) async {
    final uri = Uri.parse('${EventPlannerConfig.shareSiteOrigin}/astrologer/meetings/$eventId/horoscope');
    final ok = await canLaunchUrl(uri) && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) showInfoSnackBar(context, 'Could not open Full Horoscope'.tr);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Scaffold(
      backgroundColor: const Color(0xffF4FBF3),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4FBF3),
        elevation: 0,
        title: Text(title, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize16, color: blackColor)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                MarathonPortalHero(title: title, subtitle: 'View bookings'.tr, hint: participants),
                if (rows.isEmpty) Text('No bookings for this event yet.'.tr, style: TextStyle(color: blackColor.withValues(alpha: 0.6))),
                ...rows.map((row) {
                  final id = row['id'] is int ? row['id'] as int : int.tryParse('${row['id']}') ?? 0;
                  final eventId = row['event_id'] is int ? row['event_id'] as int : int.tryParse('${row['event_id']}');
                  final status = '${row['status'] ?? ''}';
                  final link = '${row['meeting_link'] ?? ''}'.trim();
                  final label = _label(status);
                  final ended = row['admin_ended'] == true && status != 'completed';
                  final query = '${row['customer_query'] ?? ''}'.trim();
                  final languageId = '${row['preferred_language'] ?? ''}'.trim();
                  final language = languageId.isEmpty
                      ? ''
                      : AskAstrologerLanguages.labelFor(languageId).tr;
                  final canComplete = (status == 'accepted' || status == 'assigned') && _slotEnded('${row['ends_at'] ?? ''}');
                  final lines = <String>[
                    if (language.isNotEmpty) '${'Preferred consultation language'.tr}: $language',
                    if (query.isNotEmpty) '${'Customer question'.tr}: $query',
                  ];
                  return MarathonPortalCard(
                    startsAt: '${row['starts_at'] ?? ''}',
                    timezone: viewerZone,
                    title: row['user_name']?.toString() ?? '',
                    lines: lines,
                    status: ended ? '$label · ${'Event ended by admin'.tr}' : label,
                    footer: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (eventId != null) _outline(util, 'Full Horoscope'.tr, () => _horoscope(eventId)),
                        if (link.isNotEmpty) _outline(util, 'Join Meeting'.tr, () => launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication)),
                        if (status == 'completed')
                          Text(label, style: TextStyle(fontFamily: AppFont.get(FontType.bold), color: mainColor, fontSize: util.fontSize13))
                        else if (status == 'paid')
                          Text('Waiting for admin assignment'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), color: blackColor.withValues(alpha: 0.65), fontSize: util.fontSize13))
                        else
                          _filled(
                            util,
                            canComplete ? 'Mark completed'.tr : 'Consultation time has not ended yet.'.tr,
                            canComplete ? () => _complete(id) : null,
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Widget _outline(MyUtility util, String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: mainColor,
        side: const BorderSide(color: mainColor),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13)),
    );
  }

  Widget _filled(MyUtility util, String label, VoidCallback? onTap) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: mainColor,
        disabledBackgroundColor: mainColor.withValues(alpha: 0.35),
        foregroundColor: whiteColor,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13)),
    );
  }
}
