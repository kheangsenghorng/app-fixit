import 'package:flutter/material.dart';
import 'appearance_option.dart';

class ThemeSelectionItem extends StatelessWidget {
  final String title;
  final ThemeMode mode;
  final Brightness? brightness;
  final bool isSystem;
  final ThemeMode currentThemeMode;
  final Color accentColor;
  final Function(ThemeMode) onThemeChanged;
  final int index; // Added to class fields

  const ThemeSelectionItem({
    super.key,
    required this.title,
    required this.mode,
    this.brightness,
    this.isSystem = false,
    required this.currentThemeMode,
    required this.accentColor,
    required this.onThemeChanged,
    required this.index, // Correctly initialized
  });

  @override
  Widget build(BuildContext context) {
    // Determine if this specific item is the active one
    final bool isSelected = currentThemeMode == mode;

    return AppearanceOption(
      index: index,
      title: title,
      isSelected: isSelected,
      accentColor: accentColor,
      brightness: brightness,
      isSystem: isSystem,
      onTap: () async {
        // 1. If already selected, don't trigger again
        if (isSelected) return;

        // 2. Interaction Delay
        // Gives time for the ripple effect and radio button to animate
        await Future.delayed(const Duration(milliseconds: 300));

        // 3. Trigger the theme change callback
        onThemeChanged(mode);
      },
    );
  }
}