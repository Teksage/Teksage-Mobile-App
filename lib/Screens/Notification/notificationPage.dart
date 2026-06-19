import 'dart:ui';
import 'package:astro_prompt/Components/Consultation-User/timeConversion.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/notification_model.dart';
import 'package:astro_prompt/Model/weekly_prediction_model.dart';
import 'package:astro_prompt/Model/yearly_prediction_model.dart';
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
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
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
  const NotificationPage({
    super.key,
    required this.selectedTab,
    this.userType,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with TickerProviderStateMixin {
  List<AstroConsultationEventModel> eventGetData = [];
  List<NotificationModel> generalNotifications = [];
  late TabController _tabController;
  int selectedTabIndex = 0;
  final PredictionService predictionService = PredictionService();
  Future<Map<String, dynamic>>? dailyPredictions;
  Future<({int predictionId, List<WeeklyPredictionModel> predictions})>?
      weeklyPredictions;
  Future<YearlyPredictionModel?>? yearlyPredictions;
  int userId = 0;
  bool premiumUser = false;

  Future<void> fetchUserId() async {
    int? id = await getUserId();
    setState(() {
      userId = id!;
    });
    fetchAstroUserEventService();
    dailyPredictions = PredictionService.getDailyPrediction();
    weeklyPredictions = PredictionService().getWeeklyPredictions();
    yearlyPredictions = PredictionService().getYearlyPrediction();
    premiumUser = await getUserPremium();
  }

  Future<void> fetchAstroUserEventService() async {
    try {
      var fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId);
      var data = fetchEventData
          .where((e) => e.status == 'confirmed' || e.status == 'completed')
          .toList()
        ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
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
    selectedTabIndex = widget.selectedTab;
    fetchUserId();
    fetchGeneralNotifications();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: selectedTabIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {
          selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
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
        actions: selectedTabIndex == 0
            ? [
                TextButton(
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
                        // Navigator.pop(context);
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
                      // Navigator.pop(context);
                      showErrorSnackBar(
                          context, 'Please try again after sometime');
                    }
                  },
                ),
              ]
            : null,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              labelColor: whiteColor,
              unselectedLabelColor: blackColor,
              dividerHeight: 0,
              labelStyle: TextStyle(
                  fontFamily: AppFont.get(FontType.semiBold),
                  fontSize: util.fontSize16),
              unselectedLabelStyle: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize16),
              indicator: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(30),
              ),
              indicatorPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "General".tr),
                Tab(text: "Consultation".tr),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
           generalNotifications.isEmpty
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
                      child: Container(
                        margin: EdgeInsets.only(bottom: util.height10),
                        padding: EdgeInsets.all(util.width10),
                        decoration: BoxDecoration(
                          color: notify.readBy ? whiteColor : Color(0xfff6f6f6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifyTitle.tr,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize14,
                                color: blackColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              notifyDesc.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize13,
                                color: blackColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          eventGetData.isEmpty
              ? Container(
                  margin: EdgeInsets.only(top: util.height50),
                  padding: EdgeInsets.all(util.width20),
                  child: Text(
                    'There are no Consultation updates.'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: util.fontSize14,
                        fontFamily: AppFont.get(FontType.medium),
                        color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: util.width20, vertical: util.width10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: util.height10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: eventGetData.length,
                            itemBuilder: (context, index) {
                              final event = eventGetData[index];
                              final date = DateFormat("dd MMM, yyyy - h:mm a")
                                  .format(parseWithoutOffset(event.startTime));
                              return Container(
                                margin: EdgeInsets.only(bottom: util.height10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: util.width20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xfff6f6f6),
                                    border: Border.all(
                                        color:
                                            blackColor.withValues(alpha: 0.04),
                                        width: 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        SizedBox(width: 9),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (widget.userType == true)
                                                  ? "Astrologer appointment on"
                                                      .tr
                                                      .tr
                                                  : "You have an appointment on"
                                                      .tr
                                                      .tr,
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
                                                      .fontSize14,
                                                  color: blackColor,
                                                  height: 1.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        launchGoogleMeet(event.eventLink);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              util.width20),
                                          color: astroUserConsultBG,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 9, horizontal: 6),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Meeting Link'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFont.get(FontType.semiBold),
                                            fontSize: util.fontSize12,
                                            height: 1.0,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ),
         
        ],
      ),
    );
  }
}
