import 'dart:ui'; // 1. Required for the blur effect
import 'package:fixit/features/auth/widgets/login_sheet_body.dart';
import 'package:flutter/material.dart';

class LoginSheet extends StatelessWidget {
  const LoginSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      // 2. Same rounding as your BottomBar
      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      child: BackdropFilter(
        // 3. Same blur intensity as your BottomBar
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            // 4. Using your exact unit colors and transparency
            color: theme.cardColor.withValues(alpha: isDark ? 0.7 : 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: const LoginSheetBody(), // 5. Keeps exact function
        ),
      ),
    );
  }
}