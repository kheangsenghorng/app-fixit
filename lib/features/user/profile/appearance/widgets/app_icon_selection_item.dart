import 'package:flutter/material.dart';
import 'app_icon_option.dart';

class AppIconSelectionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final String selectedIcon;
  final Color accentColor;
  final bool isChangingIcon;
  final Function(String) onIconChanged;

  const AppIconSelectionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.selectedIcon,
    required this.accentColor,
    required this.isChangingIcon,
    required this.onIconChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppIconOption(
      title: title,
      icon: icon,
      isSelected: selectedIcon == title,
      onTap: isChangingIcon ? null : () => onIconChanged(title),
      bgColor: bgColor,
      borderColor: borderColor,
      accentColor: accentColor,
    );
  }
}