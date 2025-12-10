import 'package:flutter/material.dart';

class AppTheme {
  static const Color neonGreen = Color(0xFFC1FF00);
  static const Color darkGreen = Color(0xFF2C3E14);
  static const Color blackBg = Color(0xFF0D0D0D);

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: neonGreen,
      scaffoldBackgroundColor: blackBg,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonGreen,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}