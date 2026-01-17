import 'package:fixit/features/onboarding_screen/widgets/onboarding_body.dart';
import 'package:fixit/features/onboarding_screen/widgets/onboarding_dot_indicator.dart';
import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';
// import 'package:fixit/routes/app_routes.dart'; // Keep your existing import

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to FixIt",
      "description": "Discover a world of convenience and reliability. FixIt is your one stop solution for all your home service needs",
      "image": "assets/images/onboarding1.png", // Ensure this has a transparent background
    },
    {
      "title": "Find Services",
      "description": "Browse and book a wide range of services from plumbing and electrical to appliance repair.",
      "image": "assets/images/onboarding2.png",
    },
    {
      "title": "Easy Booking",
      "description": "Schedule services at your preferred time with just a few taps. Our professionals are ready to help.",
      "image": "assets/images/onboarding3.png",
    },
  ];

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF004AAD), // Brighter blue at top
              Color(0xFF001A33), // Very dark blue at bottom
            ],
          ),
        ),
        child: OnboardingBody(
          currentPage: _currentPage,
          onboardingData: _onboardingData,
          pageController: _pageController,
          onSkip: _finishOnboarding,
          onFinish: _finishOnboarding,
          onPageChanged: (value) => setState(() => _currentPage = value),
          dotBuilder: (index) => OnboardingDotIndicator(
            index: index,
            currentPage: _currentPage,
          ),
        ),
      ),
    );
  }
}