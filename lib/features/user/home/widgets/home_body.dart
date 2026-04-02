import 'package:flutter/material.dart';
import 'home_category_list.dart';
import 'home_promo_section.dart';
import 'home_provider_section.dart';

class HomeBody extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool isSearching;
  final List<Map<String, String>> filteredResults;
  final int currentIndex;
  final VoidCallback onSearchTap;
  final VoidCallback onClear;
  final Function(int)? onNavTap;

  const HomeBody({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.isSearching,
    required this.filteredResults,
    required this.currentIndex,
    required this.onSearchTap,
    required this.onClear,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Premium Feel
        child: Column(
          children: [
            // 1. SPACE FOR FLOATING HEADER (120px is ideal)
            const SizedBox(height: 125),

            // 2. PROMO & SEARCH AREA
            HomePromoSection(
              searchController: searchController,
              searchFocusNode: searchFocusNode,
              isSearching: isSearching,
              filteredResults: filteredResults,
              currentIndex: currentIndex,
              onSearchTap: onSearchTap,
              onClear: onClear,
              onPopularServicesTap: () => onNavTap?.call(1),
              onNavTap: onNavTap,
            ),

            const SizedBox(height: 30),

            // 3. CATEGORIES
            HomeCategoryList(currentIndex: currentIndex),

            const SizedBox(height: 15),

            // 4. SERVICE PROVIDERS
            HomeProviderSection(
              onSeeAllTap: () {},
            ),
            
            // 5. BOTTOM NAV SPACE
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}