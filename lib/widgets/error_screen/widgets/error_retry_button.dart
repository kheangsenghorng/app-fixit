import 'package:flutter/material.dart';

class ErrorRetryButton extends StatelessWidget {
  final VoidCallback onRetry;
  final String? label;

  const ErrorRetryButton({
    super.key,
    required this.onRetry,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ensures the button is full-width for easy tapping
      child: ElevatedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: Text(label ?? "Try Again"), // Defaults to "Try Again" if no label is passed
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}