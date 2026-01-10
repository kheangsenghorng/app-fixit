import 'package:flutter/material.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/features/auth/ui/sign_up_sheet.dart';

import '../widgets/auth_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_button.dart';

class LoginSheet extends StatelessWidget {
  const LoginSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const AuthHeader(),
            const SizedBox(height: 20),

            Text(
              t.t('login_desc'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            CustomTextField(
              hint: t.t('email_hint'),
              icon: Icons.email_outlined,
            ),

            CustomTextField(
              hint: t.t('password_hint'),
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                t.t('forgot_password'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  t.t('sign_in'),
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
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
                          color:
                          colorScheme.onSurface.withValues(alpha: 0.6),
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
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                t.t('or_login_with'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: SocialButton(
                    label: t.t('google'),
                    iconPath: "assets/images/google_logo.png",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SocialButton(
                    label: t.t('apple'),
                    iconPath: isDarkMode
                        ? "assets/images/apple.png"
                        : "assets/images/apple_logo.png",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
