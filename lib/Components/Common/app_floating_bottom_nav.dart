import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// Floating bottom tab bar used on main shell and pushed feature pages
/// (e.g. Event Planner) so navigation stays consistent with the website.
class AppFloatingBottomNav extends StatelessWidget {
  /// When true, tapping a tab pops back to the main shell first.
  final bool popToRootOnTap;

  const AppFloatingBottomNav({super.key, this.popToRootOnTap = false});

  void _onTap(int index) {
    if (popToRootOnTap && Get.routing.current != '/') {
      Get.until((route) => route.isFirst);
    }
    Get.find<BottomNavController>().changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final controller = Get.find<BottomNavController>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return MediaQuery(
      data: MediaQuery.of(context).removeViewPadding(removeBottom: true),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 20),
        child: Container(
          height: util.responsiveHeight(0.0863),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Obx(
              () => BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: whiteColor,
                currentIndex: controller.currentIndex.value.clamp(0, 3),
                onTap: _onTap,
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
                  _item(controller, 0, 'Home'.tr, selectHome, unSelectHome),
                  _item(controller, 1, PlatformTextConfig.panchang.tr,
                      selectPanchang, unSelectPanchang),
                  _item(controller, 2, PlatformTextConfig.horoscope.tr,
                      selectHoroscope, unSelectHoroscope),
                  _item(controller, 3, 'Settings'.tr, selectSetting,
                      unSelectSetting),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _item(
    BottomNavController controller,
    int index,
    String label,
    String selectedIcon,
    String unselectedIcon,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: controller.currentIndex.value == index
            ? SvgPicture.asset(selectedIcon,
                key: ValueKey('${label}_selected'))
            : SvgPicture.asset(unselectedIcon,
                key: ValueKey('${label}_unselected')),
      ),
      label: label,
    );
  }
}
