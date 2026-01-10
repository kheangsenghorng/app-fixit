import 'package:fixit/features/user/profile/widgets/logout_dialog.dart';
import 'package:fixit/features/user/profile/widgets/profile_avatar.dart';
import 'package:fixit/features/user/profile/widgets/profile_menu_tile.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/language_provider.dart';
import '../../../core/provider/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    bool isBackgroundLight = theme.colorScheme.surface.computeLuminance() > 0.5;
    Color headerTextColor = isBackgroundLight ? const Color(0xFF002B5B) : Colors.white;

    // Helper to get translated theme mode name
    String getModeName(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system: return l10n.t('system_default');
        case ThemeMode.light: return l10n.t('light_mode');
        case ThemeMode.dark: return l10n.t('dark_mode');
      }
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.t('my_profile'), // TRANSLATED
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: headerTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const ProfileAvatar(imageUrl: 'https://i.pravatar.cc/300'),
              const SizedBox(height: 15),

              Text(
                'Mahrama',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 24,
                  color: headerTextColor,
                ),
              ),
              const SizedBox(height: 40),

              ProfileMenuTile(
                icon: Icons.person_outline,
                iconColor: Colors.red.shade300,
                title: l10n.t('edit_profile'), // TRANSLATED
                onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
              ),

              ProfileMenuTile(
                icon: Icons.notifications_none,
                iconColor: Colors.blue.shade300,
                title: l10n.t('notification'), // TRANSLATED
                onTap: () {},
              ),

              ProfileMenuTile(
                icon: Icons.palette_outlined,
                iconColor: Colors.amber,
                title: l10n.t('appearance'),
                subtitle: getModeName(themeProvider.themeMode), // ADDED SUBTITLE
                onTap: () => Navigator.pushNamed(context, AppRoutes.appearance),
              ),

              ProfileMenuTile(
                icon: Icons.language,
                iconColor: Colors.blue,
                title: l10n.t('language'),
                subtitle: langProvider.currentLocale.languageCode == 'km' ? 'ភាសាខ្មែរ' : 'English',
                onTap: () => _showLanguagePicker(context, langProvider),
              ),

              ProfileMenuTile(
                icon: Icons.headset_mic_outlined,
                iconColor: Colors.blue.shade200,
                title: l10n.t('help_support'), // TRANSLATED
                onTap: () => Navigator.pushNamed(context, AppRoutes.helpSupport),
              ),

              ProfileMenuTile(
                icon: Icons.logout,
                iconColor: Colors.red,
                title: l10n.t('logout'),
                showArrow: false,
                onTap: () => showLogoutDialog(context),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, LanguageProvider provider) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.t('select_language'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _languageOption(context, "English", "en", provider),
              _languageOption(context, "ភាសាខ្មែរ", "km", provider),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(BuildContext context, String name, String code, LanguageProvider provider) {
    bool isSelected = provider.currentLocale.languageCode == code;
    return ListTile(
      title: Text(name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
        provider.changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}
void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const LogoutDialog(),
  );
}