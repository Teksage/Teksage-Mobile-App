import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Components/Marathon/marathon_list_hero.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_checkout_page.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_summary_page.dart';
import 'package:astro_prompt/Screens/Marathon/marathon_list_page.dart';
import 'package:astro_prompt/Services/Marathon/marathon_service.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/Helper/display_timezone.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MarathonDetailPage extends StatefulWidget {
  const MarathonDetailPage({super.key, required this.id});

  final int id;

  @override
  State<MarathonDetailPage> createState() => _MarathonDetailPageState();
}

class _MarathonDetailPageState extends State<MarathonDetailPage> {
  final MarathonService _service = MarathonService();
  Map<String, dynamic>? event;
  List<Map<String, dynamic>> mine = [];
  String error = '';
  bool loading = true;
  int? slotId;
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
    final token = await getAccessToken();
    try {
      final row = await _service.publicDetail(widget.id);
      final booked = token.isEmpty
          ? <Map<String, dynamic>>[]
          : (await _service.mine()).where((item) => item['marathon_id'] == widget.id).toList();
      if (!mounted) return;
      setState(() {
        event = row;
        mine = booked;
        loading = false;
        slotId = _firstOpen(row, booked: booked);
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        error = err.toString().replaceFirst('Exception: ', '');
        loading = false;
      });
    }
  }

  int? _firstOpen(Map<String, dynamic> row, {List<Map<String, dynamic>> booked = const []}) {
    if (row['booking_open'] != true) return null;
    final taken = booked.map(_bookingSlotId).whereType<int>().toSet();
    final slots = List<Map<String, dynamic>>.from(row['slots'] ?? []);
    for (final slot in slots) {
      final id = _slotIdOf(slot);
      if (id != null && taken.contains(id)) continue;
      final left = slot['seats_left'];
      final count = left is int ? left : int.tryParse('$left') ?? 0;
      if (count > 0) return id;
    }
    return null;
  }

  int? _bookingSlotId(Map<String, dynamic> row) {
    final raw = row['slot_id'];
    return raw is int ? raw : int.tryParse('$raw');
  }

  int? _slotIdOf(Map<String, dynamic> row) {
    final raw = row['id'];
    return raw is int ? raw : int.tryParse('$raw');
  }

  bool _mineBooked(int slotId) {
    Map<String, dynamic>? slot;
    for (final item in List<Map<String, dynamic>>.from(event?['slots'] ?? [])) {
      if (_slotIdOf(item) == slotId) {
        slot = item;
        break;
      }
    }
    final slotStart = DateTime.tryParse('${slot?['starts_at'] ?? ''}');
    for (final row in mine) {
      final bookedSlot = _bookingSlotId(row);
      if (bookedSlot == slotId) return true;
      if (bookedSlot != null) continue;
      // Fallback when older APIs omit slot_id: match by start time.
      final bookingStart = DateTime.tryParse('${row['starts_at'] ?? ''}');
      if (bookingStart != null && slotStart != null && bookingStart.toUtc() == slotStart.toUtc()) {
        return true;
      }
    }
    return false;
  }

  int _count(dynamic value) => value is int ? value : int.tryParse('$value') ?? 0;

  bool _showParticipants(Map<String, dynamic> row) {
    if (row['admin_ended'] == true) return true;
    final end = DateTime.tryParse('${row['ends_at'] ?? ''}');
    return end != null && !end.isAfter(DateTime.now());
  }

  String _participantLabel(int count) {
    if (count == 1) return '1 participant'.tr;
    return '@count participants'.trParams({'count': '$count'});
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final row = event;
    final ended = row?['admin_ended'] == true && mine.isEmpty;
    final open = row?['booking_open'] == true;
    final slots = List<Map<String, dynamic>>.from(row?['slots'] ?? []);
    return Scaffold(
      backgroundColor: const Color(0xffF4FBF3),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4FBF3),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(appBackButton, colorFilter: const ColorFilter.mode(blackColor, BlendMode.srcIn)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Go back'.tr,
          style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize16, color: blackColor),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: mainColor))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                if (error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),
                if (row == null)
                  Text('No Expert Hours event is open right now.'.tr)
                else ...[
                  const MarathonListHero(),
                  const SizedBox(height: 16),
                  MarathonEventBanner(event: row, linked: false, onTap: () {}),
                  if (_showParticipants(row))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _participantLabel(_count(row['participant_count'])),
                        style: TextStyle(color: mainColor, fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize13),
                      ),
                    ),
                  if (!ended) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.schedule_rounded, color: mainColor, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select a time slot'.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.bold),
                                  fontSize: util.fontSize16,
                                  color: blackColor,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Choose from available time slots for this session.'.tr,
                                style: TextStyle(
                                  fontFamily: AppFont.get(FontType.medium),
                                  fontSize: util.fontSize12,
                                  color: blackColor.withValues(alpha: 0.6),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (mine.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerRight, child: _bookingsButton(util)),
                    ],
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const gap = 8.0;
                        final width = (constraints.maxWidth - gap * 2) / 3;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: slots
                              .map(
                                (slot) => SizedBox(
                                  width: width,
                                  child: _slotChip(slot, open && row['admin_ended'] != true),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    if (slotId != null && open && row['admin_ended'] != true && !_mineBooked(slotId!)) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: FilledButton(
                          onPressed: () => Get.to(() => MarathonCheckoutPage(marathonId: widget.id, slotId: slotId!)),
                          style: FilledButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: whiteColor,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: const StadiumBorder(),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.credit_card, size: 16),
                              const SizedBox(width: 8),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 140),
                                child: Text(
                                  'Pay & Book Session'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize14, height: 1.25),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('→'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.off(() => const MarathonListPage()),
                      child: Text(
                        'View all events'.tr,
                        style: TextStyle(
                          fontFamily: AppFont.get(FontType.semiBold),
                          color: mainColor,
                          decoration: TextDecoration.underline,
                          decorationColor: mainColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _bookingsButton(MyUtility util) {
    void open(int id) {
      if (id > 0) Get.to(() => MarathonSummaryPage(bookingId: id));
    }

    int bookingId(Map<String, dynamic> row) {
      final raw = row['id'];
      return raw is int ? raw : int.tryParse('$raw') ?? 0;
    }

    final label = Text(
      mine.length == 1 ? '${'View bookings'.tr} →' : '${'View bookings'.tr} ▾',
      style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13, color: whiteColor),
    );
    final decoration = BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: mainColor.withValues(alpha: 0.22), blurRadius: 12, offset: const Offset(0, 4))],
    );
    if (mine.length == 1) {
      return GestureDetector(
        onTap: () => open(bookingId(mine.first)),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: decoration, child: label),
      );
    }
    return PopupMenuButton<int>(
      onSelected: open,
      itemBuilder: (context) => mine.map((row) {
        final when = marathonWallParts(row['starts_at']?.toString(), zone: viewerZone);
        return PopupMenuItem<int>(value: bookingId(row), child: Text(when?.time ?? ''));
      }).toList(),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: decoration, child: label),
    );
  }

  Widget _slotChip(Map<String, dynamic> slot, bool bookingOpen) {
    final raw = slot['id'];
    final id = raw is int ? raw : int.tryParse('$raw') ?? 0;
    final left = _count(slot['seats_left']);
    final mineBooked = _mineBooked(id);
    final full = left == 0;
    final shut = !bookingOpen;
    final selectable = !mineBooked && !full && !shut;
    final selected = slotId == id && selectable;
    final when = marathonWallParts(slot['starts_at']?.toString(), zone: viewerZone);
    final label = mineBooked || full
        ? 'Booked'.tr
        : shut
            ? 'Closed'.tr
            : '@count seats'.trParams({'count': '$left'});
    final labelColor = mineBooked || full ? errorColor : shut ? const Color(0xffD35400) : mainColor;
    final accent = mineBooked || full ? errorColor : shut ? const Color(0xffD35400) : mainColor;
    final ring = selected
        ? mainColor
        : mineBooked || full
            ? const Color(0xffF6A6A6)
            : shut
                ? const Color(0xffF5B07A)
                : const Color(0xffABE4A6);
    return Material(
      color: selected ? mainColor.withValues(alpha: 0.1) : whiteColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: selectable ? () => setState(() => slotId = id) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ring),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Stack(
              children: [
                IntrinsicHeight(
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 3, color: selected ? mainColor : accent),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 8, 4, 8),
                        child: Column(
                          children: [
                            Text(
                              when?.time ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), color: blackColor, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: AppFont.get(FontType.medium), color: labelColor, fontSize: 11, height: 1.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ),
                if (selected)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
                        child: Icon(Icons.check, color: whiteColor, size: 11),
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
}
