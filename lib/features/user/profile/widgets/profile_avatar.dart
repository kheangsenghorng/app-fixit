import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color contentColor;

  const ProfileAvatar({super.key, this.imageUrl, this.radius = 60, required this.contentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: contentColor.withValues(alpha: 0.1), width: 1),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: (imageUrl != null) 
          ? NetworkImage(imageUrl!) 
          : const AssetImage('assets/images/providers/img.png') as ImageProvider,
      ),
    );
  }
}