import 'package:flutter/material.dart';

class OnboardingNextButton extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final VoidCallback onFinish;

  const OnboardingNextButton({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == totalPages - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            if (isLastPage) {
              onFinish();
            } else {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0056D2),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            isLastPage ? "Get Started" : "Next",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}