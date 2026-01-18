import 'package:flutter/material.dart';

class ContentSheetWrapper extends StatelessWidget {
  final Widget child;

  const ContentSheetWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(40),
          ),
          // Optional: Add a subtle shadow to make it pop from the background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}