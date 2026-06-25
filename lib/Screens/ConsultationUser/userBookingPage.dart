import 'package:astro_prompt/Components/Consultation-User/formatBookingDate.dart';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/slot_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userBookingDetailspage.dart';
import 'package:astro_prompt/Services/Astrologer-user/slotService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/format12HrsTime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class BookingPage extends StatefulWidget {
  final int astrologerId;
  final String astrologerFirstName;
  final String astrologerSecondName;
  final List<String> selectedCategories;
  final List<String> selectedLanguages;
  final double consultingFee;
  final String profileImage;
  final String currency;
  const BookingPage(
      {super.key,
      required this.astrologerId,
      required this.astrologerFirstName,
      required this.astrologerSecondName,
      required this.selectedCategories,
      required this.selectedLanguages,
      required this.consultingFee,
      required this.profileImage,
      required this.currency});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ScrollController scrollController = ScrollController();
  DateTime focusedDate = DateTime.now();
  DateTime? selectedDate;
  int? selectedSlotIndex;
  Future<List<SlotModel>>? slotFuture;
  List<SlotModel> availableSlots = [];
  String bookingTime = '';
  String bookingDate = '';
  bool showError = false;
  bool alreadySelected = false;
  String slotWarningMessage = '';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    slotFuture = fetchSlotsForSelectedDate(selectedDate!);
  }

  Future<List<SlotModel>> fetchSlotsForSelectedDate(
      DateTime selectedDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    var data = await SlotService().fetchAvailableSlots(
      astrologerId: widget.astrologerId.toString(),
      date: formattedDate,
    );
    // print('ReturnedData : ${data[0].startTime}');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    final daysInMonth =
        DateUtils.getDaysInMonth(focusedDate.year, focusedDate.month);
    final firstWeekday =
        DateTime(focusedDate.year, focusedDate.month, 1).weekday % 7;

    // print('Width: ${util.responsiveWidth(0.0268)}');
    // print('Height: ${util.responsiveHeight(0.1232)}');
    // print('FontSize: ${util.responsiveFontSize(0.0253)}');

    Widget buildHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: SvgPicture.asset(astroCalenderArrow),
            onPressed: () {
              setState(() {
                final now = DateTime.now();
                final previousMonth =
                    DateTime(focusedDate.year, focusedDate.month - 1);
                if (!(previousMonth.year == now.year &&
                        previousMonth.month < now.month) &&
                    !(previousMonth.year < now.year)) {
                  setState(() {
                    focusedDate = previousMonth;
                  });
                }
              });
            },
          ),
          Text(
            DateFormat.yMMMM().format(focusedDate),
            style: TextStyle(
                fontFamily: 'FontSemiBold',
                fontSize: util.fontSize16,
                height: 1.0,
                color: whiteColor),
          ),
          IconButton(
            icon: Transform.rotate(
              angle: 3.1416,
              child: SvgPicture.asset(astroCalenderArrow),
            ),
            onPressed: () {
              setState(() {
                focusedDate = DateTime(focusedDate.year, focusedDate.month + 1);
              });
            },
          ),
        ],
      );
    }

    Widget buildCalendar(int daysInMonth, int startOffset) {
      final totalBoxes = startOffset + daysInMonth;
      final rows = <TableRow>[];

      // Weekday Header
      final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      rows.add(TableRow(
        children: days.map((d) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Text(
                d,
                style: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize16,
                  height: 1.0,
                  color: whiteColor,
                ),
              ),
            ),
          );
        }).toList(),
      ));

      // Dates Grid
      List<Widget> dayWidgets = [];
      final now = DateTime.now();
      for (int i = 0; i < totalBoxes; i++) {
        if (i < startOffset) {
          dayWidgets.add(Container());
        } else {
          final day = i - startOffset + 1;
          final currentDate =
              DateTime(focusedDate.year, focusedDate.month, day);
          final isSelected = selectedDate?.day == day &&
              selectedDate?.month == focusedDate.month &&
              selectedDate?.year == focusedDate.year;
          final isPastDate =
              currentDate.isBefore(DateTime(now.year, now.month, now.day));

          dayWidgets.add(GestureDetector(
            onTap: isPastDate
                ? null
                : () {
                    setState(() {
                      selectedDate = currentDate;
                      final selectedDateStr =
                          DateFormat('yyyy-MM-dd').format(currentDate);
                      bookingDate = selectedDateStr;
                      print("Selected Date: $selectedDateStr");
                      selectedSlotIndex = null;
                      bookingTime = '';
                      alreadySelected = false;

                      slotFuture = fetchSlotsForSelectedDate(selectedDate!);
                      // Return this as needed
                    });
                  },
            child: Container(
              margin: const EdgeInsets.only(left: 1.5, right: 1.5, bottom: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : astroUserConsultBG,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: whiteColor.withValues(alpha: 0.5)),
              ),
              alignment: Alignment.center,
              height: 40,
              child: Text(
                "$day",
                style: TextStyle(
                  color: isSelected ? astroUserConsultBG : whiteColor,
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize16,
                  height: 1.0,
                ),
              ),
            ),
          ));
        }

        // Every 7 items, make a row
        if ((i + 1) % 7 == 0 || i == totalBoxes - 1) {
          rows.add(TableRow(
            children: List.generate(7, (index) {
              final itemIndex = i - ((i % 7) - index);
              return (itemIndex >= 0 && itemIndex < dayWidgets.length)
                  ? dayWidgets[itemIndex]
                  : Container();
            }),
          ));
        }
      }

      return Table(
        children: rows,
      );
    }

    return Scaffold(
      backgroundColor: astroUserConsultBG,
      appBar: AppBar(
        backgroundColor: astroUserConsultBG,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
            '${widget.astrologerFirstName} ${widget.astrologerSecondName}',
            style: TextStyle(
                color: whiteColor,
                fontSize: util.fontSize20,
                fontFamily: AppFont.get(FontType.bold),
                height: 1.0)),
        leading: IconButton(
          icon: SvgPicture.asset(
            appBackButton,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: util.width20),
          child: Column(
            children: [
              SvgPicture.asset(astroCalenderLine),
              buildHeader(),
              SvgPicture.asset(astroCalenderLine),
              SizedBox(height: 10),
              buildCalendar(daysInMonth, firstWeekday),
              SizedBox(
                height: util.height20,
              ),
              FutureBuilder<List<SlotModel>>(
                future: slotFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.halfTriangleDot(
                        color: whiteColor,
                        size: MyUtility(context).height30,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print('Error fetching slots: ${snapshot.error}');
                    return Center(child: Text('Error loading slots'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      'No slots available'.tr,
                      style: TextStyle(
                          fontFamily: 'FontSemiBold',
                          fontSize: util.fontSize16,
                          height: 1.0,
                          color: whiteColor),
                    ));
                  }

                  List<SlotModel> slots = snapshot.data!;
                  slots.sort((a, b) => parseWithoutOffset(a.startTime)
                      .compareTo(parseWithoutOffset(b.startTime)));

                  return Container(
                    width: util.width,
                    padding: EdgeInsets.all(util.width20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing Availability'.tr,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize16,
                                height: 1.0,
                                color: blackColor.withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              '${slots.where((slot) => !DateTime.parse(slot.startTime).isBefore(DateTime.now())).length} ${'Slots'.tr} - ${'30 mins each'.tr}',
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize13,
                                height: 1.0,
                                color: astroUserConsultBG,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: util.height20),
                        SvgPicture.asset(astroCalenderLine,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.2),
                                BlendMode.srcIn)),
                        Visibility(
                            visible: alreadySelected,
                            child: Column(
                              children: [
                                SizedBox(height: util.height10),
                                Text(
                                  slotWarningMessage,
                                  style: TextStyle(
                                      fontFamily: 'FontSemiBold',
                                      fontSize: util.fontSize14,
                                      color: errorColor,
                                      height: 1.0),
                                ),
                              ],
                            )),
                        SizedBox(height: util.height20),

                        /// Slot list
                        SizedBox(
                          width: util.width,
                          child: RawScrollbar(
                            thumbVisibility: true,
                            controller: scrollController,
                            thumbColor: percentageProgress,
                            thickness: 5,
                            radius: const Radius.circular(8),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: util.width10),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.spaceEvenly,
                                  children: slots
                                      .where((slot) {
                                        final slotDateTime =
                                            parseWithoutOffset(slot.startTime);
                                        return !slotDateTime
                                            .isBefore(DateTime.now());
                                      })
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        final index = entry.key;
                                        final slot = entry.value;
                                        final slotDateTime =
                                            parseWithoutOffset(slot.startTime);
                                        final startTime =
                                            TimeOfDay.fromDateTime(
                                                slotDateTime);
                                        final endTime = TimeOfDay.fromDateTime(
                                            slotDateTime.add(
                                                const Duration(minutes: 30)));

                                        final slotTime =
                                            formatTimeTo12Hour(startTime);
                                        final slotEndTime =
                                            formatTimeTo12Hour(endTime);
                                        final isBooked = slot.eventBooked;
                                        final isSelected =
                                            selectedSlotIndex == index;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedSlotIndex = index;
                                              alreadySelected = isBooked;
                                              bookingTime = isBooked
                                                  ? ''
                                                  : '$slotTime - $slotEndTime';
                                              slotWarningMessage = isBooked
                                                  ? '*This slot is already booked!'
                                                      .tr
                                                  : '';
                                              showError = false;
                                            });
                                          },
                                          child: Container(
                                            padding:
                                                EdgeInsets.all(util.width10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isBooked
                                                    ? errorColor.withValues(
                                                        alpha: 0.3)
                                                    : blackColor.withValues(
                                                        alpha: 0.1),
                                              ),
                                              color: isSelected
                                                  ? (isBooked
                                                      ? whiteColor
                                                      : astroUserConsultBG)
                                                  : whiteColor,
                                            ),
                                            child: Text(
                                              slotTime,
                                              style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.medium),
                                                fontSize: util.fontSize16,
                                                height: 1.0,
                                                color: isSelected
                                                    ? (isBooked
                                                        ? errorColor
                                                        : whiteColor)
                                                    : isBooked
                                                        ? errorColor.withValues(
                                                            alpha: 0.5)
                                                        : blackColor.withValues(
                                                            alpha: 0.6),
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: util.height20,
              ),
              Visibility(
                  visible: showError,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Text('* Choose a preferred timing'.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                color: errorColor)),
                        SizedBox(
                          height: util.height20,
                        ),
                      ],
                    ),
                  )),
              GestureDetector(
                onTap: () {
                  print('bookingDate: $bookingDate');
                  print('SelectedDate: $bookingTime');
                  if (bookingDate.isEmpty) {
                    setState(() {
                      bookingDate =
                          DateFormat("d MMMM, y").format(DateTime.now());
                    });
                  } else {
                    // final rawDate = DateFormat("yyyy-MM-dd").parse(bookingDate);
                    // final formattedDate = DateFormat("d MMMM, y").format(rawDate);
                    final formattedDate = formatBookingDate(bookingDate);
                    setState(() {
                      bookingDate = formattedDate;
                    });
                  }

                  if (bookingTime.isEmpty) {
                    setState(() {
                      showError = true;
                    });
                  } else {
                    setState(() {
                      showError = false;
                    });
                    // print('Fees: $');
                    Get.to(() => UserBookingDetailsPage(
                          selectedCategories: widget.selectedCategories,
                          selectedLanguages: widget.selectedLanguages,
                          bookingDate: bookingDate,
                          bookingTime: bookingTime,
                          consultingFee: widget.consultingFee,
                          profileImage: widget.profileImage,
                          astrologerId: widget.astrologerId,
                          astrologerFirstName: widget.astrologerFirstName,
                          astrologerLastName: widget.astrologerSecondName,
                          currency: widget.currency,
                        ));
                  }
                },
                child: Container(
                  width: util.width,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: whiteColor),
                  child: Text(
                    'Book Consultation'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'FontSemiBold',
                        fontSize: util.fontSize18,
                        height: 1.0,
                        color: astroUserConsultBG),
                  ),
                ),
              ),
              SizedBox(
                height: util.height50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
