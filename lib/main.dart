import 'dart:io';
import 'package:astro_prompt/Components/AskAstrologer/ask_answer_ready_prompt.dart';
import 'package:astro_prompt/Screens/Home/bottomNavigation.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Screens/auth/login_page.dart';
import 'package:astro_prompt/Screens/intro/splashScreen.dart';
import 'package:astro_prompt/Services/NotificationService/notificationService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/config/LocallySavedData/appLanguage.dart';
import 'package:astro_prompt/config/localeString.dart';
import 'package:astro_prompt/config/networkCheck.dart';
import 'package:astro_prompt/config/noInternetScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    await NotificationService.init();
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  NetworkManager().initialize();
  Get.put(BottomNavController());
  // Enable controller behavior after registration so bottom nav taps run access checks
  Get.find<BottomNavController>().initializeController();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale _locale = Locale('en', 'US'); // Default locale

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSavedLanguage();

    // Listen to changes and show/hide loader
    NetworkManager().internetStatus.addListener(() {
      final value = NetworkManager().internetStatus.value;
      if (value == null) {
        CustomLoader.show(Get.context!);
      } else {
        CustomLoader.hide();
      }
    });
  }

  /// Load the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    String savedLang = await getAppLanguage();
    // print('Main.dart - Loading saved language: "$savedLang"');

    if (savedLang.isNotEmpty) {
      setState(() {
        // savedLang now contains language names: "tamil", "hindi", "malayalam", etc.
        switch (savedLang.toLowerCase()) {
          case 'tamil':
            _locale = Locale('ta');
            break;
          case 'hindi':
            _locale = Locale('hi');
            break;
          case 'telugu':
            _locale = Locale('te', 'IN');
            break;
          case 'kannada':
            _locale = Locale('kn', 'IN');
            break;
          case 'malayalam':
            _locale = Locale('ml', 'IN');
            break;
          case 'marathi':
            _locale = Locale('mr', 'IN');
            break;
          case 'english':
          default:
            _locale = Locale('en', 'US');
        }
      });
      // Update GetX locale
      Get.updateLocale(_locale);
      // print('Main.dart - Set locale to: ${_locale.languageCode}');
    } else {
      // Language not set - default to English
      // Language selection will be shown on home page
      setState(() {
        _locale = Locale('en', 'US');
      });
      Get.updateLocale(_locale);
      // print('Main.dart - No saved language, defaulting to English');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInternet();
    }
  }

  void _checkInternet() async {
    NetworkManager().internetStatus.value = null; // show loader
    final hasInternet = await InternetConnection().hasInternetAccess;
    NetworkManager().updateConnectionStatus(hasInternet);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool?>(
      valueListenable: NetworkManager().internetStatus,
      builder: (context, isConnected, _) {
        return GetMaterialApp(
          translations: LocalString(),
          locale: _locale,
          fallbackLocale: Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          title: 'Teksage',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
            useMaterial3: true,
          ),
          getPages: [
            GetPage(name: '/splash', page: () => SplashScreen()),
            GetPage(name: '/home', page: () => BottomNavigationScreen()),
            GetPage(name: '/login', page: () => const LoginPage()),
          ],
          initialRoute: '/splash',
          routingCallback: (_) => AskAnswerReadyScheduler.notifyRouteChanged(),
          builder: (context, child) {
            return AskAnswerReadyPrompt(
              child: Stack(
                children: [
                  child!,
                  if (isConnected == false) const FullScreenNoInternet(),
                ],
              ),
            );
          },
          // home: SplashScreen(),
        );
      },
    );
  }
}
