import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTabTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: unicoBlue40,
        secondary: unicoGrey40,
        tertiary: unicoSecondary40,
        surface: Color(0xFFFFFBFE),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: Color(0xFF1C1B1F),
      ),
      fontFamily: 'AtkinsonHyperlegible',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'AtkinsonHyperlegible',
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontFamily: 'AtkinsonHyperlegibleBold',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          height: 1.27,
          letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'AtkinsonHyperlegible',
          fontWeight: FontWeight.normal,
          fontSize: 14,
          height: 1.43,
          letterSpacing: 0.25,
        ),
        labelSmall: TextStyle(
          fontFamily: 'AtkinsonHyperlegible',
          fontWeight: FontWeight.w500,
          fontSize: 11,
          height: 1.45,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: unicoBlue80,
        secondary: unicoGrey80,
        tertiary: unicoSecondary80,
        surface: Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: Color(0xFFE0E0E0),
      ),
      fontFamily: 'AtkinsonHyperlegible',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'AtkinsonHyperlegible',
          fontWeight: FontWeight.normal,
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontFamily: 'AtkinsonHyperlegibleBold',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          height: 1.27,
          letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'AtkinsonHyperlegible',
          fontWeight: FontWeight.normal,
          fontSize: 14,
          height: 1.43,
          letterSpacing: 0.25,
        ),
        labelSmall: TextStyle(
          fontFamily: 'AtkinsonHyperlegible',
          fontWeight: FontWeight.w500,
          fontSize: 11,
          height: 1.45,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
