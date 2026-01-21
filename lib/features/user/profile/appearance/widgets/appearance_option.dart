import 'package:fixit/features/user/profile/appearance/widgets/theme_mockup.dart';
import 'package:flutter/material.dart';
import 'custom_radio_button.dar.dart'; // Ensure this path is correct

class AppearanceOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;
  final Brightness? brightness;
  final bool isSystem;
  final int index; // For staggered delay

  const AppearanceOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
    this.brightness,
    this.isSystem = false,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          children: [
            // This is the widget that was causing the error
            ThemeMockup( // Using the new cut class
              brightness: brightness,
              accentColor: accentColor,
              isSystem: isSystem,
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
      ),
    );
  }
}