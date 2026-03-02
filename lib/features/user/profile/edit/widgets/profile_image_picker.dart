import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const ProfileImagePicker({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryBlue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.edit,
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
