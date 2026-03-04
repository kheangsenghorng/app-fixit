import 'package:flutter/material.dart';

class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;
    final Color secondaryTextColor = isDark ? Colors.grey.shade500 : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "Create your account",
        style: theme.textTheme.titleMedium?.copyWith(
          color: secondaryTextColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}