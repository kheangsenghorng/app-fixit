import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';

import 'profile_header.dart';
import 'profile_menu_section.dart';
import 'provider_account_switcher.dart';

class ProfileBodyView extends StatelessWidget {
  final UserModel user;
  final VoidCallback onJoinProvider;
  final Color headerTextColor;

  const ProfileBodyView({
    super.key,
    required this.user,
    required this.onJoinProvider,
    required this.headerTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProvider = user.role == 'provider';

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            ProfileHeader(
              name: user.name,
              imageUrl: user.avatar ?? 'assets/images/providers/img.png',
              textColor: headerTextColor,
            ),

            const SizedBox(height: 10),

            ProviderAccountSwitcher(
              isProvider: isProvider,
              onTap: () {
                if (isProvider) {
                  Navigator.pushNamed(context, '/provider-dashboard');
                } else {
                  onJoinProvider();
                }
              },
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const ProfileMenuSection(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
