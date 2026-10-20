import 'package:astro_prompt/Screens/Marathon/marathon_summary_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MarathonEventBanner extends StatefulWidget {
  const MarathonEventBanner({
    super.key,
    required this.event,
    required this.onTap,
    this.bookings = const [],
    this.linked = true,
  });

  final Map<String, dynamic> event;
  final VoidCallback onTap;
  final List<Map<String, dynamic>> bookings;
  final bool linked;

  @override
  State<MarathonEventBanner> createState() => _MarathonEventBannerState();
}

class _MarathonEventBannerState extends State<MarathonEventBanner> {
  String? _viewerZone;

  @override
  void initState() {
    super.initState();
    loadViewerTimezone().then((zone) {
      if (mounted) setState(() => _viewerZone = zone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final util = MyUtility(context);
    final categories = (event['categories'] as List?)?.map((item) => item.toString()).toList() ?? [];
    final category = categories.isEmpty ? '' : categories.first;
    final description = event['description']?.toString() ?? '';
    final ended = event['admin_ended'] == true;
    final canOpen = widget.linked && (!ended || widget.bookings.isNotEmpty);
    final start = _wallParts(event['starts_at']?.toString(), zone: _viewerZone);
    final end = _wallParts(event['ends_at']?.toString(), zone: _viewerZone);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: blackColor.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x12101810),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (start != null) _DateTile(parts: start, util: util),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              marathonDisplayName(event['name']?.toString()).tr,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.bold),
                                fontSize: util.fontSize16,
                                color: blackColor,
                                height: 1.25,
                              ),
                            ),
                            if (category.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: mainColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  category.tr.replaceFirst(' & ', ' &\n'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    fontSize: util.fontSize11,
                                    color: mainColor,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            description.tr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize13,
                              color: blackColor.withValues(alpha: 0.65),
                              height: 1.35,
                            ),
                          ),
                        ],
                        if (start != null && end != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded, size: 16, color: mainColor),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  marathonTimeRange(start.time, end.time),
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize13,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        ended
                            ? Text(
                                'Event ended by admin'.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize13,
                                  color: mainColor,
                                ),
                              )
                            : _RegisterTimer(closesAt: event['booking_closes_at']?.toString() ?? '', util: util),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (canOpen || widget.bookings.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: blackColor.withValues(alpha: 0.08))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (canOpen)
                      OutlinedButton(
                        onPressed: widget.onTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: mainColor,
                          side: const BorderSide(color: mainColor),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          minimumSize: const Size(0, 40),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '${'View details'.tr} →',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13),
                        ),
                      ),
                    if (canOpen && widget.bookings.isNotEmpty) const SizedBox(height: 8),
                    if (widget.bookings.isNotEmpty) _BookingsButton(bookings: widget.bookings, util: util),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.parts, required this.util});

  final _WallParts parts;
  final MyUtility util;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 80,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mainColor.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today_outlined, color: whiteColor, size: 14),
          Text(
            parts.day,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: util.fontSize18,
              color: whiteColor,
              height: 1.1,
            ),
          ),
          Text(
            parts.month,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.semiBold),
              fontSize: util.fontSize11,
              color: whiteColor.withValues(alpha: 0.9),
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterTimer extends StatefulWidget {
  const _RegisterTimer({required this.closesAt, required this.util});

  final String closesAt;
  final MyUtility util;

  @override
  State<_RegisterTimer> createState() => _RegisterTimerState();
}

class _RegisterTimerState extends State<_RegisterTimer> {
  late final DateTime? _end = DateTime.tryParse(widget.closesAt);

  @override
  Widget build(BuildContext context) {
    if (_end == null) return const SizedBox.shrink();
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (tick) => tick),
      builder: (context, _) {
        final left = _end.difference(DateTime.now());
        final text = left.inSeconds <= 0
            ? 'Booking for this event has closed.'.tr
            : 'Registration ends in @time'.trParams({'time': _remaining(left)});
        return Text(
          text,
          style: TextStyle(
            fontFamily: AppFont.get(FontType.semiBold),
            fontSize: widget.util.fontSize13,
            color: mainColor,
          ),
        );
      },
    );
  }
}

class _BookingsButton extends StatelessWidget {
  const _BookingsButton({required this.bookings, required this.util});

  final List<Map<String, dynamic>> bookings;
  final MyUtility util;

  int _id(Map<String, dynamic> row) {
    final raw = row['id'];
    return raw is int ? raw : int.tryParse('$raw') ?? 0;
  }

  void _open(int id) {
    if (id > 0) Get.to(() => MarathonSummaryPage(bookingId: id));
  }

  @override
  Widget build(BuildContext context) {
    final label = Text(
      '${'View bookings'.tr} →',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppFont.get(FontType.semiBold),
        fontSize: util.fontSize13,
        color: whiteColor,
      ),
    );
    final style = FilledButton.styleFrom(
      backgroundColor: mainColor,
      foregroundColor: whiteColor,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      minimumSize: const Size(0, 40),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    if (bookings.length == 1) {
      return FilledButton(onPressed: () => _open(_id(bookings.first)), style: style, child: label);
    }
    return PopupMenuButton<int>(
      onSelected: _open,
      itemBuilder: (context) => bookings.map((row) {
        final when = _wallParts(row['starts_at']?.toString(), zone: row['timezone']?.toString());
        return PopupMenuItem<int>(value: _id(row), child: Text(when?.time ?? ''));
      }).toList(),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(20)),
        child: label,
      ),
    );
  }
}

class _WallParts {
  const _WallParts({required this.day, required this.month, required this.time});

  final String day;
  final String month;
  final String time;
}

({String day, String month, String time})? marathonWallParts(String? iso, {String? zone}) {
  final parts = _wallParts(iso, zone: zone);
  if (parts == null) return null;
  return (day: parts.day, month: parts.month, time: parts.time);
}

/// Strip legacy "(IST)" from titles.
String marathonDisplayName(String? name) {
  final cleaned = (name ?? '').trim();
  if (cleaned.isEmpty) return '';
  return cleaned.replaceFirst(RegExp(r'\s*\(IST\)\s*$', caseSensitive: false), '').trim();
}

/// Same style as consultation: local clock times, no zone suffix.
String marathonTimeRange(String start, String end) => '$start – $end';

String marathonTimeWithIst(String time) => time;

_WallParts? _wallParts(String? iso, {String? zone}) {
  if (iso == null || iso.isEmpty) return null;
  // Same rules as 30-min consultation + website:
  // profile timezone (Current Location) when set, else API wall-clock.
  DateTime date;
  try {
    date = displayDateTimeFromIso(iso, zone: zone);
  } catch (_) {
    return null;
  }
  final locale = Get.locale?.toString() ?? 'en_US';
  try {
    return _WallParts(
      day: DateFormat('d', locale).format(date),
      month: DateFormat('MMM', locale).format(date).toUpperCase(),
      time: DateFormat('h:mm a', locale).format(date),
    );
  } catch (_) {
    return _WallParts(
      day: DateFormat('d').format(date),
      month: DateFormat('MMM').format(date).toUpperCase(),
      time: DateFormat('h:mm a').format(date),
    );
  }
}

String _remaining(Duration left) {
  final total = left.inSeconds < 0 ? 0 : left.inSeconds;
  final days = total ~/ 86400;
  final hours = (total % 86400) ~/ 3600;
  final minutes = (total % 3600) ~/ 60;
  final seconds = total % 60;
  final clock = [hours, minutes, seconds].map((part) => part.toString().padLeft(2, '0')).join(':');
  return days > 0 ? '${days}d $clock' : clock;
}
