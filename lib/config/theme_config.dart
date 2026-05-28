import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color electricBlue = Color(0xFF3B82F6);
  static const Color backgroundDark = Color(0xFF0A0E1A);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color muted = Color(0xFF1E293B);
  static const Color border = Color(0xFF1E3048);
  static const Color destructive = Color(0xFFEF4444);
  static const Color accent = Color(0xFF14B8A6);

  static String getFontFamily(String lang) {
    return 'Orbitron';
  }

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: 'Orbitron',
    fontFamilyFallback: const ['NotoSansSC'],
    colorScheme: const ColorScheme.dark(
      primary: neonCyan,
      secondary: electricBlue,
      surface: surfaceDark,
      background: backgroundDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Orbitron',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: neonCyan,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Orbitron',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Orbitron',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: neonCyan,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: neonCyan,
        foregroundColor: backgroundDark,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: neonCyan, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white38),
      hintStyle: const TextStyle(color: Colors.white24),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.white10),
      ),
      elevation: 10,
    ),
  );
}
