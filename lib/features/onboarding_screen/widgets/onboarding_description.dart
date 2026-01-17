import 'package:flutter/material.dart';

class OnboardingDescription extends StatelessWidget {
  final String description;

  const OnboardingDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 16,
          height: 1.5, // Improves readability
        ),
      ),
    );
  }
}