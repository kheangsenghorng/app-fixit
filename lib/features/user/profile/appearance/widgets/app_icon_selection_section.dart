import 'package:flutter/material.dart';
import 'app_icon_options_row.dart';
import 'section_header.dart';
import 'appearance_card.dart';

class AppIconSelectionSection extends StatelessWidget {
  final String selectedIcon;
  final Color accentColor;
  final bool isChangingIcon;
  final Function(String) onIconChanged;

  const AppIconSelectionSection({
    super.key,
    required this.selectedIcon,
    required this.accentColor,
    required this.isChangingIcon,
    required this.onIconChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "APP ICON"),
        AppearanceCard(
          child: AppIconOptionsRow(
            selectedIcon: selectedIcon,
            accentColor: accentColor,
            isChangingIcon: isChangingIcon,
            onIconChanged: onIconChanged,
          ),
        ),
      ],
    );
  }
}