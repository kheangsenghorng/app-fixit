import 'dart:ui'; // REQUIRED for ImageFilter
import 'package:flutter/material.dart';

class OrderTabSwitcher extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const OrderTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 1. EXACT HEADER COLORS & GLASS LOGIC
    final glassColor = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.7) 
        : Colors.white.withValues(alpha: 0.8);
    
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);
        
    final contentColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35), // Matches Header Radius
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Matches Header Blur
          child: Container(
            height: 60, // Matches Header Height
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                _buildTab(0, "Unpaid", isDark, contentColor),
                _buildTab(1, "History", isDark, contentColor),
                _buildTab(2, "Schedule", isDark, contentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label, bool isDark, Color contentColor) {
    final bool isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            // The active "pill" inside the glass
            color: isSelected 
                ? (isDark ? Colors.white : Colors.black) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                )
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              color: isSelected 
                  ? (isDark ? Colors.black : Colors.white) 
                  : contentColor.withValues(alpha: 0.4),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}