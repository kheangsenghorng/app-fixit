import 'package:fixit/features/user/profile/widgets/logout_dialog.dart';
import 'package:fixit/features/user/profile/widgets/profile_avatar.dart';
import 'package:fixit/features/user/profile/widgets/profile_menu_tile.dart';

import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    // Determine the header text color based on background luminance
    bool isBackgroundLight = theme.colorScheme.surface.computeLuminance() > 0.5;
    Color headerTextColor = isBackgroundLight ? const Color(0xFF002B5B) : Colors.white;

    String getModeName(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.system: return "System Default";
        case ThemeMode.light: return "Light Mode";
        case ThemeMode.dark: return "Dark Mode";
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

              // 1. Header Widget
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Profile',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: headerTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 2. Profile Image Widget
              const ProfileAvatar(imageUrl: 'https://i.pravatar.cc/300'),
              const SizedBox(height: 15),

              // 3. Name Label
              Text(
                'Mahrama',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 24,
                  color: headerTextColor,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Menu Items List
              ProfileMenuTile(
                icon: Icons.person_outline,
                iconColor: Colors.red.shade300,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.editProfile);
                },

              ),
              ProfileMenuTile(
                icon: Icons.notifications_none,
                iconColor: Colors.blue.shade300,
                title: 'Notification',
                onTap: () {},
              ),

              // --- THEME SWITCHER ADDED HERE ---
              // const ThemeModeSwitcher(),
              ProfileMenuTile(
                icon: Icons.palette_outlined,
                iconColor: Colors.amber.shade400,
                title: 'Appearance',
                // Use your helper function to get the name
                subtitle: getModeName(themeProvider.themeMode),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.appearance);
                },
              ),

              // ProfileMenuTile(
              //   icon: Icons.payment,
              //   iconColor: Colors.amber.shade400,
              //   title: 'Payment method',
              //   onTap: () {},
              // ),
              ProfileMenuTile(
                icon: Icons.headset_mic_outlined,
                iconColor: Colors.blue.shade200,
                title: 'Help & support',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.helpSupport);
                },
              ),
              ProfileMenuTile(
                icon: Icons.exit_to_app,
                iconColor: theme.colorScheme.primary,
                title: 'Logout',
                titleColor: theme.colorScheme.primary,
                showArrow: false,
                onTap: () {

                  showLogoutDialog(context);
                },
              ),

              const SizedBox(height: 20),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}