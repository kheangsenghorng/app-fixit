import 'package:fixit/features/user/search/search_result_screen.dart';
import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback onSearchTap;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSearching;
  final VoidCallback onClear;
  final int currentIndex;
  final Function(int)? onNavTap;


  final List<Map<String, String>> filteredResults;

  const PromoBanner({
    super.key,
    required this.onSearchTap,
    required this.controller,
    required this.focusNode,
    required this.isSearching,
    required this.onClear,
    required this.filteredResults,
    required this.currentIndex,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none, // Allows the woman's head to pop out of the top
          alignment: Alignment.bottomCenter,
          children: [
            // 1. 🔵 BLUE PROMO CARD (Helper method below)
            _buildBlueCard(),

            // 2. 🔍 FLOATING SEARCH BAR
            Positioned(
              bottom: -28, // Hangs halfway off the bottom of the blue card
              left: 0,
              right: 0,
              child: _buildSearchBar(context),
            ),
          ],
        ),

        // 3. 🔽 SEARCH SUGGESTIONS (Shows only when searching)
        if (isSearching && controller.text.isNotEmpty) ...[
          const SizedBox(height: 40),
          _SearchSuggestionsOverlay(
            results: filteredResults,
            currentIndex: currentIndex,
            onNavTap: onNavTap,
            onClearAll: () {
              controller.clear();
              onClear();
            },
          ),
        ],
      ],
    );
  }

  // Helper: Builds the Blue Card with the woman popping out
  Widget _buildBlueCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // The Background Box
        Container(
          height: 160,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF004AAD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Get 30% off",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Just by Booking Home\nServices",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // The Woman Image (Popping out of the top)
        Positioned(
          top: -35, // Moves head above the blue box
          right: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/providers/img_12.png',
            fit: BoxFit.contain,
            alignment: Alignment.bottomRight,
            height: 200, // Slightly taller than the blue card
          ),
        ),
      ],
    );
  }

  // Helper: Builds the Search Bar UI
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onTap: onSearchTap,
        readOnly: !isSearching,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: "Search here..",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search_rounded, color: Colors.grey.shade700, size: 28),
          ),
          suffixIcon: isSearching
              ? _buildClearButton()
              : Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.tune_rounded, color: Colors.grey.shade700),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: onClear,
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color(0xFFE8F0FE),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, size: 16, color: Color(0xFF004AAD)),
      ),
    );
  }
}

class _SearchSuggestionsOverlay extends StatelessWidget {
  final List<Map<String, String>> results;
  final VoidCallback onClearAll;
  final int currentIndex;
  final Function(int)? onNavTap;

  const _SearchSuggestionsOverlay({
    required this.results,
    required this.onClearAll,
    required this.currentIndex,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Searches",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.grey.shade800,
                  ),
                ),
                GestureDetector(
                  onTap: onClearAll,
                  child: const Text(
                    "Clear",
                    style: TextStyle(
                      color: Color(0xFF004AAD),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("No results found"),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final item = results[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    item['title'] ?? '',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: Text(
                    item['results'] ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    onClearAll();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultScreen(
                          query: item['title']!,
                        ),
                      ),
                    );

                  },
                );
              },
            ),
        ],
      ),
    );
  }
}