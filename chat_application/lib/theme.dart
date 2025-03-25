// First, let's create a theme.dart file to define our black and white theme

// theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Define our black and white color palette
  static const Color primaryBlack = Color(0xFF121212);
  static const Color darkGrey = Color(0xFF333333);
  static const Color mediumGrey = Color(0xFF666666);
  static const Color lightGrey = Color(0xFFAAAAAA);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: pureWhite,
    letterSpacing: 0.5,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: pureWhite,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: offWhite,
  );

  // Button styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: pureWhite,
    foregroundColor: primaryBlack,
    textStyle: const TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Create the theme data
  static ThemeData darkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: primaryBlack,
      primaryColor: pureWhite,
      colorScheme: const ColorScheme.dark(
        primary: pureWhite,
        secondary: offWhite,
        surface: darkGrey,
        background: primaryBlack,
        error: Color(0xFFCF6679),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlack,
        elevation: 0,
        titleTextStyle: subheadingStyle,
        iconTheme: IconThemeData(color: pureWhite),
      ),
      textTheme: const TextTheme(
        displayLarge: headingStyle,
        displayMedium: subheadingStyle,
        bodyLarge: bodyStyle,
        bodyMedium: bodyStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: darkGrey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: lightGrey),
        labelStyle: const TextStyle(color: offWhite),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: pureWhite, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: offWhite,
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: pureWhite,
        size: 24,
      ),
      dividerTheme: const DividerThemeData(
        color: darkGrey,
        thickness: 1,
      ),
    );
  }
}
