import 'package:fixit/features/user/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
// Import your other widgets
import 'widgets/category_card.dart';
import 'widgets/promo_banner.dart';
import 'widgets/provider_card.dart';
import 'widgets/section_header.dart';
 // NEW IMPORT
import '../services/providers/providers_page.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onPopularServicesTap;
  final int currentIndex;

  const HomeScreen({
    super.key,
    required this.onSearchTap,
    required this.onPopularServicesTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 1. MAIN CONTENT
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Space for the sticky app bar
                  SizedBox(height: MediaQuery.of(context).padding.top + 70),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        PromoBanner(onSearchTap: onSearchTap),
                        const SizedBox(height: 40),
                        SectionHeader(
                          title: "Popular Services",
                          onTap: onPopularServicesTap,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  _buildCategoryList(context),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        SectionHeader(title: "Service Providers", onTap: () {}),
                        const SizedBox(height: 15),
                        _buildProviderList(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. EXTRACTED BLURRED APP BAR
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeAppBar(),
          ),
        ],
      ),
    );
  }

  // ... (Keep your _buildCategoryList and _buildProviderList methods below)
  Widget _buildCategoryList(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _categoryItem(context, "Plumbing", Icons.plumbing),
          _categoryItem(context, "Electric", Icons.electric_bolt),
          _categoryItem(context, "Solar", Icons.wb_sunny_outlined),
          _categoryItem(context, "Cleaning", Icons.cleaning_services),
        ],
      ),
    );
  }

  Widget _categoryItem(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: CategoryCard(
        title: title,
        icon: icon,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProvidersPage(
                serviceName: title,
                currentIndex: currentIndex,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProviderList() {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _providerItem("Maskot Kota", "Plumber"),
          _providerItem("Shams Jan", "Electrician"),
          _providerItem("John Doe", "Carpenter"),
        ],
      ),
    );
  }

  Widget _providerItem(String name, String job) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        width: 180,
        child: ProviderCard(name: name, job: job),
      ),
    );
  }
}