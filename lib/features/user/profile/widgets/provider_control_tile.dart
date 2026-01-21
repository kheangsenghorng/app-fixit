import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart'; // Adjust path
import 'profile_menu_tile.dart'; // Adjust path

class ProviderControlTile extends StatelessWidget {
  final bool isProvider;
  final VoidCallback onManage;
  final VoidCallback onRegister;

  const ProviderControlTile({
    super.key,
    required this.isProvider,
    required this.onManage,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // --- State 1: Already a Provider ---
    if (isProvider) {
      return ProfileMenuTile(
        icon: Icons.engineering_outlined,
        iconColor: Colors.green,
        title: l10n.t('manage_services'),
        onTap: onManage,
      );
    }

    // --- State 2: Regular User (Invitation to join) ---
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: ProfileMenuTile(
        icon: Icons.add_business_outlined,
        iconColor: Colors.blue,
        title: l10n.t('register_as_provider'),
        subtitle: l10n.t('start_your_business_today'),
        onTap: onRegister,
      ),
    );
  }
}