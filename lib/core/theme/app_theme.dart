import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF00D9FF);
  static const Color accentPurple = Color(0xFF9D4EDD);
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color cardBackground = Color(0xFF1A1F3A);
  static const Color successGreen = Color(0xFF00FF88);
  static const Color errorRed = Color(0xFFFF3366);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentPurple,
        surface: cardBackground,
        error: errorRed,
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
