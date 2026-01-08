import 'package:flutter/material.dart';

class ProviderAppBarActions extends StatelessWidget {
  const ProviderAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border, size: 20),
          color: theme.colorScheme.secondary,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
