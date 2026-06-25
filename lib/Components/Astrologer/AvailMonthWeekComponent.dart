import 'dart:math' as math;
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class HorizontalDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Set<String> availableSlots;

  const HorizontalDatePicker(
      {super.key,
      required this.selectedDate,
      required this.onDateSelected,
      required this.availableSlots});

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late DateTime firstDayOfWeek;
  final DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    firstDayOfWeek =
        _getStartOfWeek(DateTime(today.year, today.month, today.day));
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  void _goToNextWeek() {
    setState(() {
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
    });
  }

  void _goToPreviousWeek() {
    final prevWeekStart = firstDayOfWeek.subtract(const Duration(days: 7));
    if (!isBeforeToday(prevWeekStart.add(const Duration(days: 6)))) {
      setState(() {
        firstDayOfWeek = prevWeekStart;
      });
    }
  }

  void _pickMonthYear() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: firstDayOfWeek.isBefore(today) ? today : firstDayOfWeek,
      firstDate: today,
      lastDate: DateTime(today.year + 2),
    );

    if (picked != null) {
      setState(() {
        firstDayOfWeek = _getStartOfWeek(picked);
        widget.onDateSelected(picked.isBefore(today) ? today : picked);
      });
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isBeforeToday(DateTime date) {
    return date.isBefore(DateTime(today.year, today.month, today.day));
  }

  bool hasAvailableSlots(DateTime date) {
    return widget.availableSlots
        .any((slot) => DateTime.parse(slot).day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final weekDates =
        List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
    print('availableSlots: ${widget.availableSlots}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _pickMonthYear,
              child: Row(
                children: [
                  Text(
                    DateFormat.yMMMM().format(firstDayOfWeek),
                    style: TextStyle(
                        fontSize: util.fontSize16,
                        fontFamily: AppFont.get(FontType.medium),
                        color: blackColor.withValues(alpha: 0.5),
                        height: 1.0),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    dropDownArrow,
                    colorFilter:
                        ColorFilter.mode(astroUserConsultBG, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Transform.rotate(
                angle: 90 * math.pi / 180,
                child: SvgPicture.asset(
                  dropDownArrow,
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(astroUserConsultBG, BlendMode.srcIn),
                ),
              ),
              onPressed: _goToPreviousWeek,
            ),
            IconButton(
              icon: Transform.rotate(
                angle: 270 * math.pi / 180,
                child: SvgPicture.asset(
                  dropDownArrow,
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(astroUserConsultBG, BlendMode.srcIn),
                ),
              ),
              onPressed: _goToNextWeek,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 58,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              final date = weekDates[index];
              final isSelected = isSameDay(date, widget.selectedDate);
              final isPast = isBeforeToday(date);
              final hasSlots = hasAvailableSlots(date);

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () {
                        widget.onDateSelected(date);
                      },
                child: Opacity(
                  opacity: isPast ? 0.4 : 1.0,
                  child: Container(
                    width: 45,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? astroUserConsultBG
                          : hasSlots
                              ? Color(0xffECF4D3)
                              : whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: blackColor.withValues(alpha: 0.1), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E().format(date),
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.bold),
                            fontSize: util.fontSize16,
                            height: 1.0,
                            color: isSelected
                                ? Color(0xfffdfefa)
                                : blackColor.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.bold),
                            fontSize: util.fontSize16,
                            height: 1.0,
                            color: isSelected
                                ? Color(0xfffdfefa)
                                : blackColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
