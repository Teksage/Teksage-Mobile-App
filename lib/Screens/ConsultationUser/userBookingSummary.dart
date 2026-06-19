import 'dart:ui';
import 'package:astro_prompt/Components/Consultation-User/questionsDialog.dart';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/question_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/user_booking_consultation_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userConsultationHomePage.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Services/Astrologer-user/questionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/launchGoogleMeet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class UserConsultationSummary extends StatefulWidget {
  final UserBookingConsultation bookingSummary;
  final String profilePicture;
  final String firstName;
  final String lastName;
  final String currency;
  const UserConsultationSummary(
      {super.key,
      required this.bookingSummary,
      required this.profilePicture,
      required this.firstName,
      required this.lastName,
      required this.currency});

  @override
  State<UserConsultationSummary> createState() =>
      _UserConsultationSummaryState();
}

class _UserConsultationSummaryState extends State<UserConsultationSummary> {
  String formattedDate = '';
  String formattedTime = '';
  late Future<List<UserQuestion>> fetchQuestions;
  AstroUserQuestion astroUserQuestion = AstroUserQuestion();
  int questionCount = 0;
  List<AstroConsultationEventModel> eventGetData = [];

  Future<void> fetchAstroUserEventService() async {
    try {
      final userId = await getUserId();
      var fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId!);
      setState(() {
        eventGetData = fetchEventData;
      });
    } catch (e) {
      print("Error fetching Astro User Event list: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    getQuestions();
  }

  void getQuestions() {
    final future =
        astroUserQuestion.getQuestion(widget.bookingSummary.event.id);
    setState(() {
      fetchQuestions = future;
    });
    future.then((questions) {
      setState(() {
        questionCount = questions.length;
      });

      if (questionCount < 5) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel: "ConsultationDialog",
            pageBuilder: (context, anim1, anim2) {
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                },
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child:
                            Container(color: blackColor.withValues(alpha: 0.1)),
                      ),
                      Center(
                        child: ConsultationDialog(
                          eventId: widget.bookingSummary.event.id,
                          onSubmit: refreshQuestion,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
      }
    });
  }

  void refreshQuestion() {
    setState(() {
      fetchQuestions =
          astroUserQuestion.getQuestion(widget.bookingSummary.event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final profileImage = widget.profilePicture;
    final isAssetImage = profileImage.startsWith('assets/');
    setState(() {
      formattedDate =
          convertDateToReadableFormat(widget.bookingSummary.event.startTime);
      formattedTime = convertTimeRangeToReadable(
          widget.bookingSummary.event.startTime,
          widget.bookingSummary.event.endTime);
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(
            () async {
              CustomLoader.show(context, loaderColor: questionButtonColor);
              try {
                final userId = await getUserId();
                final List<AstroConsultationEventModel>? fetchEventData =
                    await AstroUserEventService().fetchAstroUserEvents(userId!);

                CustomLoader.hide();
                if (fetchEventData != null) {
                  Get.to(() => UserConsultationDetailsHome(
                        eventData: fetchEventData,
                        backButton: false,
                      ));
                } else {
                  print("No event data received.");
                }
              } catch (e) {
                CustomLoader.hide();
                print("Error fetching Astro User Event list: $e");
              }
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(appBackButton,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn)),
            onPressed: () async {
              CustomLoader.show(context, loaderColor: questionButtonColor);
              try {
                final userId = await getUserId();
                final List<AstroConsultationEventModel>? fetchEventData =
                    await AstroUserEventService().fetchAstroUserEvents(userId!);

                CustomLoader.hide();
                if (fetchEventData != null) {
                  Get.to(() => UserConsultationDetailsHome(
                        eventData: fetchEventData,
                        backButton: false,
                      ));
                } else {
                  print("No event data received.");
                }
              } catch (e) {
                CustomLoader.hide();
                print("Error fetching Astro User Event list: $e");
              }
            },
          ),
          title: Text('Booking Details'.tr,
              style: TextStyle(
                  color: blackColor,
                  fontSize: util.fontSize20,
                  fontFamily: AppFont.get(FontType.bold),
                  height: 1.0)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                width: util.width,
                padding: EdgeInsets.symmetric(horizontal: util.width20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                        // image: DecorationImage(
                        //   image: NetworkImage(widget.profilePicture),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: ClipOval(
                        child: !isAssetImage
                            ? Image.network(
                                profileImage,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: lightGrey,
                                child: Center(
                                  child: Image.asset(
                                    profileImage,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('${widget.firstName} ${widget.lastName}',
                        style: TextStyle(
                            color: blackColor,
                            fontSize: util.fontSize24,
                            fontFamily: 'FontSemiBold',
                            height: 1.0)),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        launchGoogleMeet(
                            widget.bookingSummary.event.eventLink!);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: Color(0xff87AE0E), width: 1)),
                        child: Text(
                          'Meeting Link'.tr,
                           textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'FontSemiBold',
                              fontSize: util.fontSize16,
                              height: 1,
                              color: Color(0xff87AE0E)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SvgPicture.asset(astroCalenderLine,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.2),
                            BlendMode.srcIn)),
                    SizedBox(
                      height: 20,
                    ),
                    //Consultation Details
                    Text(
                      'Consultation Details'.tr,
                      style: TextStyle(
                          fontFamily: 'FontSemiBold',
                          fontSize: util.fontSize14,
                          height: 1.0,
                          color: blackColor.withValues(alpha: 0.6)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SvgPicture.asset(astroCalenderLine,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.2),
                            BlendMode.srcIn)),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: util.width,
                      padding: EdgeInsets.symmetric(horizontal: util.width20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: util.width / 2.5,
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
                                  formattedDate,
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
                                  width: util.width / 2.5,
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
                                  formattedTime,
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
                                  width: util.width / 2.5,
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
                                  widget.bookingSummary.event.category
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
                                  width: util.width / 2.5,
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
                                  widget.bookingSummary.event.languages
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
                                  width: util.width / 2.5,
                                  child: Text(
                                    'Consultation Fee'.tr,
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
                                    '${widget.currency == 'INR' ? '₹ ' : '\$'}${widget.bookingSummary.event.consultationFee.toStringAsFixed(2)}',
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SvgPicture.asset(astroCalenderLine,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.2),
                            BlendMode.srcIn)),
                    SizedBox(
                      height: 20,
                    ),
                    //Questions Section
                    Text('Queries you asked'.tr,
                        style: TextStyle(
                            fontFamily: 'FontSemiBold',
                            fontSize: util.fontSize14,
                            height: 1.0,
                            color: blackColor.withValues(alpha: 0.5))),
                    SizedBox(
                      height: 16,
                    ),

                    FutureBuilder<List<UserQuestion>>(
                      future: fetchQuestions,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: LoadingAnimationWidget.halfTriangleDot(
                            color: questionButtonColor,
                            size: util.height20,
                          ));
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error loading questions'.tr,
                                  style: TextStyle(
                                      fontFamily: 'FontSemiBold',
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: questionButtonColor)));
                        }

                        final questions = snapshot.data ?? [];

                        print('Questions: $questions');

                        // if (questions.isEmpty) {
                        //   return Center(
                        //       child: Text('No questions found',
                        //           style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize14, height: 1.0, color: questionButtonColor)));
                        // }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: questions.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 11),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff8f8f8),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: blackColor.withValues(
                                                alpha: 0.05),
                                            width: 1)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          questions[index].question,
                                          style: TextStyle(
                                              fontFamily: 'FontSemiBold',
                                              fontSize: util.fontSize16,
                                              height: 1.2,
                                              color: blackColor),
                                        ),
                                        if (questions[index].answer != null &&
                                            questions[index].answer!.isNotEmpty)
                                          Text(
                                            questions[index].answer!,
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.medium),
                                                fontSize: util.fontSize14,
                                                height: 1.0,
                                                color: blackColor.withValues(
                                                    alpha: 0.5)),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (questions.isEmpty)
                              Center(
                                  child: Text('No questions found'.tr,
                                      style: TextStyle(
                                          fontFamily: 'FontSemiBold',
                                          fontSize: util.fontSize14,
                                          height: 1.0,
                                          color: questionButtonColor)))
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ))),
      ),
    );
  }
}
