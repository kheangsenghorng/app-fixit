import 'package:flutter/material.dart';
import 'onboarding_dots.dart';
import 'onboarding_skip_button.dart';

class OnboardingTopBar extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  final VoidCallback onSkip;
  final Widget Function(int index) dotBuilder;

  const OnboardingTopBar({
    super.key,
    required this.currentIndex,
    required this.totalDots,
    required this.onSkip,
    required this.dotBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Indicator Dots
          OnboardingDots(
            totalDots: totalDots, // Fixed: Use constructor variable
            dotBuilder: dotBuilder, // Pass the builder directly
          ),
          // 2. Skip Button Section
          OnboardingSkipButton(onSkip: onSkip),
        ],
      ),
    );
  }
}