import 'package:fixit/features/auth/widgets/auth_header.dart';
import 'package:fixit/features/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../Auth/widgets/social_button.dart';


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
        // Important: Moves the sheet up when the keyboard appears
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Drag Handle ---
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

            const SizedBox(height: 8),

            // TERMS & CONDITIONS
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: true,
                    onChanged: (_) {},
                    activeColor: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "I agree with FixIt's ",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // SIGN UP BUTTON
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