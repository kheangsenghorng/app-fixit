import 'package:flutter/material.dart';

class OrderStatusProgress extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0

  const OrderStatusProgress({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: colorScheme.surfaceContainerHighest,
        color: colorScheme.primary,
        minHeight: 6,
        // Optional: Add rounded corners to the bar
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}