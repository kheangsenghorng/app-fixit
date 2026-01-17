import 'package:flutter/material.dart';

class ProviderStatsCard extends StatelessWidget {
  final String rating;
  const ProviderStatsCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, Icons.star_rounded, rating, "Rating"),
          _buildDivider(colorScheme),
          _buildStatItem(context, Icons.work_history_rounded, "120+", "Jobs"),
          _buildDivider(colorScheme),
          _buildStatItem(context, Icons.verified_user_rounded, "5yr", "Exp"),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(height: 30, width: 1, color: colorScheme.outlineVariant);
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
