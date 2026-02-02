import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/auth_error_helper.dart';
import '../../../widgets/general/general_error_view.dart';
import '../presentation/providers/auth_controller.dart';
import '../presentation/listeners/login_listener.dart';


import 'auth_header.dart';
import 'login_form.dart';
import 'login_submit_button.dart';
import 'sheet_drag_handle.dart';
import 'sign_up_redirect.dart';
import 'social_auth_divider.dart';
import 'social_login_section.dart';

class LoginSheetBody extends ConsumerWidget {
  const LoginSheetBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenLogin(context, ref); // 👈 one line

    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);

    final rawError = authState.error?.toString() ?? "";

    if (isSystemError(rawError)) {
      return GeneralErrorView(
        message: "The server is not responding. Please try again later.",
        onRetry: () => ref.invalidate(authControllerProvider),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetDragHandle(),
          const SizedBox(height: 20),
          const AuthHeader(),
          const SizedBox(height: 20),

          Text(t.t('login_desc'), style: theme.textTheme.titleMedium),

          const SizedBox(height: 24),
          const LoginForm(),

          if (isInvalidCredentials(rawError))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Text(
                  rawError.replaceAll('Exception: ', ''),
                  style: const TextStyle(color: Colors.redAccent),
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
        ],
      ),
    );
  }
}
