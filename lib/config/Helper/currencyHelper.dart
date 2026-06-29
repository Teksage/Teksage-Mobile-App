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

// import 'package:astro_prompt/Utility/colorConstant.dart';
// import 'package:astro_prompt/Utility/customLoader.dart';
// import 'package:astro_prompt/config/currency.dart';
// import 'package:flutter/material.dart';
//
// class CurrencyHelper {
//   static bool _isFetching = false;
//
//   static Future<void> fetchCurrencyIfNeeded({
//     Color? loaderColor,
//     required BuildContext context,
//     required String currentCurrency,
//     required void Function(String newCurrency) onCurrencyFetched,
//   }) async {
//     if (_isFetching || currentCurrency.isNotEmpty) return;
//     _isFetching = true;
//
//     CustomLoader.show(context, loaderColor: loaderColor ?? mainColor);
//
//     try {
//       final currencyService = CurrencyService();
//       final countryCode = await currencyService.getCurrency(context);
//
//       if (!context.mounted) return;
//
//       if (countryCode != null) {
//         onCurrencyFetched(countryCode);
//       }
//     } finally {
//       if (context.mounted) {
//         CustomLoader.hide();
//       }
//       _isFetching = false;
//     }
//   }
// }
