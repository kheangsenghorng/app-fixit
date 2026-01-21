import 'package:fixit/features/user/profile/widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/language_provider.dart';
import '../../../../core/provider/theme_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../routes/app_routes.dart';
import 'language_picker_sheet.dart';
import 'logout_dialog.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context);

    // Mocking the provider status for testing

    String getModeName(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system: return l10n.t('system_default');
        case ThemeMode.light: return l10n.t('light_mode');
        case ThemeMode.dark: return l10n.t('dark_mode');
      }
    }

    return Column(
      children: [
        const SizedBox(height: 40),

        // --- SETTINGS SECTION ---
        ProfileMenuTile(
          icon: Icons.person_outline,
          iconColor: Colors.red.shade300,
          title: l10n.t('edit_profile'),
          onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
        ProfileMenuTile(
          icon: Icons.notifications_none,
          iconColor: Colors.blue.shade300,
          title: l10n.t('notification'),
          onTap: () {},
        ),
        ProfileMenuTile(
          icon: Icons.palette_outlined,
          iconColor: Colors.amber,
          title: l10n.t('appearance'),
          subtitle: getModeName(themeProvider.themeMode),
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
          title: l10n.t('help_support'),
          onTap: () => Navigator.pushNamed(context, AppRoutes.helpSupport),
        ),
        //
        // // --- DYNAMIC SECTION (If not a provider, show the invite) ---
        // if (isProvider) ...[
        //   const SizedBox(height: 10),
        //   JoinProviderBanner(
        //     onTap: () => _showJoinProviderSheet(context),
        //   ),
        // ],

        // --- DANGER ZONE ---
        const SizedBox(height: 10),
        ProfileMenuTile(
          icon: Icons.logout,
          iconColor: Colors.red,
          title: l10n.t('logout'),
          showArrow: false,
          onTap: () => _handleLogout(context),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  // Helper Methods (Keep these here or move to a 'ProfileActions' service class)

  void _showLanguagePicker(BuildContext context, LanguageProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LanguagePickerSheet(provider: provider),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
  }
}