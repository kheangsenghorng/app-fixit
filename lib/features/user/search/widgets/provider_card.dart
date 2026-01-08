import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  final String name;
  final String job;
  final String rating;
  final String? imagePath;

  const ProviderCard({
    super.key,
    required this.name,
    required this.job,
    this.rating = "4.8",
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;


    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Area
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: Colors.blue.shade50, // Background color if image fails
                child: imagePath != null
                    ? Image.asset(imagePath!, fit: BoxFit.cover)
                    : Icon(Icons.person, size: 50, color: colorScheme.primary.withValues(alpha: 0.5)),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 2. Name
          Text(
            name,
            style:  TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color:textTheme.titleMedium!.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // 3. Job Title
          Text(
            job,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 10),

          // 4. Rating and Details Button
          Row(
            children: [
              const Icon(Icons.star, color: Colors.blue, size: 16),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              // Details Button
              GestureDetector(
                onTap: () {
                  // Navigate to details page
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary, // Using your 0xFF0056D2 blue
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}