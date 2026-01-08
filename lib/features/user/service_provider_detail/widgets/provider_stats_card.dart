import 'package:flutter/material.dart';

class ProviderStatsCard extends StatelessWidget {
  final String rating;

  const ProviderStatsCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget stat(IconData icon, String val, String label, Color color) {
      return Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 5),
          Text(val, style: theme.textTheme.titleMedium),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          stat(Icons.star, rating, "Rating", Colors.amber),
          stat(Icons.rocket_launch, "120+", "Jobs", theme.colorScheme.primary),
          stat(Icons.verified, "5 yrs", "Exp.", theme.colorScheme.secondary),
        ],
      ),
    );
  }
}
