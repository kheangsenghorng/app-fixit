import 'package:flutter/material.dart';


class PaymentTitleText extends StatelessWidget {
  final String title;
  final bool isSelected;

  const PaymentTitleText({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isSelected ? colorScheme.onSurface : Colors.grey.shade600,
        ),
      ),
    );
  }
}