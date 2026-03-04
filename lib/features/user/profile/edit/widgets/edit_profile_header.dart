import 'package:flutter/material.dart';
import 'profile_image_picker.dart';

class EditProfileHeader extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onImageTap;
  final Color contentColor; // Added for Black/White sync

  const EditProfileHeader({
    super.key, 
    required this.imageUrl, 
    required this.onImageTap,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10), // Clean spacing
        ProfileImagePicker(
          imageUrl: imageUrl,
          onTap: onImageTap,
          contentColor: contentColor,
        ),
      ],
    );
  }
}