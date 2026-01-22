import 'package:flutter/material.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_profile_info.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_stats_card.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_section_title.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/review_item.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/show_gallery_sheet.dart';

class ProviderDetailContentView extends StatelessWidget {
  final String name;
  final String category;
  final String rating;

  const ProviderDetailContentView({
    super.key,
    required this.name,
    required this.category,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profile Basic Info
            ProviderProfileInfo(name: name, category: category),
            const SizedBox(height: 32),

            // 2. Statistics (Rating, Jobs, etc.)
            ProviderStatsCard(rating: rating),
            const SizedBox(height: 32),

            // 3. About Section
            ProviderSectionTitle(title: "About $name"),
            const SizedBox(height: 12),
            Text(
              "Experienced $category with a focus on high-efficiency results. Known for prompt response times and meticulous attention to detail.",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // 4. Work Gallery Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ProviderSectionTitle(title: "Work Gallery"),
                TextButton(
                  onPressed: () => showGallerySheet(context),
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 5. Reviews Section
            const ProviderSectionTitle(title: "Recent Reviews"),
            const SizedBox(height: 16),
            const ReviewItem(
              user: "Josh Peter",
              comment:
              "Exceptional quality. Arrived exactly on time and fixed the leak in minutes. Highly recommended!",
            ),
          ],
        ),
      ),
    );
  }
}