import 'package:flutter/material.dart';

class ProviderFlexibleSpace extends StatelessWidget {
  final String title;
  final Widget background;
  final List<StretchMode> stretchModes;

  const ProviderFlexibleSpace({
    super.key,
    required this.title,
    required this.background,
    this.stretchModes = const [StretchMode.zoomBackground],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate collapse progress
        final double top = constraints.biggest.height;
        final double statusBarHeight = MediaQuery.of(context).padding.top;
        // fullyCollapsed reached when height is around kToolbarHeight + status bar
        final bool isCollapsed = top <= (statusBarHeight + kToolbarHeight + 20);

        return FlexibleSpaceBar(
          centerTitle: true,
          stretchModes: stretchModes,
          titlePadding: const EdgeInsets.only(bottom: 16),
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            opacity: isCollapsed ? 1.0 : 0.0,
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ),
          background: background,
        );
      },
    );
  }
}