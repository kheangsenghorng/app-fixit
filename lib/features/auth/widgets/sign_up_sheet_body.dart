import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../presentation/providers/auth_controller.dart';
import 'sign_up_form.dart';
import 'sheet_drag_handle.dart';
import 'auth_header.dart';
import 'sign_up_title.dart';
import 'sign_up_submit_button.dart';
import 'social_auth_divider.dart';
import 'social_login_section.dart';
import 'login_redirect.dart';

class SignUpSheetBody extends ConsumerWidget {
  const SignUpSheetBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetDragHandle(),
          const SizedBox(height: 20),
          const AuthHeader(),
          const SizedBox(height: 20),
          const SignUpTitle(),
          const SizedBox(height: 24),
          const SignUpForm(),
          const SizedBox(height: 24),

          SignUpSubmitButton(
            loading: auth.isLoading,
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).register(
                name: SignUpForm.nameController.text,
                phone: SignUpForm.phoneController.text,
                password: SignUpForm.passwordController.text,
              );

              if (context.mounted && ref.read(authControllerProvider).value != null) {
                Navigator.pop(context); // close sheet on success
              }
            },
          ),

          const SocialAuthDivider(isSignUp: true),
          const SocialLoginSection(),
          const SizedBox(height: 24),
          const LoginRedirect(),
        ],
      ),
    );
  }
}
