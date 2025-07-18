import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Montserrat',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
      bodyMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
      bodySmall: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: iosButtonStyle),
  );

  static ThemeData get darkTheme => ThemeData(
    fontFamily: 'Montserrat',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 16, color: Colors.white),
      bodySmall: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: iosButtonStyleDark),
  );

  static ButtonStyle get iosButtonStyle => ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: const TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    elevation: 0,
  );

  static ButtonStyle get iosButtonStyleDark => ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: const TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    elevation: 0,
  );
}
