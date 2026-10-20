import 'package:astro_prompt/Components/Marathon/marathon_portal_card.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_astrologer_bookings_page.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonAstrologerPage extends StatefulWidget {
  const MarathonAstrologerPage({super.key});

  @override
  State<MarathonAstrologerPage> createState() => _MarathonAstrologerPageState();
}

class _MarathonAstrologerPageState extends State<MarathonAstrologerPage> {
  final MarathonService _service = MarathonService();
  List<Map<String, dynamic>> waiting = [];
  List<Map<String, dynamic>> mine = [];
  List<Map<String, dynamic>> drafts = [];
  bool loading = true;
  bool showUpcoming = true;
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
      final openDrafts = await _service.astrologerDrafts();
      if (!mounted) return;
      openDrafts.sort((left, right) => '${right['starts_at']}'.compareTo('${left['starts_at']}'));
      setState(() {
        waiting = List<Map<String, dynamic>>.from(data['waiting'] ?? []);
        mine = List<Map<String, dynamic>>.from(data['mine'] ?? []);
        drafts = openDrafts;
        loading = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() => loading = false);
      showErrorSnackBar(context, err.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _confirm(int id) async {
    try {
      await _service.confirmParticipation(id);
      await _load();
    } catch (err) {
      if (!mounted) return;
      showErrorSnackBar(context, err.toString().replaceFirst('Exception: ', ''));
    }
  }

  String _seats(int id) {
    final rows = [
      ...waiting.where((row) => row['marathon_id'] == id),
      ...mine.where((row) => row['marathon_id'] == id),
    ];
    final waitingCount = rows.where((row) => row['status'] == 'paid').length;
    final confirmed = rows.where((row) => row['status'] == 'accepted' || row['status'] == 'assigned').length;
    final done = rows.where((row) => row['status'] == 'completed').length;
    final waitingLine = waitingCount == 0
        ? 'No seats waiting'.tr
        : (waitingCount == 1 ? '@count seat waiting' : '@count seats waiting').trParams({'count': '$waitingCount'});
    final parts = <String>[waitingLine];
    if (confirmed > 0) parts.add('@count confirmed'.trParams({'count': '$confirmed'}));
    if (done > 0) parts.add('@count completed'.trParams({'count': '$done'}));
    return parts.join(' · ');
  }

  bool _completed(int id) {
    final open = waiting.where((row) => row['marathon_id'] == id);
    final owned = mine.where((row) => row['marathon_id'] == id);
    if (open.isNotEmpty || owned.isEmpty) return false;
    return owned.every((row) => row['status'] == 'completed');
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Scaffold(
      backgroundColor: const Color(0xffF4FBF3),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4FBF3),
        elevation: 0,
        title: Text(
          'Teksage Expert Hours'.tr,
          style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize16, color: blackColor),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : Builder(
              builder: (context) {
                final now = DateTime.now();
                bool upcoming(Map<String, dynamic> row) {
                  final end = DateTime.tryParse('${row['ends_at'] ?? ''}');
                  final ended = row['admin_ended'] == true;
                  final id = row['id'] is int ? row['id'] as int : int.tryParse('${row['id']}') ?? 0;
                  return !ended && !_completed(id) && (end == null || !end.isBefore(now));
                }

                final visible = drafts.where((row) => showUpcoming ? upcoming(row) : !upcoming(row)).toList();
                final pastCount = drafts.where((row) => !upcoming(row)).length;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    MarathonPortalHero(
                      title: 'Teksage Expert Hours'.tr,
                      subtitle: 'Events waiting for you'.tr,
                      hint: 'Confirm you will take part. Admin publishes after astrologers confirm.'.tr,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => showUpcoming = true),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: showUpcoming ? mainColor : whiteColor,
                              foregroundColor: showUpcoming ? whiteColor : mainColor,
                              side: const BorderSide(color: mainColor),
                            ),
                            child: Text('Upcoming'.tr),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => showUpcoming = false),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: !showUpcoming ? mainColor : whiteColor,
                              foregroundColor: !showUpcoming ? whiteColor : mainColor,
                              side: const BorderSide(color: mainColor),
                            ),
                            child: Text('${'Past'.tr} ($pastCount)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (visible.isEmpty)
                      Text('No Expert Hours event is open right now.'.tr, style: TextStyle(color: blackColor.withValues(alpha: 0.6))),
                    ...visible.map((row) {
                      final id = row['id'] is int ? row['id'] as int : int.tryParse('${row['id']}') ?? 0;
                      final completed = _completed(id);
                      final ended = row['admin_ended'] == true;
                      final status = completed ? 'Completed'.tr : ended ? 'Event ended by admin'.tr : null;
                      final categories = (row['categories'] as List?)?.map((item) => item.toString()).toList() ?? <String>[];
                      final confirmed = row['confirmed'] == true;
                      return MarathonPortalCard(
                        startsAt: '${row['starts_at'] ?? ''}',
                        endsAt: '${row['ends_at'] ?? ''}',
                        timezone: viewerZone,
                        title: row['name']?.toString() ?? '',
                        categories: categories,
                        status: status,
                        closesAt: status == null ? row['booking_closes_at']?.toString() : null,
                        onTap: () => Get.to(() => MarathonAstrologerBookingsPage(marathonId: id)),
                        footer: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                              child: Text(_seats(id), style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize12, color: mainColor)),
                            ),
                            if (!confirmed)
                              FilledButton(
                                onPressed: () => _confirm(id),
                                style: FilledButton.styleFrom(
                                  backgroundColor: mainColor,
                                  foregroundColor: whiteColor,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text('Confirm participation'.tr, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13)),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
    );
  }
}
