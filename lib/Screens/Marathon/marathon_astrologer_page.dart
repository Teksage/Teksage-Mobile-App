import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
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

  int _id(Map<String, dynamic> row) => row['id'] is int ? row['id'] as int : int.tryParse('${row['id']}') ?? 0;

  bool _upcoming(Map<String, dynamic> row) {
    final end = DateTime.tryParse('${row['ends_at'] ?? ''}');
    final ended = row['admin_ended'] == true;
    return !ended && !_completed(_id(row)) && (end == null || !end.isBefore(DateTime.now()));
  }

  Widget _pill(MyUtility util, String label, bool on, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: on ? mainColor : whiteColor,
          borderRadius: BorderRadius.circular(24),
          border: on ? null : Border.all(color: blackColor.withValues(alpha: 0.1)),
        ),
        child: Text(label, style: marathonText(util, FontType.semiBold, color: on ? whiteColor : blackColor.withValues(alpha: 0.55))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final visible = drafts.where((row) => _upcoming(row) == showUpcoming).toList();
    return Scaffold(
      backgroundColor: marathonPageBg,
      body: Column(
        children: [
          MarathonPortalHeader(
            title: 'Teksage Expert Hours'.tr,
            subtitle: 'Confirm you will take part. Admin publishes after astrologers confirm.'.tr,
            onBack: () => Get.back(),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: mainColor))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          _pill(util, 'Upcoming'.tr, showUpcoming, () => setState(() => showUpcoming = true)),
                          _pill(util, 'Past'.tr, !showUpcoming, () => setState(() => showUpcoming = false)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (visible.isEmpty)
                        Text('No Expert Hours event is open right now.'.tr, style: marathonText(util, FontType.medium, color: blackColor.withValues(alpha: 0.5))),
                      ...visible.map((row) {
                        final id = _id(row);
                        final completed = _completed(id);
                        final ended = row['admin_ended'] == true;
                        final status = completed ? 'Completed'.tr : ended ? 'Event ended by admin'.tr : null;
                        final categories = (row['categories'] as List?)?.map((item) => item.toString()).toList() ?? <String>[];
                        return MarathonPortalCard(
                          startsAt: '${row['starts_at'] ?? ''}',
                          endsAt: '${row['ends_at'] ?? ''}',
                          timezone: viewerZone,
                          title: row['name']?.toString() ?? '',
                          category: categories.isEmpty ? '' : categories.first.tr,
                          active: status == null,
                          status: status,
                          closesAt: status == null ? row['booking_closes_at']?.toString() : null,
                          lines: [_seats(id)],
                          onTap: () => Get.to(() => MarathonAstrologerBookingsPage(marathonId: id)),
                          actions: [
                            MarathonSoftButton(
                              label: 'View bookings'.tr,
                              onTap: () => Get.to(() => MarathonAstrologerBookingsPage(marathonId: id)),
                            ),
                            if (row['confirmed'] != true) MarathonPortalButton(label: 'Confirm participation'.tr, onTap: () => _confirm(id)),
                          ],
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
