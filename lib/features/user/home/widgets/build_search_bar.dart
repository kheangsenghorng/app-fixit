import 'package:flutter/material.dart';
import 'build_clear_button.dart';

Widget buildSearchBar({
  required TextEditingController controller,
  required FocusNode focusNode,
  required bool isSearching,
  GestureTapCallback? onSearchTap,
}) {
  return Container(
    height: 58,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      focusNode: focusNode,
      onTap: onSearchTap,
      readOnly: !isSearching,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        hintText: "Search here..",
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.search_rounded, color: Colors.grey, size: 28),
        ),
        suffixIcon: isSearching
            ? buildClearButton()
            : Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.tune_rounded, color: Colors.grey),
        ),
      ),
    ),
  );
}
