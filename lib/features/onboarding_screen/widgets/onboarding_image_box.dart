import 'package:flutter/material.dart';

class OnboardingImageBox extends StatelessWidget {
  final String image;

  const OnboardingImageBox({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.none, // Essential: allows the image to overflow the container
      alignment: Alignment.bottomCenter,
      children: [
        // 1. The Glassy Background Box
        Container(
          width: size.width * 0.75,
          height: size.height * 0.35,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        // 2. The Character/Illustration
        Positioned(
          top: -60, // Negative offset creates the "Popping" effect
          bottom: 0,
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image_outlined,
              size: 100,
              color: Colors.white24,
            ),
          ),
        ),
      ],
    );
  }
}