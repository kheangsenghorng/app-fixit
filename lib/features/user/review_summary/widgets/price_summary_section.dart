import 'package:flutter/material.dart';

class PriceSummaryCard extends StatelessWidget {
  final String totalPrice;
  final String? originalPrice;
  final String? couponText;

  const PriceSummaryCard({
    super.key,
    required this.totalPrice,
    this.originalPrice,
    this.couponText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _priceRow(theme, "Service Fee", totalPrice, false),
          const SizedBox(height: 12),
          _priceRow(theme, "Traveling Fee", "Free", true),

          if (couponText != null && originalPrice != null) ...[
            const SizedBox(height: 12),
            _priceRow(theme, "Original Price", originalPrice!, false),
            const SizedBox(height: 12),
            _priceRow(theme, "Coupon", couponText!, true),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(thickness: 1, height: 1),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (originalPrice != null)
                    Text(
                      originalPrice!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.outline,
                      ),
                    ),
                  Text(
                    totalPrice,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(ThemeData theme, String label, String price, bool highlight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.green : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}