import 'package:flutter/material.dart';

class OrderPriceRow extends StatelessWidget {
  final String label;
  final String price;
  final bool isTotal;

  const OrderPriceRow({
    super.key,
    required this.label,
    required this.price,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),


          Text(
            price,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}