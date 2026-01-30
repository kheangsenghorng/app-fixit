import 'package:fixit/features/auth/presentation/providers/auth_controller.dart';
import 'package:fixit/features/auth/presentation/ui/login_sheet.dart';
import 'package:fixit/features/user/city/city_screen.dart';
import 'package:fixit/features/user/home/home_screen.dart';
import 'package:fixit/features/user/orders/my_orders_screen.dart';
import 'package:fixit/features/user/profile/profile_screen.dart';
import 'package:fixit/features/user/services/popular/popular_services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fixit/widgets/main_bottom_nav.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  // Login sheet
  void _showLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LoginSheet(),
    );
  }

  void _handleNavTap(int index, {bool pop = false}) {
    final requiresLogin = index == 2 || index == 3;

    final authState = ref.watch(authControllerProvider);

    final isLoggedIn = authState.maybeWhen(
      data: (auth) => auth?.token != null && auth!.token.isNotEmpty,
      orElse: () => false,
    );

    if (requiresLogin && !isLoggedIn) {
      _showLoginSheet();
      return;
    }

    setState(() => _selectedIndex = index);

    if (pop && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    // 🔥 Listen for logout → go Home
    ref.listen(authControllerProvider, (prev, next) {
      if (prev?.value != null && next.value == null) {
        setState(() => _selectedIndex = 0);
      }
    });

    ref.watch(authControllerProvider);

    final screens = [
      HomeScreen(
        onPopularServicesTap: _openPopularServices,
        currentIndex: _selectedIndex,
        onNavTap: (index) => _handleNavTap(index),
      ),
      const CityScreen(),
      const MyOrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => _handleNavTap(index),
      ),
    );
  }
}
