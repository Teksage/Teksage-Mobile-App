import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Components/Marathon/marathon_list_empty.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_checkout_page.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_slots.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class MarathonListPage extends StatefulWidget {
  const MarathonListPage({super.key, this.focusId});

  final int? focusId;

  @override
  State<MarathonListPage> createState() => _MarathonListPageState();
}

class _MarathonListPageState extends State<MarathonListPage> {
  final MarathonService _service = MarathonService();
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> mine = [];
  bool loading = true;
  String error = '';
  bool showUpcoming = true;
  int page = 0;

  @override
  void initState() {
    super.initState();
    final locale = Get.locale?.toString() ?? 'en_US';
    initializeDateFormatting(locale);
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await _service.publicList();
      rows.sort((left, right) => '${right['starts_at']}'.compareTo('${left['starts_at']}'));
      final token = await getAccessToken();
      final past = token.isEmpty ? <Map<String, dynamic>>[] : await _service.mine();
      if (!mounted) return;
      final focusId = widget.focusId;
      var openUpcoming = true;
      if (focusId != null) {
        for (final event in rows) {
          if (marathonInt(event['id']) == focusId) {
            openUpcoming = _upcoming(event);
            break;
          }
        }
      }
      setState(() {
        events = rows;
        mine = past;
        showUpcoming = openUpcoming;
        loading = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        error = err.toString().replaceFirst('Exception: ', '');
        loading = false;
      });
    }
  }

  bool _upcoming(Map<String, dynamic> event) {
    final end = DateTime.tryParse('${event['ends_at'] ?? ''}');
    final ended = event['admin_ended'] == true;
    return !ended && (end == null || !end.isBefore(DateTime.now()));
  }

  void _book(Map<String, dynamic> event, int slotId) {
    Get.to(() => MarathonCheckoutPage(marathonId: marathonInt(event['id']), slotId: slotId));
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
    final focusId = widget.focusId;
    final visible = <Map<String, dynamic>>[];
    Map<String, dynamic>? pinned;
    for (final event in events.where((event) => _upcoming(event) == showUpcoming)) {
      if (focusId != null && pinned == null && marathonInt(event['id']) == focusId) {
        pinned = event;
      } else {
        visible.add(event);
      }
    }
    if (pinned != null) visible.insert(0, pinned);
    final pages = (visible.length / marathonPageSize).ceil().clamp(1, 1 << 20);
    final current = page.clamp(0, pages - 1);
    final slice = visible.skip(current * marathonPageSize).take(marathonPageSize).toList();
    return Scaffold(
      backgroundColor: marathonPageBg,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: whiteColor,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: blackColor.withValues(alpha: 0.1)),
                        ),
                        child: Icon(Icons.chevron_left_rounded, size: 22, color: blackColor.withValues(alpha: 0.6)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AstroConnect Pro'.tr, style: marathonText(util, FontType.bold, size: util.fontSize18, height: 1.15)),
                          const SizedBox(height: 2),
                          Text(
                            'Better guidance · Brighter tomorrow'.tr,
                            style: marathonText(util, FontType.medium, size: util.fontSize13, color: blackColor.withValues(alpha: 0.5), height: 1.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                          _pill(util, 'Upcoming'.tr, showUpcoming, () => setState(() {
                                showUpcoming = true;
                                page = 0;
                              })),
                          _pill(util, 'Past'.tr, !showUpcoming, () => setState(() {
                                showUpcoming = false;
                                page = 0;
                              })),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),
                      if (slice.isEmpty && error.isEmpty) MarathonListEmpty(upcoming: showUpcoming),
                      ...slice.map((event) {
                        final rows = mine.where((row) => marathonInt(row['marathon_id']) == marathonInt(event['id'])).toList();
                        final slotId = marathonFirstOpenSlot(event, rows);
                        return MarathonEventBanner(
                          event: event,
                          bookings: rows,
                          onBook: slotId == null ? null : () => _book(event, slotId),
                        );
                      }),
                      MarathonPager(
                        index: current,
                        total: pages,
                        onPrev: () => setState(() => page = current - 1),
                        onNext: () => setState(() => page = current + 1),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
