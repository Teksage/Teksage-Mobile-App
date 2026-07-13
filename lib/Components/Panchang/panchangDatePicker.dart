import 'dart:io';

import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// ±365 days from today — mirrors website `PANCHANG_DATE.rangeDays`.
const int kPanchangDateRangeDays = 365;

const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

/// Bottom-sheet calendar matching website `PanchangDatePicker`.
Future<DateTime?> showPanchangDatePicker({
  required BuildContext context,
  required DateTime selectedDate,
  DateTime? today,
}) {
  final now = today ?? DateTime.now();
  final todayDay = DateTime(now.year, now.month, now.day);
  final initial = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return _PanchangDatePickerSheet(
        selectedDate: initial,
        today: todayDay,
      );
    },
  );
}

class _PanchangDatePickerSheet extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime today;

  const _PanchangDatePickerSheet({
    required this.selectedDate,
    required this.today,
  });

  @override
  State<_PanchangDatePickerSheet> createState() =>
      _PanchangDatePickerSheetState();
}

class _PanchangDatePickerSheetState extends State<_PanchangDatePickerSheet> {
  late DateTime _focusedMonth;
  late DateTime _selected;

  DateTime get _min =>
      widget.today.subtract(const Duration(days: kPanchangDateRangeDays));
  DateTime get _max =>
      widget.today.add(const Duration(days: kPanchangDateRangeDays));

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedDate;
    _focusedMonth = DateTime(_selected.year, _selected.month, 1);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _inRange(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return !day.isBefore(_min) && !day.isAfter(_max);
  }

  bool get _canPrev {
    final prev = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    final minMonth = DateTime(_min.year, _min.month, 1);
    return !prev.isBefore(minMonth);
  }

  bool get _canNext {
    final next = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    final maxMonth = DateTime(_max.year, _max.month, 1);
    return !next.isAfter(maxMonth);
  }

  void _pick(DateTime date) {
    if (!_inRange(date)) return;
    Navigator.of(context).pop(DateTime(date.year, date.month, date.day));
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final brand = Platform.isAndroid ? mainColor : iosMainColor;
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final offset = DateTime(year, month, 1).weekday % 7; // Sun=0
    final monthLabel = DateFormat('MMMM yyyy').format(_focusedMonth);
    final showToday = !_sameDay(_selected, widget.today);

    return Container(
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        util.width20,
        util.width20,
        util.width20,
        util.width20 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Panchang date'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFont.get(FontType.semiBold),
              fontSize: util.fontSize16,
              color: blackColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MonthNavButton(
                icon: Icons.chevron_left,
                enabled: _canPrev,
                brand: brand,
                onTap: () {
                  setState(() {
                    _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
                  });
                },
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFont.get(FontType.semiBold),
                    fontSize: util.fontSize14,
                    color: blackColor,
                  ),
                ),
              ),
              _MonthNavButton(
                icon: Icons.chevron_right,
                enabled: _canNext,
                brand: brand,
                onTap: () {
                  setState(() {
                    _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: _weekdays
                .map(
                  (d) => Expanded(
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.semiBold),
                        fontSize: util.fontSize11,
                        color: blackColor.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: offset + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < offset) {
                return const SizedBox.shrink();
              }
              final day = index - offset + 1;
              final date = DateTime(year, month, day);
              final inRange = _inRange(date);
              final selected = _sameDay(date, _selected);
              final isToday = _sameDay(date, widget.today);

              return GestureDetector(
                onTap: inRange ? () => _pick(date) : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? brand : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday && !selected
                        ? Border.all(
                            color: brand.withValues(alpha: 0.45),
                          )
                        : null,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize14,
                      color: !inRange
                          ? blackColor.withValues(alpha: 0.25)
                          : selected
                              ? whiteColor
                              : blackColor,
                    ),
                  ),
                ),
              );
            },
          ),
          if (showToday) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _pick(widget.today),
              style: TextButton.styleFrom(
                foregroundColor: brand,
                side: BorderSide(color: brand.withValues(alpha: 0.3)),
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Today'.tr,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color brand;
  final VoidCallback onTap;

  const _MonthNavButton({
    required this.icon,
    required this.enabled,
    required this.brand,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.3,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: blackColor.withValues(alpha: 0.14),
            ),
          ),
          child: Icon(icon, color: blackColor, size: 22),
        ),
      ),
    );
  }
}
