import 'package:astro_prompt/Components/Marathon/marathon_event_banner.dart';
import 'package:astro_prompt/Components/Marathon/marathon_flow_widgets.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// White header with a back box, title and tagline, same as the user list.
class MarathonPortalHeader extends StatelessWidget {
  const MarathonPortalHeader({super.key, required this.title, required this.subtitle, required this.onBack});

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
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
                onTap: onBack,
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
                    Text(title, style: marathonText(util, FontType.bold, size: util.fontSize18, height: 1.3)),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(subtitle, style: marathonText(util, FontType.medium, color: blackColor.withValues(alpha: 0.5))),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small green or soft-green pill used inside astrologer cards.
class MarathonPortalButton extends StatelessWidget {
  const MarathonPortalButton({super.key, required this.label, required this.onTap, this.soft = false});

  final String label;
  final VoidCallback? onTap;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    if (soft) {
      return Material(
        color: mainColor.withValues(alpha: 0.14),
        shape: StadiumBorder(side: BorderSide(color: mainColor.withValues(alpha: 0.28))),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            child: Text(label, style: marathonText(util, FontType.semiBold, color: mainColor, height: 1.2)),
          ),
        ),
      );
    }
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: whiteColor,
        disabledBackgroundColor: mainColor.withValues(alpha: 0.4),
        disabledForegroundColor: whiteColor,
        minimumSize: const Size(0, 42),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: Text(label, textAlign: TextAlign.center, style: marathonText(util, FontType.semiBold, color: whiteColor, height: 1.2)),
    );
  }
}

/// Astrologer event or booking card, same layout as the user event card.
class MarathonPortalCard extends StatelessWidget {
  const MarathonPortalCard({
    super.key,
    required this.startsAt,
    required this.title,
    required this.active,
    this.endsAt,
    this.timezone,
    this.category = '',
    this.lines = const [],
    this.status,
    this.closesAt,
    this.onTap,
    this.actions = const [],
  });

  final String startsAt;
  final String? endsAt;
  final String? timezone;
  final String title;
  final bool active;
  final String category;
  final List<String> lines;
  final String? status;
  final String? closesAt;
  final VoidCallback? onTap;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final start = marathonWallDetail(startsAt, zone: timezone);
    final end = marathonWallDetail(endsAt, zone: timezone);
    final hours = start == null
        ? ''
        : end == null
            ? start.time
            : marathonTimeRange(start.time, end.time);
    final hasStatus = status != null && status!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: MarathonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category.isNotEmpty)
                    Flexible(
                      fit: FlexFit.loose,
                      child: MarathonCategoryBadge(label: category, on: active),
                    ),
                  if (hasStatus || (closesAt != null && closesAt!.isNotEmpty))
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: category.isNotEmpty ? 12 : 0),
                        child: hasStatus
                            ? MarathonDot(label: status!, on: active, alignEnd: true)
                            : MarathonPortalTimer(closesAt: closesAt!, alignEnd: true),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(marathonDisplayName(title), style: marathonText(util, FontType.bold, size: util.fontSize16, height: 1.3)),
              for (final line in lines) ...[
                const SizedBox(height: 4),
                Text(line, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.6))),
              ],
              if (start != null) ...[
                const SizedBox(height: 16),
                MarathonDateRow(day: start.day, month: start.month, weekday: start.weekday, hours: hours, slots: ''),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: actions),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Registration countdown shown in the status slot of the card.
class MarathonPortalTimer extends StatelessWidget {
  const MarathonPortalTimer({super.key, required this.closesAt, this.alignEnd = false});

  final String closesAt;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
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
        final row = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: mainColor)),
            ),
            const SizedBox(width: 8),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                text,
                textAlign: alignEnd ? TextAlign.right : TextAlign.left,
                style: marathonText(util, FontType.semiBold, color: mainColor),
              ),
            ),
          ],
        );
        if (!alignEnd) return row;
        return Align(alignment: Alignment.centerRight, child: row);
      },
    );
  }
}
