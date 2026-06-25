import 'dart:io';
import 'package:astro_prompt/Screens/Chat/chat.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/auth/login_entry.dart';
import 'package:astro_prompt/Screens/intro/onboardingPage.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/onBoarding.dart';
import 'package:astro_prompt/config/UpgradeDialog.dart';
import 'package:astro_prompt/config/upgradeChecker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool _navigated = false;
  bool tokenExist = false;
  late bool isAndroid;

  @override
  void initState() {
    super.initState();
    isAndroid = Platform.isAndroid;
    _startAnimation();
    _bootstrap();
    checkAccessToken();
  }

  Future<void> _bootstrap() async {
    // TimezoneManager.instance.ensureTimezoneSynced().catchError((e, _) {
    //   if (kDebugMode) print('[TZ] sync error: $e');
    // });

    // Ensure splash screen is visible for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    await _checkUserStatus();
  }

  Future<void> checkAccessToken() async {
    String? token = await getAccessToken();
    setState(() {
      tokenExist = token.isNotEmpty;
    });
  }

  Future<void> _checkUserStatus() async {
    if (_navigated) return;
    _navigated = true;

    final hasSeenOnboarding = (await getOnboardingStatus());

    if (!mounted) return;

    bool updateAvailable = false;
    if (Platform.isAndroid) {
      updateAvailable = await UpdateChecker.isUpdateAvailable();
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        print("Update check not implemented for iOS via this plugin.");
      }
    }

    if (!mounted) return;

    if (updateAvailable) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const UpdateRequiredDialog(),
      );
      return;
    }

    if (!hasSeenOnboarding) {
      Get.off(
        () => const OnboardingPage(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 800),
      );
    } else {
      if (Platform.isAndroid) {
        Get.off(
          () => const BottomNavigationScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 800),
        );
      } else {
        if (!tokenExist) {
          Get.off(
            () => const LoginEntryPage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 800),
          );
        } else {
          Get.off(
            () => const AIChatScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 800),
          );
        }
      }
    }
  }

  void _startAnimation() {
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = Tween<double>(begin: 1.0, end: 3.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(splashBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: animation,
            child: isAndroid
                ? SvgPicture.asset(
                    logoIos,
                    width: 50,
                  )
                : Image.asset(
                    newIosLogoPNG,
                    width: 50,
                  ),
          ),
        ),
      ),
    );
  }
}
