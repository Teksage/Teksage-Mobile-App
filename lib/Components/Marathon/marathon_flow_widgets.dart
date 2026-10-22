import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Page tint behind the white cards, same mint wash as the website flow.
const marathonPageBg = Color(0xffF4FBF3);

/// Light gray used by the date row and the review panel.
const marathonRowGray = Color(0xffF1F1F1);

/// Warm tone for the last few seats, same as the website slot pills.
const marathonLowSeatColor = Color(0xffD35400);

/// Seat pills turn warm at this count and below.
const marathonLowSeats = 2;

/// Two events per row on the website, ten per page, then previous / next.
const marathonPageSize = 10;

/// Pale green behind notes, same 12% mix the website uses.
final marathonNoteBg = Color.alphaBlend(mainColor.withValues(alpha: 0.12), whiteColor);

TextStyle marathonText(
  MyUtility util,
  FontType type, {
  double? size,
  Color? color,
  double height = 1.4,
}) {
  return TextStyle(
    fontFamily: AppFont.get(type),
    fontSize: size ?? util.fontSize14,
    color: color ?? blackColor,
    height: height,
  );
}

/// White bar with back button, title, and the optional step row.
class MarathonFlowBar extends StatelessWidget {
  const MarathonFlowBar({
    super.key,
    required this.title,
    required this.onBack,
    this.steps = const [],
    this.step = 1,
    this.onStep,
  });

  final String title;
  final VoidCallback onBack;
  final List<String> steps;
  final int step;
  final ValueChanged<int>? onStep;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
      width: double.infinity,
      color: whiteColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: blackColor.withValues(alpha: 0.1)),
                      ),
                      child: Icon(Icons.chevron_left_rounded, size: 22, color: blackColor.withValues(alpha: 0.6)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: marathonText(util, FontType.bold),
                    ),
                  ),
                ],
              ),
              if (steps.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 8,
                  children: [
                    for (var index = 0; index < steps.length; index++)
                      _StepItem(
                        number: index + 1,
                        label: steps[index],
                        step: step,
                        onTap: onStep == null ? null : () => onStep!(index + 1),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.number, required this.label, required this.step, this.onTap});

  final int number;
  final String label;
  final int step;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final done = number < step;
    final active = number == step;
    final color = done
        ? mainColor
        : active
            ? blackColor
            : blackColor.withValues(alpha: 0.35);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done)
            const Icon(Icons.check_rounded, size: 18, color: mainColor)
          else
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? mainColor : blackColor.withValues(alpha: 0.1),
              ),
              child: Text(
                '$number',
                style: marathonText(util, FontType.semiBold, size: util.fontSize12, color: active ? whiteColor : blackColor.withValues(alpha: 0.4), height: 1),
              ),
            ),
          const SizedBox(width: 8),
          Text(label, style: marathonText(util, FontType.semiBold, color: color)),
        ],
      ),
    );
  }
}

/// White rounded card used by every step.
class MarathonCard extends StatelessWidget {
  const MarathonCard({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: blackColor.withValues(alpha: 0.06)),
        boxShadow: const [BoxShadow(color: Color(0x0F101810), blurRadius: 28, offset: Offset(0, 10))],
      ),
      child: child,
    );
  }
}

/// Light green pill around the event category, with the green dot inside.
class MarathonCategoryBadge extends StatelessWidget {
  const MarathonCategoryBadge({super.key, required this.label, required this.on});

  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: MarathonDot(label: label, on: on),
    );
  }
}

/// Dot with a label, used for the category and the registration status.
class MarathonDot extends StatelessWidget {
  const MarathonDot({super.key, required this.label, required this.on, this.alignEnd = false});

  final String label;
  final bool on;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: on ? mainColor : blackColor.withValues(alpha: 0.25)),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            label,
            textAlign: alignEnd ? TextAlign.right : TextAlign.left,
            overflow: alignEnd ? TextOverflow.visible : TextOverflow.ellipsis,
            style: marathonText(util, FontType.semiBold, color: on ? mainColor : blackColor.withValues(alpha: 0.45)),
          ),
        ),
      ],
    );
    if (!alignEnd) return row;
    return Align(alignment: Alignment.centerRight, child: row);
  }
}

/// Light gray row with the green date tile, weekday, time range and slot count.
class MarathonDateRow extends StatelessWidget {
  const MarathonDateRow({
    super.key,
    required this.day,
    required this.month,
    required this.weekday,
    required this.hours,
    required this.slots,
  });

  final String day;
  final String month;
  final String weekday;
  final String hours;
  final String slots;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: marathonRowGray, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          MarathonDateTile(day: day, month: month),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weekday, style: marathonText(util, FontType.bold)),
                Text(hours, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.55))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(slots, textAlign: TextAlign.right, style: marathonText(util, FontType.semiBold)),
        ],
      ),
    );
  }
}

/// Green square with day and month.
class MarathonDateTile extends StatelessWidget {
  const MarathonDateTile({super.key, required this.day, required this.month});

  final String day;
  final String month;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: marathonText(util, FontType.bold, color: whiteColor, height: 1)),
          const SizedBox(height: 2),
          Text(
            month.toUpperCase(),
            style: marathonText(util, FontType.semiBold, size: util.fontSize12, color: whiteColor.withValues(alpha: 0.9), height: 1),
          ),
        ],
      ),
    );
  }
}

/// Pale green note with a leading icon.
class MarathonNote extends StatelessWidget {
  const MarathonNote({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: marathonNoteBg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 16, color: mainColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.7))),
          ),
        ],
      ),
    );
  }
}

/// Plain gray line under the summary rows.
class MarathonPlainNote extends StatelessWidget {
  const MarathonPlainNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(text, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.55))),
    );
  }
}

class MarathonSummaryRow {
  const MarathonSummaryRow(this.label, this.value, {this.accent = false});

  final String label;
  final String value;
  final bool accent;
}

/// Booking or payment summary card.
class MarathonSummaryCard extends StatelessWidget {
  const MarathonSummaryCard({
    super.key,
    required this.kicker,
    required this.rows,
    required this.totalLabel,
    required this.total,
    this.lead,
    this.children = const [],
  });

  final String kicker;
  final List<MarathonSummaryRow> rows;
  final String totalLabel;
  final String total;
  final Widget? lead;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return MarathonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            kicker.toUpperCase(),
            style: marathonText(util, FontType.semiBold, size: util.fontSize12, color: blackColor.withValues(alpha: 0.4)).copyWith(letterSpacing: 1.6),
          ),
          if (lead != null) ...[const SizedBox(height: 16), lead!],
          const SizedBox(height: 16),
          for (var index = 0; index < rows.length; index++)
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rows[index].label, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.45))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rows[index].value,
                      textAlign: TextAlign.right,
                      style: marathonText(
                        util,
                        rows[index].accent ? FontType.bold : FontType.semiBold,
                        color: rows[index].accent ? mainColor : blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const _DashedLine(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(totalLabel, style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.7))),
              const Spacer(),
              Text(total, style: marathonText(util, FontType.bold, size: util.fontSize22, height: 1.1)),
            ],
          ),
          ...children,
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 4.0;
        const gap = 3.0;
        final count = (constraints.maxWidth / (dash + gap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(right: gap),
              child: Container(width: dash, height: 1, color: blackColor.withValues(alpha: 0.15)),
            ),
          ),
        );
      },
    );
  }
}

/// Solid green action with white text.
class MarathonPrimaryButton extends StatelessWidget {
  const MarathonPrimaryButton({super.key, required this.label, required this.onTap, this.wide = false});

  final String label;
  final VoidCallback? onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final button = FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: whiteColor,
        disabledBackgroundColor: mainColor.withValues(alpha: 0.4),
        disabledForegroundColor: whiteColor,
        minimumSize: const Size(0, 44),
        padding: EdgeInsets.symmetric(horizontal: wide ? 16 : 40),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: Text(label, textAlign: TextAlign.center, style: marathonText(util, FontType.semiBold, color: whiteColor)),
    );
    if (wide) return SizedBox(width: double.infinity, child: button);
    return Center(child: button);
  }
}

/// Transparent green action, used for Book a Slot.
class MarathonSoftButton extends StatelessWidget {
  const MarathonSoftButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    return Material(
      color: mainColor.withValues(alpha: 0.14),
      shape: StadiumBorder(side: BorderSide(color: mainColor.withValues(alpha: 0.28))),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: marathonText(util, FontType.semiBold, color: mainColor, height: 1.2)),
              const SizedBox(width: 4),
              Text('›', style: marathonText(util, FontType.semiBold, color: mainColor, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Previous / next row with the page count.
class MarathonPager extends StatelessWidget {
  const MarathonPager({super.key, required this.index, required this.total, required this.onPrev, required this.onNext});

  final int index;
  final int total;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    if (total < 2) return const SizedBox.shrink();
    final util = MyUtility(context);
    Widget arrow(IconData icon, VoidCallback? tap, String label) {
      return Opacity(
        opacity: tap == null ? 0.4 : 1,
        child: Semantics(
          button: true,
          label: label.tr,
          child: InkWell(
            onTap: tap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor,
                border: Border.all(color: blackColor.withValues(alpha: 0.1)),
              ),
              child: Icon(icon, size: 20, color: blackColor.withValues(alpha: 0.6)),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          arrow(Icons.chevron_left_rounded, index == 0 ? null : onPrev, 'Previous'),
          const SizedBox(width: 12),
          Text('${index + 1}/$total', style: marathonText(util, FontType.semiBold, color: blackColor.withValues(alpha: 0.7))),
          const SizedBox(width: 12),
          arrow(Icons.chevron_right_rounded, index >= total - 1 ? null : onNext, 'Next'),
        ],
      ),
    );
  }
}

/// One time-slot pill: selected is solid green, last seats are warm.
class MarathonSlotPill extends StatelessWidget {
  const MarathonSlotPill({
    super.key,
    required this.time,
    required this.label,
    required this.selected,
    required this.low,
    this.booked = false,
    required this.open,
    required this.onTap,
  });

  final String time;
  final String label;
  final bool selected;
  final bool low;
  final bool booked;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final fill = selected
        ? mainColor
        : low
            ? Color.alphaBlend(marathonLowSeatColor.withValues(alpha: 0.14), whiteColor)
            : whiteColor;
    final border = selected
        ? mainColor
        : booked
            ? errorColor
            : low
                ? Color.alphaBlend(marathonLowSeatColor.withValues(alpha: 0.3), whiteColor)
                : blackColor.withValues(alpha: 0.1);
    final timeColor = selected
        ? whiteColor
        : low
            ? marathonLowSeatColor
            : blackColor;
    final seat = selected
        ? whiteColor.withValues(alpha: 0.9)
        : booked
            ? errorColor
            : low
                ? marathonLowSeatColor
                : mainColor;
    return Opacity(
      opacity: open || booked ? 1 : 0.6,
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: open ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minWidth: 90),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: marathonText(util, FontType.bold, color: timeColor)),
                Text(label, style: marathonText(util, FontType.semiBold, color: seat)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
