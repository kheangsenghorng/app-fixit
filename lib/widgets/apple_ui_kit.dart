import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 1. Skeleton Loader for initial profile fetch
class AppleSkeletonLoader extends StatelessWidget {
  const AppleSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar Circle
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const CupertinoActivityIndicator(),
          ),
          const SizedBox(height: 40),
          // Name Bar
          Container(
            width: 180,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 15),
          // Email Bar
          Container(
            width: 240,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 40),
          // Input Field Skeletons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )),
            ),
          )
        ],
      ),
    );
  }
}

class AppleErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppleErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            // This creates the blur effect
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                // Use a semi-transparent white to get the "glass" look
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Card wraps content height
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    size: 50,
                    color: CupertinoColors.activeOrange,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Something went wrong",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, // Full width button inside card
                    child: CupertinoButton(
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(14),
                      onPressed: onRetry,
                      child: const Text(
                        "Try Again",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 3. Modern Apple Style Primary Button
class AppleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppleButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF), // Official Apple Blue
          disabledBackgroundColor: const Color(0xFF007AFF).withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Text(
          label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// 4. Apple Style Frosted Glass HUD (Heads-up Display)
class AppleLoadingHUD extends StatelessWidget {
  final String message;

  const AppleLoadingHUD({super.key, this.message = "Updating"});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) => Opacity(opacity: value, child: child),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.1),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 40,
                      spreadRadius: -5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CupertinoActivityIndicator(radius: 16),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}