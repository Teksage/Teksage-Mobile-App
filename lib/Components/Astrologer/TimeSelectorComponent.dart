import 'package:astro_prompt/Utility/customSnackBar.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:get/get.dart';


class TimeSlotSelector extends StatefulWidget {
  final Set<String> bookedSlots;
  final bool isEditMode;
  final List<String> selectedSlots;
  final Function(Set<String>)? onSelectionChanged;
  final DateTime selectedDate;

  const TimeSlotSelector({
    super.key,
    this.onSelectionChanged,
    required this.bookedSlots,
    required this.isEditMode,
    required this.selectedSlots,
    required this.selectedDate,
  });

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  bool isMorningExpanded = true;
  bool isAfternoonExpanded = true;
  late Set<String> internalSelectedSlots;

  @override
  void initState() {
    super.initState();
    internalSelectedSlots = widget.isEditMode
        ? Set.from(widget.selectedSlots)
        : {...widget.selectedSlots, ...widget.bookedSlots};
    // print('internalSelectedSlots: $internalSelectedSlots');
  }

  @override
  void didUpdateWidget(TimeSlotSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSlots != widget.selectedSlots ||
        oldWidget.bookedSlots != widget.bookedSlots ||
        oldWidget.isEditMode != widget.isEditMode) {
      internalSelectedSlots = widget.isEditMode
          ? Set.from(widget.selectedSlots)
          : {...widget.selectedSlots, ...widget.bookedSlots};
    }
  }

  List<String> generateTimeSlots(int startHour, int endHour, String session) {
    List<String> slots = [];
    for (int hour = startHour; hour < endHour; hour++) {
      slots.add(
          "$session|${format12HourTime(hour, 0)} - ${format12HourTime(hour, 30)}");
      if (hour != endHour - 1) {
        slots.add(
            "$session|${format12HourTime(hour, 30)} - ${format12HourTime(hour + 1, 0)}");
      }
    }
    slots.add(
        "$session|${format12HourTime(endHour - 1, 30)} - ${format12HourTime(endHour % 24, 0)}");
    return slots;
  }

  String format12HourTime(int hour, int minute) {
    final dt = DateTime(2000, 1, 1, hour, minute);
    return DateFormat('h:mm').format(dt);
  }

  String normalizeSlotTime(String rawSlot, String session) {
    try {
      final parts = rawSlot.split(' - ');
      String start = parts[0].trim();
      String end = parts[1].trim();

      if (!start.contains("AM") && !start.contains("PM")) {
        if (session == "Afternoon") {
          start += (start.startsWith("12") ? " PM" : " PM");
        } else {
          start += (start.startsWith("12") ? " AM" : " AM");
        }
      }

      if (!end.contains("AM") && !end.contains("PM")) {
        if (session == "Afternoon") {
          end += (end.startsWith("12") ? " PM" : " PM");
        } else {
          end += (end.startsWith("12") ? " AM" : " AM");
        }
      }

      final startTime = DateFormat('h:mm a').parse(start);
      final endTime = DateFormat('h:mm a').parse(end);

      return "${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}";
    } catch (e) {
      print("❌ Error normalizing '$rawSlot' for $session: $e");
      return "";
    }
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isSlotInPast(String slotLabel, String session) {
    try {
      final parts = slotLabel.split(' - ');
      String start = parts[0].trim();

      if (!start.contains("AM") && !start.contains("PM")) {
        start += session == "Afternoon" ? " PM" : " AM";
      }
      final parsedSlotTime = DateFormat('h:mm a').parse(start);
      final slotDateTime = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        parsedSlotTime.hour,
        parsedSlotTime.minute,
      );
      final now = DateTime.now();
      // ✅ Block only if selected date is today AND slot time is before now
      return _isSameDate(widget.selectedDate, now) &&
          slotDateTime.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget buildSession(
      String title, List<String> slots, bool isExpanded, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: widget.isEditMode
            ? Border.all(
                color: isExpanded
                    ? astroUserConsultBG
                    : blackColor.withValues(alpha: 0.06),
                width: 1)
            : null,
        color: widget.isEditMode ? Color(0xfff5f5f5) : whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          // slots.isEmpty
          //     ? SizedBox(
          //         width: MyUtility(context).width,
          //         height: 51,
          //         child: Center(
          //             child: Text(
          //           'Time has Passed',
          //           style: TextStyle(fontFamily: AppFont.get(FontType.medium), fontSize: MyUtility(context).fontSize14, color: blackColor.withValues(alpha: 0.5)),
          //         )))
          //     :
          Column(
        children: [
          SizedBox(
            height: 51,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              onTap: onTap,
              title: Text(
                title.tr,
                style: TextStyle(
                    fontFamily: AppFont.get(FontType.bold),
                    fontSize: MyUtility(context).fontSize16,
                    height: 1.0,
                    color: blackColor.withValues(alpha: 0.6)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${internalSelectedSlots.where((s) {
                      final hour = int.tryParse(s.split(':').first) ?? 0;
                      return title == "Morning" ? hour < 12 : hour >= 12;
                    }).length} slots",
                    style: TextStyle(
                        fontFamily: 'FontSemiBold',
                        fontSize: MyUtility(context).fontSize16,
                        height: 1.0,
                        color: astroUserConsultBG),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: astroUserConsultBG,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DashedLine(color: blackColor.withValues(alpha: 0.2)),
            ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: slots.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final sessionSlot = slots[index];
                  final session = sessionSlot.split('|')[0];
                  final slot = sessionSlot.split('|')[1];
                  final normalizedSlot = normalizeSlotTime(slot, session);
                  final isSelected =
                      widget.selectedSlots.contains(normalizedSlot);
                  final isBooked = widget.bookedSlots.contains(normalizedSlot);
                  final isPastSlot = isSlotInPast(slot, session);

                  Color slotColor;
                  Color fontColor;

                  if (isPastSlot) {
                    slotColor = widget.isEditMode
                        ? Color(0xffE0E0E0)
                        : Color(0xffFFDCDC);
                    fontColor = widget.isEditMode
                        ? blackColor.withValues(alpha: 0.6)
                        : blackColor;
                  } else if (isBooked) {
                    slotColor = widget.isEditMode
                        ? Color(0xffE0E0E0)
                        : Color(0xffFFDCDC);
                    fontColor = widget.isEditMode
                        ? blackColor.withValues(alpha: 0.6)
                        : blackColor;
                  } else if (isSelected) {
                    slotColor = widget.isEditMode
                        ? astroUserConsultBG
                        : Color(0xffECF4D3);
                    fontColor = widget.isEditMode ? whiteColor : blackColor;
                  } else {
                    slotColor = Colors.white;
                    fontColor = widget.isEditMode
                        ? blackColor.withValues(alpha: 0.6)
                        : blackColor;
                  }

                  return GestureDetector(
                    onTap: !widget.isEditMode || isPastSlot
                        ? null
                        : () {
                            if (isBooked) {
                              customSnackBar(
                                context: context,
                                message:
                                    "This slot is already booked by a user and cannot be removed.",
                                backgroundColor:
                                    const Color(0xFFFFE5E5), // light red
                                indicatorColor: Colors.red, // red side bar
                                duration: Duration(seconds: 2),
                                iconType: 'error',
                              );

                              return;
                            }
                            setState(() {
                              if (internalSelectedSlots
                                  .contains(normalizedSlot)) {
                                internalSelectedSlots.remove(normalizedSlot);
                              } else {
                                internalSelectedSlots.add(normalizedSlot);
                              }
                              widget.onSelectionChanged
                                  ?.call(internalSelectedSlots);
                            });
                          },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: slotColor,
                        borderRadius: BorderRadius.circular(12),
                        border: widget.isEditMode
                            ? Border.all(
                                color: blackColor.withValues(alpha: 0.1),
                                width: 1.0)
                            : null,
                      ),
                      child: Text(
                        slot,
                        style: TextStyle(
                            color: fontColor,
                            fontFamily: 'FontSemiBold',
                            fontSize: MyUtility(context).fontSize14,
                            height: 1.0),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allMorningSlots = generateTimeSlots(0, 12, "Morning");
    final allAfternoonSlots = generateTimeSlots(12, 24, "Afternoon");

    final Set<String> visibleSlots = {
      ...widget.selectedSlots,
      ...widget.bookedSlots
    };

    // final morningSlots = widget.isEditMode
    //     ? allMorningSlots
    //     : allMorningSlots.where((s) {
    //         final session = s.split('|')[0];
    //         final slot = s.split('|')[1];
    //         final normalized = normalizeSlotTime(slot, session);
    //         // return visibleSlots.contains(normalized);
    //         if (widget.isEditMode && isSlotInPast(slot, session)) return false;
    //         return widget.isEditMode || visibleSlots.contains(normalized);
    //       }).toList();

    final morningSlots = allMorningSlots.where((s) {
      final session = s.split('|')[0];
      final slot = s.split('|')[1];
      final normalized = normalizeSlotTime(slot, session);

      // Hide past slots in edit mode
      if (widget.isEditMode && isSlotInPast(slot, session)) return false;

      return widget.isEditMode || visibleSlots.contains(normalized);
    }).toList();

    final afternoonSlots = allAfternoonSlots.where((s) {
      final session = s.split('|')[0];
      final slot = s.split('|')[1];
      final normalized = normalizeSlotTime(slot, session);

      // Hide past slots in edit mode
      if (widget.isEditMode && isSlotInPast(slot, session)) return false;

      return widget.isEditMode || visibleSlots.contains(normalized);
    }).toList();

    // final afternoonSlots = widget.isEditMode
    //     ? allAfternoonSlots
    //     : allAfternoonSlots.where((s) {
    //         final session = s.split('|')[0];
    //         final slot = s.split('|')[1];
    //         final normalized = normalizeSlotTime(slot, session);
    //         return visibleSlots.contains(normalized);
    //       }).toList();
    return Column(
      children: [
        buildSession(
          "Morning",
          morningSlots,
          isMorningExpanded,
          () => setState(() {
            isMorningExpanded = !isMorningExpanded;
            // isAfternoonExpanded = !isAfternoonExpanded;
            // if (isMorningExpanded) isAfternoonExpanded = false;
          }),
        ),
        buildSession(
          "Afternoon",
          afternoonSlots,
          isAfternoonExpanded,
          () => setState(() {
            // isMorningExpanded = !isMorningExpanded;
            isAfternoonExpanded = !isAfternoonExpanded;
            // if (isAfternoonExpanded) isMorningExpanded = false;
          }),
        ),
      ],
    );
  }
}
