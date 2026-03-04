import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';
import 'profile_header.dart';
import 'profile_menu_section.dart';
import 'provider_account_switcher.dart';

class ProfileBodyView extends StatelessWidget {
  final UserModel user;
  final VoidCallback onJoinProvider;
  final Color headerTextColor;
  final bool isLoading;

  const ProfileBodyView({
    super.key,
    required this.user,
    required this.onJoinProvider,
    required this.headerTextColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        ProfileHeader(
          name: user.name, 
          imageUrl: user.avatar, 
          textColor: headerTextColor
        ),
        
        const SizedBox(height: 40), 

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ProviderAccountSwitcher(
            isProvider: user.role == 'provider', 
            onTap: onJoinProvider
          ),
        ),

        const SizedBox(height: 50), 

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              // FIXED: Changed to Pure Black for Dark Mode
              color: isDark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(32),
              // ADDED: A tiny hairline border so the black box is visible on black background
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                )
              ],
            ),
            child: ProfileMenuSection(
              user: user, 
              contentColor: headerTextColor
            ),
          ),
        ),
        
        const SizedBox(height: 120),
      ],
    );
  }
}