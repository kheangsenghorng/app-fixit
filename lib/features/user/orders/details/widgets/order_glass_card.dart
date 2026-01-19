import 'package:flutter/material.dart';

class OrderGlassCard extends StatelessWidget {
  final Widget child;
  final double margin;
  final double padding;

  const OrderGlassCard({
    super.key,
    required this.child,
    this.margin = 20.0,
    this.padding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}