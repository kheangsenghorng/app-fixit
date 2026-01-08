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
    final Map<String, dynamic> providerData =
    (args is Map<String, dynamic>) ? args : {};

    final theme = Theme.of(context);

    final String name = providerData['name'] ?? "Emily Jani";
    final String category = providerData['category'] ?? "Plumber";
    final String imageUrl =
        providerData['image'] ?? 'assets/images/providers/img.png';
    final String rating = providerData['rating']?.toString() ?? "4.9";

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 360,
                backgroundColor: theme.colorScheme.surface,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: const [
                  ProviderAppBarActions(),
                ],
                flexibleSpace: ProviderFlexibleSpace(
                  title: name,
                  background: ProviderHeader(imageUrl: imageUrl),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProviderProfileInfo(
                        name: name,
                        category: category,
                      ),
                      const SizedBox(height: 25),
                      ProviderStatsCard(rating: rating),
                      const SizedBox(height: 30),
                      Text("About $name",
                          style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      Text(
                        "Highly professional service provider dedicated to quality results.",
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Gallery",
                              style: theme.textTheme.headlineMedium),
                          TextButton(
                            onPressed: () => showGallerySheet(context),
                            child: const Text("View all"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text("Recent Reviews",
                          style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      const ReviewItem(
                        user: "Josh Peter",
                        comment: "Highly recommended!",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          FloatingBookingButton(providerData: providerData),
        ],
      ),
    );
  }
}
