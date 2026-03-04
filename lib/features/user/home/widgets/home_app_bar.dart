import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_bar_actions.dart';
import 'app_logo.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // GLASS LOGIC
    final glassColor = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8) 
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return ClipRRect(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo (Make sure AppLogo uses Monochrome/Unit Blue)
              const AppLogo(),
              // Actions (Notifications/Message icons)
              const AppBarActions(),
            ],
          ),
        ),
      ),
    );
  }
}