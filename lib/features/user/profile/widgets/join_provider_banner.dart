import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'profile_menu_tile.dart';

class JoinProviderBanner extends StatelessWidget {
  final VoidCallback onTap;

  const JoinProviderBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // Using orange with low alpha to create a soft "highlight" effect
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ProfileMenuTile(
        icon: Icons.star_outline,
        iconColor: Colors.orange,
        title: l10n.t('join_as_provider'),
        // No arrow here makes it look more like a specialized banner
        showArrow: true,
        onTap: onTap,
      ),
    );
  }
}