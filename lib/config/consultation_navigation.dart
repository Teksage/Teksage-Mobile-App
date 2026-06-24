import 'dart:async';

import 'package:astro_prompt/Model/AstrologerUserConsult/astro_user_events_model.dart';
import 'package:astro_prompt/Screens/ConsultationUser/consultation_astrologer_listing_page.dart';
import 'package:astro_prompt/Screens/ConsultationUser/userConsultationHomePage.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:astro_prompt/config/Helper/currencyHelper.dart';
import 'package:astro_prompt/config/consultation_default_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Opens astrologer listing directly (from Find & Consult card on consultation home).
Future<void> openConsultationAstrologerListing(
  BuildContext context, {
  bool replaceStack = false,
}) async {
  final completer = Completer<String>();
  await CurrencyHelper.fetchCurrencyIfNeeded(
    loaderColor: homeBanner,
    context: context,
    currentCurrency: '',
    onCurrencyFetched: completer.complete,
  );
  final currency = await completer.future;
  if (!context.mounted) return;
  if (currency.isEmpty) {
    showErrorSnackBar(
      context,
      'Location access is required to determine your currency. Please enable it',
    );
    return;
  }
  final page = ConsultationAstrologerListingPage(
    selectedCategories: ConsultationDefaultFilter.categories,
    selectedLanguages: ConsultationDefaultFilter.languages,
    currency: currency,
  );
  if (replaceStack) {
    Get.offAll(() => page);
  } else {
    Get.to(() => page);
  }
}

/// Book Consultation entry points — opens consultation home (Find & Consult + meetings tabs).
Future<void> openBookConsultation(
  BuildContext context, {
  bool backButton = true,
  List<AstroConsultationEventModel> eventData = const [],
}) async {
  Get.to(
    () => UserConsultationDetailsHome(
      backButton: backButton,
      eventData: eventData,
    ),
  );
}
