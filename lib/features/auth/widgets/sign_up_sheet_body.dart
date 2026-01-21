import 'package:flutter/material.dart';
import 'sheet_drag_handle.dart';
import 'auth_header.dart';
import 'sign_up_title.dart';
import 'sign_up_form.dart';
import 'sign_up_submit_button.dart';
import 'social_auth_divider.dart';
import 'social_login_section.dart';
import 'login_redirect.dart';

class SignUpSheetBody extends StatelessWidget {
  const SignUpSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. The Drag Handle at the very top
          const SheetDragHandle(),

          const SizedBox(height: 20),
          // 2. Branding/Logo
          const AuthHeader(),

          const SizedBox(height: 20),
          // 3. Title Text
          const SignUpTitle(),

          const SizedBox(height: 24),
          // 4. Input Fields (Full Name, Email, Password)
          const SignUpForm(),

          const SizedBox(height: 24),
          // 5. Primary Action Button
          SignUpSubmitButton(
            onPressed: () {
              // TODO: Implement your SignUp logic (Bloc/Provider)
              debugPrint("Sign up pressed");
            },
          ),

          // 6. Social Login Divider ("Or sign up with")
          const SocialAuthDivider(isSignUp: true),

          // 7. Social Buttons (Google/Apple)
          const SocialLoginSection(),

          const SizedBox(height: 24),
          // 8. Navigation back to Login
          const LoginRedirect(),
        ],
      ),
    );
  }
}