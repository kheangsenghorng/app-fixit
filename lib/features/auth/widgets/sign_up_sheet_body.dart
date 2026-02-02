
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../data/auth_repository.dart';
import '../presentation/providers/auth_controller.dart';
import '../presentation/ui/otp/otp_screen.dart';
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
              final phone = SignUpForm.phoneController.text;
              final password = SignUpForm.passwordController.text;

              // 1️⃣ Register (creates inactive user)
              await ref.read(authControllerProvider.notifier).register(
                name: SignUpForm.nameController.text,
                phone: phone,
                password: password,
              );

              final result = ref.read(authControllerProvider);

              // 2️⃣ If register successful → send OTP + navigate
              if (context.mounted && result.value == null && !result.hasError) {
                // Send OTP
                await ref.read(authRepositoryProvider).sendOtp(phone);
                // Navigate to OTP screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpScreen(
                      phone: phone,
                      password: password,
                    ),
                  ),
                );
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
