import 'package:fixit/features/auth/presentation/ui/sign_up_sheet.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';


class SignUpRedirect extends StatelessWidget {
  const SignUpRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Center(
      child: GestureDetector(
        key: const Key('signup_redirect_gesture'),
        onTap: () {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const SignUpSheet(),
          );
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${t.t('new_to_fixit')} ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              TextSpan(
                text: t.t('sign_up_now'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}