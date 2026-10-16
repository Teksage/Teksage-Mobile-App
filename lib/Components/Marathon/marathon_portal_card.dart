import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarathonPortalHero extends StatelessWidget {
  const MarathonPortalHero({super.key, required this.title, required this.subtitle, this.hint = ''});

  final String title;
  final String subtitle;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: mainColor.withValues(alpha: 0.28), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: const Icon(Icons.calendar_today_outlined, color: whiteColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize20, color: blackColor, height: 1.15)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize14, color: blackColor)),
                if (hint.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(hint, style: TextStyle(fontFamily: AppFont.get(FontType.medium), fontSize: util.fontSize13, color: blackColor.withValues(alpha: 0.55), height: 1.35)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarathonPortalCard extends StatelessWidget {
  const MarathonPortalCard({
    super.key,
    required this.startsAt,
    required this.title,
    this.endsAt,
    this.timezone,
    this.categories = const [],
    this.status,
    this.closesAt,
    this.onTap,
    this.footer,
  });

  final String startsAt;
  final String? endsAt;
  final String? timezone;
  final String title;
  final List<String> categories;
  final String? status;
  final String? closesAt;
  final VoidCallback? onTap;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final start = marathonWallParts(startsAt, zone: timezone);
    final end = marathonWallParts(endsAt, zone: timezone);
    final when = start == null
        ? ''
        : end == null
            ? _stamp(start)
            : '${_stamp(start)} – ${_stamp(end)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: blackColor.withValues(alpha: 0.08)),
              boxShadow: [BoxShadow(color: const Color(0x12101810), blurRadius: 24, offset: const Offset(0, 8))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (start != null) _tile(start.day, start.month, util),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 16, color: mainColor),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize15, color: blackColor, height: 1.25),
                                  ),
                                ),
                              ],
                            ),
                            if (when.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.schedule_rounded, size: 16, color: mainColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(when, style: TextStyle(fontFamily: AppFont.get(FontType.medium), fontSize: util.fontSize13, color: blackColor.withValues(alpha: 0.7))),
                                  ),
                                ],
                              ),
                            ],
                            if (categories.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: categories.map((name) => _chip(name, util)).toList(),
                              ),
                            ],
                            if (status != null && status!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(status!, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13, color: mainColor)),
                            ] else if (closesAt != null && closesAt!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: _PortalTimer(closesAt: closesAt!, util: util),
                              ),
                          ],
                        ),
                      ),
                      if (onTap != null || closesAt == null || closesAt!.isEmpty)
                        Icon(Icons.chevron_right, color: blackColor.withValues(alpha: 0.3)),
                    ],
                  ),
                ),
                if (footer != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: blackColor.withValues(alpha: 0.08)))),
                    child: footer,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _stamp(({String day, String month, String time}) parts) {
    final month = parts.month.isEmpty ? '' : '${parts.month[0]}${parts.month.substring(1).toLowerCase()}';
    return '${parts.day} $month, ${parts.time}';
  }

  Widget _tile(String day, String month, MyUtility util) {
    return Container(
      width: 64,
      height: 72,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: mainColor.withValues(alpha: 0.28), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(fontFamily: AppFont.get(FontType.bold), fontSize: util.fontSize18, color: whiteColor, height: 1)),
          Text(month, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize11, color: whiteColor.withValues(alpha: 0.9))),
        ],
      ),
    );
  }

  Widget _chip(String name, MyUtility util) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
      child: Text(
        name.tr.replaceFirst(' & ', ' &\n'),
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize11, color: mainColor, height: 1.2),
      ),
    );
  }
}

class _PortalTimer extends StatelessWidget {
  const _PortalTimer({required this.closesAt, required this.util});

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
        final total = left.inSeconds < 0 ? 0 : left.inSeconds;
        final days = total ~/ 86400;
        final clock = [
          (total % 86400) ~/ 3600,
          (total % 3600) ~/ 60,
          total % 60,
        ].map((part) => part.toString().padLeft(2, '0')).join(':');
        final text = total == 0
            ? 'Booking for this event has closed.'.tr
            : 'Registration ends in @time'.trParams({'time': days > 0 ? '${days}d $clock' : clock});
        return Text(text, style: TextStyle(fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize13, color: mainColor));
      },
    );
  }
}
