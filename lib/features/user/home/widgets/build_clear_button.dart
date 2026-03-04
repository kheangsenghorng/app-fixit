import 'package:flutter/material.dart';

Widget buildClearButton({
  required VoidCallback onClear,
  required Color contentColor,
}) {
  return GestureDetector(
    onTap: onClear,
    child: Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: contentColor.withValues(alpha: 0.1), // Subtle monochrome circle
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