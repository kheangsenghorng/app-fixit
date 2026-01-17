import 'package:fixit/features/user/service_provider_detail/widgets/floating_booking_button.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_appbar_actions.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_flexible_space.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_header.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_profile_info.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_stats_card.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/review_item.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/show_gallery_sheet.dart';
import 'package:flutter/material.dart';


class ProviderDetailScreen extends StatelessWidget {
  const ProviderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> providerData = (args is Map<String, dynamic>) ? args : {};

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String name = providerData['name'] ?? "Emily Jani";
    final String category = providerData['category'] ?? "Plumber";
    final String imageUrl = providerData['image'] ?? 'assets/images/providers/img.png';
    final String rating = providerData['rating']?.toString() ?? "4.9";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                expandedHeight: 380,
                backgroundColor: colorScheme.surface,
                elevation: 0,
                // Soft gradient reveal when collapsed
                surfaceTintColor: colorScheme.surface,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ProviderAppBarActions(), // Ensure these use the circular bg style
                  ),
                ],
                // flexibleSpace: FlexibleSpaceBar(
                //   stretchModes: const [StretchMode.zoomBackground],
                //   background: ProviderHeader(imageUrl: imageUrl),
                // ),
                flexibleSpace: ProviderFlexibleSpace(
                  title: name,
                  stretchModes: const [StretchMode.zoomBackground],
                  background: ProviderHeader(imageUrl: imageUrl),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  // Use a negative margin to pull content over the rounded header
                  margin: const EdgeInsets.only(top: 0),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProviderProfileInfo(name: name, category: category),
                      const SizedBox(height: 32),

                      ProviderStatsCard(rating: rating),
                      const SizedBox(height: 32),

                      _buildSectionTitle(theme, "About $name"),
                      const SizedBox(height: 12),
                      Text(
                        "Experienced $category with a focus on high-efficiency results. Known for prompt response times and meticulous attention to detail.",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle(theme, "Work Gallery"),
                          TextButton(
                            onPressed: () => showGallerySheet(context),
                            child: Text("See All", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      _buildSectionTitle(theme, "Recent Reviews"),
                      const SizedBox(height: 16),
                      const ReviewItem(
                        user: "Josh Peter",
                        comment: "Exceptional quality. Arrived exactly on time and fixed the leak in minutes. Highly recommended!",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Footer
          Positioned(
            bottom: 24, // Padding from bottom
            left: 24,   // Padding from left
            right: 24,  // Padding from right
            child: FloatingBookingButton(providerData: providerData),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    );
  }
}
