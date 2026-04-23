import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/category_model.dart';
import '../../home/data/provider/category_provider.dart';
import 'search_result_page.dart';

class FilledSearchPage extends ConsumerStatefulWidget {
  final String? initialQuery;

  const FilledSearchPage({super.key, this.initialQuery});

  @override
  ConsumerState<FilledSearchPage> createState() => _FilledSearchPageState();
}

class _FilledSearchPageState extends ConsumerState<FilledSearchPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _shimmerController;
  final FocusNode _searchFocusNode = FocusNode();
  String _filterText = "";

  final Color primaryColor = const Color(0xFF6366F1);
  final Color backgroundColor = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _filterText = widget.initialQuery ?? '';

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  /// Maps category names to specific UI styles.
  /// Essential for 10,000 items where you can't manually set icons for all.
  Map<String, dynamic> _getCategoryStyle(String name) {
    final n = name.toLowerCase();
    if (n.contains('repair')) return {'icon': Icons.build_circle_outlined, 'color': Colors.blue};
    if (n.contains('clean')) return {'icon': Icons.cleaning_services_outlined, 'color': Colors.green};
    if (n.contains('beauty') || n.contains('salon')) return {'icon': Icons.face_retouching_natural_outlined, 'color': Colors.pink};
    if (n.contains('it') || n.contains('tech')) return {'icon': Icons.computer_outlined, 'color': Colors.orange};
    if (n.contains('plumb')) return {'icon': Icons.plumbing_outlined, 'color': Colors.cyan};
    if (n.contains('electr')) return {'icon': Icons.electric_bolt_outlined, 'color': Colors.amber};
    if (n.contains('paint')) return {'icon': Icons.format_paint_outlined, 'color': Colors.deepPurple};
    if (n.contains('move')) return {'icon': Icons.local_shipping_outlined, 'color': Colors.teal};

    // Fallback for the other 9,900+ items
    return {'icon': Icons.grid_view_rounded, 'color': primaryColor};
  }

  void _goToSearchResults({String? query, int? categoryId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultPage(
          query: query ?? _searchController.text.trim(),
          initialCategoryId: categoryId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: categoriesAsync.when(
        loading: () => _buildLoadingSkeleton(),
        error: (error, stack) => _buildErrorState(error.toString()),
        data: (allCategories) {
          // Optimized filtering for large datasets
          final filteredCategories = allCategories.where((cat) {
            return cat.name.toLowerCase().contains(_filterText.toLowerCase());
          }).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Custom App Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: backgroundColor,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  "Search Services",
                  style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              // 2. Sticky-style Search Bar
              SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),

              // 3. Popular Section (Only visible when not filtering)
              if (_filterText.isEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                    child: Text(
                      "Popular Searches",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildPopularSection()),
              ],

              // 4. Categories Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                  child: Text(
                    _filterText.isEmpty ? "All Categories" : "Matching Categories (${filteredCategories.length})",
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ),
              ),

              // 5. Virtualized Grid (High Performance for 10,000 items)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: filteredCategories.isEmpty
                    ? const SliverToBoxAdapter(child: Center(child: Text("No categories match your search")))
                    : SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final cat = filteredCategories[index];
                      final style = _getCategoryStyle(cat.name);
                      return _buildCategoryCard(cat, style);
                    },
                    childCount: filteredCategories.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) => _goToSearchResults(query: value),
          onChanged: (value) => setState(() => _filterText = value),
          decoration: InputDecoration(
            hintText: "Search categories...",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            prefixIcon: Icon(Icons.search, color: primaryColor),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
              onPressed: () {
                _searchController.clear();
                setState(() => _filterText = "");
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category cat, Map<String, dynamic> style) {
    return InkWell(
      onTap: () => _goToSearchResults(categoryId: cat.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (style['color'] as Color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(style['icon'], size: 26, color: style['color']),
            ),
            const SizedBox(height: 10),
            Text(
              cat.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSection() {
    final List<String> popular = ["AC Repair", "Cleaning", "Plumbing", "Paint", "Electrician", "Moving"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: popular.map((title) => InkWell(
          onTap: () => _goToSearchResults(query: title),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(backgroundColor: backgroundColor, elevation: 0),
        SliverToBoxAdapter(child: _shimmerBox(double.infinity, 54, 16, margin: 16)),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _shimmerBox(double.infinity, 100, 16),
              childCount: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _shimmerBox(double width, double height, double radius, {double margin = 0}) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width, height: height,
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
              stops: [0.0, _shimmerController.value, 1.0],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(child: Text("Error: $message", style: const TextStyle(color: Colors.red)));
  }
}