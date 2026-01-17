import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo/fixit_logo_small.png',
          width: 32,
          height: 32,
          color: theme.colorScheme.primary,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.build_circle, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Text(
          "FIXIT",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}