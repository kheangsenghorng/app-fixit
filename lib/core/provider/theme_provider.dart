import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// This file will be generated automatically
part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // This is the initial state
    return ThemeMode.system;
  }

  // Equivalent to your setThemeMode method
  void setThemeMode(ThemeMode mode) {
    state = mode; // Simply updating 'state' notifies all listeners
  }

  // Equivalent to your toggleTheme method
  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}