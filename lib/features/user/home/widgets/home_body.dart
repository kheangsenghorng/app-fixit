import 'package:flutter/material.dart';
// Import your local widgets
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
  final VoidCallback onPopularServicesTap;
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
    required this.onPopularServicesTap,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Space for the sticky app bar (Dynamic height)
            SizedBox(height: MediaQuery.of(context).padding.top + 70),

            // 1. Promo & Search Area
            HomePromoSection(
              searchController: searchController,
              searchFocusNode: searchFocusNode,
              isSearching: isSearching,
              filteredResults: filteredResults,
              currentIndex: currentIndex,
              onSearchTap: onSearchTap,
              onClear: onClear,
              onPopularServicesTap: onPopularServicesTap,
              onNavTap: onNavTap,
            ),

            const SizedBox(height: 15),
            // We previously extracted this to HomeCategoryList

            HomeCategoryList(currentIndex: currentIndex),

           // 4. Service Providers Section
            HomeProviderSection(
              onSeeAllTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}