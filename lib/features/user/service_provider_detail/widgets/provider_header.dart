import 'package:flutter/material.dart';

class ProviderHeader extends StatelessWidget {
  final String imageUrl;

  const ProviderHeader({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        // 1. Stylized Background with Rounded Bottom
        Container(
          height: 340,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
        ),

        // 2. The Main Image with a subtle float effect
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Hero(
            tag: imageUrl,
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),

        // 3. Gradient Overlay for readability and depth
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  colorScheme.surface.withValues(alpha: 0.1),
                  colorScheme.surface.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
        ),

        // 4. Floating Badge (e.g., Experience or Top Rated)
        Positioned(
          bottom: 20,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  "4.9",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}