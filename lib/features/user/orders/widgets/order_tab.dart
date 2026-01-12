import 'package:flutter/material.dart';

class OrderTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const OrderTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white : theme.colorScheme.primary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? theme.colorScheme.primary : Colors.white)
                  : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}