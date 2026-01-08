import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        const SizedBox(width: 8),
        Image.asset(
          'assets/logo/fixit_logo_small.png',
          height: 30,
          color: theme.brightness == Brightness.dark
              ? colorScheme.onSurface
              : null, // optional tint for dark mode
        ),
      ],
    );
  }
}
