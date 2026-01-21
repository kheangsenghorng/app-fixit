import 'package:flutter/material.dart';

class GlowyCheckmark extends StatelessWidget {
  final bool isSelected;

  const GlowyCheckmark({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: Icon(
        Icons.check_circle,
        size: 22,
        color: isSelected
            ? colorScheme.primary
            : Colors.grey.shade200,
      ),
    );
  }
}