import 'package:flutter/material.dart';
import 'section_header.dart';
import 'home_provider_list.dart';

class HomeProviderSection extends StatelessWidget {
  final VoidCallback onSeeAllTap;

  const HomeProviderSection({
    super.key,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),

        // Header stays within the 20px padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(
            title: "Service Providers",
            onTap: onSeeAllTap,
          ),
        ),

        const SizedBox(height: 15),

        // List scrolls edge-to-edge (Padding should be INSIDE HomeProviderList)
        const HomeProviderList(),

        const SizedBox(height: 100), // Bottom spacing for navigation/FAB
      ],
    );
  }
}