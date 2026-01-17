import 'package:flutter/material.dart';


class OnboardingContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),

        // THE POPPING IMAGE BOX
        Stack(
          clipBehavior: Clip.none, // Allows the head to overflow
          alignment: Alignment.bottomCenter,
          children: [
            // The Rounded Background Box
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1), // Glassy lighter blue
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            // The Image
            Positioned(
              top: -60, // Pushes the head out of the top
              bottom: 0,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                // height: MediaQuery.of(context).size.height * 0.45,
              ),
            ),
          ],
        ),

        const Spacer(flex: 2),

        // TEXT CONTENT
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),

        const Spacer(flex: 3),
      ],
    );
  }
}