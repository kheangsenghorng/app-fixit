
import 'package:fixit/features/auth/ui/login_sheet.dart';
import 'package:fixit/features/user/home/home_screen.dart';
import 'package:fixit/features/user/orders/my_orders_screen.dart';
import 'package:fixit/features/user/search/search_result_screen.dart';
import 'package:fixit/features/user/services/popular_services_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show BuildContext, Center, Colors, IndexedStack, Scaffold, State, StatefulWidget, Text, Widget, showModalBottomSheet, MaterialPageRoute;


import 'package:fixit/widgets/main_bottom_nav.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;

  String? userId; // null = not logged in


  void _showLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LoginSheet(),
    );
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(
          currentIndex: _selectedIndex,
          onNavTap: (index) {
            if ((index == 2 || index == 3) && !isLoggedIn) {
              _showLoginSheet();
            } else {
              setState(() => _selectedIndex = index);
              Navigator.pop(context); // back to MainScreen
            }
          },
        ),
      ),
    );
  }
  void _openPopularServices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PopularServicesPage(
          currentIndex: _selectedIndex,
          onNavTap: (index) {
            setState(() => _selectedIndex = index);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }



  late final List<Widget> _screens = [
    HomeScreen(
      onSearchTap: _openSearch,
      onPopularServicesTap: _openPopularServices,
    ),
    const Center(child: Text("City Screen ehfgeyfugbqueifgqbewf")),
    MyOrdersScreen(),
    const Center(child: Text("Profile Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          final bool requiresLogin = index == 2 || index == 3;

          if (requiresLogin && userId == null) {
            _showLoginSheet(); // 🔒 not logged in
            return;
          }

          setState(() => _selectedIndex = index); // ✅ allowed
        },
      ),

    );
  }
}
