import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:fixit/features/user/home/widgets/category_card.dart';
import 'package:fixit/features/user/home/widgets/promo_banner.dart';
import 'package:fixit/features/user/home/widgets/provider_card.dart';
import 'package:fixit/features/user/home/widgets/section_header.dart';
import 'package:fixit/features/user/services/providers/providers_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onPopularServicesTap;

  const HomeScreen({
    super.key,
    required this.onSearchTap,
    required this.onPopularServicesTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 1. MAIN SCROLLABLE CONTENT
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Spacer for the blurred AppBar height
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
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. BLURRED STICKY APP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildBlurredAppBar(context),
          ),

        ],
      ),
    );
  }

  // --- NEW STYLED BLURRED APP BAR ---
  Widget _buildBlurredAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          // --- ADDED COLOR HERE ---
          // .withOpacity(0.7) or (0.8) usually looks best for glass effect
          color: theme.colorScheme.surface.withValues(alpha: 0.7),

          padding: EdgeInsets.only(top: topPadding, left: 20, right: 10, bottom: 10),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo or Brand
                Row(
                  children: [
                    Image.asset(
                      'assets/logo/fixit_logo_small.png',
                      width: 32,
                      height: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "FIXIT",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none_rounded, color: theme.colorScheme.onSurface),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.phone_outlined, color: theme.colorScheme.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProvidersPage(serviceName: title)),
        ),
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

  static Widget _providerItem(String name, String job) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        width: 180,
        child: ProviderCard(name: name, job: job),
      ),
    );
  }
}