import 'package:fixit/features/user/profile/appearance/widgets/theme_selection_section.dart';
import 'package:flutter/material.dart';
import 'app_icon_selection_section.dart';
// Your previous cut

class AppearanceBodyView extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final String selectedIcon;
  final Color accentColor;
  final bool isChangingIcon;
  final Function(ThemeMode) onThemeChanged;
  final Function(String) onIconChanged;

  const AppearanceBodyView({
    super.key,
    required this.currentThemeMode,
    required this.selectedIcon,
    required this.accentColor,
    required this.isChangingIcon,
    required this.onThemeChanged,
    required this.onIconChanged,
  });

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SECTION 1: THEME ---
          ThemeSelectionSection(
            currentThemeMode: currentThemeMode,
            accentColor: accentColor,
            onThemeChanged: onThemeChanged,
          ),
          const SizedBox(height: 30),
          // --- SECTION 2: APP ICON ---
          // Icon selection logic encapsulated
          AppIconSelectionSection(
            selectedIcon: selectedIcon,
            accentColor: accentColor,
            isChangingIcon: isChangingIcon,
            onIconChanged: onIconChanged,
          ),
        ],
      ),
    );
  }
}