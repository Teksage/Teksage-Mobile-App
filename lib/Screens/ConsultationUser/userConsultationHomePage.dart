import 'dart:ui';
import 'package:astro_prompt/Components/Astrologer/meetingsTab.dart';
import 'package:astro_prompt/Components/Common/dashedLine.dart';
import 'package:astro_prompt/Components/Consultation-User/ratingDialog.dart';
import 'package:astro_prompt/Components/Notification/Find&ConsultCard.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/UserBookingSummaryHome.dart';
import 'package:astro_prompt/Screens/ConsultationUser/astrologerDetailpage.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userBookingComplete.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userCategory.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/launchGoogleMeet.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class UserConsultationDetailsHome extends StatefulWidget {
  final bool backButton;
  final List<AstroConsultationEventModel> eventData;
  const UserConsultationDetailsHome(
      {super.key, required this.eventData, required this.backButton});

  @override
  State<UserConsultationDetailsHome> createState() =>
      _UserConsultationDetailsHomeState();
}

class _UserConsultationDetailsHomeState
    extends State<UserConsultationDetailsHome>
    with SingleTickerProviderStateMixin {
  bool isUpcoming = true;
  int completedCount = 0;
  List<AstroConsultationEventModel> upcomingMeetings = [];
  List<AstroConsultationEventModel> completedMeetings = [];
  List<AstroConsultationEventModel> eventGetData = [];
  final astroService = AstroUserEventService();
  String currency = '';
  // int userId = 0;

  Future<void> fetchAstroUserEventService() async {
    try {
      final userId = await getUserId();
      final fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId!);

      final filteredData = fetchEventData
          .where((e) => e.status == 'confirmed' || e.status == 'completed')
          .toList()
        ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
      setState(() {
        eventGetData = filteredData;
        completedMeetings =
            eventGetData.where((e) => e.status == 'completed').toList();
        upcomingMeetings =
            eventGetData.where((e) => e.status == 'confirmed').toList();
        completedCount =
            completedMeetings.where((e) => e.queriesAnswered != null).length;
      });

      print('upcomingMeetings: ${upcomingMeetings.length}');
    } catch (e) {
      debugPrint("Error fetching Astro User Event list: $e");
    }
  }

  Future<void> fetchCurrency() async {
    await CurrencyHelper.fetchCurrencyIfNeeded(
      context: context,
      currentCurrency: currency,
      onCurrencyFetched: (fetchedCurrency) {
        setState(() {
          currency = fetchedCurrency;
          print('fetchedCurrency,$fetchedCurrency');
        });
      },
    );
  }

  Future<void> navigateToAstrologerDetail({
    required int astrologerId,
    required List<String> selectedCategories,
    required List<String> selectedLanguages,
  }) async {
    // Ensure currency is fetched before navigating
    await fetchCurrency();
    
    if (!mounted) return;
    
    print('Navigating to AstrologerDetailPage with currency: $currency');
    Get.to(() => AstrologerDetailPage(
      astrologerId: astrologerId,
      selectedCategories: selectedCategories,
      selectedLanguages: selectedLanguages,
      currency: currency,
    ));
  }

  @override
  void initState() {
    super.initState();
    fetchAstroUserEventService();
    fetchCurrency();
  }

  void onTabChanged(bool isUpcomingSelected) {
    setState(() {
      isUpcoming = isUpcomingSelected;
    });
  }

  double _getExpandedHeight() {
    final currentLocale = Get.locale?.languageCode ?? 'en';

    // Define heights for different languages
    switch (currentLocale) {
      case 'ta': // Tamil
      case 'tamil':
        return 310;
      case 'hi': // Hindi
      case 'hindi':
        return 230;
      case 'te': // Telugu
      case 'telugu':
        return 250;
      case 'ml': // Malayalam
      case 'malayalam':
        return 290;
      case 'kn': // Kannada
      case 'kannada':
        return 270;
      case 'mr': // Marathi
      case 'marathi':
        return 250;
      default: // English and other languages
        return 230;
    }
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            widget.backButton
                ? Get.back()
                : Get.to(() => BottomNavigationScreen());
          });
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      floating: false,
                      expandedHeight: _getExpandedHeight(),
                      backgroundColor: questionButtonColor,
                      elevation: 0,
                      centerTitle: true,
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child:
                            Text(PlatformTextConfig.astrologerUserHomeTitle.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: util.fontSize20,
                                  fontFamily: AppFont.get(FontType.bold),
                                )),
                      ),
                      leading: IconButton(
                        icon: SvgPicture.asset(
                          appBackButton,
                        ),
                        onPressed: () {
                          widget.backButton
                              ? Get.back()
                              : Get.to(() => BottomNavigationScreen());
                          // Get.back();
                        },
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.only(
                              top: 110, left: 10, right: 10, bottom: 20),
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => UserCategoryPage(
                                      toHome: false,
                                      // currency: widget.currency,
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xffa2be35),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              PlatformTextConfig
                                                  .astrologerUserCTA1.tr,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.semiBold),
                                                fontSize: util.fontSize18,
                                                height: 1.2,
                                                color: Color(0xff455c02),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Transform.rotate(
                                            angle: 3.1416,
                                            child: SvgPicture.asset(
                                              appBackButton,
                                              colorFilter: ColorFilter.mode(
                                                Color(0xff455c02),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    FindConsultCard(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: MeetingTabHeaderDelegate(
                        isUpcoming: isUpcoming,
                        onTabChanged: onTabChanged,
                        completedCount: completedCount,
                      ),
                    ),
                  ];
                },
                body: (isUpcoming ? upcomingMeetings : completedMeetings)
                        .isEmpty
                    ? Container(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          isUpcoming
                              ? "You have no upcoming meetings at the moment."
                                  .tr
                              : "You have no completed meetings at the moment."
                                  .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: blackColor.withAlpha(150),
                            fontFamily: AppFont.get(FontType.medium),
                            fontSize: MyUtility(context).fontSize14,
                            height: 1.0,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 50),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: isUpcoming
                              ? upcomingMeetings.length
                              : completedMeetings.length,
                          itemBuilder: (context, index) {
                            final event = isUpcoming
                                ? upcomingMeetings[index]
                                : completedMeetings[index];
                            // final date = DateFormat("dd MMM, yyyy - h:mm a").format(DateTime.parse(event.startTime));
                            final DateTime eventDt =
                                parseWithoutOffset(event.startTime);
                            final date = DateFormat("dd MMM, yyyy - h:mm a")
                                .format(eventDt);
                            final eventDate =
                                DateFormat("d MMMM, y").format(eventDt);
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: isUpcoming
                                        ? blackColor.withValues(alpha: 0.04)
                                        : whiteColor,
                                    width: 1),
                                color:
                                    isUpcoming ? Color(0xfff8f8f8) : whiteColor,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: isUpcoming ? 20 : 0,
                                  bottom: isUpcoming ? 20 : 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 41,
                                        height: 41,
                                        decoration: BoxDecoration(
                                            color: lightGrey,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: astroUserConsultBG
                                                    .withValues(alpha: 0.3),
                                                width: 2.6)),
                                        child: ClipOval(
                                          child: event.profileImage.isNotEmpty
                                              ? Image.network(
                                                  event.profileImage,
                                                  fit: BoxFit.cover,
                                                )
                                              : Center(
                                                  child: Image.asset(
                                                    dummyImage,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'meeting_with'.tr.replaceAll(
                                                  '{name}',
                                                  '${event.astrologerFirstName} ${event.astrologerLastName}',
                                                ),
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.medium),
                                                fontSize: MyUtility(context)
                                                    .fontSize14,
                                                height: 1.0,
                                                color: blackColor.withValues(
                                                    alpha: 0.8)),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            date,
                                            style: TextStyle(
                                                fontFamily: AppFont.get(
                                                    FontType.semiBold),
                                                fontSize: MyUtility(context)
                                                    .fontSize16,
                                                color: blackColor,
                                                height: 1.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13),
                                  (!isUpcoming && event.queriesAnswered != null)
                                      ? Column(
                                          children: [
                                            Container(
                                              width: util.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Color(0xffDDE8A9),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                "Astrologer submitted answers for your queries"
                                                    .tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: util.fontSize13,
                                                    fontFamily: AppFont.get(
                                                        FontType.medium),
                                                    height: 1.0,
                                                    color: Color(0xff4B5909)),
                                              ),
                                            ),
                                            SizedBox(height: 13),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  isUpcoming
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final DateFormat inputFormat =
                                                      DateFormat(
                                                          "yyyy-MM-ddTHH:mm:ss");
                                                  final DateFormat
                                                      outputFormat =
                                                      DateFormat("hh:mm a");

                                                  final DateTime start =
                                                      inputFormat.parse(
                                                          event.startTime);
                                                  final DateTime end =
                                                      inputFormat
                                                          .parse(event.endTime);

                                                  String formattedTime =
                                                      "${outputFormat.format(start)} - ${outputFormat.format(end)}";
                                                  print(
                                                      'Formatted Time: $formattedTime ${event.bookingDate}');
                                                  Get.to(() =>
                                                      UserConsultationSummaryHome(
                                                        categories:
                                                            event.category!,
                                                        languages:
                                                            event.languages!,
                                                        bookingDate: eventDate,
                                                        bookingTime:
                                                            formattedTime,
                                                        consultingFee: event
                                                            .consultationFee
                                                            .toString(),
                                                        currency:
                                                            event.currency,
                                                        profileImage:
                                                            event.profileImage,
                                                        eventId: event.id,
                                                        firstName: event
                                                            .astrologerFirstName!,
                                                        lastName: event
                                                            .astrologerLastName!,
                                                        meetingLink:
                                                            event.eventLink,
                                                      ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff87ae0e),
                                                        width: 1),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 9),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'View Details'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'FontSemiBold',
                                                      fontSize: util.fontSize16,
                                                      height: 1.0,
                                                      color: Color(0xff87ae0e),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              flex: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  print(
                                                      'EventLink: ${event.eventLink}');
                                                  launchGoogleMeet(
                                                      event.eventLink);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff87ae0e),
                                                        width: 1),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 9),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Meeting Link'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'FontSemiBold',
                                                      fontSize: util.fontSize16,
                                                      height: 1.0,
                                                      color: Color(0xff87ae0e),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(
                                          height: 55,
                                          width: util.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  event.rating != null
                                                      ? Text(
                                                          '${event.rating}.0',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'FontSemiBold',
                                                              fontSize: util
                                                                  .fontSize16,
                                                              color: Color(
                                                                  0xff87AE0E),
                                                              height: 1.0),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            final shouldRefresh =
                                                                await showGeneralDialog<
                                                                    bool>(
                                                              context: context,
                                                              barrierLabel:
                                                                  "RatingDialog",
                                                              barrierDismissible:
                                                                  true,
                                                              barrierColor: Colors
                                                                  .black
                                                                  .withValues(
                                                                      alpha:
                                                                          0.4), // semi-transparent dark blur
                                                              transitionDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              pageBuilder: (context,
                                                                  animation1,
                                                                  animation2) {
                                                                return BackdropFilter(
                                                                  filter: ImageFilter
                                                                      .blur(
                                                                          sigmaX:
                                                                              4,
                                                                          sigmaY:
                                                                              4),
                                                                  child: Center(
                                                                    child:
                                                                        RatingDialog(
                                                                      meetingId:
                                                                          event
                                                                              .id,
                                                                      onSubmit:
                                                                          (newRating) {
                                                                        setState(
                                                                            () {
                                                                          final list = isUpcoming
                                                                              ? upcomingMeetings
                                                                              : completedMeetings;
                                                                          final index = list.indexWhere((e) =>
                                                                              e.id ==
                                                                              event.id);
                                                                          if (index !=
                                                                              -1) {
                                                                            list[index] =
                                                                                list[index].copyWith(rating: newRating);
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                            if (shouldRefresh ==
                                                                true) {
                                                              await fetchAstroUserEventService();
                                                              // setState(() {
                                                              //   completedMeetings = eventGetData.where((e) => e.status == 'completed').toList();
                                                              //   upcomingMeetings = eventGetData.where((e) => e.status == 'confirmed').toList();
                                                              //   completedCount = completedMeetings.where((e) => e.queriesAnswered != null).length;
                                                              // });
                                                            }
                                                          },
                                                          child: Text(
                                                            'Rate'.tr,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'FontSemiBold',
                                                                fontSize: util
                                                                    .fontSize14,
                                                                height: 1.0,
                                                                color: Color(
                                                                    0xff87AE0E)),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    width: 0,
                                                  ),
                                                  SvgPicture.asset(
                                                      ratingSelect),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: VerticalDivider(
                                                  color: blackColor.withValues(
                                                      alpha: 0.2),
                                                  thickness: 1,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => navigateToAstrologerDetail(
                                                  astrologerId: event.astrologerId,
                                                  selectedCategories: [],
                                                  selectedLanguages: [],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Text(
                                                    'Meet Again'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'FontSemiBold',
                                                        fontSize:
                                                            util.fontSize14,
                                                        height: 1.0,
                                                        color:
                                                            Color(0xff87AE0E)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2),
                                                child: VerticalDivider(
                                                  color: blackColor.withValues(
                                                      alpha: 0.2),
                                                  thickness: 1,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  final DateFormat inputFormat =
                                                      DateFormat(
                                                          "yyyy-MM-ddTHH:mm:ss");
                                                  final DateFormat
                                                      outputFormat =
                                                      DateFormat("hh:mm a");

                                                  final DateTime start =
                                                      inputFormat.parse(
                                                          event.startTime);
                                                  final DateTime end =
                                                      inputFormat
                                                          .parse(event.endTime);
                                                  String formattedTime =
                                                      "${outputFormat.format(start)} - ${outputFormat.format(end)}";

                                                  final shouldRefresh = await Get.to(() =>
                                                      UserConsultationBookingComplete(
                                                          categories:
                                                              event.category!,
                                                          languages:
                                                              event.languages!,
                                                          bookingDate:
                                                              event.bookingDate,
                                                          bookingTime:
                                                              formattedTime,
                                                          consultingFee: event
                                                              .consultationFee
                                                              .toString(),
                                                          profileImage: event
                                                              .profileImage,
                                                          eventId: event.id,
                                                          firstName: event
                                                              .astrologerFirstName!,
                                                          lastName: event
                                                              .astrologerLastName!,
                                                          rating:
                                                              event.rating ?? 0,
                                                          currency:
                                                              event.currency));

                                                  if (shouldRefresh == true) {
                                                    await fetchAstroUserEventService();
                                                    // setState(() {
                                                    //   completedMeetings = widget.eventData.where((e) => e.status == 'completed').toList();
                                                    // });
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Text(
                                                    'View Details'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'FontSemiBold',
                                                        fontSize:
                                                            util.fontSize14,
                                                        height: 1.0,
                                                        color:
                                                            Color(0xff87AE0E)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  if (!isUpcoming) ...[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    DashedLine(
                                      dashWidth: 2,
                                      color: blackColor.withValues(alpha: 0.2),
                                    ),
                                  ]
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isUpcoming;
  final void Function(bool) onTabChanged;
  final int? completedCount;

  MeetingTabHeaderDelegate(
      {required this.isUpcoming,
      required this.onTabChanged,
      this.completedCount});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MeetingTabButton(
                  label: "Upcoming",
                  selected: isUpcoming,
                  userPage: false,
                  onTap: () => onTabChanged(true),
                ),
                const SizedBox(width: 8),
                MeetingTabButton(
                  label: "Completed",
                  selected: !isUpcoming,
                  userPage: true,
                  count: completedCount,
                  onTap: () => onTabChanged(false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant MeetingTabHeaderDelegate oldDelegate) {
    return oldDelegate.isUpcoming != isUpcoming ||
        oldDelegate.completedCount != completedCount;
  }
}
