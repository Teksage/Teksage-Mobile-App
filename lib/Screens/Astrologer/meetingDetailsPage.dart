import 'package:astro_prompt/Components/Astrologer/answerDialog.dart';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/customSnackBar.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_consult_event_model.dart';
import 'package:astro_prompt/Screens/Astrologer/homePage.dart';
import 'package:astro_prompt/Screens/Astrologer/horoscopeDetailPage.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/enum/enum.dart';
import 'package:astro_prompt/config/launchGoogleMeet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class MeetingDetailsPage extends StatefulWidget {
  final int meetingId;
  final String initials;
  final String name;
  final bool? meetingStatus;
  final String meetingLink;
  const MeetingDetailsPage(
      {super.key,
      required this.meetingId,
      required this.initials,
      required this.name,
      this.meetingStatus,
      required this.meetingLink});

  @override
  State<MeetingDetailsPage> createState() => _MeetingDetailsPageState();
}

class _MeetingDetailsPageState extends State<MeetingDetailsPage> {
  final astroService = AstroUserEventService();
  late Future<ConsultationEventModel?> eventFuture;
  bool isCompleted = false;
  List<AstroConsultationEventModel> eventData = [];

  Future<void> fetchAstroUserEventService() async {
    try {
      final userId = await getUserId();
      var fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId!);
      var data = fetchEventData
          .where((e) => e.status == 'confirmed' || e.status == 'completed')
          .toList()
        ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
      setState(() {
        eventData = data;
      });
    } catch (e) {
      print("Error fetching Astro User Event list: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    eventFuture = astroService.fetchAstroSingleUserEvent(widget.meetingId);
    print('widget.meetingStatus: ${eventFuture}');
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return Scaffold(
      backgroundColor: astroUserConsultBG,
      appBar: AppBar(
        backgroundColor: astroUserConsultBG,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text("Meeting Details".tr,
            style: TextStyle(
                color: whiteColor,
                fontSize: util.fontSize20,
                fontFamily: AppFont.get(FontType.bold),
                height: 1.0)),
        leading: SizedBox(
          width: util.responsiveWidth(0.08),
          height: util.responsiveHeight(0.037),
          child: IconButton(
            icon: SvgPicture.asset(
              backButton,
              width: util.width20,
              height: util.height20,
              colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn),
            ),
            onPressed: () async {
              if (isCompleted) {
                CustomLoader.show(context, loaderColor: astroUserConsultBG);
                await fetchAstroUserEventService();
                CustomLoader.hide();

                Get.to(() => AstrologerHomePage(
                      eventData: eventData,
                    ));
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(util.width20),
          child: FutureBuilder<ConsultationEventModel?>(
              future: astroService.fetchAstroSingleUserEvent(widget.meetingId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: util.height / 2,
                    width: util.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MyUtility(context).responsiveWidth(0.2668),
                        height: MyUtility(context).responsiveHeight(0.1232),
                        child: Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(util.width20),
                          ),
                          child: Center(
                            child: LoadingAnimationWidget.halfTriangleDot(
                              color: astroUserConsultBG,
                              size: MyUtility(context).height30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                      child: Text('No event found.'.tr,
                          style: TextStyle(
                              fontFamily: 'FontSemiBold',
                              fontSize: MyUtility(context).fontSize13,
                              color: whiteColor)));
                }
                print('widget.meetingId: ${widget.meetingId}');
                final event = snapshot.data!;
                final questions = event.questions;
                final horoscope = event.userHoroscope;
                final customer = event.customer;
                final hasAnswered =
                    questions.every((q) => (q.answer?.isNotEmpty ?? false));

                final eventTime = parseWithoutOffset(event.startTime);
                // final date = DateFormat("dd MMM, yyyy - h:mm a").format(parseWithoutOffset(event.startTime));
                final meetingStartTime =
                    TimeOfDay.fromDateTime(eventTime).format(context);
                final meetingEndTime =
                    TimeOfDay.fromDateTime(eventTime.add(Duration(minutes: 30)))
                        .format(context);
                final meetingDate = DateFormat("d MMMM, y").format(eventTime);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Meeting Details
                    Container(
                      padding: EdgeInsets.all(util.width20),
                      width: util.width,
                      // height: 272,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: homeBanner, width: 3.26)),
                                child: Center(
                                    child: Text(widget.initials,
                                        style: TextStyle(
                                            color: homeBanner,
                                            fontFamily: 'FontSemiBold',
                                            fontSize:
                                                MyUtility(context).fontSize18,
                                            height: 1.0))),
                              ),
                              SizedBox(
                                width: util.width20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize18,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.8)),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    '${'Booked a slot for'.tr} ${event.consultationDuration} ${'min'.tr}'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.8)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          DashedLine(
                            dashWidth: 1,
                            color: blackColor.withValues(alpha: 0.3),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 3,
                                  child: Text(
                                    'Date'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  meetingDate,
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 3,
                                  child: Text(
                                    'Time'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  '$meetingStartTime - $meetingEndTime',
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 3,
                                  child: Text(
                                    'Consulting On'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  event.category
                                      .map((e) =>
                                          e[0].toUpperCase() + e.substring(1))
                                      .join(', '),
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 3,
                                  child: Text(
                                    'Language'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                    child: Text(
                                  event.languages
                                      .map((e) =>
                                          e[0].toUpperCase() + e.substring(1))
                                      .join(', '),
                                  style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 3,
                                  child: Text(
                                    'Fees Paid'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color:
                                            blackColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                                Text(':  '),
                                Expanded(
                                  child: Text(
                                    event.astrologerShare != null
                                        ? '₹ ${event.astrologerShare!.toStringAsFixed(2)}/-'
                                        : '₹ -/-',
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!isCompleted) {
                                if (hasAnswered) {
                                  final result = await astroService
                                      .updateAstrologerEvent(widget.meetingId,
                                          {"status": "completed"});
                                  if (result == 'Event updated successfully') {
                                    setState(() {
                                      isCompleted = true;
                                    });
                                    customSnackBar(
                                      context: context,
                                      message:
                                          'Meeting has been updated Successfully',
                                      backgroundColor: Color(0xffECF4D3),
                                      indicatorColor: mainColor,
                                      iconType: 'success',
                                      // position: SnackBarPosition.top
                                    );
                                  } else {
                                    print('else part');
                                  }
                                } else {
                                  launchGoogleMeet(widget.meetingLink);
                                }
                              } else {
                                print('else part');
                              }
                            },
                            child: Container(
                              width: util.width,
                              padding: EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (isCompleted ||
                                          widget.meetingStatus == true)
                                      ? notEditable
                                      : (!hasAnswered
                                          ? whiteColor
                                          : astroUserConsultBG),
                                  border: (isCompleted ||
                                          widget.meetingStatus == true)
                                      ? null
                                      : Border.all(
                                          color: Color(0xff87AE0E), width: 1)),
                              child: (isCompleted ||
                                      widget.meetingStatus == true)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Submitted'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: AppFont.get(
                                                  FontType.semiBold),
                                              fontSize: util.fontSize16,
                                              color: astroUserConsultBG,
                                              height: 1.0),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          size: 14,
                                          color: astroUserConsultBG,
                                        )
                                      ],
                                    )
                                  : Text(
                                      hasAnswered
                                          ? 'Submit & Mark as completed'.tr
                                          : 'Meeting Link'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.semiBold),
                                          fontSize: util.fontSize16,
                                          color: !hasAnswered
                                              ? Color(0xff87AE0E)
                                              : whiteColor,
                                          height: 1.0),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    ///HoroscopeDetails
                    Container(
                      width: util.width,
                      padding: EdgeInsets.all(util.width20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor,
                          border: Border.all(
                              color: blackColor.withValues(alpha: 0.04),
                              width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(meetingHoroscope),
                          Text(
                            'Horoscope Details'.tr,
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize16,
                                color: blackColor.withValues(alpha: 0.8),
                                height: 1.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (horoscope == null) {
                                showInfoSnackBarDual(context,
                                    'Horoscope details are not available');
                                return;
                              } else {
                                Get.to(() => HoroscopeDetailsPage(
                                      horoscope: horoscope,
                                      fullName: widget.name,
                                    ));
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: astroUserConsultBG, width: 1.0)),
                              child: Text(
                                'View'.tr,
                                style: TextStyle(
                                    fontFamily: 'FontSemiBold',
                                    fontSize: util.fontSize12,
                                    height: 1.0,
                                    color: astroUserConsultBG),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    ///Queries
                    Text(
                      hasAnswered
                          ? "Queries asked - You've already shared your thoughts!"
                              .tr
                          : "Queries asked - Time to share your thoughts!".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'FontSemiBold',
                          fontSize: util.fontSize14,
                          color: blackColor.withValues(alpha: 0.6),
                          height: 1.0),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: blackColor.withValues(alpha: 0.12),
                            width: 1.0),
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: questions.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => DashedLine(
                          dashWidth: 1,
                          color: blackColor.withValues(alpha: 0.3),
                        ),
                        itemBuilder: (context, index) {
                          final question = questions[index];

                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        question.question,
                                        style: TextStyle(
                                            fontFamily: 'FontSemiBold',
                                            fontSize: util.fontSize14,
                                            color: blackColor),
                                      ),
                                    ),
                                    if (question.answer == null ||
                                        question.answer!.isEmpty)
                                      GestureDetector(
                                        onTap: () async {
                                          final DateTime meetingEnd = eventTime
                                              .add(Duration(minutes: 30));
                                          final DateTime now = DateTime.now();

                                          if (now.isBefore(meetingEnd)) {
                                            showInfoSnackBarDual(context,
                                                'You can answer only after completing the consultation.');
                                            return;
                                          } else {
                                            final result = await answerDialog(
                                                context, questions, index);
                                            if (result == true) {
                                              setState(() {
                                                eventFuture = astroService
                                                    .fetchAstroSingleUserEvent(
                                                        widget.meetingId);
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: astroUserConsultBG,
                                                  width: 1)),
                                          child: Text(
                                            'Answer'.tr,
                                            style: TextStyle(
                                                fontFamily: 'FontSemiBold',
                                                fontSize: util.fontSize12,
                                                color: astroUserConsultBG),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                if (question.answer != null &&
                                    question.answer!.isNotEmpty)
                                  Text(
                                    question.answer!.trim().isNotEmpty
                                        ? '${question.answer!.trim()[0].toUpperCase()}${question.answer!.trim().substring(1)}'
                                        : '',
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      color: blackColor.withValues(alpha: 0.5),
                                      height: 1.3,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: util.height50,
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
