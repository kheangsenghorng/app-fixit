import 'package:flutter/material.dart';

Widget buildSearchBar({
  required BuildContext context,
  required TextEditingController controller,
  required FocusNode focusNode,
  required bool isSearching,
  required VoidCallback onClear,
  GestureTapCallback? onSearchTap,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final activeColor = Theme.of(context).colorScheme.primary;
  
  // MONOCHROME COLORS
  final contentColor = isDark ? Colors.white : Colors.black;

  return TextField(
    controller: controller,
    focusNode: focusNode,
    onTap: onSearchTap,
    readOnly: !isSearching,
    style: TextStyle(
      fontSize: 15, 
      color: contentColor, 
      fontWeight: FontWeight.w500
    ),
    decoration: InputDecoration(
      hintText: "Search services...",
      hintStyle: TextStyle(
        color: contentColor.withValues(alpha: 0.3), 
        fontSize: 15
      ),
      border: InputBorder.none, // Pure floating look
      prefixIcon: Icon(
        Icons.search_rounded, 
        color: contentColor.withValues(alpha: 0.4), 
        size: 22
      ),
      suffixIcon: isSearching
          ? _buildClearButton(onClear: onClear, contentColor: contentColor)
          : Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.tune_rounded, 
                color: activeColor, // Keep Unit Color for Filter
                size: 22
              ),
            ),
    ),
  );
}

Widget _buildClearButton({
  required VoidCallback onClear,
  required Color contentColor,
}) {
  return GestureDetector(
    onTap: onClear,
    child: Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: contentColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.close_rounded, 
        size: 14, 
        color: contentColor.withValues(alpha: 0.8)
      ),
    ),
  );
}