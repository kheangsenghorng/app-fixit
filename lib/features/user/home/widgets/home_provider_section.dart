import 'package:flutter/material.dart';
import 'section_header.dart'; // Ensure this matches the w900 version we built
import 'home_provider_list.dart';

class HomeProviderSection extends StatelessWidget {
  final VoidCallback onSeeAllTap;

  const HomeProviderSection({
    super.key,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        // SECTION HEADER (MONOCHROME & W900)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(
            title: "Service Providers",
            contentColor: contentColor, // Matches the Profile logic
            onTap: onSeeAllTap,
          ),
        ),

        const SizedBox(height: 20),

        // List scrolls edge-to-edge
        const HomeProviderList(),

        const SizedBox(height: 110), // Bottom spacing for Floating Nav
      ],
    );
  }
}