import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';

class ProviderCard extends StatelessWidget {
  final String name;
  final String job;
  final String? imagePath;
  final VoidCallback? onTap;

  const ProviderCard({
    super.key,
    required this.name,
    required this.job,
    this.imagePath,
    this.onTap,
  });

  void _navigateToDetail(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.providerDetail,
      arguments: {
        'name': name,
        'category': job,
        'image': imagePath,
        'rating': "4.8", 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary; // Your Unit Blue

    // MONOCHROME THEME COLORS
    final contentColor = isDark ? Colors.white : Colors.black;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // 1. SOLID BG (Pure White or Deep Black)
        color: cardBg,
        borderRadius: BorderRadius.circular(32),
        // 2. NO HEAVY BORDER (Hairline only)
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3. IMAGE AREA (High Rounded Corners)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.person_rounded, size: 40, color: activeColor.withValues(alpha: 0.5)),
                      )
                    : Icon(Icons.person_rounded, size: 40, color: activeColor.withValues(alpha: 0.5)),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 4. NAME (Premium Heavy Typography)
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: contentColor,
              fontWeight: FontWeight.w900, // Matches Profile style
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),

          // 5. JOB TITLE
          Text(
            job,
            style: TextStyle(
              color: contentColor.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // 6. ACTION ROW
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                "4.8",
                style: TextStyle(
                  color: contentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // DETAILS BUTTON (Stadium/Pill Shape)
              GestureDetector(
                onTap: () => _navigateToDetail(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(20),
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
    ),
  );
}
}