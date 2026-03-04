import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color contentColor; // 1. ADDED THIS
  final VoidCallback onTap;

  const SectionHeader({
    super.key, 
    required this.title, 
    required this.contentColor, // 2. ADDED THIS
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.w900, // Premium Heavy weight
            color: contentColor,         // Monochrome Sync
            letterSpacing: -0.5,
          )
        ),
        TextButton(
          onPressed: onTap, 
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            "View all", 
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}