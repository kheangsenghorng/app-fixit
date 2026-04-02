import 'package:fixit/features/user/home/widgets/home_app_bar.dart';
import 'package:fixit/features/user/home/widgets/home_body.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onNavTap;

  const HomeScreen({
    super.key,
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
    _filteredResults = _allRecentSearches;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchTap() => setState(() => _isSearching = true);

  void _onClear() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 1. BLACK & WHITE BACKGROUND
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // 2. MAIN CONTENT
          HomeBody(
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
            isSearching: _isSearching,
            filteredResults: _filteredResults,
            currentIndex: widget.currentIndex,
            onSearchTap: _onSearchTap,
            onClear: _onClear,
            onNavTap: widget.onNavTap,
          ),

          // 3. FLOATING GLASS APP BAR
          const Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: HomeAppBar(),
          ),
        ],
      ),
    );
  }
}