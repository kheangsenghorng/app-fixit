import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fixit/features/user/search/search_result_screen.dart';
import '../../search/filled_search/filled_search_page.dart';
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

  void _openFilledSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilledSearchPage(

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final glassColor = isDark
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            buildBlueCard(),

            Positioned(
              bottom: -28,
              left: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _openFilledSearchPage(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: glassColor,
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: IgnorePointer(
                        child: buildSearchBar(
                          context: context,
                          controller: controller,
                          focusNode: focusNode,
                          isSearching: isSearching,
                          onSearchTap: onSearchTap,
                          onClear: onClear,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isSearching && controller.text.isNotEmpty) ...[
          const SizedBox(height: 50),
          _SearchSuggestionsOverlay(
            results: filteredResults,
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

  const _SearchSuggestionsOverlay({
    required this.results,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.01)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Searches",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: contentColor,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
                GestureDetector(
                  onTap: onClearAll,
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text("No results found"),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    Icons.history_rounded,
                    color: contentColor.withValues(alpha: 0.3),
                    size: 20,
                  ),
                  title: Text(
                    item['title'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: contentColor,
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SearchResultScreen(query: item['title']!),
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