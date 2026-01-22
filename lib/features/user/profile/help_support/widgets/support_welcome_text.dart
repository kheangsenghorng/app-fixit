import 'package:flutter/material.dart';

class SupportWelcomeText extends StatelessWidget {
  final String text;

  const SupportWelcomeText({
    super.key,
    this.text = 'Hello, how can we assist you?',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}
