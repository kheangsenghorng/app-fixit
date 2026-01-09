import 'package:fixit/features/user/profile/appearance/widgets/custom_radio_button.dar.dart';
import 'package:flutter/material.dart';


class AppIconOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color bgColor;
  final Color borderColor;
  final Color accentColor;

  const AppIconOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.bgColor,
    required this.borderColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.token_outlined, color: Colors.grey, size: 28),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          CustomRadioButton(isSelected: isSelected, accentColor: accentColor),
        ],
      ),
    );
  }
}