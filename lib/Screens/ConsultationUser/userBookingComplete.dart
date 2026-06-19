import 'dart:ui';
import 'package:astro_prompt/Components/Consultation-User/ratingDialog.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astrologer_consult_event_model.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/question_model.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Services/Astrologer-user/questionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';


class UserConsultationBookingComplete extends StatefulWidget {
  final int eventId;
  final List<String> categories;
  final List<String> languages;
  final String bookingDate;
  final String bookingTime;
  final String consultingFee;
  final String profileImage;
  final String firstName;
  final String lastName;
  final int rating;
  final String currency;

  const UserConsultationBookingComplete(
      {super.key,
      required this.eventId,
      required this.categories,
      required this.languages,
      required this.bookingDate,
      required this.bookingTime,
      required this.consultingFee,
      required this.profileImage,
      required this.firstName,
      required this.lastName,
      required this.currency,
      required this.rating});

  @override
  State<UserConsultationBookingComplete> createState() =>
      _UserConsultationBookingCompleteState();
}

class _UserConsultationBookingCompleteState
    extends State<UserConsultationBookingComplete> {
  late Future<List<UserQuestion>> fetchQuestions;
  AstroUserQuestion astroUserQuestion = AstroUserQuestion();
  int questionCount = 0;
  final astroService = AstroUserEventService();
  late Future<ConsultationEventModel?> eventFuture;

  @override
  void initState() {
    super.initState();
    eventFuture = astroService.fetchAstroSingleUserEvent(widget.eventId);
    getQuestions();
  }

  void getQuestions() {
    final future = astroUserQuestion.getQuestion(widget.eventId);
    setState(() {
      fetchQuestions = future;
    });
    future.then((questions) {
      setState(() {
        questionCount = questions.length;
      });
    });
  }

  void refreshQuestion() {
    setState(() {
      fetchQuestions = astroUserQuestion.getQuestion(widget.eventId);
    });
  }

  void refreshRating() {
    setState(() {
      eventFuture = astroService.fetchAstroSingleUserEvent(widget.eventId);
    });
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
        leading: IconButton(
          icon: SvgPicture.asset(appBackButton,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn)),
          onPressed: () {
            Get.back(result: true);
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                      // image: DecorationImage(
                      //   image: NetworkImage(widget.profileImage),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: ClipOval(
                      child: widget.profileImage.isNotEmpty
                          ? Image.network(
                              widget.profileImage,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: lightGrey,
                              child: Center(
                                child: Image.asset(
                                  dummyImage,
                                  width: 20,
                                  height: 20,
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
                    height: 20,
                  ),
                  SvgPicture.asset(astroCalenderLine,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.2),
                          BlendMode.srcIn)),
                  SizedBox(
                    height: 12,
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
                    height: 12,
                  ),
                  SvgPicture.asset(astroCalenderLine,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.2),
                          BlendMode.srcIn)),
                  SizedBox(
                    height: 10,
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
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                ),
                              ),
                              Text(':  '),
                              Expanded(
                                  child: Text(
                                widget.bookingDate,
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
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                ),
                              ),
                              Text(':  '),
                              Expanded(
                                  child: Text(
                                widget.bookingTime,
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
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                ),
                              ),
                              Text(':  '),
                              Expanded(
                                  child: Text(
                                widget.categories
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
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                ),
                              ),
                              Text(':  '),
                              Expanded(
                                  child: Text(
                                widget.languages
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
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.0,
                                      color: blackColor.withValues(alpha: 0.5)),
                                ),
                              ),
                              Text(':  '),
                              Expanded(
                                child: Text(
                                  '${widget.currency == 'INR' ? '₹' : '\$'} ${double.parse(widget.consultingFee).toStringAsFixed(2)}/-',
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
                    height: 10,
                  ),
                  SvgPicture.asset(astroCalenderLine,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.2),
                          BlendMode.srcIn)),
                  SizedBox(
                    height: 20,
                  ),
//Rating Section
                  FutureBuilder<ConsultationEventModel?>(
                    future: eventFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.halfTriangleDot(
                            color: Color(0xff85AD0A),
                            size: MyUtility(context).height30,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading data'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No event data found'));
                      }

                      final eventData = snapshot.data!;
                      final rating =
                          eventData.rating ?? 0; // fallback in case null

                      return rating == 0
                          ? GestureDetector(
                              onTap: () async {
                                final shouldRefresh =
                                    await showGeneralDialog<bool>(
                                  context: context,
                                  barrierLabel: "RatingDialog",
                                  barrierDismissible: true,
                                  barrierColor:
                                      Colors.black.withValues(alpha: 0.4),
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                  pageBuilder:
                                      (context, animation1, animation2) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 4, sigmaY: 4),
                                      child: Center(
                                        child: RatingDialog(
                                          meetingId: widget.eventId,
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (shouldRefresh == true) {
                                  refreshRating(); // This triggers the FutureBuilder to rebuild
                                }
                              },
                              child: Container(
                                width: util.width,
                                padding: EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xff85AD0A),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Give Rating'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize16,
                                        height: 1.0,
                                        color: whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    SvgPicture.asset(
                                      customerRatingSelect,
                                      width: 15,
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  'Ratings'.tr,
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.semiBold),
                                    fontSize: util.fontSize14,
                                    height: 1.0,
                                    color: blackColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      rating.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize24,
                                        height: 1.0,
                                        color: blackColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SvgPicture.asset(
                                      customerRatingSelect,
                                      width: 23,
                                      height: 23,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SvgPicture.asset(
                                  astroCalenderLine,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withValues(alpha: 0.2),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            );
                    },
                  ),

//                   eventFuture.rating == 0
//                       ? GestureDetector(
//                           onTap: () async {
//                             final shouldRefresh = await showGeneralDialog<bool>(
//                               context: context,
//                               barrierLabel: "RatingDialog",
//                               barrierDismissible: true,
//                               barrierColor: Colors.black.withValues(alpha: 0.4), // semi-transparent dark blur
//                               transitionDuration: const Duration(milliseconds: 200),
//                               pageBuilder: (context, animation1, animation2) {
//                                 return BackdropFilter(
//                                   filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//                                   child: Center(
//                                     child: RatingDialog(
//                                       meetingId: widget.eventId,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                             if (shouldRefresh == true) {
//                               refreshRating();
//                             }
//                           },
//                           child: Container(
//                             width: util.width,
//                             padding: EdgeInsets.symmetric(vertical: 13),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Color(0xff85AD0A),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Give Rating',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize16, height: 1.0, color: whiteColor),
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                                 SvgPicture.asset(
//                                   customerRatingSelect,
//                                   width: 15,
//                                   height: 15,
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       : Column(
//                           children: [
//                             Text(
//                               'Ratings',
//                               style: TextStyle(
//                                  fontFamily: AppFont.get(FontType.semiBold), fontSize: util.fontSize14, height: 1.0, color: blackColor.withValues(alpha: 0.5)),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   '${widget.rating.toString()}.0',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize24, height: 1.0, color: blackColor),
//                                 ),
//                                 SizedBox(
//                                   width: 12,
//                                 ),
//                                 SvgPicture.asset(
//                                   customerRatingSelect,
//                                   width: 23,
//                                   height: 23,
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             SvgPicture.asset(astroCalenderLine, colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.2), BlendMode.srcIn)),
//                           ],
//                         ),

//Questions Section
                  FutureBuilder<List<UserQuestion>>(
                    future: fetchQuestions,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
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
                                            height: 1.0,
                                            color: blackColor),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      if (questions[index].answer != null &&
                                          questions[index].answer!.isNotEmpty)
                                        Text(
                                          questions[index].answer!,
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFont.get(FontType.medium),
                                              fontSize: util.fontSize14,
                                              height: 1.2,
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
    );
  }
}
