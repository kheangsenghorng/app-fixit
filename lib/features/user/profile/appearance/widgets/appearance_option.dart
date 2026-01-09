import 'package:fixit/features/user/profile/appearance/widgets/custom_radio_button.dar.dart';
import 'package:flutter/material.dart';


class AppearanceOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;
  final Brightness? brightness;
  final bool isSystem;

  const AppearanceOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
    this.brightness,
    this.isSystem = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          _PhoneMockup(brightness: brightness, accentColor: accentColor, isSystem: isSystem),
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

class _PhoneMockup extends StatelessWidget {
  final Brightness? brightness;
  final Color accentColor;
  final bool isSystem;

  const _PhoneMockup({this.brightness, required this.accentColor, this.isSystem = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 50,
      decoration: BoxDecoration(
        color: isSystem ? Colors.grey[300] : (brightness == Brightness.dark ? Colors.black : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
      child: Stack(
        children: [
          if (isSystem)
            Row(
              children: [
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: Colors.black)),
              ],
            ),
          Center(child: Icon(Icons.apps, size: 18, color: accentColor)),
        ],
      ),
    );
  }
}