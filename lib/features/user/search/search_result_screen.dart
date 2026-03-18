import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './get_service_screen/get_service_screen.dart';
import 'data/providers/types_provider.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/provider_card.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final String? query;

  const SearchResultScreen({super.key, this.query});

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  int selectedCategoryIndex = 0; // 0 is "All"
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch data on load
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(typeProvider.notifier).fetchActiveTypes(loadMore: true);
      }
    });

    Future.microtask(() {
      ref.read(typeProvider.notifier).fetchActiveTypes();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final typeState = ref.watch(typeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- LOGIC: EXTRACT UNIQUE CATEGORIES ---
    // Since the API returns "Types", and multiple types share one category,
    // we need to filter them so "Repair" only shows once in the sidebar.
    final List<dynamic> uniqueCategories = [];
    final Set<int> seenCategoryIds = {};

    for (var type in typeState.types) {
      if (!seenCategoryIds.contains(type.category.id)) {
        seenCategoryIds.add(type.category.id);
        uniqueCategories.add(type.category);
      }
    }

    // --- LOGIC: FILTER RESULTS ---
    // If "All" (index 0) is selected, show everything.
    // Otherwise, show only types belonging to the selected category.
    final filteredTypes = selectedCategoryIndex == 0
        ? typeState.types
        : typeState.types
        .where((t) => t.category.id == uniqueCategories[selectedCategoryIndex - 1].id)
        .toList();

    // --- THEME COLORS ---
    final scaffoldBg = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;
    final glassColor = isDark
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
    final activeColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Row(
              children: [
                // --- LEFT SIDEBAR (CATEGORIES) ---
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: borderColor, width: 0.5),
                    ),
                  ),
                  child: typeState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: uniqueCategories.length + 1,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;

                      // Get Label and Icon
                      final String label = index == 0 ? "All" : uniqueCategories[index - 1].name;
                      final String? iconUrl = index == 0 ? null : uniqueCategories[index - 1].icon;

                      return GestureDetector(
                        onTap: () => setState(() => selectedCategoryIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? activeColor.withValues(alpha: 0.08) : Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: isSelected ? activeColor : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              index == 0
                                  ? Icon(Icons.grid_view_rounded,
                                  size: 24,
                                  color: isSelected ? activeColor : contentColor.withValues(alpha: 0.3))
                                  : Image.network(
                                iconUrl!,
                                height: 24,
                                width: 24,
                                color: isSelected ? activeColor : contentColor.withValues(alpha: 0.3),
                                errorBuilder: (_, __, ___) => Icon(Icons.category,
                                    size: 24,
                                    color: isSelected ? activeColor : contentColor.withValues(alpha: 0.3)),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                label,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? activeColor : contentColor.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // --- RIGHT RESULTS AREA ---
                Expanded(
                  child: typeState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        _buildFeaturedServiceCard(context, theme, activeColor),
                        const SizedBox(height: 25),

                        if (filteredTypes.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text("No services found", style: TextStyle(color: contentColor.withValues(alpha: 0.5))),
                          ),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: filteredTypes.length,
                          itemBuilder: (context, index) {
                            final item = filteredTypes[index];
                            return ProviderCard(
                              name: item.name, // The Type name (e.g. Electrician)
                              job: item.category.name, // The Category name (e.g. Repair)
                              imageUrl: item.icon,
                            );
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- FLOATING GLASS HEADER ---
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: contentColor, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: widget.query ?? "Search services...",
                            hintStyle: TextStyle(color: contentColor.withValues(alpha: 0.3), fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.tune_rounded, color: activeColor),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => const FilterSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedServiceCard(BuildContext context, ThemeData theme, Color activeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: activeColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: activeColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FEATURED SERVICE",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            "Professional Repair",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: activeColor,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GetServiceScreen(query: widget.query)),
              ),
              child: const Text("Get Now", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}