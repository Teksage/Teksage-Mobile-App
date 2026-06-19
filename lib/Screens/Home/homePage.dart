import 'dart:io';
import 'dart:math';
import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Components/Predictions/predictionLandingPage.dart';
import 'package:astro_prompt/Components/dailyPredictions/predictionHeaderAnimation.dart';
import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Model/match_making_model.dart';
import 'package:astro_prompt/Model/notification_model.dart';
import 'package:astro_prompt/Model/rasi_model.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Model/weekly_prediction_model.dart';
import 'package:astro_prompt/Screens/Astrologer/homePage.dart';
import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userCategory.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userConsultationHomePage.dart';
import 'package:astro_prompt/Screens/MatchMaking/matchMakingDetails.dart';
import 'package:astro_prompt/Screens/MatchMaking/matchMakingPage.dart';
import 'package:astro_prompt/Screens/Notification/notificationPage.dart';
import 'package:astro_prompt/Screens/intro/welcomePage.dart';
import 'package:astro_prompt/Screens/prediction/dailyPrediction.dart';
import 'package:astro_prompt/Screens/prediction/lifePrediction.dart';
import 'package:astro_prompt/Screens/prediction/weeklyPrediction.dart';
import 'package:astro_prompt/Screens/prediction/yearlyPrediction.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Services/Astrologer-user/eventsService.dart';
import 'package:astro_prompt/Services/MatchService/matchService.dart';
import 'package:astro_prompt/Services/NotificationService/notificationService.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/chatLanguage.dart';
import 'package:astro_prompt/config/LocallySavedData/matchMaking.dart';
import 'package:astro_prompt/config/LocallySavedData/name.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/LocallySavedData/userId.dart';
import 'package:astro_prompt/config/LocallySavedData/userType.dart';
import 'package:astro_prompt/config/LocallySavedData/welcomeMessage.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  String currentTime = "";
  Future<Map<String, dynamic>>? dailyPredictions;
  Future<({int predictionId, List<WeeklyPredictionModel> predictions})>?
      weeklyPredictions;
  bool tokenExist = false;
  bool premiumUser = false;
  String userName = '';
  bool userType = true;
  int userId = 0;
  List<RasiModel> rasiList = [];
  MatchMakingModel? matchMakingGetData;
  List<AstroConsultationEventModel> eventGetData = [];
  List<NotificationModel> generalNotifications = [];
  List<String> nakshatraList = [];
  final PredictionService predictionService = PredictionService();
  String currency = '';
  bool isCurrencyDialogShown = false;
  int unreadCount = 0;
  String planStatus = '';
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
    currentTime = getCurrentTime();
    fetchUserName();
    checkAccessToken();

    NotificationService.onGeneralNotificationReceived = () {
      debugPrint('[HomePage] 🟢 Received general notification');
      if (!mounted) return;
      setState(() {
        unreadCount +=
            1; // Or fetchGeneralNotifications() if you want to refresh list
      });
    };
  }

  Future<void> fetchUserName() async {
    String token = await getAccessToken();

    if (token.isEmpty) return;

    try {
      await getProfileData();
    } on IncompleteProfileException {
      return;
    }

    try {
      int? id = await getUserId();
      String name = await getUserName();
      bool type = await getUserType();
      dailyPredictions = PredictionService.getDailyPrediction();
      weeklyPredictions = PredictionService().getWeeklyPredictions();
      premiumUser = await getUserPremium();

      if (!mounted) return;

      setState(() {
        userName = name;
        userType = type;
        userId = id!;
      });

      fetchAstroUserEventService();
      fetchGeneralNotifications();
      fetchRasiList();
      fetchLatestMatchMaking();
    } catch (e) {
      if (kDebugMode) print('Error in fetchUserName: $e');
    }
  }

  Future<void> getProfileData() async {
    ProfileService profileService = ProfileService();
    try {
      UserProfile? profileData = await profileService.fetchUserProfile();

      bool hasSeenWelcome = await getWelcomeMessageStatus();
      debugPrint(
          'hasSeenWelcome: $hasSeenWelcome subscription: ${profileData?.subscription}');

      if (!mounted) return;
      setState(() {
        planStatus = profileData?.subscription?.planStatus ?? '';
      });

      if (profileData?.subscription == null) {
        if (!hasSeenWelcome) {
          await Get.offAll(() => WelcomePage(),
              transition: Transition.fade,
              duration: Duration(milliseconds: 500));
          await saveWelcomeMessageStatus();
          return;
        }
      }

      if (!mounted) return;
      String lang = await getChatLanguage();
      if (lang.isEmpty && (profileData?.chatLanguage ?? '').isNotEmpty) {
        await saveChatLanguage(profileData!.chatLanguage);
        lang = profileData.chatLanguage;
      }
    } on IncompleteProfileException {
      if (!mounted) return;
      Get.to(() => ProfilePage(
            title: 'Profile Details',
            isProfileUpdated: false,
          ));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching profile: $e');
      }
    }
  }

  String getCurrentTime() {
    final now = DateTime.now();
    final sixAMToday = DateTime(now.year, now.month, now.day, 6, 0);
    final dateToShow =
        now.isBefore(sixAMToday) ? now.subtract(Duration(days: 1)) : now;
    return DateFormat('E - MMM dd, yyyy').format(dateToShow);
  }

  Future<void> checkAccessToken() async {
    String? token = await getAccessToken();
    if (!mounted) return;
    setState(() {
      tokenExist = token.isNotEmpty;
    });
  }

  Future<void> fetchRasiList() async {
    try {
      List<RasiModel> fetchedRashi = await MatchMakingService().getRashiList();
      if (!mounted) return;
      setState(() {
        rasiList = fetchedRashi;
      });
    } catch (e) {
      debugPrint("Error fetching Rashi list: $e");
    }
  }

  Future<void> fetchLatestMatchMaking() async {
    try {
      // Check the persistent flag — if language was changed,
      // always show the generate page until user generates new match making
      bool needsRegeneration = await getMatchMakingNeedsRegeneration();

      if (kDebugMode) {
        print('🔍 Match Making - needsRegeneration flag: $needsRegeneration');
      }

      if (needsRegeneration) {
        if (kDebugMode) {
          print(
              '🔄 Match Making needs regeneration (language was changed) - Showing generate page');
        }

        if (!mounted) return;
        setState(() {
          matchMakingGetData = null;
        });

        return;
      }

      // No regeneration needed - initialize previousAppLanguage if first time
      String currentLang = await getAppLanguage();
      String previousLang = await getPreviousAppLanguage();

      if (kDebugMode) {
        print(
            '📊 Match Making Check - Current: "$currentLang", Previous: "$previousLang"');
      }

      if (previousLang.isEmpty && currentLang.isNotEmpty) {
        await savePreviousAppLanguage(currentLang);
        if (kDebugMode) {
          print('🆕 Initialized previous language to: "$currentLang"');
        }
      }

      // Fetch match making data from backend
      if (kDebugMode) {
        print('✅ Fetching match making data from backend...');
      }
      final fetched = await MatchMakingService().getMatchMaking();

      if (kDebugMode) {
        print(
            '📦 Backend returned match making data: ${fetched != null ? "YES (showing details)" : "NO (showing generate page)"}');
      }

      if (!mounted) return;
      setState(() {
        matchMakingGetData = fetched;
      });
    } catch (e) {
      debugPrint('Error fetching match making: $e');
    }
  }

  Future<void> fetchAstroUserEventService() async {
    try {
      var fetchEventData =
          await AstroUserEventService().fetchAstroUserEvents(userId);
      var data = fetchEventData
          .where((e) => e.status == 'confirmed' || e.status == 'completed')
          .toList()
        ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
      if (!mounted) return;
      setState(() {
        eventGetData = data;
      });
    } catch (e) {
      debugPrint("Error fetching Astro User Event list: $e");
    }
  }

  Future<void> fetchGeneralNotifications() async {
    try {
      final data = await NotificationService().fetchNotifications();
      if (!mounted) return;
      setState(() {
        generalNotifications = data;
        unreadCount = data.where((n) => n.readBy == false).length;
      });
    } catch (e) {
      debugPrint('Error fetching general notifications: $e');
    }
  }

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => const LoginPromptDialog(reDirectHome: false),
    );
  }

  Future<void> handlePredictionAccess({
    required BuildContext context,
    required Future<dynamic> Function() fetchPrediction,
    required Widget Function(dynamic data) onSuccess,
    required String title,
    required String icon,
    required Color gradientTop,
    required Color gradientBottom,
    required String subscriptionStatus,
  }) async {
    final String token = await getAccessToken();
    final bool isPremium = await getUserPremium();

    if (mounted) {
      setState(() {
        tokenExist = token.isNotEmpty;
        premiumUser = isPremium;
      });
    }

    if (token.isEmpty) {
      if (_isDialogShown) return;
      _isDialogShown = true;
      try {
        showLoginDialog(context);
      } finally {
        _isDialogShown = false;
      }
      return;
    }

    if (isPremium && subscriptionStatus == 'active') {
      dynamic predictionData;
      try {
        if (mounted) CustomLoader.show(context);
        predictionData = await fetchPrediction();
      } catch (e, st) {
        debugPrint('Error fetching prediction: $e\n$st');
        if (mounted) {
          Get.to(() => PredictionLandingPage(
                title: title,
                icon: icon,
                gradientTop: gradientTop,
                gradientBottom: gradientBottom,
              ));
        }
        return;
      } finally {
        if (mounted) CustomLoader.hide();
      }

      if (predictionData == null) {
        if (mounted) {
          Get.to(() => PredictionLandingPage(
                title: title,
                icon: icon,
                gradientTop: gradientTop,
                gradientBottom: gradientBottom,
              ));
        }
      } else {
        if (mounted) Get.to(() => onSuccess(predictionData));
      }
      return;
    }

    if (subscriptionStatus == 'expired') {
      if (_isDialogShown) return;
      _isDialogShown = true;
      try {
        await showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withAlpha(128),
          builder: (_) => const SubscribePromptDialog(
            planStatus: 'expired',
            currency: 'INR',
            reDirectHome: false,
          ),
        );
      } finally {
        _isDialogShown = false;
      }
      return;
    }

    if (Platform.isIOS) {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withAlpha(128),
        builder: (_) => const SubscribePromptDialog(
          currency: 'INR',
          reDirectHome: false,
        ),
      );
      return;
    }

    // Only fetch currency if not premium
    String tempCurrency = currency;
    await CurrencyHelper.fetchCurrencyIfNeeded(
      context: context,
      currentCurrency: tempCurrency,
      onCurrencyFetched: (fetchedCurrency) {
        tempCurrency = fetchedCurrency;
        setState(() {
          currency = fetchedCurrency;
        });
      },
    );

    if (tempCurrency.isNotEmpty) {
      if (_isDialogShown) return;
      _isDialogShown = true;
      try {
        await showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withAlpha(128),
          builder: (_) => SubscribePromptDialog(
            currency: tempCurrency,
            reDirectHome: false,
          ),
        );
      } finally {
        _isDialogShown = false;
      }
    } else {
      showErrorSnackBar(
          context, 'Please enable location permission to access this feature.');
    }
  }

  Future<void> handleConsultationNavigation(BuildContext context) async {
    if (!tokenExist) return showLoginDialog(context);
    if (userType) {
      if (eventGetData.isNotEmpty) {
        Get.to(() => UserConsultationDetailsHome(
              backButton: false,
              eventData: eventGetData,
            ));
      } else {
        Get.to(() => UserCategoryPage(
              toHome: false,
            ));
      }
    } else {
      Get.to(() => AstrologerHomePage(eventData: eventGetData));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    NotificationService.onGeneralNotificationReceived = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // debugPrint('Width: ${util.responsiveWidth(0.0268)}');
    // debugPrint('Height: ${util.responsiveHeight(0.1023)}');
    // debugPrint('FontSize: ${util.responsiveFontSize(0.0153)}');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            SystemNavigator.pop();
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF).withValues(alpha: 0.5),
                    Color(0xFF10B100).withValues(alpha: 0.3),
                  ],
                  stops: [-2, 1], // Adjusted stops based on given values
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: util.width20),
                child: Column(
                  children: [
                    SizedBox(
                      height: util.responsiveHeight(0.079),
                    ),
                    //Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${'Good day'.tr} $userName!',
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.bold),
                              fontSize: util.fontSize20,
                              height: util.lineHeight24 / util.fontSize20,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (tokenExist) {
                              Get.to(() => NotificationPage(
                                    selectedTab: 0,
                                    userType: userType,
                                  ));
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor:
                                    Colors.black.withValues(alpha: 0.5),
                                builder: (context) => const LoginPromptDialog(
                                  reDirectHome: false,
                                ),
                              );
                            }
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: SvgPicture.asset(notification),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  top: -10,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: errorColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: util.fontSize14,
                                          fontFamily: 'FontSemiBold'),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )

                        // GestureDetector(
                        //   onTap: () {
                        //     Get.to(() => NotificationPage());
                        //   },
                        //   child: Container(padding: EdgeInsets.only(left: 5, right: 5), child: SvgPicture.asset(notification)),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: util.responsiveHeight(0.0161),
                    ),
                    Container(
                      height: 1,
                      color: blackColor.withValues(alpha: 0.3),
                    ),
                    SizedBox(
                      height: util.responsiveHeight(0.0198),
                    ),
                    //Consultation Banner
                    Stack(
                      children: [
                        Container(
                          height: util.responsiveHeight(0.1121),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(util.width20),
                              border:
                                  Border.all(color: homeBannerBorder, width: 2),
                              color: homeBanner),
                        ),
                        SizedBox(
                            height: util.responsiveHeight(0.1121),
                            child: Image.asset(homeBanDeco)),
                        SizedBox(
                          height: util.responsiveHeight(0.112),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: util.responsiveHeight(0.0112),
                                    left: util.responsiveWidth(0.0268),
                                    bottom: util.responsiveHeight(0.0025)),
                                child: Image.asset(
                                  'assets/images/test.png',
                                ),
                              ),
                              Text(
                                userType
                                    ? PlatformTextConfig
                                        .astrologerConsultation.tr
                                    : 'Astrologer'.tr,
                                style: TextStyle(
                                    fontFamily: AppFont.get(FontType.bold),
                                    fontSize: util.fontSize16,
                                    height:
                                        util.lineHeight19_2 / util.fontSize16,
                                    color: Color(0xff3a3b00)),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    handleConsultationNavigation(context),
                                // onTap: (){
                                //   Get.to(() => TestPage());
                                // },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: util.responsiveWidth(0.0375),
                                      vertical: util.responsiveHeight(0.0087)),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(util.width20),
                                      color: whiteColor),
                                  child: Text(
                                    userType ? 'Book Now'.tr : 'My Profile'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize11,
                                        height: util.lineHeight13_2 /
                                            util.fontSize11,
                                        color: Color(0xff0E0D0C)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: util.responsiveHeight(0.0296),
                    ),
                    //Predictions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(homeLine),
                        Text(
                          'Explore Other Predictions'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.semiBold),
                            fontSize: util.fontSize14,
                            height: util.lineHeight16_8 / util.fontSize14,
                          ),
                        ),
                        SvgPicture.asset(homeLine),
                      ],
                    ),
                    SizedBox(
                      height: util.responsiveHeight(0.005),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (tokenExist) {
                                  CustomLoader.show(context); // Show loader
                                  try {
                                    final data = await weeklyPredictions!;
                                    CustomLoader.hide();
                                    Get.to(() => WeeklyPrediction(
                                        weeklyPrediction: data));
                                  } catch (e) {
                                    CustomLoader.hide();
                                    debugPrint(
                                        'Error fetching weekly predictions: $e');
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierColor:
                                        Colors.black.withValues(alpha: 0.5),
                                    builder: (context) =>
                                        const LoginPromptDialog(
                                      reDirectHome: false,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1F000000),
                                      blurRadius: 25,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  weekly,
                                ),
                              ),
                            ),
                            Text(
                              PlatformTextConfig.weeklyPrediction.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize14,
                                  height: util.lineHeight16_8 / util.fontSize14,
                                  color: blackColor.withValues(alpha: 0.7)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => handlePredictionAccess(
                                context: context,
                                fetchPrediction:
                                    predictionService.getYearlyPrediction,
                                onSuccess: (data) => YearlyPredictionPage(
                                  predictionData: data,
                                ),
                                title:
                                    PlatformTextConfig.yearlyPredictionLanding,
                                icon: yearlyDecoLogo,
                                gradientTop: yearlyTopGradient,
                                gradientBottom: yearlyBottomGradient,
                                subscriptionStatus: planStatus,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1F000000),
                                      blurRadius: 25,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  yearly,
                                ),
                              ),
                            ),
                            Text(
                              PlatformTextConfig.yearlyPrediction.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize14,
                                  height: util.lineHeight16_8 / util.fontSize14,
                                  color: blackColor.withValues(alpha: 0.7)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => handlePredictionAccess(
                                  context: context,
                                  fetchPrediction:
                                      predictionService.getLifePrediction,
                                  onSuccess: (data) => LifePredictionPage(
                                        predictionData: data,
                                      ),
                                  title:
                                      PlatformTextConfig.lifePredictionLanding,
                                  icon: lifeDecoLogo,
                                  gradientTop: lifeTopGradient,
                                  gradientBottom: lifeBottomGradient,
                                  subscriptionStatus: planStatus),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1F000000),
                                      blurRadius: 25,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  life,
                                ),
                              ),
                            ),
                            Text(
                              PlatformTextConfig.lifePrediction.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.semiBold),
                                  fontSize: util.fontSize14,
                                  height: util.lineHeight16_8 / util.fontSize14,
                                  color: blackColor.withValues(alpha: 0.7)),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: util.responsiveHeight(0.0296),
                    ),
                    //MatchMaking & Daily Predictions
                    Row(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'matchMakingHero',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(util.width20),
                              child: GestureDetector(
                                onTap: () async {
                                  print(
                                      'matchMakingGetData,:$matchMakingGetData');
                                  if (tokenExist) {
                                    if (matchMakingGetData == null) {
                                      print('MatchMakingPageeeeeeeeeeee');
                                      Get.to(() => MatchMakingPage(
                                            rasiList: rasiList,
                                            // nakshatraList: nakshatraList,
                                          ));
                                    } else {
                                      Get.to(() => MatchMakingDetailsPage(
                                            getMatchMakingModel:
                                                matchMakingGetData!,
                                            fromHomePage: true,
                                          ));
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierColor:
                                          Colors.black.withValues(alpha: 0.5),
                                      builder: (context) =>
                                          const LoginPromptDialog(
                                              reDirectHome: false),
                                    );
                                  }
                                },
                                child: Container(
                                  width: util.width,
                                  height: util.responsiveHeight(0.218),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius:
                                        BorderRadius.circular(util.width20),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        top: util.responsiveHeight(0.0235),
                                        child: Text(
                                          'Marriage\nMatch Making'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFont.get(FontType.bold),
                                              fontSize: util.fontSize16,
                                              height: util.lineHeight19_2 /
                                                  util.fontSize16,
                                              color: marriageColor),
                                        ),
                                      ),
                                      Positioned(
                                          top: util.responsiveHeight(0.1023),
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: SvgPicture.asset(
                                            marriage,
                                            fit: BoxFit.fitWidth,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: util.width20),
                        tokenExist
                            ? Expanded(
                                child: FutureBuilder(
                                  future: dailyPredictions,
                                  builder: (context, snapshot) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (snapshot.hasData &&
                                            snapshot.data!.isNotEmpty) {
                                          Get.to(
                                            () => DailyPrediction(
                                              predictionsData: snapshot.data!,
                                              premiumUser: premiumUser,
                                              currency: currency,
                                            ),
                                            transition: Transition.fadeIn,
                                            duration:
                                                Duration(milliseconds: 300),
                                          );
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(util.width20),
                                        child: Container(
                                          height: util.responsiveHeight(0.218),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      util.width20),
                                              border: Border.all(
                                                  width: 1,
                                                  color: blackColor.withValues(
                                                      alpha: 0.06))),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: util.height250,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF0DA602),
                                                        Color(0xFF10B100)
                                                            .withValues(
                                                                alpha: 0.75)
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: AnimatedBuilder(
                                                  animation: controller,
                                                  builder: (context, child) {
                                                    return CustomPaint(
                                                      size: Size(
                                                          util.width,
                                                          util.responsiveHeight(
                                                              0.218)),
                                                      painter: ArcPainter(
                                                          controller.value),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                top: util
                                                    .responsiveHeight(0.0235),
                                                left: 0,
                                                right: 0,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      PlatformTextConfig
                                                          .dailyPrediction.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: AppFont.get(
                                                            FontType.bold),
                                                        fontSize:
                                                            util.fontSize18,
                                                        height:
                                                            util.lineHeight21_6 /
                                                                util.fontSize18,
                                                        color: whiteColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: util
                                                            .responsiveHeight(
                                                                0.0013)),
                                                    Text(
                                                      currentTime,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'FontSemiBold',
                                                        fontSize:
                                                            util.fontSize14,
                                                        height:
                                                            util.lineHeight28 /
                                                                util.fontSize14,
                                                        color: whiteColor
                                                            .withValues(
                                                                alpha: 0.75),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: util
                                                            .responsiveHeight(
                                                                0.0112)),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(
                                                          horizontal: util
                                                              .responsiveWidth(
                                                                  0.0215)),
                                                      width: util.width,
                                                      height:
                                                          util.responsiveHeight(
                                                              0.053),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        borderRadius: BorderRadius
                                                            .circular(util
                                                                .responsiveWidth(
                                                                    0.032)),
                                                      ),
                                                      child: snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting
                                                          ? Center(
                                                              child: LoadingAnimationWidget
                                                                  .halfTriangleDot(
                                                                color:
                                                                    mainColor,
                                                                size: util
                                                                    .height20,
                                                              ),
                                                            )
                                                          : snapshot.hasError
                                                              ? Center(
                                                                  child: Text(
                                                                      snapshot
                                                                          .error
                                                                          .toString()))
                                                              : !snapshot.hasData ||
                                                                      snapshot
                                                                          .data!
                                                                          .isEmpty
                                                                  ? Center(
                                                                      child: Text(
                                                                          "Loading ..."))
                                                                  : Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              snapshot.data!['thara_bala'] ?? "N/A",
                                                                              style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize10, height: util.lineHeight12 / util.fontSize10, color: blackColor),
                                                                            ),
                                                                            Text(
                                                                              'Thara Bala'.tr,
                                                                              style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize8, height: util.lineHeight9_6 / util.fontSize8, color: mainColor),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SvgPicture.asset(
                                                                            homeDailyDivider),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              snapshot.data!['chandra_bala'] ?? "N/A",
                                                                              style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize10, height: util.lineHeight12 / util.fontSize10, color: blackColor),
                                                                            ),
                                                                            Text(
                                                                              'Chandra Bala'.tr,
                                                                              style: TextStyle(fontFamily: 'FontSemiBold', fontSize: util.fontSize8, height: util.lineHeight9_6 / util.fontSize8, color: mainColor),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                    ),
                                                    SizedBox(
                                                        height: util
                                                            .responsiveHeight(
                                                                0.0087)),
                                                    AnimatedBuilder(
                                                      animation: controller,
                                                      builder:
                                                          (context, child) {
                                                        return Transform
                                                            .translate(
                                                          offset: Offset(
                                                              0,
                                                              4 *
                                                                  sin(controller
                                                                          .value *
                                                                      2 *
                                                                      pi)),
                                                          child:
                                                              SvgPicture.asset(
                                                                  downArrow),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Hero(
                                  tag: 'dailyPredictionHero',
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(util.width20),
                                    child: Container(
                                      height: util.responsiveHeight(0.218),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              util.width20),
                                          border: Border.all(
                                              width: 1,
                                              color: blackColor.withValues(
                                                  alpha: 0.06))),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: util.height250,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF0DA602),
                                                    Color(0xFF10B100)
                                                        .withValues(alpha: 0.75)
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: AnimatedBuilder(
                                              animation: controller,
                                              builder: (context, child) {
                                                return CustomPaint(
                                                  size: Size(
                                                      util.width,
                                                      util.responsiveHeight(
                                                          0.218)),
                                                  painter: ArcPainter(
                                                      controller.value),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: util.responsiveHeight(0.0235),
                                            left: 0,
                                            right: 0,
                                            child: Column(
                                              children: [
                                                Text(
                                                  PlatformTextConfig
                                                      .dailyPrediction.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: AppFont.get(
                                                          FontType.bold),
                                                      fontSize: util.fontSize18,
                                                      height:
                                                          util.lineHeight21_6 /
                                                              util.fontSize18,
                                                      color: whiteColor),
                                                ),
                                                SizedBox(
                                                    height:
                                                        util.responsiveHeight(
                                                            0.0013)),
                                                Text(
                                                  currentTime,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'FontSemiBold',
                                                      fontSize: util.fontSize14,
                                                      height:
                                                          util.lineHeight28 /
                                                              util.fontSize14,
                                                      color:
                                                          whiteColor.withValues(
                                                              alpha: 0.75)),
                                                ),
                                                SizedBox(
                                                  height: util
                                                      .responsiveHeight(0.0112),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      barrierColor: Colors.black
                                                          .withValues(
                                                              alpha: 0.5),
                                                      builder: (context) =>
                                                          const LoginPromptDialog(
                                                              reDirectHome:
                                                                  false),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: util
                                                            .responsiveWidth(
                                                                0.0215)),
                                                    width: util.width,
                                                    height:
                                                        util.responsiveHeight(
                                                            0.053),
                                                    decoration: BoxDecoration(
                                                      color: whiteColor,
                                                      borderRadius: BorderRadius
                                                          .circular(util
                                                              .responsiveWidth(
                                                                  0.032)),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      'Click to view'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'FontSemiBold',
                                                          fontSize:
                                                              util.fontSize14,
                                                          height: 1.0,
                                                          color: mainColor),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        util.responsiveHeight(
                                                            0.0087)),
                                                AnimatedBuilder(
                                                  animation: controller,
                                                  builder: (context, child) {
                                                    return Transform.translate(
                                                      offset: Offset(
                                                          0,
                                                          4 *
                                                              sin(controller
                                                                      .value *
                                                                  2 *
                                                                  pi)),
                                                      child: child,
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    downArrow,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: util.responsiveHeight(0.0296),
                    ),
                    // Chat Page
                    GestureDetector(
                      onTap: () {
                        if (tokenExist) {
                          Get.to(() => AIChatScreen());
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierColor: Colors.black.withValues(alpha: 0.5),
                            builder: (context) => const LoginPromptDialog(
                              reDirectHome: false,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: util.responsiveHeight(0.1121),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(util.width20),
                          color: homeBanner2,
                          image: DecorationImage(
                            image: AssetImage(bottomBannerBg),
                            fit: BoxFit.cover, // Adjust how the image fits
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              PlatformTextConfig.chatHomePage.tr,
                              style: TextStyle(
                                  fontFamily: AppFont.get(FontType.bold),
                                  fontSize: util.fontSize16,
                                  height: util.lineHeight19_2 / util.fontSize16,
                                  color: whiteColor),
                            ),
                            SvgPicture.asset(bannerElement),
                            Container(
                              width: util.responsiveWidth(0.2695),
                              height: util.responsiveHeight(0.0346),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(util.width20),
                                  color: whiteColor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Chat Now'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.semiBold),
                                        fontSize: util.fontSize11,
                                        height: util.lineHeight13_2 /
                                            util.fontSize11,
                                        color: homeBannerFont),
                                  ),
                                  SvgPicture.asset(rightArrow),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: util.responsiveHeight(0.15),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
