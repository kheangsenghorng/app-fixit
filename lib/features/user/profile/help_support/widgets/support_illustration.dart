import 'package:flutter/material.dart';

class SupportIllustration extends StatelessWidget {
  final String assetPath;
  final double size;

  const SupportIllustration({
    super.key,
    this.assetPath = 'assets/images/img_2.png',
    this.size = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        assetPath,
        height: size,
        width: size,
        fit: BoxFit.contain,
        // Added error handling to prevent the app from crashing if the image is missing
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.image_not_supported_outlined,
              size: size * 0.25,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}