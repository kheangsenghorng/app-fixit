import 'package:fixit/features/user/search/search_result_screen.dart';
import 'package:flutter/material.dart';

import 'build_blue_card.dart';
import 'build_search_bar.dart';

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
            // Helper: Builds the Blue Card with the woman popping out
            buildBlueCard(),

            // 2. 🔍 FLOATING SEARCH BAR
            Positioned(
              bottom: -28,
              left: 0,
              right: 0,
              child: buildSearchBar(
                controller: controller,
                focusNode: focusNode,
                isSearching: isSearching,
                onSearchTap: onSearchTap,
              ),
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