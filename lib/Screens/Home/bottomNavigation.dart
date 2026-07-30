import 'package:astro_prompt/Components/Common/app_floating_bottom_nav.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Screens/Home/homePage.dart';
import 'package:astro_prompt/Screens/Horoscope/horoscopePage.dart';
import 'package:astro_prompt/Screens/Panchang/PanchangPage.dart';
import 'package:astro_prompt/Screens/settings/settings_page.dart';
import 'package:eq_indexd_stack/eq.indexd.stack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  late final EQLazyStackController _stackController;
  final BottomNavController controller = Get.find<BottomNavController>();

  final List<Widget> pages = [
    HomePage(),
    PanchangPage(),
    HoroscopePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _stackController = EQLazyStackController(
      initialIndex: controller.currentIndex.value,
      disposeUnused: false, // preserves your state
    );

    controller.currentIndex.listen((index) {
      _stackController.switchTo(index, pages.length);
    });
  }

  @override
  void dispose() {
    _stackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: EQLazyLoadIndexedStack(
        controller: _stackController,
        children: pages,
      ),
      bottomNavigationBar: const AppFloatingBottomNav(),
    );
  }
}
