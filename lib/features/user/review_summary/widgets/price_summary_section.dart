import 'package:flutter/material.dart';

class PriceSummaryCard extends StatelessWidget {
  final String totalPrice;
  const PriceSummaryCard({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Price Summary", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _priceRow(theme, "Service Fee", "\$$totalPrice/H"),
        _priceRow(theme, "Traveling Fee", "Free", isFree: true),
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text("\$$totalPrice", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
          ],
        ),
      ],
    );
  }

  Widget _priceRow(ThemeData theme, String label, String price, {bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: theme.colorScheme.outline)),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold, color: isFree ? Colors.green : null)),
        ],
      ),
    );
  }
}