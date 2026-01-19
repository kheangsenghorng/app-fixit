import 'package:flutter/material.dart';
import 'package:fixit/routes/app_routes.dart';

import '../providers/providers_page.dart';

class ProviderGridCard extends StatelessWidget {
  final ProviderModel provider;

  const ProviderGridCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // IMAGE
          Padding(
            padding: const EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Container(
                decoration: BoxDecoration(
                  color: provider.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildImage(),
                ),
              ),
            ),
          ),

          // NAME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              provider.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // CATEGORY
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              provider.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),

          // RATING + DETAILS BUTTON
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      provider.rating.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                // DETAILS BUTTON
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.providerDetail,
                      arguments: {
                        'name': provider.name,
                        'category': provider.category,
                        'image': provider.imageUrl,
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Details',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // IMAGE BUILDER
  Widget _buildImage() {
    if (provider.imageUrl == null || provider.imageUrl!.isEmpty) {
      return const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.white70,
        ),
      );
    }

    return Image.asset(
      provider.imageUrl!,
      fit: BoxFit.contain,
      alignment: Alignment.bottomCenter,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.white70,
        ),
      ),
    );
  }
}
