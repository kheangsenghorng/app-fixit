import 'package:fixit/features/user/profile/appearance/widgets/theme_options_row.dart';
import 'package:flutter/material.dart';
import 'section_header.dart';
import 'appearance_card.dart';

class ThemeSelectionSection extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Color accentColor;
  final Function(ThemeMode) onThemeChanged;

  const ThemeSelectionSection({
    super.key,
    required this.currentThemeMode,
    required this.accentColor,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "THEME SELECTION"),
        AppearanceCard(
          child: ThemeOptionsRow(
            currentThemeMode: currentThemeMode,
            accentColor: accentColor,
            onThemeChanged: onThemeChanged,
          ),
        ),
      ],
    );
  }
}