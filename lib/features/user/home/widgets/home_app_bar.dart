import 'dart:ui';
import 'package:flutter/material.dart';

import 'app_bar_actions.dart';
import 'app_logo.dart';

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
                const AppLogo(),
                // Action Buttons
                const AppBarActions(),
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