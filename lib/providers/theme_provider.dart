import 'package:flutter/material.dart';
import '../config/theme_config.dart';
import '../services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final StorageService _storage = StorageService();

  AppThemeMode _themeMode = AppThemeMode.defaultTheme;
  Color _customPrimaryColor = const Color(0xFF0066CC);
  Color _customAccentColor = const Color(0xFF00D9FF);
  Color _customBackgroundColor = Colors.white;
  bool _customIsDark = false;

  AppThemeMode get themeMode => _themeMode;
  ThemeData get themeData {
    switch (_themeMode) {
      case AppThemeMode.defaultTheme:
        return ThemeConfig.defaultTheme;
      case AppThemeMode.dark:
        return ThemeConfig.darkTheme;
      case AppThemeMode.light:
        return ThemeConfig.lightTheme;
      case AppThemeMode.custom:
        return ThemeConfig.customTheme(
          primaryColor: _customPrimaryColor,
          accentColor: _customAccentColor,
          backgroundColor: _customBackgroundColor,
          isDark: _customIsDark,
        );
    }
  }

  Color get customPrimaryColor => _customPrimaryColor;
  Color get customAccentColor => _customAccentColor;
  Color get customBackgroundColor => _customBackgroundColor;
  bool get customIsDark => _customIsDark;

  Future<void> initialize() async {
    final savedTheme = await _storage.getThemeMode();
    if (savedTheme != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => AppThemeMode.defaultTheme,
      );
    }

    if (_themeMode == AppThemeMode.custom) {
      final customTheme = await _storage.getCustomTheme();
      if (customTheme != null) {
        _customPrimaryColor = Color(int.parse(customTheme['primaryColor']!));
        _customAccentColor = Color(int.parse(customTheme['accentColor']!));
        _customBackgroundColor = Color(
          int.parse(customTheme['backgroundColor']!),
        );
        _customIsDark = customTheme['isDark'] == 'true';
      }
    }
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _storage.saveThemeMode(mode.toString());
    notifyListeners();
  }

  Future<void> setCustomTheme({
    required Color primaryColor,
    required Color accentColor,
    required Color backgroundColor,
    required bool isDark,
  }) async {
    _customPrimaryColor = primaryColor;
    _customAccentColor = accentColor;
    _customBackgroundColor = backgroundColor;
    _customIsDark = isDark;
    _themeMode = AppThemeMode.custom;

    await _storage.saveCustomTheme({
      'primaryColor': primaryColor.value.toString(),
      'accentColor': accentColor.value.toString(),
      'backgroundColor': backgroundColor.value.toString(),
      'isDark': isDark.toString(),
    });
    await _storage.saveThemeMode(AppThemeMode.custom.toString());
    notifyListeners();
  }
}
