import 'package:flutter/material.dart';

class AppColors {
  // Primary colors

  static const MaterialColor base = MaterialColor(
    0xFFFFB74D, // primary value
    <int, Color>{
      50: Color(0xFFFFB74D),
      100: Color(0xFFFFFFFF),
    },
  );

  static const MaterialColor warning = MaterialColor(
      0xFFFFC107, // primary value
      <int, Color>{
        50: Color(0xFFFEF6AC),
        100: Color(0xFFFFF27B),
        200: Color(0xFFFFED4C),
        300: Color(0xFFFDE82C),
      });


  static const MaterialColor error = MaterialColor(
    0xFFE74C3C, // primary value
    <int, Color>{
      50: Color(0xFFFEF2F2),
      100: Color(0xFFFEE2E2),
      200: Color(0xFFfecaca),
      300: Color(0xFFfca5a5),
      400: Color(0xFFf87171),
      500: Color(0xFFef4444),
      600: Color(0xFFdc2626),
    },
  );


  static const MaterialColor success = MaterialColor(
    0xFF10B981, // primary value
    <int, Color>{
      50: Color(0xFFecfdf5),
      100: Color(0xFFd1fae5),
      200: Color(0xFFa7f3d0),
      300: Color(0xFF6ee7b7),
      400: Color(0xFF34d399),
      500: Color(0xFF10b981),
      600: Color(0xFF059669),
    },
  );

  static const MaterialColor background = MaterialColor(
    0xFFf9f9f9, // primary value
    <int, Color>{
      50: Color(0xFFFDFCFA),
      100: Color(0xFFF7FAFC),
    },
  );

    static const MaterialColor neutral = MaterialColor(
    0xFFF7FAFC, // primary value
    <int, Color>{
      50: Color(0xFFCACACA),
      100: Color(0xFF343434),
    },
  );

  static const Color white = Colors.white;
}
