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

class LoginSheetBody extends ConsumerStatefulWidget {
  const LoginSheetBody({super.key});

  @override
  ConsumerState<LoginSheetBody> createState() => _LoginSheetBodyState();
}

class _LoginSheetBodyState extends ConsumerState<LoginSheetBody> {
  ProviderSubscription? _loginSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loginSubscription = listenLogin(context, ref);
    });
  }

  @override
  void dispose() {
    _loginSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);

    final Color secondaryTextColor =
    isDark ? Colors.grey.shade500 : Colors.grey.shade600;

    final rawError = authState.whenOrNull(
      error: (err, _) => err.toString(),
    ) ??
        '';

    if (isSystemError(rawError)) {
      return GeneralErrorView(
        message: "The server is not responding. Please try again later.",
        onRetry: () => ref.read(authControllerProvider.notifier),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetDragHandle(),
          const SizedBox(height: 16),
          const AuthHeader(),
          const SizedBox(height: 12),
          Text(
            t.t('login_desc'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: secondaryTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 32),
          const LoginForm(),
          if (isInvalidCredentials(rawError))
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  rawError.replaceAll('Exception: ', ''),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 32),
          const LoginSubmitButton(),
          const SizedBox(height: 24),
          const SignUpRedirect(),
          const SizedBox(height: 24),
          const SocialAuthDivider(isSignUp: false),
          const SizedBox(height: 16),
          const SocialLoginSection(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}