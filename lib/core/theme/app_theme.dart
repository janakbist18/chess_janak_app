import 'package:flutter/material.dart';
import 'color_palette.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: ColorPalette.primary,
      scaffoldBackgroundColor: ColorPalette.white,
      colorScheme: ColorScheme.light(
        primary: ColorPalette.primary,
        secondary: ColorPalette.secondary,
        surface: ColorPalette.white,
        background: ColorPalette.grey50,
        error: ColorPalette.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ColorPalette.white,
        foregroundColor: ColorPalette.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: titleLarge,
      ),
      cardTheme: CardTheme(
        color: ColorPalette.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primary,
          foregroundColor: ColorPalette.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: textTheme,
      inputDecorationTheme: _inputDecorationTheme(),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: ColorPalette.primary,
      scaffoldBackgroundColor: ColorPalette.grey900,
      colorScheme: ColorScheme.dark(
        primary: ColorPalette.primary,
        secondary: ColorPalette.secondary,
        surface: ColorPalette.grey800,
        background: ColorPalette.grey900,
        error: ColorPalette.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ColorPalette.grey800,
        foregroundColor: ColorPalette.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: titleLarge,
      ),
      cardTheme: CardTheme(
        color: ColorPalette.grey800,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primary,
          foregroundColor: ColorPalette.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: textTheme,
      inputDecorationTheme: _inputDecorationTheme(),
    );
  }

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: titleLarge.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: titleLarge.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: titleLarge.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: titleLarge.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: titleLarge.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
    );
  }

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.33,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: ColorPalette.grey100,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.error, width: 2),
      ),
      hintStyle: TextStyle(color: ColorPalette.grey500),
      errorStyle: TextStyle(color: ColorPalette.error),
    );
  }
}
