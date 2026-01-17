import 'package:fixit/features/onboarding_screen/widgets/onboarding_content.dart';
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
        child: SafeArea(
          child: Column(
            children: [
              // 2. TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        _onboardingData.length,
                            (index) => buildDot(index: index),
                      ),
                    ),
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. PAGES
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) => setState(() => _currentPage = value),
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) => OnboardingContent(
                    image: _onboardingData[index]["image"]!,
                    title: _onboardingData[index]["title"]!,
                    description: _onboardingData[index]["description"]!,
                  ),
                ),
              ),

              // 4. NEXT BUTTON
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0056D2), // Darker blue button
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: _currentPage == index ? 24 : 6, // Pill shape for active
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}