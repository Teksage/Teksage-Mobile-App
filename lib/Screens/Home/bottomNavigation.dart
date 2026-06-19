import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Screens/Home/homePage.dart';
import 'package:astro_prompt/Screens/Horoscope/horoscopePage.dart';
import 'package:astro_prompt/Screens/Panchang/emptyPanchangPage.dart';
import 'package:astro_prompt/Screens/Panchang/PanchangPage.dart';
import 'package:astro_prompt/Screens/settings/settings_page.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:eq_indexd_stack/eq.indexd.stack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

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
    final util = MyUtility(context);
    return Scaffold(
      extendBody: true,
      // body: Obx(() => pages[controller.currentIndex.value]),
      // body: Obx(() {
      //   final index = controller.currentIndex.value;
      //
      //   return IndexedStack(
      //     index: index,
      //     children: [
      //       pages[0],
      //       controller.isPremiumUser.value ? pages[1] : const PanchangSubscriptionCheckPage(),
      //       pages[2],
      //       pages[3],
      //     ],
      //   );
      // }),
      // body: Obx(() => IndexedStack(
      //       index: controller.currentIndex.value,
      //       children: pages,
      //     )),
      body: EQLazyLoadIndexedStack(
        controller: _stackController,
        children: pages,
      ),
      bottomNavigationBar: Obx(() => buildBottomNavBar(util)),
    );
  }

  Widget buildBottomNavBar(MyUtility util) {
    final bottomPadding = MediaQuery.of(Get.context!).padding.bottom;

    return MediaQuery(
      data: MediaQuery.of(Get.context!).removeViewPadding(removeBottom: true),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 20),
        child: Container(
          height: util.responsiveHeight(0.0863),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: whiteColor,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeIndex,
              selectedItemColor: mainColor,
              selectedLabelStyle: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize11,
                height: util.lineHeight13_2 / util.fontSize11,
              ),
              unselectedItemColor: blackColor.withValues(alpha: 0.6),
              unselectedLabelStyle: TextStyle(
                fontFamily: AppFont.get(FontType.semiBold),
                fontSize: util.fontSize11,
                height: util.lineHeight13_2 / util.fontSize11,
              ),
              showUnselectedLabels: true,
              items: [
                buildNavItem(0, "Home".tr, selectHome, unSelectHome),
                buildNavItem(1, PlatformTextConfig.panchang.tr, selectPanchang,
                    unSelectPanchang),
                buildNavItem(2, PlatformTextConfig.horoscope.tr,
                    selectHoroscope, unSelectHoroscope),
                buildNavItem(3, "Settings".tr, selectSetting, unSelectSetting),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem buildNavItem(
      int index, String label, String selectedIcon, String unselectedIcon) {
    return BottomNavigationBarItem(
      icon: Obx(() => AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: controller.currentIndex.value == index
                ? SvgPicture.asset(selectedIcon,
                    key: ValueKey('${label}_selected'))
                : SvgPicture.asset(unselectedIcon,
                    key: ValueKey('${label}_unselected')),
          )),
      label: label,
    );
  }
}
