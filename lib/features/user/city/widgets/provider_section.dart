import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import 'provider_grid_card.dart';

class ProviderSection extends StatelessWidget {
  final String title;
  final List<ProviderModel> providers;

  const ProviderSection({
    super.key,
    required this.title,
    required this.providers,
  });

  @override
  Widget build(BuildContext context) {
    if (providers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: providers.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(right: 14),
              child: ProviderGridCard(provider: providers[index]),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
