


import 'package:fixit/features/auth/ui/sign_up_sheet.dart';
import 'package:flutter/material.dart';
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

    return Container(
      // Ensure the sheet rounds at the top
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12, // Small top padding for the handle
        // This adds padding for the keyboard
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bottom Sheet Drag Handle ---
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
              "Enter your email and password to login",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            const CustomTextField(
              hint: "Enter your email",
              icon: Icons.email_outlined,
            ),

            const CustomTextField(
              hint: "Enter your password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forgot Password?",
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
                  "Sign In",
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
                  Navigator.pop(context); // 1. Close the LoginSheet
                  // 2. Open the SignUpSheet as a bottom sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Necessary for keyboard support
                    backgroundColor: Colors.transparent, // Allows container decoration to show
                    builder: (context) => const SignUpSheet(),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "New to FixIt? ",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      TextSpan(
                        text: "Sign up now",
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
                "Or log in with",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(
                  child: SocialButton(
                    label: "Google",
                    iconPath: "assets/images/google_logo.png",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SocialButton(
                    label: "Apple",
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