import 'dart:ui';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          // Glass effect color
          color: theme.colorScheme.surface.withValues(alpha: 0.7),
          padding: EdgeInsets.only(top: topPadding, left: 20, right: 10, bottom: 10),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo or Brand Section
                Row(
                  children: [
                    Image.asset(
                      'assets/logo/fixit_logo_small.png',
                      width: 32,
                      height: 32,
                      color: theme.colorScheme.primary,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.build_circle, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "FIXIT",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none_rounded,
                          color: theme.colorScheme.onSurface),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.phone_outlined,
                          color: theme.colorScheme.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100); // 60 height + top padding
}