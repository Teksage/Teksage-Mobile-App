import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_list_page.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Home entry card — title, latest active event line + timer, CTA.
class MarathonHomeBanner extends StatefulWidget {
  const MarathonHomeBanner({super.key});

  @override
  State<MarathonHomeBanner> createState() => _MarathonHomeBannerState();
}

class _MarathonHomeBannerState extends State<MarathonHomeBanner> {
  Map<String, dynamic>? _event;
  String? _viewerZone;

  @override
  void initState() {
    super.initState();
    loadViewerTimezone().then((zone) {
      if (mounted) setState(() => _viewerZone = zone);
    });
    _loadLatestActive();
  }

  Future<void> _loadLatestActive() async {
    try {
      final rows = await MarathonService().publicList();
      final event = _latestActive(rows);
      if (!mounted) return;
      setState(() => _event = event);
    } catch (_) {
      if (!mounted) return;
      setState(() => _event = null);
    }
  }

  /// Open for booking (not ended, registration still open). Latest by starts_at.
  Map<String, dynamic>? _latestActive(List<Map<String, dynamic>> rows) {
    final now = DateTime.now();
    final active = rows.where((row) {
      if (row['admin_ended'] == true) return false;
      final closes = DateTime.tryParse(row['booking_closes_at']?.toString() ?? '');
      if (closes != null) return closes.isAfter(now);
      final ends = DateTime.tryParse(row['ends_at']?.toString() ?? '');
      return ends != null && ends.isAfter(now);
    }).toList()
      ..sort((a, b) {
        final left = DateTime.tryParse(a['starts_at']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final right = DateTime.tryParse(b['starts_at']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });
    return active.isEmpty ? null : active.first;
  }

  void _open() {
    Get.to(() => const MarathonListPage());
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final event = _event;
    final closesAt = event?['booking_closes_at']?.toString();
    final when = marathonWallParts(
      event?['starts_at']?.toString(),
      zone: _viewerZone,
    );
    final name = marathonDisplayName(event?['name']?.toString());
    final eventLine = (event != null && when != null && name.isNotEmpty)
        ? '$name · ${_monthLabel(when.month)} ${when.day}, ${marathonTimeWithIst(when.time)}'
        : null;

    return GestureDetector(
      onTap: _open,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: marathonHomeCardBorder),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [marathonHomeCardStart, whiteColor],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0F101810),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: mainColor),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      util.width12,
                      util.responsiveHeight(0.014),
                      util.width12,
                      util.responsiveHeight(0.014),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Teksage Expert Hours'.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.bold),
                                  fontSize: util.fontSize16,
                                  color: blackColor,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            if (closesAt != null && closesAt.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              _CompactTimer(closesAt: closesAt, util: util),
                            ],
                          ],
                        ),
                        if (eventLine != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            eventLine,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize13,
                              color: blackColor,
                              height: 1.3,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: mainColor),
                          ),
                          child: Text(
                            'View details'.tr,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize12,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthLabel(String month) {
    if (month.isEmpty) return month;
    return '${month[0]}${month.substring(1).toLowerCase()}';
  }
}

class _CompactTimer extends StatelessWidget {
  const _CompactTimer({required this.closesAt, required this.util});

  final String closesAt;
  final MyUtility util;

  @override
  Widget build(BuildContext context) {
    final end = DateTime.tryParse(closesAt);
    if (end == null) return const SizedBox.shrink();
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (tick) => tick),
      builder: (context, _) {
        final left = end.difference(DateTime.now());
        if (left.inSeconds <= 0) return const SizedBox.shrink();
        return Text(
          _remaining(left),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.semiBold),
            fontSize: util.fontSize12,
            color: mainColor,
          ),
        );
      },
    );
  }

  String _remaining(Duration left) {
    final total = left.inSeconds < 0 ? 0 : left.inSeconds;
    final days = total ~/ 86400;
    final clock = [
      (total % 86400) ~/ 3600,
      (total % 3600) ~/ 60,
      total % 60,
    ].map((part) => part.toString().padLeft(2, '0')).join(':');
    return days > 0 ? '${days}d $clock' : clock;
  }
}
