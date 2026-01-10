import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  // Default to English or Khmer as you prefer
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners(); // This tells MaterialApp to rebuild
  }
}