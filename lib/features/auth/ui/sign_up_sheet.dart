import 'package:fixit/features/auth/widgets/auth_header.dart';
import 'package:fixit/features/auth/widgets/custom_text_field.dart';
import 'package:fixit/features/auth/widgets/social_button.dart';
import 'package:flutter/material.dart';

class SignUpSheet extends StatelessWidget {
  const SignUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

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
              "Create your account",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            const CustomTextField(
              hint: "Full name",
              icon: Icons.person_outline,
            ),
            const CustomTextField(
              hint: "Enter your email",
              icon: Icons.email_outlined,
            ),
            const CustomTextField(
              hint: "Enter password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "Or sign up with",
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
                    label: "Google",
                    iconPath: "assets/images/google_logo.png",
                    onTap: () {
                      // TODO: Google sign-up
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SocialButton(
                    label: "Apple",
                    iconPath: isDarkMode
                        ? "assets/images/apple.png"
                        : "assets/images/apple_logo.png",
                    onTap: () {
                      // TODO: Apple sign-up
                    },
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
