import 'dart:ui';

import 'package:fixit/features/user/orders/widgets/content_sheet_wrapper.dart';
import 'package:fixit/features/user/orders/widgets/order_list_view.dart';
import 'package:fixit/features/user/orders/widgets/order_tab_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/providers/auth_controller.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authControllerProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authControllerProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final scaffoldBg = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;
    final glassColor = isDark
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 125),

              OrderTabSwitcher(
                selectedTab: selectedTab,
                onTabChanged: (index) => setState(() => selectedTab = index),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: ContentSheetWrapper(
                  child: authAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Error: $error'),
                    ),
                    data: (auth) {
                      final int? userId = auth?.user?.id;

                      if (userId == null) {
                        return const Center(
                          child: Text('User not found'),
                        );
                      }

                      return OrderListView(
                        selectedTab: selectedTab,
                        userId: userId,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Booking",
                        style: TextStyle(
                          color: contentColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Icon(
                        Icons.history_rounded,
                        color: contentColor,
                        size: 22,
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
}