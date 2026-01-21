import 'package:fixit/features/user/profile/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final Color textColor;

  const ProfileHeader({
    super.key,
    required this.name,
    this.imageUrl,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // We use the Avatar class here
        ProfileAvatar(
          imageUrl: imageUrl,
          radius: 60, // You can control size here
        ),
        const SizedBox(height: 15),
        Text(
          name,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}