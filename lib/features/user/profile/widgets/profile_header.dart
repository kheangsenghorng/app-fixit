import 'package:fixit/features/user/profile/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final Color textColor;

  const ProfileHeader({super.key, required this.name, this.imageUrl, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatar(imageUrl: imageUrl, contentColor: textColor),
        const SizedBox(height: 20),
        Text(
          name,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}