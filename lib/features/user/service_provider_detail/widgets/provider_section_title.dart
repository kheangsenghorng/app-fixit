import 'package:flutter/material.dart';


class ProviderSectionTitle extends StatelessWidget {
  final String title;

  const ProviderSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    );
  }
}