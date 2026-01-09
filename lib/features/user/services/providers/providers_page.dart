
import 'package:fixit/features/user/search/widgets/filter_sheet.dart';
import 'package:fixit/features/user/services/widgets/provider_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:fixit/widgets/main_bottom_nav.dart';


class ProvidersPage extends StatelessWidget {
  final String serviceName;
  final int? currentIndex;
  final Function(int)? onNavTap;

  const ProvidersPage({
    super.key,
    required this.serviceName,
    this.currentIndex,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. UPDATED DATA: Added imageUrl to each item
    final List<ProviderModel> providers = [
      ProviderModel(name: "Jackson", category: serviceName, rating: 4.9, bgColor: const Color(0xFFE8D5F5), imageUrl: "assets/images/providers/img.png"),
      ProviderModel(name: "Logan", category: serviceName, rating: 5.0, bgColor: const Color(0xFFE5D5C5), imageUrl: "assets/images/providers/img_1.png"),
      ProviderModel(name: "Ethan Lita", category: serviceName, rating: 4.4, bgColor: const Color(0xFFD5F5E3), imageUrl: "assets/images/providers/img_2.png"),
      ProviderModel(name: "Isabella Una", category: serviceName, rating: 4.3, bgColor: const Color(0xFFF5F1D5), imageUrl: "assets/images/providers/img_3.png"),
      ProviderModel(name: "Panama", category: serviceName, rating: 4.9, bgColor: const Color(0xFFD5D9F5), imageUrl: "assets/images/providers/img_4.png"),
      ProviderModel(name: "Jamalo", category: serviceName, rating: 4.7, bgColor: const Color(0xFFD5F5F0), imageUrl: "assets/images/providers/img_5.png"),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "$serviceName Providers",
          style: theme.textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: theme.iconTheme.color),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FilterSheet(),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemCount: providers.length,
        itemBuilder: (_, index) => ProviderGridCard(provider: providers[index]),
      ),
      bottomNavigationBar: (currentIndex != null && onNavTap != null)
          ? MainBottomNav(
        currentIndex: currentIndex!,
        onTap: (index) {
          onNavTap!(index);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      )
          : null,
    );
  }
}

// 3. UPDATED MODEL: Added imageUrl property
class ProviderModel {
  final String name;
  final String category;
  final double rating;
  final Color bgColor;
  final String? imageUrl; // Added this

  ProviderModel({
    required this.name,
    required this.category,
    required this.rating,
    required this.bgColor,
    this.imageUrl, // Added this
  });
}