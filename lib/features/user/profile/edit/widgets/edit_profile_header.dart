import 'package:flutter/material.dart';
import 'profile_image_picker.dart';

class EditProfileHeader extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onImageTap;

  const EditProfileHeader({super.key, required this.imageUrl, required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        ProfileImagePicker(
          imageUrl: imageUrl ?? 'https://i.pravatar.cc/300',
          onTap: onImageTap,
        ),
      ],
    );
  }
}