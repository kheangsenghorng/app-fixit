import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming these are your paths based on the snippets
import '../../../../../core/models/service_model.dart';
import '../../../../routes/app_routes.dart';
import '../data/providers/service_search_provider.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  final String query;
  final int? initialCategoryId;

  const SearchResultPage({
    super.key,
    required this.query,
    this.initialCategoryId,
  });

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late AnimationController _shimmerController;

  bool _isSearching = false;
  int? activeCategoryId;

  final Color primaryColor = const Color(0xFF6366F1); // Modern Indigo
  final Color backgroundColor = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _searchFocusNode = FocusNode();
    activeCategoryId = widget.initialCategoryId;

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _searchFocusNode.addListener(() {
      setState(() => _isSearching = _searchFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We watch the provider using the current search controller text
    final servicesAsync = ref.watch(searchServicesProvider(_searchController.text.trim()));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildCategorySelector(),
                Expanded(
                  child: servicesAsync.when(
                    loading: () => _buildSkeletonList(),
                    error: (error, stack) => _buildErrorState(),
                    data: (services) {
                      // Apply local category filtering on top of provider data
                      final filteredServices = services.where((service) {
                        return activeCategoryId == null ||
                            service.category.id == activeCategoryId;
                      }).toList();

                      if (filteredServices.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filteredServices.length,
                        itemBuilder: (context, index) {
                          return _buildModernServiceCard(filteredServices[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Backdrop blur when search field is focused
          if (_isSearching)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _searchFocusNode.unfocus(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(color: Colors.black.withValues(alpha: 0.05)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          _backButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}), // Triggers provider watch update
                decoration: InputDecoration(
                  hintText: "Search services...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _categoryChip("All", null);
          final cat = categories[index - 1];
          return _categoryChip(cat.name, cat.id);
        },
      ),
    );
  }

  Widget _categoryChip(String label, int? id) {
    final isSelected = activeCategoryId == id;
    return GestureDetector(
      onTap: () => setState(() => activeCategoryId = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildModernServiceCard(Service service) {
    final imageUrl = service.images.isNotEmpty ? service.images.first.url : '';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.providerDetail,
          arguments: service.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Stack(
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: 120,
                      height: 130,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 120,
                      height: 130,
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${service.basePrice}',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Book",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // UI States (Loading, Empty, Error)
  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 120,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            _shimmerBox(120, 120, 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(140, 15, 4),
                    const SizedBox(height: 10),
                    _shimmerBox(180, 12, 4),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _shimmerBox(50, 20, 4),
                        _shimmerBox(60, 30, 8),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, double radius) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          margin: const EdgeInsets.only(right: 10),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No services found", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Text("Error loading services", style: TextStyle(color: Colors.red.shade300)),
    );
  }

  // Mock Category Data (Should ideally come from a provider)
  final List<CategoryModel> categories = [
    CategoryModel(id: 10, name: 'Repair'),
    CategoryModel(id: 9, name: 'Cleaning'),
    CategoryModel(id: 13, name: 'Plumbing'),
    CategoryModel(id: 14, name: 'Electrical'),
  ];
}

class CategoryModel {
  final int id;
  final String name;
  CategoryModel({required this.id, required this.name});
}