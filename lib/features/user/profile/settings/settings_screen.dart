import 'dart:ui';
import 'package:fixit/features/user/profile/widgets/language_picker_sheet.dart';
import 'package:fixit/features/user/profile/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/provider/theme_provider.dart';
import '../../../../core/provider/language_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    
    final themeMode = ref.watch(themeNotifierProvider);
    final currentLocale = ref.watch(languageNotifierProvider);
    // final userAsync = ref.watch(userProvider);
    // final user = userAsync.value;

    // MONOCHROME UI COLORS
    final scaffoldBg = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    
    // Header Glass Color
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
          // 1. MAIN CONTENT
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 130, 20, 40), // Top padding for Floating Header
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SECTION: APPEARANCE
                _buildSectionHeader(l10n.t('appearance'), contentColor),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: _cardDecoration(cardBg, isDark),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _themeButton(ThemeMode.light, Icons.wb_sunny_rounded, l10n.t('light_mode'), themeMode, contentColor),
                      _themeButton(ThemeMode.dark, Icons.nightlight_round, l10n.t('dark_mode'), themeMode, contentColor),
                      _themeButton(ThemeMode.system, Icons.settings_brightness_rounded, l10n.t('system_default'), themeMode, contentColor),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                // SECTION: ACCOUNT
                _buildSectionHeader("Account & App", contentColor),
                const SizedBox(height: 15),
                Container(
                  decoration: _cardDecoration(cardBg, isDark),
                  child: Column(
                    children: [
                      _settingsTile(
                        icon: Icons.language_rounded,
                        iconColor: Colors.blue,
                        title: l10n.t('language'),
                        subtitle: currentLocale.languageCode == 'km' ? 'ភាសាខ្មែរ' : 'English',
                        contentColor: contentColor,
                        onTap: () => _showLanguagePicker(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                // LOGOUT SECTION
                Container(
                  decoration: _cardDecoration(cardBg, isDark),
                  child: _settingsTile(
                    icon: Icons.logout_rounded,
                    iconColor: Colors.red,
                    title: l10n.t('logout'),
                    subtitle: "Sign out",
                    contentColor: contentColor,
                    showArrow: false,
                    onTap: () => _handleLogout(context),
                  ),
                ),
              ],
            ),
          ),

          // 2. FLOATING GLASS HEADER WITH "SETTINGS" TITLE
          Positioned(
            top: 50, left: 16, right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: borderColor),
                  ),
                  child: Center(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        color: contentColor, 
                        fontWeight: FontWeight.w900, // Premium Heavy weight
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  BoxDecoration _cardDecoration(Color bg, bool isDark) {
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(32),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.white.withValues(alpha: 0.01) : Colors.black.withValues(alpha: 0.03),
          blurRadius: 20,
        )
      ],
    );
  }

  Widget _themeButton(ThemeMode mode, IconData icon, String label, ThemeMode current, Color contentColor) {
    final isSelected = current == mode;
    final primaryBlue = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(themeNotifierProvider.notifier).setThemeMode(mode);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? primaryBlue : contentColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isSelected ? Colors.white : contentColor, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryBlue : contentColor.withValues(alpha: 0.5),
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon, 
    required Color iconColor, 
    required String title, 
    required String subtitle, 
    required Color contentColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: contentColor.withValues(alpha: 0.4), fontSize: 12)),
      trailing: showArrow ? Icon(Icons.arrow_forward_ios_rounded, color: contentColor.withValues(alpha: 0.2), size: 14) : null,
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: color.withValues(alpha: 0.4),
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const LanguagePickerSheet(),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => LogoutDialog(
        onConfirm: () async {
          Navigator.pop(dialogContext);

          // 🔄 Loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          // ✅ Logout
          await ref.read(authControllerProvider.notifier).logout();

          // ✅ IMPORTANT: invalidate OUTSIDE controller
          ref.invalidate(userProvider);

          if (context.mounted) {
            Navigator.of(context).pop(); // close loading

            // 🚀 Go to login screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
                  (route) => false,
            );
          }
        },
      ),
    );
  }
}