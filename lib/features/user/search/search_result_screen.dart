import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/category_model.dart';
import '../../../core/models/type_model.dart';
import '../../../core/provider/type_listener_provider.dart';
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
  int selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      ref.read(typeListenerProvider);
      await ref.read(typeProvider.notifier).loadInitialTypes();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(typeProvider.notifier).fetchActiveTypes(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typeState = ref.watch(typeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categories = _buildUniqueCategories(typeState.types);

    if (selectedCategoryIndex > categories.length) {
      selectedCategoryIndex = 0;
    }

    final filteredTypes = _filterTypesByCategory(
      types: typeState.types,
      categories: categories,
      selectedCategoryIndex: selectedCategoryIndex,
    );

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
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: borderColor, width: 0.5),
                    ),
                  ),
                  child: typeState.isLoading && typeState.types.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: categories.length + 1,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;
                      final Category? category =
                      index == 0 ? null : categories[index - 1];

                      final String label =
                      index == 0 ? 'All' : category?.name ?? '';
                      final String iconUrl =
                      index == 0 ? '' : category?.icon ?? '';

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? activeColor.withValues(alpha: 0.08)
                                : Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: isSelected
                                    ? activeColor
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildCategoryIcon(
                                index: index,
                                iconUrl: iconUrl,
                                isSelected: isSelected,
                                activeColor: activeColor,
                                contentColor: contentColor,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                label,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? activeColor
                                      : contentColor.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: typeState.isLoading && typeState.types.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        _buildFeaturedServiceCard(
                          context,
                          activeColor,
                        ),
                        const SizedBox(height: 25),
                        if (typeState.error != null &&
                            typeState.types.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Text(
                              typeState.error!,
                              style: TextStyle(
                                color:
                                contentColor.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        if (filteredTypes.isEmpty &&
                            !(typeState.isLoading &&
                                typeState.types.isEmpty))
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              'No services found',
                              style: TextStyle(
                                color:
                                contentColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        if (filteredTypes.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 250,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: filteredTypes.length,
                            itemBuilder: (context, index) {
                              final item = filteredTypes[index];

                              return ProviderCard(
                                name: item.name,
                                job: item.category?.name ?? '',
                                imageUrl: item.icon,
                              );
                            },
                          ),
                        if (typeState.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(),
                          ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                          style: TextStyle(
                            color: contentColor,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.query ?? 'Search services...',
                            hintStyle: TextStyle(
                              color: contentColor.withValues(alpha: 0.3),
                              fontSize: 15,
                            ),
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

  List<Category> _buildUniqueCategories(List<TypeModel> types) {
    final List<Category> uniqueCategories = [];
    final Set<int> seenCategoryIds = {};

    for (final type in types) {
      final category = type.category;
      final categoryId = category?.id;

      if (category != null &&
          categoryId != null &&
          !seenCategoryIds.contains(categoryId)) {
        seenCategoryIds.add(categoryId);
        uniqueCategories.add(category);
      }
    }

    return uniqueCategories;
  }

  List<TypeModel> _filterTypesByCategory({
    required List<TypeModel> types,
    required List<Category> categories,
    required int selectedCategoryIndex,
  }) {
    if (selectedCategoryIndex == 0) {
      return types;
    }

    final selectedCategory = categories[selectedCategoryIndex - 1];

    return types.where((type) {
      return type.category?.id == selectedCategory.id;
    }).toList();
  }

  Widget _buildCategoryIcon({
    required int index,
    required String iconUrl,
    required bool isSelected,
    required Color activeColor,
    required Color contentColor,
  }) {
    final iconColor = isSelected
        ? activeColor
        : contentColor.withValues(alpha: 0.3);

    if (index == 0) {
      return Icon(
        Icons.grid_view_rounded,
        size: 24,
        color: iconColor,
      );
    }

    if (iconUrl.isEmpty) {
      return Icon(
        Icons.category,
        size: 24,
        color: iconColor,
      );
    }

    return Image.network(
      iconUrl,
      height: 24,
      width: 24,
      color: iconColor,
      errorBuilder: (_, __, ___) {
        return Icon(
          Icons.category,
          size: 24,
          color: iconColor,
        );
      },
    );
  }

  Widget _buildFeaturedServiceCard(
      BuildContext context,
      Color activeColor,
      ) {
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FEATURED SERVICE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Professional Repair',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GetServiceScreen(query: widget.query),
                  ),
                );
              },
              child: const Text(
                'Get Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}