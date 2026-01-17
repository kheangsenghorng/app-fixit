import 'package:flutter/material.dart';

class OnboardingDotIndicator extends StatelessWidget {
  final int index;
  final int currentPage;

  const OnboardingDotIndicator({
    super.key,
    required this.index,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: isActive ? 24 : 6, // Expands to a pill shape when active
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}