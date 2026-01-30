import 'package:fixit/features/user/profile/widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../core/provider/language_provider.dart';
import '../../../../core/provider/theme_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import 'language_picker_sheet.dart';
import 'logout_dialog.dart';

class ProfileMenuSection extends ConsumerWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final currentLocale = ref.watch(languageNotifierProvider);
    final l10n = AppLocalizations.of(context);

    String getModeName(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system:
          return l10n.t('system_default');
        case ThemeMode.light:
          return l10n.t('light_mode');
        case ThemeMode.dark:
          return l10n.t('dark_mode');
      }
    }

    return Column(
      children: [
        const SizedBox(height: 40),

        ProfileMenuTile(
          icon: Icons.person_outline,
          iconColor: Colors.redAccent,
          title: l10n.t('edit_profile'),
          onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),

        ProfileMenuTile(
          icon: Icons.notifications_none,
          iconColor: Colors.blueAccent,
          title: l10n.t('notification'),
          onTap: () {},
        ),

        ProfileMenuTile(
          icon: Icons.palette_outlined,
          iconColor: Colors.amber,
          title: l10n.t('appearance'),
          subtitle: getModeName(themeMode),
          onTap: () => Navigator.pushNamed(context, AppRoutes.appearance),
        ),

        ProfileMenuTile(
          icon: Icons.language,
          iconColor: Colors.blue,
          title: l10n.t('language'),
          subtitle:
          currentLocale.languageCode == 'km' ? 'ភាសាខ្មែរ' : 'English',
          onTap: () => _showLanguagePicker(context),
        ),

        ProfileMenuTile(
          icon: Icons.headset_mic_outlined,
          iconColor: Colors.blueGrey,
          title: l10n.t('help_support'),
          onTap: () => Navigator.pushNamed(context, AppRoutes.helpSupport),
        ),

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

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LanguagePickerSheet(),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => LogoutDialog(
        onConfirm: () async {
          // 1. Close the Confirmation Dialog
          Navigator.pop(dialogContext);

          // 2. Show Loading Dialog (Non-dismissible)
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0056D2),
              ),
            ),
          );

          // 3. Wait for 5 seconds
          await Future.delayed(const Duration(seconds: 5));

          // 4. Perform logout logic
          // Using context.mounted is best practice before using context after an 'await'
          if (context.mounted) {
            final ref = ProviderScope.containerOf(context);
            await ref.read(authControllerProvider.notifier).logout();

            // 5. Close the loading dialog
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }



}
