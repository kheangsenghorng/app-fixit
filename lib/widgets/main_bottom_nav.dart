import 'package:flutter/material.dart';
import 'package:fixit/l10n/app_localizations.dart'; // Ensure correct path

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
    //eng to kh
    final l10n = AppLocalizations.of(context);

    return Container(
      // Optional: Add a subtle top border or shadow for better theme separation
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  isDark ? 0.3 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,

        // --- THEME SUPPORTED COLORS ---
        backgroundColor: theme.cardColor, // Adapts to Dark Grey or White
        selectedItemColor: theme.colorScheme.primary, // Adapts to your Primary Blue
        unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade400,

        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: l10n.t('nav_home'), // TRANSLATED
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_city),
            label: l10n.t('nav_city'), // TRANSLATED
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            label: l10n.t('nav_order'), // TRANSLATED
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: l10n.t('nav_profile'), // TRANSLATED
          ),
        ],
      ),
    );
  }
}