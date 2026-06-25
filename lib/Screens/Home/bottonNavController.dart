import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/Components/Dashboard/LoginDialog.dart';
import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:astro_prompt/config/currency.dart';
import 'package:astro_prompt/Services/ProfileService/profileService.dart';
import 'package:astro_prompt/Screens/settings/profile_page.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;
  var isPremiumUser = false.obs;
  var planStatus = ''.obs;

  // internal guards
  bool _dialogShown = false;
  bool _screenActive = true;
  bool _initialized = false;

  void initializeController() {
    _initialized = true; // enable behavior when app is ready
  }

  void changeIndex(int index) async {
    if (!_initialized) return;

    currentIndex.value = index;

    if (index == 1) {
      _screenActive = true;

      // small delay to allow UI to settle before showing a dialog
      Future.delayed(const Duration(milliseconds: 10), () {
        _checkAccessFlow();
      });
    } else {
      _screenActive = false;
    }
  }

  Future<bool> _checkAccessFlow() async {
    try {
      if (Get.context == null) return false;
      CustomLoader.show(Get.context!);

      final token = await getAccessToken();

      if (token.isEmpty) {
        CustomLoader.hide();
        if (_screenActive && (Get.context != null) && (Get.context!.mounted)) {
          await _showDialog(const LoginPromptDialog(reDirectHome: true));
        }
        return false;
      }

      // Fetch profile and check plan status (expired -> prompt subscription)
      try {
        final profile = await ProfileService().fetchUserProfile();
        final serverPlanStatus = profile?.subscription?.planStatus;
        if (serverPlanStatus != null) {
          planStatus.value = serverPlanStatus;
        }

        if (planStatus.value == 'expired') {
          // Hide loader before showing dialog
          CustomLoader.hide();
          if (_screenActive && (Get.context != null) && (Get.context!.mounted)) {
            await _showDialog(const SubscribePromptDialog(currency: 'INR', reDirectHome: true, planStatus: 'expired'));
          }
          return false;
        }
      } on IncompleteProfileException catch (_) {
        CustomLoader.hide();
        if (_screenActive && (Get.context != null) && (Get.context!.mounted)) {
          Get.to(() => ProfilePage(title: 'Profile Details', isProfileUpdated: false));
        }
        return false;
      } catch (e) {
        // If profile fetch fails, log and continue to other checks (don't block UX)
        debugPrint('Profile fetch warning: $e');
      }

      final premium = await getUserPremium();
      isPremiumUser.value = premium;
      if (!premium) {
        final currency = await CurrencyService().getCurrency(Get.context!);
        CustomLoader.hide();

        if (_screenActive && currency != null && currency.isNotEmpty) {
          await _showDialog(SubscribePromptDialog(
            currency: currency,
            reDirectHome: true,
          ));
        }

        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Access check failed: $e');
      return false;
    } finally {
      CustomLoader.hide();
    }
  }

  Future<void> _showDialog(Widget dialog) async {
    if (_dialogShown) return;
    _dialogShown = true;

    try {
      if (Get.context?.mounted ?? false) {
        await showDialog(
          context: Get.context!,
          barrierDismissible: true,
          barrierColor: Colors.black.withAlpha(50),
          builder: (_) => dialog,
        );
      }
    } catch (e) {
      debugPrint('Dialog error: $e');
    } finally {
      _dialogShown = false;
    }
  }
}
