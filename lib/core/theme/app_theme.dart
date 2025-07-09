import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.base,
        brightness: Brightness.light,
        primary: AppColors.base,
        secondary: const Color(0xFF64B5F6),
        surface: AppColors.white,
        background: AppColors.background[50]!,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: const Color(0xFF1F2C40),
        onBackground: const Color(0xFF202D41),
        onError: AppColors.white,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFB74D),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 24),
      ),

      // Text Theme
      textTheme: const TextTheme(
        // Headlines
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Color(0xFF202D41),
          letterSpacing: -1.50,
          fontFamily: 'Poppins',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF202D41),
          letterSpacing: -1,
          fontFamily: 'Poppins',
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF202D41),
          fontFamily: 'Poppins',
        ),

        // Body Text
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2C40),
          fontFamily: 'Poppins',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6A788C),
          fontFamily: 'Poppins',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF6A788C),
          fontFamily: 'Poppins',
        ),

        // Labels
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F2C40),
          fontFamily: 'Poppins',
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2C40),
          fontFamily: 'Poppins',
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6A788C),
          fontFamily: 'Poppins',
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: const Color(0x3FB4ADAD),
        margin: const EdgeInsets.all(8),
      ),

      // ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.base,
          foregroundColor: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      // OutlinedButton Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.base,
          side: BorderSide(color: AppColors.base),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      // TextButton Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF64B5F6),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.base, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF6A788C),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF6A788C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // TabBar Theme
      tabBarTheme: const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2, color: Color(0xFFFFB74D)),
          ),
        ),
        labelColor: Color(0xFFFFB74D),
        unselectedLabelColor: Color(0xFF202D41),
        labelStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: Color(0xFF6A788C), size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF6A788D),
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.base,
        unselectedItemColor: const Color(0xFF6A788C),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: const Color(0xFFFCFBFA),

      // Material 3 Extensions
      extensions: <ThemeExtension>[
        CustomColorExtension(
          incomeColor: const Color(0xFF40B029),
          expenseColor: const Color(0xFFFF4545),
          separatorColor: const Color(0xFF6A788D),
          lightGray: const Color(0xFF6A788C),
          darkGray: const Color(0xFF1F2C40),
          cardShadow: const Color(0x3FB4ADAD),
        ),
      ],
    );
  }
}

// Custom Color Extension for specific app colors
class CustomColorExtension extends ThemeExtension<CustomColorExtension> {
  final Color incomeColor;
  final Color expenseColor;
  final Color separatorColor;
  final Color lightGray;
  final Color darkGray;
  final Color cardShadow;

  const CustomColorExtension({
    required this.incomeColor,
    required this.expenseColor,
    required this.separatorColor,
    required this.lightGray,
    required this.darkGray,
    required this.cardShadow,
  });

  @override
  CustomColorExtension copyWith({
    Color? incomeColor,
    Color? expenseColor,
    Color? separatorColor,
    Color? lightGray,
    Color? darkGray,
    Color? cardShadow,
  }) {
    return CustomColorExtension(
      incomeColor: incomeColor ?? this.incomeColor,
      expenseColor: expenseColor ?? this.expenseColor,
      separatorColor: separatorColor ?? this.separatorColor,
      lightGray: lightGray ?? this.lightGray,
      darkGray: darkGray ?? this.darkGray,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  CustomColorExtension lerp(
    ThemeExtension<CustomColorExtension>? other,
    double t,
  ) {
    if (other is! CustomColorExtension) {
      return this;
    }
    return CustomColorExtension(
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t)!,
      expenseColor: Color.lerp(expenseColor, other.expenseColor, t)!,
      separatorColor: Color.lerp(separatorColor, other.separatorColor, t)!,
      lightGray: Color.lerp(lightGray, other.lightGray, t)!,
      darkGray: Color.lerp(darkGray, other.darkGray, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}

// Extension to easily access custom colors
extension CustomColorsExtension on ThemeData {
  CustomColorExtension get customColors => extension<CustomColorExtension>()!;
}
