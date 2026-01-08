import 'package:flutter/material.dart';

class ProviderProfileInfo extends StatelessWidget {
  final String name;
  final String category;
  // final String price; // Added price field

  const ProviderProfileInfo({
    super.key,
    required this.name,
    required this.category,
    // required this.price, // Added to constructor
  });

  String formatPrice(num price) => "\$${price.toStringAsFixed(0)}/H";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                name,
                style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 4),
            Text(
                category,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant
                )
            ),
            const SizedBox(height: 4),
            // Added Price Text
            Text(
              formatPrice(40),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.phone_outlined, color: theme.colorScheme.primary),
        ),
      ],
    );
  }
}