import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;
  final Color contentColor; // Black in Light Mode, White in Dark Mode

  const ProfileImagePicker({
    super.key,
    this.imageUrl,
    this.onTap,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryBlue = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    
    // Determine which image to show
    final ImageProvider image;
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      image = NetworkImage(imageUrl!);
    } else {
      image = const AssetImage('assets/images/providers/img.png');
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. OUTER THIN BORDER (Matches ProfileAvatar)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: contentColor.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              backgroundImage: image,
            ),
          ),

          // 2. EDIT BADGE (Primary Blue with BG-matching border)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryBlue, // Your brand blue
                shape: BoxShape.circle,
                border: Border.all(
                  // Matches the screen background (Pure Black or Pure White)
                  color: isDark ? Colors.black : Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded, // More modern icon
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}