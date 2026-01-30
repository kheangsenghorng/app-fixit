import 'package:flutter/material.dart';

class GeneralLoadingView extends StatelessWidget {
  final String? message;

  const GeneralLoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Using your Primary Blue from the theme
    final primaryBlue = theme.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Circular Progress Indicator with your Primary Blue
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
            strokeWidth: 3,
          ),

          if (message != null) ...[
            const SizedBox(height: 16),
            // 2. Text using your BodyMedium theme color (White60 for dark, Black54 for light)
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}