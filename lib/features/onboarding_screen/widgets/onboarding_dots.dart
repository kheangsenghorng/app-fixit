import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  final int totalDots;
  final Widget Function(int index) dotBuilder;

  const OnboardingDots({
    super.key,
    required this.totalDots,
    required this.dotBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Prevents the row from taking full width
      children: List.generate(
        totalDots,
            (index) => dotBuilder(index),
      ),
    );
  }
}