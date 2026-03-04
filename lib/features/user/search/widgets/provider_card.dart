import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  final String name;
  final String job;

  const ProviderCard({super.key, required this.name, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary;

    // MONOCHROME THEME COLORS
    final contentColor = isDark ? Colors.white : Colors.black;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 1. IMAGE AREA (Monochrome background)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(Icons.person_rounded, size: 40, color: activeColor.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(height: 12),

          // 2. NAME (Heavy Weight Typography)
          Text(
            name, 
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: contentColor, 
              fontWeight: FontWeight.w900, // Matches Profile style
              fontSize: 16,
              letterSpacing: -0.5,
            )
          ),
          
          // 3. JOB
          Text(
            job, 
            style: TextStyle(
              color: contentColor.withValues(alpha: 0.4), 
              fontSize: 12, 
              fontWeight: FontWeight.w500
            )
          ),
          
          const SizedBox(height: 12),

          // 4. ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  Text(" 4.9", style: TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              // DETAILS BUTTON (Pill shape)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Details", 
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}