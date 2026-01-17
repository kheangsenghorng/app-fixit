import 'package:flutter/material.dart';
import 'promo_banner.dart';
import 'section_header.dart';

class HomePromoSection extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool isSearching;
  final List<Map<String, String>> filteredResults;
  final int currentIndex;
  final VoidCallback onSearchTap;
  final VoidCallback onClear;
  final VoidCallback onPopularServicesTap;
  final Function(int)? onNavTap;

  const HomePromoSection({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.isSearching,
    required this.filteredResults,
    required this.currentIndex,
    required this.onSearchTap,
    required this.onClear,
    required this.onPopularServicesTap,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 25),
          // Your extracted Banner & Search logic
          PromoBanner(
            controller: searchController,
            focusNode: searchFocusNode,
            isSearching: isSearching,
            onSearchTap: onSearchTap,
            onClear: onClear,
            filteredResults: filteredResults,
            currentIndex: currentIndex,
            onNavTap: onNavTap,
          ),

          const SizedBox(height: 40),
          // Section Title
          SectionHeader(
            title: "Popular Services",
            onTap: onPopularServicesTap,
          ),
        ],
      ),
    );
  }
}