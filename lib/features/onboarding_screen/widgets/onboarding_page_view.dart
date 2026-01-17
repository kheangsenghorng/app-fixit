import 'package:flutter/material.dart';

import 'onboarding_content.dart';
// Ensure you import your OnboardingContent widget here
// import 'onboarding_content.dart';

class OnboardingPageView extends StatelessWidget {
  final PageController controller;
  final List<Map<String, String>> onboardingData;
  final Function(int) onPageChanged;

  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.onboardingData,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: controller,
        onPageChanged: onPageChanged,
        itemCount: onboardingData.length,
        itemBuilder: (context, index) => OnboardingContent(
          image: onboardingData[index]["image"]!,
          title: onboardingData[index]["title"]!,
          description: onboardingData[index]["description"]!,
        ),
      ),
    );
  }
}