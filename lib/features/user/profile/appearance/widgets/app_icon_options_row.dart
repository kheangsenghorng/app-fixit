import 'package:flutter/material.dart';
import 'app_icon_selection_item.dart';

class AppIconOptionsRow extends StatelessWidget {
  final String selectedIcon;
  final Color accentColor;
  final bool isChangingIcon;
  final Function(String) onIconChanged;

  const AppIconOptionsRow({
    super.key,
    required this.selectedIcon,
    required this.accentColor,
    required this.isChangingIcon,
    required this.onIconChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AppIconSelectionItem(
          title: 'Modern',
          icon: Icons.design_services,
          bgColor: Colors.white,
          borderColor: Colors.grey,
          selectedIcon: selectedIcon,
          accentColor: accentColor,
          isChangingIcon: isChangingIcon,
          onIconChanged: onIconChanged,
        ),
        AppIconSelectionItem(
          title: "Classic",
          icon: Icons.build,
          bgColor: theme.colorScheme.secondary,
          borderColor: theme.colorScheme.secondary,
          selectedIcon: selectedIcon,
          accentColor: accentColor,
          isChangingIcon: isChangingIcon,
          onIconChanged: onIconChanged,
        ),
        AppIconSelectionItem(
          title: "Lifestyle",
          icon: Icons.favorite,
          bgColor: const Color(0xFF121212),
          borderColor: Colors.black,
          selectedIcon: selectedIcon,
          accentColor: accentColor,
          isChangingIcon: isChangingIcon,
          onIconChanged: onIconChanged,
        ),
      ],
    );
  }
}