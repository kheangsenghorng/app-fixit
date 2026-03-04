import 'package:flutter/material.dart';

class ContentSheetWrapper extends StatelessWidget {
  final Widget child;

  const ContentSheetWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Padding(
        // Side padding to make the card "Float" like the Profile Menu
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // SOLID BG (Pure White or Deep Black)
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            // FULL ROUNDED CORNERS (Matches your design system)
            borderRadius: BorderRadius.circular(32),
            // NO BORDER as requested, just a very soft shadow
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.01) 
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: child,
          ),
        ),
      ),
    );
  }
}