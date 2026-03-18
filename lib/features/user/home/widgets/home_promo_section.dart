import 'package:flutter/material.dart';
import 'promo_banner.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // PROMO BANNER & GLASS SEARCH
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

          const SizedBox(height: 55),

          // SECTION HEADER (MONOCHROME & W900)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category Services",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900, // Matches Profile Name
                  color: contentColor,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: onPopularServicesTap,
                child: const Text(
                  "View all",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}