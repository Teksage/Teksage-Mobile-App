import 'dart:ui';
import 'package:astro_prompt/Components/AskAstrologer/ask_astrologer_notification_card.dart';
import 'package:astro_prompt/Components/Notification/notification_card_shell.dart';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/Model/ask_astrologer_model.dart';
import 'package:astro_prompt/Screens/AskAstrologer/ask_astrologer_summary_page.dart';
import 'package:astro_prompt/Services/AskAstrologerService/askAstrologerService.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/notification_model.dart';
import 'package:astro_prompt/Model/weekly_prediction_model.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/UserBookingSummaryHome.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/prediction/dailyPrediction.dart';
import 'package:astro_prompt/Screens/prediction/weeklyPrediction.dart';
import 'package:astro_prompt/Screens/prediction/yearlyPrediction.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Services/NotificationService/notificationService.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/LocallySavedData/askAstrologerFlow.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:astro_prompt/config/launchGoogleMeet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:astro_prompt/config/Helper/appFont.dart';

class NotificationPage extends StatefulWidget {
  final int selectedTab;
  final bool? userType;
  final int? openAskRequestId;
  const NotificationPage({
    super.key,
    required this.selectedTab,
    this.userType,
    this.openAskRequestId,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with TickerProviderStateMixin {
  List<AstroConsultationEventModel> eventGetData = [];
  List<AskAstrologerRequest> askRequests = [];
  List<NotificationModel> generalNotifications = [];
  late TabController _tabController;
  final PredictionService predictionService = PredictionService();
  Future<Map<String, dynamic>>? dailyPredictions;
  Future<({int predictionId, List<WeeklyPredictionModel> predictions})>?
      weeklyPredictions;
  Future<YearlyPredictionModel?>? yearlyPredictions;
  int userId = 0;
  bool premiumUser = false;
  bool isAstrologer = false;

  Future<void> fetchUserId() async {
    int? id = await getUserId();
    final isCustomer = widget.userType ?? await getUserType();
    setState(() {
      userId = id!;
      isAstrologer = !isCustomer;
    });
    fetchAstroUserEventService();
    if (!isAstrologer) {
      fetchAskRequests();
    }
    dailyPredictions = PredictionService.getDailyPrediction();
    weeklyPredictions = PredictionService().getWeeklyPredictions();
    yearlyPredictions = PredictionService().getYearlyPrediction();
    premiumUser = await getUserPremium();
  }

  Future<void> fetchAskRequests() async {
    try {
      final data = await AskAstrologerService().fetchMyRequests();
      if (!mounted) return;
      data.sort((a, b) {
        final aTime = DateTime.tryParse(a.answeredAt ?? a.createdAt ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = DateTime.tryParse(b.answeredAt ?? b.createdAt ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      setState(() {
        askRequests = data;
      });
      _maybeOpenAskAnswerDialog();
    } catch (e) {
      debugPrint('Error fetching Ask Astrologer requests: $e');
    }
  }

  void _maybeOpenAskAnswerDialog() {
    final requestId = widget.openAskRequestId;
    if (requestId == null || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.to(() => AskAstrologerSummaryPage(requestId: requestId));
    });
  }

  Future<void> fetchAstroUserEventService() async {
    try {
      var fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId);
      var data = fetchEventData
          .where((e) => e.status == 'confirmed' || e.status == 'completed')
          .toList()
        ..sort((a, b) {
          final aTime = DateTime.tryParse(a.startTime) ??
              DateTime.tryParse(a.bookingDate) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b.startTime) ??
              DateTime.tryParse(b.bookingDate) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });
      final pendingEvents =
          data.where((e) => e.queriesAnswered == false).toList();
      setState(() {
        eventGetData = pendingEvents;
      });
    } catch (e) {
      debugPrint("Error fetching Astro User Event list: $e");
    }
  }

  Future<void> fetchGeneralNotifications() async {
    try {
      final data = await NotificationService().fetchNotifications();
      data.sort((a, b) => b.sentAt.compareTo(a.sentAt));
      setState(() {
        generalNotifications = data;
      });
    } catch (e) {
      debugPrint('Error fetching general notifications: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final initialTab = widget.selectedTab.clamp(0, 2);
    if (widget.selectedTab == 2 && widget.openAskRequestId != null) {
      setViewingAskAnswerRequestId(widget.openAskRequestId);
    }
    fetchUserId();
    fetchGeneralNotifications();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialTab,
      animationDuration: const Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    if (widget.openAskRequestId != null) {
      setViewingAskAnswerRequestId(null);
    }
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('EventData: ${eventGetData[0].status}');
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          'Notifications'.tr,
          style: TextStyle(
              fontFamily: AppFont.get(FontType.bold),
              fontSize: util.fontSize20,
              // height: 1.0,
              color: blackColor),
        ),
        centerTitle: true,
        leading: SizedBox(
          width: util.responsiveWidth(0.08),
          height: util.responsiveHeight(0.037),
          child: IconButton(
            icon: SvgPicture.asset(appBackButton,
                width: util.width20,
                height: util.height20,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn)),
            onPressed: () {
              Get.to(() => BottomNavigationScreen());
            },
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: _tabController,
            builder: (context, _) {
              if (_tabController.index != 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                child: Text(
                  'Clear All'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: AppFont.get(FontType.semiBold),
                      fontSize: util.fontSize16,
                      color: errorColor,
                      height: 1.0),
                ),
                onPressed: () async {
                  CustomLoader.show(context);
                  try {
                    final message =
                        await NotificationService().clearAllNotification();
                    if (message == "Notification statuses updated.") {
                      setState(() {
                        generalNotifications.clear();
                      });
                      CustomLoader.hide();
                      showInfoSnackBarDual(
                          context, "All Notification has been cleared");
                      await fetchGeneralNotifications();
                    } else {
                      CustomLoader.hide();
                      showErrorSnackBar(
                          context, 'Failed to update notification status');
                    }
                  } catch (e) {
                    showErrorSnackBar(
                        context, 'Please try again after sometime');
                  }
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: blackColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelColor: whiteColor,
                unselectedLabelColor: blackColor.withValues(alpha: 0.75),
                dividerHeight: 0,
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                labelStyle: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize12,
                  height: 1.15,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize12,
                  height: 1.15,
                ),
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicator: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    height: 42,
                    child: Text(
                      "General".tr,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    height: 42,
                    child: Text(
                      "30 Mins Consultation".tr,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    height: 42,
                    child: Text(
                      "Single-Query Consultation".tr,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(
          parent: PageScrollPhysics(),
        ),
        children: [
          _NotificationKeepAlive(
            child: generalNotifications.isEmpty
              ? Container(
                  margin: EdgeInsets.only(top: util.height50),
                  padding: EdgeInsets.all(util.width20),
                  child: Text(
                    'There are no recent general updates from your astrological guidance'
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: util.fontSize14,
                        fontFamily: AppFont.get(FontType.medium),
                        color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: util.width20, vertical: util.height10),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: generalNotifications.length,
                  itemBuilder: (context, index) {
                    final notify = generalNotifications[index];
                    final dateFormatted = DateFormat("dd MMM, yyyy - h:mm a")
                        .format(notify.sentAt);
                    String notifyTitle = '';
                    String notifyDesc = '';

                    if (Platform.isAndroid) {
                      if (notify.title == 'Daily Wisdom') {
                        notifyTitle = 'Daily Prediction';
                        notifyDesc =
                            'Your Daily Prediction have been generated';
                      } else if (notify.title == 'Weekly Insights') {
                        notifyTitle = 'Weekly Prediction';
                        notifyDesc =
                            'Your Weekly Prediction have been generated';
                      } else if (notify.title == 'Yearly Insights') {
                        notifyTitle = 'Yearly Prediction';
                        notifyDesc =
                            'Your Yearly Prediction have been generated';
                      } else {
                        notifyTitle = notify.title;
                        notifyDesc = notify.message;
                      }
                    } else {
                      notifyTitle = notify.title;
                      notifyDesc = notify.message;
                    }

                    return GestureDetector(
                      onTap: () async {
                        Future<void> handleNotificationStatusUpdate() async {
                          if (!notify.readBy) {
                            CustomLoader.show(context);
                            try {
                              final message = await NotificationService()
                                  .updateNotificationStatus([notify.id]);
                              CustomLoader.hide();
                              if (message == "Notification statuses updated.") {
                                await fetchGeneralNotifications();
                              } else {
                                showErrorSnackBar(context,
                                    'Failed to update notification status');
                              }
                            } catch (e) {
                              CustomLoader.hide();
                              showErrorSnackBar(
                                  context, 'Please try again after sometime');
                            }
                          }
                        }

                        if (notify.title == 'Daily Wisdom') {
                          await handleNotificationStatusUpdate();
                          Navigator.pop(context);

                          CustomLoader.show(context);
                          try {
                            final dailyData = await dailyPredictions;
                            CustomLoader.hide();
                            if (dailyData != null) {
                              Get.to(() => DailyPrediction(
                                  predictionsData: dailyData,
                                  premiumUser: premiumUser));
                            }
                          } catch (e) {
                            CustomLoader.hide();
                            debugPrint('Error fetching daily predictions: $e');
                          }
                        } else if (notify.title == 'Weekly Insights') {
                          await handleNotificationStatusUpdate();
                          Navigator.pop(context);

                          CustomLoader.show(context);
                          try {
                            final data = await weeklyPredictions;
                            CustomLoader.hide();
                            if (data != null) {
                              Get.to(() =>
                                  WeeklyPrediction(weeklyPrediction: data));
                            }
                          } catch (e) {
                            CustomLoader.hide();
                            debugPrint('Error fetching weekly predictions: $e');
                          }
                        } else if (notify.title == 'Yearly Insights') {
                          await handleNotificationStatusUpdate();
                          Navigator.pop(context);

                          CustomLoader.show(context);
                          try {
                            final data = await yearlyPredictions;
                            CustomLoader.hide();
                            if (data != null) {
                              Get.to(() =>
                                  YearlyPredictionPage(predictionData: data));
                            }
                          } catch (e) {
                            CustomLoader.hide();
                            debugPrint('Error fetching weekly predictions: $e');
                          }
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Stack(
                              children: [
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                      color:
                                          Colors.black.withValues(alpha: 0.3)),
                                ),
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    padding: EdgeInsets.all(util.width20),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await handleNotificationStatusUpdate();
                                              Navigator.pop(context);
                                            },
                                            child:
                                                SvgPicture.asset(closeButton),
                                          ),
                                        ),
                                        Text(
                                          notifyTitle.tr,
                                          style: TextStyle(
                                            fontSize: util.fontSize16,
                                            fontFamily:
                                                AppFont.get(FontType.semiBold),
                                            color: blackColor,
                                          ),
                                        ),
                                        SizedBox(height: util.height10),
                                        Text(
                                          notifyDesc.tr,
                                          style: TextStyle(
                                            fontSize: util.fontSize14,
                                            fontFamily:
                                                AppFont.get(FontType.medium),
                                            color: blackColor.withValues(
                                                alpha: 0.85),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: NotificationCardShell(
                        emphasized: !notify.readBy,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const NotificationCircleAvatar(),
                            SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (!notify.readBy) ...[
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: mainColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                      ],
                                      Expanded(
                                        child: Text(
                                          notifyTitle.tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppFont.get(
                                                FontType.semiBold),
                                            fontSize: util.fontSize14,
                                            height: 1.0,
                                            color: blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    notifyDesc.tr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily:
                                          AppFont.get(FontType.medium),
                                      fontSize: util.fontSize13,
                                      height: 1.2,
                                      color:
                                          blackColor.withValues(alpha: 0.75),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    dateFormatted,
                                    style: TextStyle(
                                      fontSize: util.fontSize11,
                                      height: 1.0,
                                      color:
                                          blackColor.withValues(alpha: 0.4),
                                      fontFamily:
                                          AppFont.get(FontType.medium),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          _NotificationKeepAlive(
            child: eventGetData.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: util.height50),
                    padding: EdgeInsets.all(util.width20),
                    child: Text(
                      'There are no 30 Mins Consultation updates.'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: util.fontSize14,
                          fontFamily: AppFont.get(FontType.medium),
                          color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: util.width20, vertical: util.width10),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: eventGetData.length,
                    itemBuilder: (context, index) {
                      final event = eventGetData[index];
                      final date = DateFormat("dd MMM, yyyy - h:mm a")
                          .format(parseWithoutOffset(event.startTime));
                      return NotificationCardShell(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NotificationCircleAvatar(
                              imageUrl: event.profileImage.isNotEmpty
                                  ? event.profileImage
                                  : null,
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAstrologer
                                        ? "Astrologer appointment on".tr
                                        : "You have an appointment on".tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize14,
                                        height: 1.0,
                                        color: blackColor.withValues(
                                            alpha: 0.8)),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    date,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize14,
                                        color: blackColor,
                                        height: 1.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: util.width8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isAstrologer)
                                  NotificationActionPill(
                                    label: 'View Details'.tr,
                                    outlined: true,
                                    onTap: () {
                                      final DateTime eventDt =
                                          parseWithoutOffset(event.startTime);
                                      final DateTime endDt =
                                          parseWithoutOffset(event.endTime);
                                      final outputFormat =
                                          DateFormat("hh:mm a");
                                      final bookingDateLabel =
                                          DateFormat("d MMMM, y")
                                              .format(eventDt);
                                      final formattedTime =
                                          "${outputFormat.format(eventDt)} - ${outputFormat.format(endDt)}";
                                      Get.to(() => UserConsultationSummaryHome(
                                            eventId: event.id,
                                            categories: event.category ?? [],
                                            languages: event.languages ?? [],
                                            bookingDate: bookingDateLabel,
                                            bookingTime: formattedTime,
                                            consultingFee: event
                                                .consultationFee
                                                .toString(),
                                            currency: event.currency,
                                            profileImage: event.profileImage,
                                            firstName:
                                                event.astrologerFirstName ?? '',
                                            lastName:
                                                event.astrologerLastName ?? '',
                                            meetingLink: event.eventLink,
                                            isCompleted:
                                                event.status == 'completed',
                                          ));
                                    },
                                  ),
                                if (!isAstrologer &&
                                    event.eventLink.isNotEmpty)
                                  SizedBox(height: 6),
                                if (event.eventLink.isNotEmpty)
                                  NotificationActionPill(
                                    label: 'Meeting Link'.tr,
                                    onTap: () {
                                      launchGoogleMeet(event.eventLink);
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          _NotificationKeepAlive(
            child: askRequests.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: util.height50),
                    padding: EdgeInsets.all(util.width20),
                    child: Text(
                      'There are no Single-Query Consultation updates.'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: util.fontSize14,
                          fontFamily: AppFont.get(FontType.medium),
                          color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: util.width20, vertical: util.width10),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: askRequests.length,
                    itemBuilder: (context, index) {
                      return AskAstrologerNotificationCard(
                        request: askRequests[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Keeps each notifications tab mounted so swipe/tap switches stay smooth.
class _NotificationKeepAlive extends StatefulWidget {
  final Widget child;
  const _NotificationKeepAlive({required this.child});

  @override
  State<_NotificationKeepAlive> createState() => _NotificationKeepAliveState();
}

class _NotificationKeepAliveState extends State<_NotificationKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
