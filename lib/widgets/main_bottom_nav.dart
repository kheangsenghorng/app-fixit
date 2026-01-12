import 'dart:ui'; // 1. REQUIRED for ImageFilter
import 'package:flutter/material.dart';
import 'package:fixit/l10n/app_localizations.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return ClipRRect( // 2. Wrap in ClipRRect so the blur doesn't spread
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // 3. The Blur Intensity
        child: Container(
          decoration: BoxDecoration(
            // 4. Use semi-transparent background color
            color: theme.cardColor.withValues(alpha: isDark ? 0.7 : 0.8),
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,

            // 5. MUST BE TRANSPARENT to see the blur
            backgroundColor: Colors.transparent,
            elevation: 0,

            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_filled),
                label: l10n.t('nav_home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.location_city),
                label: l10n.t('nav_city'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.assignment_outlined),
                label: l10n.t('nav_order'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: l10n.t('nav_profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}