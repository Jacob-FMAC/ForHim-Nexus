import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LocaleProvider with ChangeNotifier {
  final StorageService _storage = StorageService();

  Locale _locale = const Locale('zh'); // Default to Chinese

  Locale get locale => _locale;

  Future<void> initialize() async {
    final savedLanguage = await _storage.getLanguage();
    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      _locale = Locale(savedLanguage);
    } else {
      _locale = const Locale('zh');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _storage.saveLanguage(locale.languageCode);
    notifyListeners();
  }

  bool get isChinese => _locale.languageCode == 'zh';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('zh'), // Chinese
    Locale('en'), // English
  ];

  static const Map<String, String> languageNames = {
    'zh': '中文',
    'en': 'English',
  };
}
