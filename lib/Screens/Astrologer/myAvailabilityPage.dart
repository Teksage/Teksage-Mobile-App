import 'package:astro_prompt/Components/Astrologer/AvailMonthWeekComponent.dart';
import 'package:astro_prompt/Components/Astrologer/TimeSelectorComponent.dart';
import 'package:astro_prompt/Components/Astrologer/dateChangeDialog.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/slot_model.dart';
import 'package:astro_prompt/Services/Astrologer-user/slotService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart' show getUserId;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class MyAvailabilityPage extends StatefulWidget {
  const MyAvailabilityPage({super.key});

  @override
  State<MyAvailabilityPage> createState() => _MyAvailabilityPageState();
}

class _MyAvailabilityPageState extends State<MyAvailabilityPage> {
  DateTime selectedDate = DateTime.now();
  List<SlotModel> slotList = [];
  List<String> selectedSlots = [];
  bool isEdit = false;
  Set<String> originalAvailableSlots = {};

  @override
  void initState() {
    super.initState();
    fetchSlotsForDate(selectedDate);
  }

  void fetchSlotsForDate(DateTime date) async {
    final service = SlotService();
    final userId = await getUserId();

    try {
      final response = await service.fetchAvailableSlots(
        astrologerId: userId.toString(),
        date: DateFormat('yyyy-MM-dd').format(date),
      );
      final available = getAvailableSlotRanges(response);

      setState(() {
        slotList = response;
        selectedDate = date;
        selectedSlots = available.toList();
        originalAvailableSlots = available;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void onDateChanged(DateTime newDate) {
    final hasChanges = isEdit &&
            !Set.from(selectedSlots).containsAll(originalAvailableSlots) ||
        !Set.from(originalAvailableSlots).containsAll(selectedSlots);

    if (hasChanges) {
      showClearSlotsConfirmationDialog(
        context: context,
        onYesPressed: () {
          setState(() {
            selectedSlots.clear();
            selectedDate = newDate;
            fetchSlotsForDate(newDate);
          });
        },
      );
    } else {
      setState(() {
        selectedDate = newDate;
        fetchSlotsForDate(newDate);
      });
    }
  }

  // void onSlotTap(SlotModel slot) {
  //   if (!isEdit) return;
  //
  //   if (slot.eventBooked) {
  //     showErrorSnackBar(context, "This slot is already booked!");
  //     return;
  //   }
  //
  //   setState(() {
  //     if (selectedSlots.contains(slot.startTime)) {
  //       selectedSlots.remove(slot.startTime);
  //     } else {
  //       selectedSlots.add(slot.startTime);
  //     }
  //   });
  // }

  Set<String> getAvailableSlots() {
    return slotList
        .where((slot) => !slot.eventBooked)
        .map((slot) => slot.startTime)
        .toSet();
  }

  String formatSlotRange(String startIso, String endIso) {
    // Extract time directly from ISO string without timezone conversion
    // Example: "2026-01-06T07:30:00+04:00" -> "07:30"
    final formattedStart = _extractTime(startIso);
    final formattedEnd = _extractTime(endIso);

    return '$formattedStart - $formattedEnd';
  }

  String _extractTime(String isoString) {
    try {
      final timePart = isoString.split('T')[1];
      final timeOnly = timePart.split(':');
      return '${timeOnly[0]}:${timeOnly[1]}';
    } catch (e) {
      return '00:00';
    }
  }

  Set<String> getBookedSlotRanges(List<SlotModel> slots) {
    final booked = slots
        .where((s) => s.eventBooked == true)
        .map((s) => formatSlotRange(s.startTime, s.endTime))
        .toSet();
    return booked;
  }

  Set<String> getAvailableSlotRanges(List<SlotModel> slots) {
    final available = slots
        .where((s) => s.eventBooked == false)
        .map((s) => formatSlotRange(s.startTime, s.endTime))
        .toSet();
    return available;
  }

  List<Map<String, dynamic>> buildSlotPayload() {
    final date = DateFormat('yyyy-MM-dd').format(selectedDate);
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    final outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    final formattedSlots = selectedSlots
        .map((slot) {
          final timeRange = slot.split(' - ');
          if (timeRange.length != 2) {
            return null;
          }

          final startLabel = timeRange[0];
          final endLabel = timeRange[1];

          try {
            final startTime =
                outputFormat.format(inputFormat.parse('$date $startLabel'));
            final endTime =
                outputFormat.format(inputFormat.parse('$date $endLabel'));

            return {
              "start_datetime": startTime,
              "end_datetime": endTime,
            };
          } catch (e) {
            return null;
          }
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    if (formattedSlots.isNotEmpty) return formattedSlots;

    // Fallback from getAvailableSlots if no valid slots
    final availableSlots = getAvailableSlots();
    final firstSlot = availableSlots.first;

    final isoFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    try {
      final parsedStartTime = isoFormat.parse(firstSlot);
      final parsedEndTime = parsedStartTime.add(Duration(minutes: 30));

      return [
        {
          "start_datetime": isoFormat.format(parsedStartTime),
          "end_datetime": isoFormat.format(parsedEndTime),
          "create": false,
        }
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("My Availability".tr,
            style: TextStyle(
                color: blackColor,
                fontSize: util.fontSize20,
                fontFamily: AppFont.get(FontType.bold),
                height: 1.0)),
        leading: SizedBox(
          width: util.responsiveWidth(0.08),
          height: util.responsiveHeight(0.037),
          child: IconButton(
            icon: SvgPicture.asset(backButton,
                width: util.width20, height: util.height20),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (!isEdit) {
                setState(() => isEdit = true);
                return;
              }

              final hasChanges = !Set.from(selectedSlots)
                      .containsAll(originalAvailableSlots) ||
                  !Set.from(originalAvailableSlots).containsAll(selectedSlots);

              if (kDebugMode) {
                print('selectedSlot: $selectedSlots, hasChanges: $hasChanges, AvailableSlots: ${getAvailableSlots()}');
              }

              if (!hasChanges) {
                setState(() => isEdit = false);
                return;
              }

              CustomLoader.show(context, loaderColor: astroUserConsultBG);

              final slotData = buildSlotPayload();

              try {
                final result = await SlotService().createSlots(slotData);
                CustomLoader.hide();

                if (result == 'success') {
                  showSuccessSnackBar(context, "Slot Updated Successfully.");
                  setState(() {
                    isEdit = false;
                    originalAvailableSlots = {...selectedSlots};
                  });
                  Get.off(() => MyAvailabilityPage());
                }
              } catch (e) {
                CustomLoader.hide();
                if (kDebugMode) {
                  print("❌ Error creating slots: $e");
                }
                showErrorSnackBar(context, "Please try again.");
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: util.width20),
              padding: EdgeInsets.all(util.width10),
              child: Text(
                isEdit ? 'Save'.tr : 'Edit'.tr,
                style: TextStyle(
                    fontFamily: 'FontSemiBold',
                    fontSize: util.fontSize18,
                    height: 1.0,
                    color: astroUserConsultBG),
              ),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            DashedLine(color: blackColor.withValues(alpha: 0.2)),
            SizedBox(
              height: 16,
            ),
            Text(
              isEdit
                  ? 'Select the slots that you are available'.tr
                  : 'Showing the available time that you picked'.tr,
              style: TextStyle(
                  fontFamily: 'FontSemiBold',
                  fontSize: util.fontSize16,
                  height: 1.0,
                  color: blackColor),
            ),
            SizedBox(
              height: 28,
            ),
            DashedLine(color: blackColor.withValues(alpha: 0.2)),
            SizedBox(
              height: 28,
            ),
            HorizontalDatePicker(
              selectedDate: selectedDate,
              onDateSelected: onDateChanged,
              availableSlots: getAvailableSlots(),
            ),
            SizedBox(
              height: 20,
            ),
            TimeSlotSelector(
              bookedSlots: getBookedSlotRanges(slotList),
              isEditMode: isEdit,
              selectedSlots: selectedSlots,
              onSelectionChanged: (selected) {
                setState(() {
                  selectedSlots = selected.toList();
                });
              },
              selectedDate: selectedDate,
            ),
          ]),
        ),
      ),
    );
  }
}
