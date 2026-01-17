import 'package:flutter/material.dart';

import 'onboarding_title.dart';

class OnboardingTextColumn extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingTextColumn({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        OnboardingTitle(title: title),
        // Extracted Description
      ],
    );
  }
}