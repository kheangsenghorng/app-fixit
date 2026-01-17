import 'package:fixit/features/user/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
// Import your other widgets
import 'widgets/category_card.dart';
import 'widgets/promo_banner.dart';
import 'widgets/provider_card.dart';
import 'widgets/section_header.dart';
// NEW IMPORT
import '../services/providers/providers_page.dart';

class HomeScreen extends StatefulWidget {

  final VoidCallback onPopularServicesTap;
  final int currentIndex;

  final Function(int)? onNavTap;

  const HomeScreen({
    super.key,

    required this.onPopularServicesTap,
    required this.currentIndex,
    this.onNavTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearching = false;


  final List<Map<String, String>> _allRecentSearches = [
    {'title': 'Plumber', 'results': '232 results'},
    {'title': 'Cloth washer', 'results': '112 results'},
    {'title': 'Electrical Repairs', 'results': '12 results'},
    {'title': 'House Cleaning', 'results': '76 results'},
  ];

  List<Map<String, String>> _filteredResults = [];

  @override
  void initState() {
    super.initState();
    _filteredResults = _allRecentSearches; // Initial state
    _searchController.addListener(_onSearchChanged);
  }
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }



  void _onSearchTap() {
    setState(() {
      _isSearching = true;
    });
  }

  void _onClear() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      // Close keyboard
      FocusScope.of(context).unfocus();
    });
  }
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredResults = _allRecentSearches
          .where((item) => item['title']!.toLowerCase().contains(query))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 1. MAIN CONTENT
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Space for the sticky app bar
                  SizedBox(height: MediaQuery.of(context).padding.top + 70),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        PromoBanner(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          isSearching: _isSearching,
                          onSearchTap: _onSearchTap,
                          onClear: _onClear,
                          filteredResults: _filteredResults,
                          currentIndex: widget.currentIndex, // ✅ REQUIRED
                          onNavTap: widget.onNavTap,           // ✅ OPTIONAL (but recommended)
                        ),

                        const SizedBox(height: 40),
                        SectionHeader(
                          title: "Popular Services",
                          onTap: widget.onPopularServicesTap,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  _buildCategoryList(context),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        SectionHeader(title: "Service Providers", onTap: () {}),
                        const SizedBox(height: 15),
                        _buildProviderList(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. EXTRACTED BLURRED APP BAR
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeAppBar(),
          ),
        ],
      ),
    );
  }

  // ... (Keep your _buildCategoryList and _buildProviderList methods below)
  Widget _buildCategoryList(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _categoryItem(context, "Plumbing", Icons.plumbing),
          _categoryItem(context, "Electric", Icons.electric_bolt),
          _categoryItem(context, "Solar", Icons.wb_sunny_outlined),
          _categoryItem(context, "Cleaning", Icons.cleaning_services),
        ],
      ),
    );
  }

  Widget _categoryItem(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: CategoryCard(
        title: title,
        icon: icon,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProvidersPage(
                serviceName: title,
                currentIndex: widget.currentIndex,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProviderList() {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _providerItem("Maskot Kota", "Plumber"),
          _providerItem("Shams Jan", "Electrician"),
          _providerItem("John Doe", "Carpenter"),
        ],
      ),
    );
  }

  Widget _providerItem(String name, String job) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        width: 180,
        child: ProviderCard(name: name, job: job),
      ),
    );
  }
}