import 'package:fixit/features/user/profile/appearance/widgets/custom_radio_button.dar.dart';
import 'package:flutter/material.dart';

class AppIconOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Future<void> Function()? onTap; // ✅ CHANGE HERE
  final Color bgColor;
  final Color borderColor;
  final Color accentColor;
  final IconData icon;

  const AppIconOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.bgColor,
    required this.borderColor,
    required this.accentColor,
    required this.icon,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? accentColor : borderColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? accentColor : Colors.grey,
              ),
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
          CustomRadioButton(
            isSelected: isSelected,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}
