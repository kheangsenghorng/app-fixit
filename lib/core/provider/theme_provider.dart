import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // 1. Change the variable to ThemeMode (instead of bool)
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // 2. Add this specific method that was missing
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // This triggers the UI to update
  }

  // Optional: Keep this if you still use a simple toggle elsewhere
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}