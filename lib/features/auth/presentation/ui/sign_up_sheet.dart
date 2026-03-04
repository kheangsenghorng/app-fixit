import 'dart:ui';
import 'package:fixit/features/auth/widgets/sign_up_sheet_body.dart';
import 'package:flutter/material.dart';



class SignUpSheet extends StatelessWidget {
  const SignUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
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
          child: const SignUpSheetBody(),
        ),
      ),
    );
  }
}
