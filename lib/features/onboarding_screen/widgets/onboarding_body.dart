import 'package:flutter/material.dart';
// Import your individual widgets here
import 'onboarding_top_bar.dart';
import 'onboarding_page_view.dart';
import 'onboarding_next_button.dart';

class OnboardingBody extends StatelessWidget {
  final int currentPage;
  final List<Map<String, String>> onboardingData;
  final PageController pageController;
  final Function(int) onPageChanged;
  final VoidCallback onSkip;
  final VoidCallback onFinish;
  final Widget Function(int index) dotBuilder;

  const OnboardingBody({
    super.key,
    required this.currentPage,
    required this.onboardingData,
    required this.pageController,
    required this.onPageChanged,
    required this.onSkip,
    required this.onFinish,
    required this.dotBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // 2. TOP BAR
          OnboardingTopBar(
            currentIndex: currentPage,
            totalDots: onboardingData.length,
            onSkip: onSkip,
            dotBuilder: dotBuilder,
          ),

          // 3. PAGES
          OnboardingPageView(
            controller: pageController,
            onboardingData: onboardingData,
            onPageChanged: onPageChanged,
          ),

          // 4. NEXT BUTTON
          OnboardingNextButton(
            currentPage: currentPage,
            totalPages: onboardingData.length,
            pageController: pageController,
            onFinish: onFinish,
          ),
        ],
      ),
    );
  }
}