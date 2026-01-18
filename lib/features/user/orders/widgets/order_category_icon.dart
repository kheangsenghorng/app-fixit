import 'package:flutter/material.dart';

class OrderCategoryIcon extends StatelessWidget {
  final IconData icon;
  final Color activeColor;

  const OrderCategoryIcon({
    super.key,
    required this.icon,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: activeColor, size: 24),
    );
  }
}