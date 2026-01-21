import 'package:flutter/material.dart';


class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 65, // Default size
  });

  @override
  Widget build(BuildContext context) {
    // Determine which image to show
    final ImageProvider image;
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      image = NetworkImage(imageUrl!);
    } else {
      image = const AssetImage('assets/images/providers/img.png');
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: 5,
          )
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: image,
      ),
    );
  }
}