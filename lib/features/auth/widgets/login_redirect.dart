import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../ui/login_sheet.dart'; // Import your LoginSheet here

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Center(
      child: GestureDetector(
        key: const Key('login_redirect_gesture'),
        onTap: () {
          // Close the SignUpSheet
          Navigator.pop(context);
          // Re-open the LoginSheet
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const LoginSheet(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${t.t('already_have_account')} ', // Add this key to your l10n
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                TextSpan(
                  text: t.t('login_here'), // Add this key to your l10n
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}