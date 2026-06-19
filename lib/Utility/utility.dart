// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class MyUtility {
//   final BuildContext context;
//
//   MyUtility(this.context);
//
//   double get width => MediaQuery.sizeOf(context).width;
//   double get height => MediaQuery.sizeOf(context).height;
//
//   // ✅ FIXED: TextScaler (no deprecated API)
//   TextScaler get _textScaler =>
//       MediaQuery.textScalerOf(context).clamp(
//         minScaleFactor: 1.0,
//         maxScaleFactor: 1.2,
//       );
//
//   // ✅ FIXED: font scaling only
//   double responsiveFontSize(double size) {
//     return _textScaler.scale(size);
//   }
//
//   // --- UNCHANGED BELOW ---
//
//   double responsiveWidth(double factor) {
//     return width * factor;
//   }
//
//   double responsiveHeight(double factor) {
//     return height * factor;
//   }
//
//   double get width8 => responsiveWidth(0.0215);
//   double get width10 => responsiveWidth(0.0267);
//   double get width12 => responsiveWidth(0.032);
//   double get width20 => responsiveWidth(0.0535);
//   double get width30 => responsiveWidth(0.08);
//   double get width50 => responsiveWidth(0.134);
//
//   double get height10 => responsiveHeight(0.0124);
//   double get height20 => responsiveHeight(0.0247);
//   double get height30 => responsiveHeight(0.037);
//   double get height50 => responsiveHeight(0.0616);
//   double get height250 => responsiveHeight(0.308);
//
//   // ⛔ Keeping line heights as-is (per your constraint)
//   double get lineHeight9_6 => responsiveHeight(0.0112);
//   double get lineHeight10_8 => responsiveHeight(0.0134);
//   double get lineHeight12 => responsiveHeight(0.0148);
//   double get lineHeight13_2 => responsiveHeight(0.0163);
//   double get lineHeight14_4 => responsiveHeight(0.0178);
//   double get lineHeight15_6 => responsiveHeight(0.0193);
//   double get lineHeight16_8 => responsiveHeight(0.0207);
//   double get lineHeight19_2 => responsiveHeight(0.0237);
//   double get lineHeight21_6 => responsiveHeight(0.0248);
//   double get lineHeight24 => responsiveHeight(0.0296);
//   double get lineHeight28 => responsiveHeight(0.0345);
//   double get lineHeight28_8 => responsiveHeight(0.0355);
//
//   // ✅ FIXED: use REAL font sizes (no screen math)
//   double get fontSize8 => responsiveFontSize(8);
//   double get fontSize9 => responsiveFontSize(9);
//   double get fontSize10 => responsiveFontSize(10);
//   double get fontSize11 => responsiveFontSize(11);
//   double get fontSize12 => responsiveFontSize(12);
//   double get fontSize13 => responsiveFontSize(13);
//   double get fontSize14 => responsiveFontSize(14);
//   double get fontSize15 => responsiveFontSize(15);
//   double get fontSize16 => responsiveFontSize(16);
//   double get fontSize18 => responsiveFontSize(18);
//   double get fontSize19 => responsiveFontSize(19);
//   double get fontSize20 => responsiveFontSize(20);
//   double get fontSize22 => responsiveFontSize(22);
//   double get fontSize24 => responsiveFontSize(24);
//   double get fontSize29 => responsiveFontSize(29);
//   double get fontSize32 => responsiveFontSize(32);
//   double get fontSize60 => responsiveFontSize(60);
// }
//


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyUtility {
  BuildContext context;

  MyUtility(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  double responsiveFontSize(double factor) {
    return (width + height) * factor / 2;
  }

  double responsiveWidth(double factor) {
    return width * factor;
  }

  double responsiveHeight(double factor) {
    return height * factor;
  }

  double get width8 => responsiveWidth(0.0215);
  double get width10 => responsiveWidth(0.0267);
  double get width12 => responsiveWidth(0.032);
  double get width20 => responsiveWidth(0.0535);
  double get width30 => responsiveWidth(0.08);
  double get width50 => responsiveWidth(0.134);

  double get height10 => responsiveHeight(0.0124);
  double get height20 => responsiveHeight(0.0247);
  double get height30 => responsiveHeight(0.037);
  double get height50 => responsiveHeight(0.0616);
  double get height250 => responsiveHeight(0.308);

  double get lineHeight9_6 => responsiveHeight(0.0112);
  double get lineHeight10_8 => responsiveHeight(0.0134);
  double get lineHeight12 => responsiveHeight(0.0148);
  double get lineHeight13_2 => responsiveHeight(0.0163);
  double get lineHeight14_4 => responsiveHeight(0.0178);
  double get lineHeight15_6 => responsiveHeight(0.0193);
  double get lineHeight16_8 => responsiveHeight(0.0207);
  double get lineHeight19_2 => responsiveHeight(0.0237);
  double get lineHeight21_6 => responsiveHeight(0.0248);
  double get lineHeight24 => responsiveHeight(0.0296);
  double get lineHeight28 => responsiveHeight(0.0345);
  double get lineHeight28_8 => responsiveHeight(0.0355);

  double get fontSize8 => responsiveFontSize(0.0135);
  double get fontSize9 => responsiveFontSize(0.0153);
  double get fontSize10 => responsiveFontSize(0.017);
  double get fontSize11 => responsiveFontSize(0.0186);
  double get fontSize12 => responsiveFontSize(0.0203);
  double get fontSize13 => responsiveFontSize(0.022);
  double get fontSize14 => responsiveFontSize(0.0236);
  double get fontSize15 => responsiveFontSize(0.0253);
  double get fontSize16 => responsiveFontSize(0.027);
  double get fontSize18 => responsiveFontSize(0.0304);
  double get fontSize19 => responsiveFontSize(0.0321);
  double get fontSize20 => responsiveFontSize(0.0338);
  double get fontSize22 => responsiveFontSize(0.0371);
  double get fontSize24 => responsiveFontSize(0.0406);
  double get fontSize29 => responsiveFontSize(0.049);
  double get fontSize32 => responsiveFontSize(0.054);
  double get fontSize60 => responsiveFontSize(0.1011);
}