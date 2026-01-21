import 'package:fixit/features/auth/widgets/social_button.dart';
import 'package:flutter/material.dart';

class SocialLoginSection extends StatelessWidget {
  const  SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: SocialButton(
                label: "Google",
                iconPath: "assets/images/google_logo.png",
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SocialButton(
                label: "Apple",
                iconPath: isDarkMode
                    ? "assets/images/apple.png"
                    : "assets/images/apple_logo.png",
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}