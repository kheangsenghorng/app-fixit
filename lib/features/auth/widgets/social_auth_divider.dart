import 'package:flutter/material.dart';

class SocialAuthDivider extends StatelessWidget {
  final bool isSignUp;

  const SocialAuthDivider({
    super.key,
    this.isSignUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isSignUp ? "Or sign up with" : "Or log in with",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1))),
        ],
      ),
    );
  }
}