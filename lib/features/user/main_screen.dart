import 'package:fixit/features/auth/ui/login_sheet.dart';
import 'package:fixit/features/user/city/city_screen.dart';
import 'package:fixit/features/user/home/home_screen.dart';
import 'package:fixit/features/user/orders/my_orders_screen.dart';
import 'package:fixit/features/user/profile/profile_screen.dart';
import 'package:fixit/features/user/search/search_result_screen.dart';
import 'package:fixit/features/user/services/popular/popular_services_page.dart';
import 'package:flutter/material.dart';

import 'package:fixit/widgets/main_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? userId  = "1"; // null = not logged in

  // 🔐 Login sheet
  void _showLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LoginSheet(),
    );
  }

  // ✅ SINGLE navigation handler (BEST PRACTICE)
  void _handleNavTap(int index, {bool pop = false}) {
    final bool requiresLogin = index == 2 || index == 3;

    if (requiresLogin && userId == null) {
      _showLoginSheet();
      return;
    }

    setState(() => _selectedIndex = index);

    if (pop && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // 🔍 Search screen
  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(
          currentIndex: _selectedIndex,
          onNavTap: (index) => _handleNavTap(index, pop: true),
        ),
      ),
    );
  }

  // ⭐ Popular services
  void _openPopularServices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PopularServicesPage(
          currentIndex: _selectedIndex,
          onNavTap: (index) => _handleNavTap(index, pop: true),
        ),
      ),
    );
  }

  late final List<Widget> _screens = [
    HomeScreen(
      onSearchTap: _openSearch,
      onPopularServicesTap: _openPopularServices,
      currentIndex: _selectedIndex,
    ),

    const CityScreen(),
    const MyOrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => _handleNavTap(index),
      ),
    );
  }
}
