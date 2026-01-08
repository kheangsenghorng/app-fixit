import 'package:flutter/material.dart';

class ProviderFlexibleSpace extends StatelessWidget {
  final String title;
  final Widget background;

  const ProviderFlexibleSpace({
    super.key,
    required this.title,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final top = constraints.biggest.height;

        return FlexibleSpaceBar(
          centerTitle: true,
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: top < 120 ? 1.0 : 0.0,
            child: Text(
              title,
              style: theme.textTheme.headlineMedium,
            ),
          ),
          background: background,
        );
      },
    );
  }
}
