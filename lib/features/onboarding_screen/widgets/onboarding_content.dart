import 'package:flutter/material.dart';

import 'onboarding_description.dart';
import 'onboarding_image_box.dart';
import 'onboarding_text_column.dart';


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
        OnboardingImageBox(image: image),

        const Spacer(flex: 2),
        // 2. Text Piece
        OnboardingTextColumn(
          title: title,
          description: description,
        ),

        const SizedBox(height: 16),

        OnboardingDescription(description: description),

        const Spacer(flex: 3),
      ],
    );
  }
}