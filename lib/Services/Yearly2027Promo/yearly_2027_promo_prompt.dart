import 'dart:async';

import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Components/Home/yearly_2027_promo_sheet.dart';
import 'package:astro_prompt/Components/Predictions/predictionLandingPage.dart';
import 'package:astro_prompt/Model/yearly_2027_promo_model.dart';
import 'package:astro_prompt/Services/PredictionService/predictionService.dart';
import 'package:astro_prompt/Services/Yearly2027Promo/yearly_2027_promo_service.dart';
import 'package:astro_prompt/Screens/prediction/yearlyPrediction.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/config/LocallySavedData/accessToken.dart';
import 'package:astro_prompt/config/LocallySavedData/yearly2027Promo.dart';
import 'package:astro_prompt/config/textConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Once-per-day 2027 yearly promo bottom sheet on Home.
class Yearly2027PromoPrompt {
  Yearly2027PromoPrompt._();

  static final Yearly2027PromoService _service = Yearly2027PromoService();
  static bool _sheetOpen = false;
  static String? _handledDay;
  static Future<void>? _inFlight;

  static Future<void> maybeShow(BuildContext context) async {
    final today = yearly2027LocalTodayIso();
    if (_sheetOpen || _handledDay == today || !context.mounted) return;

    // Serialize prompts — home can call this on every visibility sync.
    if (_inFlight != null) {
      await _inFlight;
      return;
    }
    final gate = Completer<void>();
    _inFlight = gate.future;

    try {
      final accessToken = await getAccessToken();
      if (accessToken.trim().isEmpty || !context.mounted) return;
      if (_handledDay == today) return;

      final status = await _service.fetchStatus(ensure: true);
      // Dismiss may have completed while the status request was in flight.
      if (_handledDay == today || !context.mounted) return;

      if (status == null) {
        if (await isYearly2027PromoHiddenLocallyToday()) {
          _handledDay = today;
        }
        return;
      }

      if (status.hiddenToday) {
        await markYearly2027PromoHiddenLocallyToday();
        _handledDay = today;
        return;
      }
      if (_handledDay == today) return;

      if (!status.showSheet) {
        _handledDay = today;
        return;
      }

      await clearYearly2027PromoDismissedLocal();
      if (_handledDay == today || !context.mounted) return;

      _sheetOpen = true;
      // Root navigator so the sheet covers `extendBody` floating bottom nav.
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: const Color(0xFFF7FCF4),
        barrierColor: Colors.black.withValues(alpha: 0.45),
        // Stronger top curve than website 1.25rem for clearer sheet silhouette.
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (ctx) => Yearly2027PromoSheet(
          scores: status.scores,
          isPremium: status.isPremium,
          generating: status.generating,
          onClose: () => _closeSheet(ctx),
          onOpenYearly: () {
            _closeSheet(ctx);
            _openYearly(context, status);
          },
          onUpgrade: () {
            _closeSheet(ctx);
            _openUpgrade(context);
          },
        ),
      );

      // Barrier dismiss / system back — still hide for today.
      await dismissForToday();
    } finally {
      _sheetOpen = false;
      if (!gate.isCompleted) gate.complete();
      if (identical(_inFlight, gate.future)) _inFlight = null;
    }
  }

  /// Mark dismissed synchronously before pop so a concurrent maybeShow cannot reopen.
  static void _closeSheet(BuildContext sheetContext) {
    final today = yearly2027LocalTodayIso();
    _handledDay = today;
    unawaited(markYearly2027PromoHiddenLocallyToday());
    unawaited(_service.dismiss());
    if (sheetContext.mounted) {
      Navigator.of(sheetContext).pop();
    }
  }

  static Future<void> dismissForToday() async {
    final today = yearly2027LocalTodayIso();
    _handledDay = today;
    await markYearly2027PromoHiddenLocallyToday();
    await _service.dismiss();
  }

  static Future<void> _openUpgrade(BuildContext context) async {
    await dismissForToday();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => const SubscribePromptDialog(
        reDirectHome: true,
      ),
    );
  }

  static Future<void> _openYearly(
    BuildContext context,
    Yearly2027PromoStatus status,
  ) async {
    await dismissForToday();
    if (!context.mounted) return;

    if (status.isPremium) {
      final data = await PredictionService().getYearlyPrediction();
      if (!context.mounted) return;
      if (data != null) {
        Get.to(
          () => YearlyPredictionPage(predictionData: data),
          transition: Transition.fade,
          fullscreenDialog: true,
          popGesture: false,
          duration: const Duration(milliseconds: 700),
        );
        return;
      }
      Get.to(
        () => PredictionLandingPage(
          title: PlatformTextConfig.yearlyPredictionLanding,
          icon: yearlyDecoLogo,
          gradientTop: yearlyTopGradient,
          gradientBottom: yearlyBottomGradient,
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => const SubscribePromptDialog(
        reDirectHome: true,
      ),
    );
  }
}
