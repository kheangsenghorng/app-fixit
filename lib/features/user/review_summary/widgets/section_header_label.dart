import 'package:flutter/material.dart';

class SectionHeaderLabel extends StatelessWidget {
  final String text;

  const SectionHeaderLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.w900,
          color: theme.colorScheme.primary.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}