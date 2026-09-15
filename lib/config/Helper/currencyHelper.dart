import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/customLoader.dart';
import 'package:astro_prompt/config/currency.dart';
import 'package:flutter/material.dart';

class CurrencyHelper {
  static Future<void> fetchCurrencyIfNeeded({
    Color? loaderColor,
    required BuildContext context,
    required String currentCurrency,
    required void Function(String newCurrency) onCurrencyFetched,
  }) async {
    if (currentCurrency.isNotEmpty) {
      onCurrencyFetched(currentCurrency);
      return;
    }

    CustomLoader.show(context, loaderColor: loaderColor ?? mainColor);
    try {
      final currencyService = CurrencyService();
      final countryCode = await currencyService.getCurrency(context);
      onCurrencyFetched(countryCode ?? '');
    } finally {
      if (context.mounted) {
        CustomLoader.hide();
      }
    }
  }
}
