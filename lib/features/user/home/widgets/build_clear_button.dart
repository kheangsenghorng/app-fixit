import 'package:flutter/material.dart';

Widget buildClearButton() {
  GestureTapCallback? onClear;
  return GestureDetector(
    onTap: onClear,
    child: Container(
      margin: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFFE8F0FE),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.close, size: 16, color: Color(0xFF004AAD)),
    ),
  );
}
