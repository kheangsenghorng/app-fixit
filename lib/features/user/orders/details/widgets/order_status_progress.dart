import 'package:flutter/material.dart';

class OrderStatusProgress extends StatelessWidget {
  final double progress;
  final Color? color;

  const OrderStatusProgress({
    super.key,
    required this.progress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: colorScheme.surfaceContainerHighest,
        color: color ?? colorScheme.primary,
        minHeight: 6,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}