import 'package:flutter/material.dart';


class ProviderGridCarder extends StatelessWidget {
  const ProviderGridCarder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14, bottom: 10, top: 5),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image Container
          Container(
            height: 150,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // Using themed highlight or fallbacks for variety
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 70, color: Colors.white70),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Jackson",
                    style: theme.textTheme.labelLarge?.copyWith(fontSize: 16)
                ),
                Text(
                    "Electrician",
                    style: theme.textTheme.bodyMedium
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: colorScheme.primary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                            "3.9",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary
                            )
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(70, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: const Text("Details", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
