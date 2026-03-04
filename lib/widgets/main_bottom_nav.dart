import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    // YOUR ORIGINAL COLORS
    final Color activeColor = theme.colorScheme.primary;
    // Updated inactiveColor to be more visible (like button text)
    final Color inactiveColor = isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.5);
    final Color backgroundColor = theme.cardColor.withValues(alpha: isDark ? 0.7 : 0.8);
    final Color borderColor = isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);

    return Container(
      // The "Floating" margin like the image
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35), 
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Your original blur
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: backgroundColor, // Your original background color
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: borderColor, // Your original border color
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildSmoothTab(
                  index: 0,
                  icon: Icons.home_filled,
                  label: l10n.t('nav_home'),
                  isSelected: currentIndex == 0,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  isDark: isDark,
                ),
                _buildSmoothTab(
                  index: 1,
                  icon: Icons.search_rounded,
                  label: l10n.t('nav_search'), 
                  isSelected: currentIndex == 1,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  isDark: isDark,
                ),
                _buildSmoothTab(
                  index: 2,
                  icon: Icons.assignment_outlined,
                  label: l10n.t('nav_order'),
                  isSelected: currentIndex == 2,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  isDark: isDark,
                ),
                 _buildSmoothTab(
                  index: 3,
                  icon: Icons.settings_rounded,
                  label: l10n.t('nav_settings'), 
                  isSelected: currentIndex == 3,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  isDark: isDark,
                ),
                _buildSmoothTab(
                  index: 4,
                  icon: Icons.person_outline,
                  label: l10n.t('nav_profile'),
                  isSelected: currentIndex == 4,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmoothTab({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color activeColor,
    required Color inactiveColor,
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick(); 
          onTap(index);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // SMOOTH SLIDING HIGHLIGHT (Telegram Style)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: isSelected ? 75 : 0, 
              height: 45,
              decoration: BoxDecoration(
                // Uses your primary color with low opacity for the highlight
                color: isSelected ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SMOOTH ICON SCALE
                AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: isSelected ? 1.15 : 1.0,
                  child: Icon(
                    icon,
                    color: isSelected ? activeColor : inactiveColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
