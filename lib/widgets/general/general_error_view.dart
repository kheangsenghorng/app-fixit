import 'package:flutter/material.dart';

class GeneralErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const GeneralErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important for BottomSheets
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Red Icon
          const Icon(
            Icons.cloud_off,
            size: 60,
            color: Colors.redAccent,
          ),

          const SizedBox(height: 16),

          // 2. Bold Title
          const Text(
            "Connection Error",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // 3. Dynamic Message with Opacity
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 24),

          // 4. Full Width Button
          SizedBox(
            width: double.infinity,
            height: 50, // Added standard height
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Retry Connection",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}