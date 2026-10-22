import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_summary_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Event card on the Expert Hours list. Same layout as the website card.
class MarathonEventBanner extends StatefulWidget {
  const MarathonEventBanner({
    super.key,
    required this.event,
    this.onBook,
    this.bookings = const [],
  });

  final Map<String, dynamic> event;

  /// Opens checkout on the first open slot. Null hides the Book a Slot button.
  final VoidCallback? onBook;
  final List<Map<String, dynamic>> bookings;

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
    final category = categories.isEmpty ? 'Session'.tr : categories.first.tr;
    final description = event['description']?.toString() ?? '';
    final ended = event['admin_ended'] == true;
    final open = event['booking_open'] == true && !ended;
    final status = ended
        ? 'Event ended by admin'.tr
        : open
            ? 'Registration open'.tr
            : 'Booking for this event has closed.'.tr;
    final start = marathonWallDetail(event['starts_at']?.toString(), zone: _viewerZone);
    final end = marathonWallDetail(event['ends_at']?.toString(), zone: _viewerZone);
    final slots = '@count Slots Available'.trParams({'count': '${marathonOpenSlotCount(event)}'});
    final hasActions = widget.onBook != null || widget.bookings.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MarathonCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: MarathonCategoryBadge(label: category, on: open),
                ),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: MarathonDot(label: status, on: open, alignEnd: true)),
              ],
            ),
            const SizedBox(height: 12),
            Text(marathonDisplayName(event['name']?.toString()).tr, style: marathonText(util, FontType.bold)),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(description.tr, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.6))),
            ],
            if (start != null && end != null) ...[
              const SizedBox(height: 20),
              MarathonDateRow(
                day: start.day,
                month: start.month,
                weekday: start.weekday,
                hours: marathonTimeRange(start.time, end.time),
                slots: slots,
              ),
            ],
            if (hasActions) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (widget.onBook != null) MarathonSoftButton(label: 'Book a Slot'.tr, onTap: widget.onBook!),
                  if (widget.bookings.isNotEmpty) _BookingsButton(bookings: widget.bookings, zone: _viewerZone),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BookingsButton extends StatelessWidget {
  const _BookingsButton({required this.bookings, required this.zone});

  final List<Map<String, dynamic>> bookings;
  final String? zone;

  int _id(Map<String, dynamic> row) {
    final raw = row['id'];
    return raw is int ? raw : int.tryParse('$raw') ?? 0;
  }

  void _open(int id) {
    if (id > 0) Get.to(() => MarathonSummaryPage(bookingId: id));
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final single = bookings.length == 1;
    final label = Text(
      single ? '${'View bookings'.tr} →' : '${'View bookings'.tr} ▾',
      style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize14, color: whiteColor, height: 1.2),
    );
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(24)),
      child: label,
    );
    if (single) {
      return GestureDetector(onTap: () => _open(_id(bookings.first)), child: pill);
    }
    return PopupMenuButton<int>(
      onSelected: _open,
      itemBuilder: (context) => bookings.map((row) {
        final when = marathonWallParts(row['starts_at']?.toString(), zone: row['timezone']?.toString() ?? zone);
        return PopupMenuItem<int>(value: _id(row), child: Text(when?.time ?? ''));
      }).toList(),
      child: pill,
    );
  }
}

/// Open slot count, same rule as the website card.
int marathonOpenSlotCount(Map<String, dynamic> event) {
  if (event['booking_open'] != true || event['admin_ended'] == true) return 0;
  final slots = List<Map<String, dynamic>>.from(event['slots'] ?? []);
  return slots.where((slot) => _toInt(slot['seats_left']) > 0).length;
}

int _toInt(dynamic value) => value is int ? value : int.tryParse('$value') ?? 0;

class _WallParts {
  const _WallParts({
    required this.day,
    required this.month,
    required this.time,
    required this.weekday,
    required this.shortDay,
  });

  final String day;
  final String month;
  final String time;
  final String weekday;
  final String shortDay;
}

({String day, String month, String time})? marathonWallParts(String? iso, {String? zone}) {
  final parts = _wallParts(iso, zone: zone);
  if (parts == null) return null;
  return (day: parts.day, month: parts.month, time: parts.time);
}

/// Same wall-clock parts plus the long weekday and a short "Thu, 29 Oct" line.
({String day, String month, String time, String weekday, String shortDay})? marathonWallDetail(String? iso, {String? zone}) {
  final parts = _wallParts(iso, zone: zone);
  if (parts == null) return null;
  return (day: parts.day, month: parts.month, time: parts.time, weekday: parts.weekday, shortDay: parts.shortDay);
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
  String format(String pattern) {
    try {
      return DateFormat(pattern, locale).format(date);
    } catch (_) {
      return DateFormat(pattern).format(date);
    }
  }

  return _WallParts(
    day: format('d'),
    month: format('MMM').toUpperCase(),
    time: format('h:mm a'),
    weekday: format('EEEE'),
    shortDay: format('EEE, d MMM'),
  );
}
