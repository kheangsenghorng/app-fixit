import 'package:flutter/material.dart';

class ProviderHeader extends StatelessWidget {
  final String imageUrl;

  const ProviderHeader({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.contain,
            height: 300,
          ),
        ),
      ),
    );
  }
}
