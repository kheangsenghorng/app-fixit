import 'package:fixit/features/auth/presentation/providers/auth_controller.dart';
import 'package:fixit/features/auth/presentation/ui/login_sheet.dart';
import 'package:fixit/features/user/home/home_screen.dart';
import 'package:fixit/features/user/orders/my_orders_screen.dart';
import 'package:fixit/features/user/profile/profile_screen.dart';
import 'package:fixit/features/user/profile/wallet/wallet_screen.dart';
import 'package:fixit/features/user/search/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fixit/widgets/main_bottom_nav.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int currentIndex;
  const MainScreen({super.key, required this.currentIndex});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _showLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LoginSheet(),
    );
  }

  void _handleNavTap(int index, {bool pop = false}) {
    final requiresLogin = index == 2 || index == 3 || index == 4;

    final authState = ref.read(authControllerProvider);

    final isLoggedIn = authState.maybeWhen(
      data: (auth) => auth?.token?.isNotEmpty == true,
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

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (prev, next) {
      if (prev?.valueOrNull != null &&
          next.valueOrNull == null &&
          !next.hasError) {
        setState(() => _selectedIndex = 0);
      }
    });

    final authState = ref.watch(authControllerProvider);
    final auth = authState.valueOrNull;

    final int? userId = auth?.user?.id;

    final screens = [
      HomeScreen(
        currentIndex: _selectedIndex,
        onNavTap: (index) => _handleNavTap(index),
      ),
      const SearchResultScreen(),
      const MyOrdersScreen(),
      if (userId != null)
        WalletScreen(userId: userId)
      else
        const Center(
          child: Text("Please login to view wallet"),
        ),
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
