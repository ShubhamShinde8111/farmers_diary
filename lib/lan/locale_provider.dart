import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('mr'), // Marathi added here
  ];

  Locale _locale = const Locale('en'); // Default locale

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale(); // Load saved locale on initialization
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code != null && _isSupported(code)) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale.languageCode)) return;

    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  bool _isSupported(String code) {
    return supportedLocales.any((locale) => locale.languageCode == code);
  }
}
