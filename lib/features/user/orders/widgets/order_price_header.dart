import 'package:flutter/material.dart';

class OrderPriceHeader extends StatelessWidget {
  final String amount;
  final String? statusLabel;
  final Color? statusColor;
  final Color activeColor;
  final bool isDark;

  const OrderPriceHeader({
    super.key,
    required this.amount,
    required this.activeColor,
    required this.isDark,
    this.statusLabel,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "\$$amount",
          style: TextStyle(
            color: isDark ? Colors.white : activeColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (statusLabel != null) ...[
          const SizedBox(height: 4),
          _StatusBadge( // This is the badge we refactored earlier
            label: statusLabel!,
            color: statusColor ?? Colors.grey,
          ),
        ],
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        // Adds 20% opacity to the background for that modern "chip" look
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}