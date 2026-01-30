import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fixit/features/auth/widgets/sheet_drag_handle.dart';
import 'package:fixit/features/auth/widgets/sign_up_redirect.dart';
import 'package:fixit/features/auth/widgets/social_auth_divider.dart';
import 'package:fixit/features/auth/widgets/social_login_section.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/general/general_error_view.dart';
import '../presentation/providers/auth_controller.dart';
import 'auth_header.dart';
import 'login_form.dart';
import 'login_submit_button.dart';

class LoginSheetBody extends ConsumerWidget {
  const LoginSheetBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context);

    final authState = ref.watch(authControllerProvider);

    // 1. Identify Error Type
    final errorMsg = authState.error?.toString() ?? "";
    // We assume "Invalid credentials" is the only 'User Error'
    final isSystemError = authState.hasError && !errorMsg.contains("Invalid credentials");

    ref.listen(authControllerProvider, (prev, next) {
      next.whenOrNull(
        data: (auth) {
          if (auth != null) Navigator.pushReplacementNamed(context, '/main');
        },
      );
    });

    // 🔥 IF API NOT WORKING: Show this view instead of the form
    if (isSystemError) {
      return GeneralErrorView(
        message: "The server is not responding. Please try again later.",
        onRetry: () => ref.invalidate(authControllerProvider),
      );
    }

    // 2. NORMAL VIEW (Form + Inline Error for Invalid Credentials)
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

            // 🔥 SHORT MESSAGE ONLY for "Invalid credentials"
            if (authState.hasError && !isSystemError)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),
            const LoginSubmitButton(),
            const SizedBox(height: 20),

            const SignUpRedirect(),
            const SizedBox(height: 20),

            const SocialAuthDivider(isSignUp: false),
            const SocialLoginSection(),
            const SizedBox(height: 30),
          ],
        ),

    );
  }
}