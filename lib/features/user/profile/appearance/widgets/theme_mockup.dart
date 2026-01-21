import 'package:flutter/material.dart';

class ThemeMockup extends StatelessWidget {
  final Brightness? brightness;
  final Color accentColor;
  final bool isSystem;

  const ThemeMockup({
    super.key,
    this.brightness,
    required this.accentColor,
    this.isSystem = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      height: 90,
      width: 50,
      decoration: BoxDecoration(
        color: isSystem
            ? Colors.grey[200]
            : (isDark ? const Color(0xFF1A1A1A) : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            // Split view for System Mode
            if (isSystem)
              const Row(
                children: [
                  Expanded(child: ColoredBox(color: Colors.white)),
                  Expanded(child: ColoredBox(color: Colors.black)),
                ],
              ),
            // Center icon representing the app UI
            Center(
              child: Icon(
                Icons.apps,
                size: 18,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}