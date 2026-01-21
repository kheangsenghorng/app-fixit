import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final double leftPadding;

  const SectionHeader({
    super.key,
    required this.title,
    this.leftPadding = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: 12, top: 16),
      child: Text(
        title.toUpperCase(), // Common style for section headers
        style: theme.textTheme.labelSmall?.copyWith(
          // Use onSurface with opacity for a subtle, secondary feel
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1, // Makes small bold text easier to read
        ),
      ),
    );
  }
}