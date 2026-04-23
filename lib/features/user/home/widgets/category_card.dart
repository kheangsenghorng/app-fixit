import 'dart:ui';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final IconData? icon;
  final String? image;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    this.icon,
    this.image,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary;

    final contentColor = isDark ? Colors.white : Colors.black;

    final glassColor = isDark
        ? (_isPressed
        ? activeColor.withValues(alpha: 0.15)
        : const Color(0xFF1A1A1A).withValues(alpha: 0.7))
        : (_isPressed
        ? activeColor.withValues(alpha: 0.05)
        : Colors.white.withValues(alpha: 0.8));

    final borderColor = _isPressed
        ? activeColor.withValues(alpha: 0.4)
        : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05));

    final iconBgColor = _isPressed ? activeColor : activeColor.withValues(alpha: 0.12);
    final iconColor = _isPressed ? (isDark ? Colors.black : Colors.white) : activeColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // Slightly smaller radius
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 90,
              height: 85, // Added a hint height, though parent might override
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4), // Minimal padding
              decoration: BoxDecoration(
                color: glassColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
                children: [
                  const Spacer(), // Flexible space at top
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(8), // Compact icon padding
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: _buildIcon(iconColor),
                  ),
                  const Spacer(), // Flexible space between icon and text
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _isPressed && isDark ? activeColor : contentColor,
                      fontSize: 11, // Reduced font size slightly
                      fontWeight: _isPressed ? FontWeight.w900 : FontWeight.w700,
                      height: 1.1, // Tighten line height
                    ),
                  ),
                  const Spacer(), // Flexible space at bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Color iconColor) {
    if (widget.image != null && widget.image!.isNotEmpty) {
      return Image.network(
        widget.image!,
        width: 18, // Reduced size to fit the 78px constraint
        height: 18,
        fit: BoxFit.contain,
        color: _isPressed ? iconColor : null,
        errorBuilder: (_, __, ___) => Icon(Icons.category, color: iconColor, size: 18),
      );
    }
    return Icon(widget.icon ?? Icons.category, size: 18, color: iconColor);
  }
}