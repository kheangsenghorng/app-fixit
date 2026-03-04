import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // THEME COLORS
    final activeColor = theme.colorScheme.primary; // Your Unit Blue
    final contentColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. BRAND ICON (Stays Blue to stand out)
        Image.asset(
          'assets/logo/fixit_logo_small.png',
          width: 28, // Slightly smaller for a more "precise" look
          height: 28,
          color: activeColor,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.build_circle_rounded, color: activeColor, size: 28),
        ),
        
        const SizedBox(width: 8),
        
        // 2. BRAND NAME (Monochrome Black/White)
        Text(
          "FIXIT",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900, // Matches your premium header weight
            letterSpacing: -0.5, // Tighter tracking for a high-end feel
            color: contentColor,
          ),
        ),
      ],
    );
  }
}