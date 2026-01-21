import 'package:fixit/features/auth/widgets/sheet_drag_handle.dart';
import 'package:fixit/features/auth/widgets/sign_up_redirect.dart';
import 'package:fixit/features/auth/widgets/social_auth_divider.dart';
import 'package:fixit/features/auth/widgets/social_login_section.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'auth_header.dart';
import 'login_form.dart';
import 'login_submit_button.dart';

class LoginSheetBody extends StatelessWidget {
  const LoginSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context); // Assuming this is your localization helper

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetDragHandle(),
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
          const LoginForm(),
          const SizedBox(height: 24),

          const LoginSubmitButton(),
          const SizedBox(height: 20),

          const SignUpRedirect(), // This is what your test was looking for!
          const SizedBox(height: 20),

          const SocialAuthDivider(isSignUp: false),

          const SocialLoginSection(),
        ],
      ),
    );
  }
}