import 'dart:io';
import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Components/Dashboard/LogoutDialog.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Components/Settings/Rating/rateUsHelper.dart';
import 'package:astro_prompt/Model/user_model.dart';
import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_details_page_IOS.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_home_page.dart';
import 'package:astro_prompt/Screens/settings/DeleteAccount/deleteAccount_mainPage.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_home_page_ios.dart';
import 'package:astro_prompt/Screens/settings/app_language_page.dart';
import 'package:astro_prompt/Screens/settings/faq_page.dart';
import 'package:astro_prompt/Screens/settings/privacy_page.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';
import 'package:astro_prompt/Screens/settings/pushNotification.dart';
import 'package:astro_prompt/Screens/settings/Subscription/subscription_details_page.dart';
import 'package:astro_prompt/Screens/settings/support_page.dart';
import 'package:astro_prompt/Screens/settings/t&c_page.dart';
import 'package:astro_prompt/Services/AuthService/authService.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/currency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String email = '';
  String mobileNumber = '';
  bool premiumUser = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  AuthService authService = AuthService();
  bool tokenExist = false;
  var subscriptionData;
  var planData;
  var userNotifyData;
  String currency = '';

  bool _isPlanExpired() {
    try {
      final status = (subscriptionData?.planStatus ?? '');
      return status.toString().toLowerCase().trim() == 'expired';
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -5, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    checkAccessToken();
  }

  Future<void> checkAccessToken() async {
    String? token = await getAccessToken();
    if (!mounted) return;
    setState(() {
      tokenExist = token.isNotEmpty;
    });
    if (tokenExist) {
      getProfileData();
      getPremiumUser();
    }
  }

  void getPremiumUser() async {
    final result = await getUserPremium();
    setState(() {
      premiumUser = result;
    });
  }

  Future<void> getProfileData() async {
    ProfileService profileService = ProfileService();

    UserProfile? profileData = await profileService.fetchUserProfile();
    if (!mounted || profileData == null) return;
    final fetchedStatus = profileData.subscription?.planStatus ?? '';
    if (kDebugMode) {
      print('ProfileData.planStatus (raw): "$fetchedStatus"');
      print(
          'ProfileData.planStatus (normalized): "${fetchedStatus.toLowerCase().trim()}"');
    }
    final String status = (profileData.subscription?.planStatus ?? '')
        .toString()
        .toLowerCase()
        .trim();
    if (status == 'active') {
      await savePremiumUser(true);
      setState(() {
        premiumUser = true;
      });
    } else {
      await savePremiumUser(false);
      setState(() {
        premiumUser = false;
      });
    }
    setState(() {
      subscriptionData = profileData.subscription;
      planData = profileData.planDetails;
      email = profileData.email;
      userNotifyData = profileData.userNotify;
    });
  }

  void handleLogout(BuildContext context) async {
    CustomLoader.show(context);
    await Future.delayed(Duration(seconds: 1));
    String? responseMessage = await authService.logout();
    CustomLoader.hide();
    if (responseMessage != null) {
      showLogoutSnackBar(context, responseMessage);
      Get.offAllNamed('/home');
    } else {
      showLogoutSnackBar(context, 'Logout failed. Please try again.');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (tokenExist) {
        if (kDebugMode) {
          print(
              'App resumed - calling getProfileData to refresh subscription status');
        }
        getProfileData();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.2668)}');
    // print('Height: ${util.responsiveHeight(0.1232)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Future.microtask(() {
            final controller = Get.find<BottomNavController>();
            controller.changeIndex(0);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Platform.isAndroid ? Color(0x80FFFFFF) : Colors.transparent,
          centerTitle: true,
          title: Text(
            "Settings".tr,
            style: TextStyle(
                fontFamily: AppFont.get(FontType.bold),
                fontSize: util.fontSize20,
                height: util.lineHeight24 / util.fontSize20,
                color: blackColor),
          ),
          leading: Platform.isAndroid
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    Get.to(() => AIChatScreen());
                  },
                  icon: SvgPicture.asset(
                    backButton,
                  ),
                ),
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            width: util.width,
            decoration: BoxDecoration(
              gradient: Platform.isIOS
                  ? null
                  : LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        mainColor.withValues(alpha: 0.1),
                        Color(0x80FFFFFF),
                      ],
                      stops: [0.0, 0.9],
                    ),
              image: Platform.isIOS
                  ? DecorationImage(
                      image: AssetImage(iosSettingBg),
                      alignment: Alignment.topLeft,
                      // fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: util.height30,
                  ),
                  //Profile
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (tokenExist) {
                            Get.to(() => ProfilePage(
                                  title: 'Profile Details'.tr,
                                  isProfileUpdated: true,
                                ));
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (context) =>
                                  const LoginPromptDialog(reDirectHome: false),
                            );
                          }
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    profile,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Profile'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0149),
                      ),
                    ],
                  ),
                  //Push Notification
                  if (Platform.isAndroid)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (!tokenExist) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor:
                                    Colors.black.withValues(alpha: 0.5),
                                builder: (context) => const LoginPromptDialog(
                                    reDirectHome: false),
                              );
                              return;
                            }

                            if (premiumUser) {
                              final result = await Get.to(() =>
                                  PushNotificationPage(
                                      userNotifyData: userNotifyData));
                              if (result == true) {
                                getProfileData();
                              }
                              return;
                            }

                            if (Platform.isIOS) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor:
                                    Colors.black.withValues(alpha: 0.5),
                                builder: (context) =>
                                    const SubscribePromptDialog(
                                  reDirectHome: false,
                                  currency: 'INR',
                                ),
                              );
                              return;
                            }

                            if (currency.isEmpty) {
                              final permissionGranted = await CurrencyService()
                                  .requestPermission(context);
                              if (permissionGranted) {
                                await CurrencyHelper.fetchCurrencyIfNeeded(
                                  context: context,
                                  currentCurrency: '',
                                  onCurrencyFetched: (newCurrency) =>
                                      currency = newCurrency,
                                );
                              }
                            }

                            final String safeCurrency = currency;
                            if (_isPlanExpired()) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black.withAlpha(128),
                                builder: (_) => SubscribePromptDialog(
                                  planStatus: 'expired',
                                  currency: safeCurrency,
                                  reDirectHome: false,
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor:
                                    Colors.black.withValues(alpha: 0.5),
                                builder: (context) => SubscribePromptDialog(
                                  reDirectHome: false,
                                  currency: safeCurrency,
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: util.responsiveHeight(0.0555),
                            padding:
                                EdgeInsets.symmetric(horizontal: util.width20),
                            decoration: BoxDecoration(
                              color: blackColor.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(util.width8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: util.width10,
                                  children: [
                                    SvgPicture.asset(
                                      pushNotification,
                                      colorFilter: ColorFilter.mode(
                                          Platform.isAndroid
                                              ? mainColor
                                              : iosMainColor,
                                          BlendMode.srcIn),
                                    ),
                                    Text(
                                      'Push Notifications'.tr,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize16,
                                          height: util.lineHeight19_2 /
                                              util.fontSize16,
                                          color: blackColor),
                                    ),
                                  ],
                                ),
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(_animation.value, 0),
                                      child: Transform.rotate(
                                        angle: 270 * (3.141592653589793 / 180),
                                        child: SvgPicture.asset(dropDownArrow),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: util.responsiveHeight(0.0149),
                        ),
                      ],
                    ),
                  //App lang
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => AppLanguagePage());
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    languageIcon,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Language'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0149),
                      ),
                    ],
                  ),
                  //Subscriptions
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (Platform.isAndroid) {
                            // print(
                            //     'plan expired settings page,$_isPlanExpired');//

                            if (!tokenExist) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor:
                                    Colors.black.withValues(alpha: 0.5),
                                builder: (context) => const LoginPromptDialog(
                                    reDirectHome: false),
                              );
                              return;
                            }
                            CustomLoader.show(context);
                            try {
                              if (Platform.isIOS) {
                                if (subscriptionData != null) {
                                  await Get.to(() => SubscriptionDetailsPage(
                                      selectedIndex: 1, currency: 'INR'));
                                  // refresh profile after returning
                                  getProfileData();
                                } else {
                                  await Get.to(() => SubscriptionLandingPage(
                                        subscriptionData: subscriptionData,
                                        planData: planData,
                                        fromSettingPage: true,
                                        currency: 'INR',
                                      ));
                                  getProfileData();
                                }
                              } else {
                                print(
                                    'subscriptionData in settings page,$subscriptionData');
                                if (currency.isEmpty) {
                                  final permissionGranted =
                                      await CurrencyService()
                                          .requestPermission(context);
                                  if (permissionGranted) {
                                    currency = await CurrencyService()
                                            .getCurrency(context) ??
                                        '';
                                  }
                                }

                                if (currency.isNotEmpty) {
                                  if (kDebugMode) {
                                    print('Curreny: $currency');
                                  }
                                  // CustomLoader.show(context);
                                  // try {
                                  CustomLoader.hide();
                                  if (subscriptionData == null) {
                                    await Get.to(() => SubscriptionDetailsPage(
                                        selectedIndex: 1, currency: currency));
                                    getProfileData();
                                  } else if (_isPlanExpired()) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierColor: Colors.black.withAlpha(128),
                                      builder: (_) => SubscribePromptDialog(
                                        planStatus: 'expired',
                                        currency: currency,
                                        reDirectHome: false,
                                      ),
                                    );
                                  } else {
                                    await Get.to(() => SubscriptionLandingPage(
                                          subscriptionData: subscriptionData,
                                          planData: planData,
                                          fromSettingPage: true,
                                          currency: currency,
                                        ));
                                    getProfileData();
                                  }
                                  // } finally {
                                  //   CustomLoader.hide();
                                  // }
                                } else {
                                  CustomLoader.hide();
                                  showErrorSnackBar(context,
                                      'Please enable location access to view relevant subscription plans');
                                }
                              }
                            } finally {
                              CustomLoader.hide();
                            }
                          } else {
                            if (subscriptionData != null) {
                              await Get.to(() => SubscriptionLandingPageIos(
                                    subscriptionData: subscriptionData,
                                  ));
                              getProfileData();
                            } else {
                              await Get.to(() => SubscriptionDetailsPageIos());
                              getProfileData();
                            }
                          }
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    subscription,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Subscriptions'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0149),
                      ),
                    ],
                  ),
                  //Terms & Conditions
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => TermsAndConditionsPage());
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    terms,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Terms & Conditions'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0149),
                      ),
                    ],
                  ),
                  //Privacy Policy
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PrivacyPolicyPage());
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    privacy,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Privacy Policy'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0149),
                      ),
                    ],
                  ),
                  //Support
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (tokenExist) {
                            Get.to(() => SupportPage());
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (context) =>
                                  const LoginPromptDialog(reDirectHome: false),
                            );
                          }
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    support,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Support'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0149),
                      ),
                    ],
                  ),
                  //FAQ
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => FaqPage());
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    faq,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'FAQs'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: util.responsiveHeight(0.0149),
                      ),
                    ],
                  ),
                  //Rate Us
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (tokenExist) {
                            print('Pressed');
                            RateUsHelper.showRatingDialog(context);
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (context) =>
                                  const LoginPromptDialog(reDirectHome: false),
                            );
                          }
                        },
                        child: Container(
                          height: util.responsiveHeight(0.0555),
                          padding:
                              EdgeInsets.symmetric(horizontal: util.width20),
                          decoration: BoxDecoration(
                            color: blackColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(util.width8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: util.width10,
                                children: [
                                  SvgPicture.asset(
                                    rating,
                                    colorFilter: ColorFilter.mode(
                                        Platform.isAndroid
                                            ? mainColor
                                            : iosMainColor,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Rate us'.tr,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFont.get(FontType.medium),
                                        fontSize: util.fontSize16,
                                        height: util.lineHeight19_2 /
                                            util.fontSize16,
                                        color: blackColor),
                                  ),
                                ],
                              ),
                              AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_animation.value, 0),
                                    child: Transform.rotate(
                                      angle: 270 * (3.141592653589793 / 180),
                                      child: SvgPicture.asset(dropDownArrow),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Delete Account
                  if (tokenExist)
                    Column(
                      children: [
                        SizedBox(
                          height: util.lineHeight24,
                        ),
                        Container(
                          height: 1,
                          color: blackColor.withValues(alpha: 0.08),
                        ),
                        SizedBox(
                          height: util.lineHeight12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => DeleteAccountPage(email: email));
                          },
                          child: Container(
                            height: util.responsiveHeight(0.0555),
                            padding:
                                EdgeInsets.symmetric(horizontal: util.width20),
                            decoration: BoxDecoration(
                              color: blackColor.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(util.width8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: util.width10,
                                  children: [
                                    SvgPicture.asset(
                                      deleteAccount,
                                    ),
                                    Text(
                                      'Delete Account'.tr,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize16,
                                          height: util.lineHeight19_2 /
                                              util.fontSize16,
                                          color: blackColor),
                                    ),
                                  ],
                                ),
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(_animation.value, 0),
                                      child: Transform.rotate(
                                        angle: 270 * (3.141592653589793 / 180),
                                        child: SvgPicture.asset(dropDownArrow),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: util.responsiveHeight(0.0149),
                  ),
                  //Logout
                  if (tokenExist)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (_) => const LogoutPromptDialog(),
                            );
                            // handleLogout(context);
                          },
                          child: Container(
                            height: util.responsiveHeight(0.0555),
                            padding:
                                EdgeInsets.symmetric(horizontal: util.width20),
                            decoration: BoxDecoration(
                              color: errorColor.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(util.width8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: util.width10,
                                  children: [
                                    SvgPicture.asset(logout),
                                    Text(
                                      'Logout'.tr,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.get(FontType.medium),
                                          fontSize: util.fontSize16,
                                          height: util.lineHeight19_2 /
                                              util.fontSize16,
                                          color: errorColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: util.responsiveHeight(0.0149),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
