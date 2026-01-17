import 'package:fixit/features/user/city/widgets/provider_grid_card.dart';
import 'package:flutter/material.dart';


class ProviderSection extends StatelessWidget {
  final String title;
  final String category;

  const ProviderSection({
    super.key,
    required this.title,
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                    "View all",
                    style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300, // Fixed height for horizontal cards
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 4, // Replace with your list length
            itemBuilder: (context, index) => const ProviderGridCarder(),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
