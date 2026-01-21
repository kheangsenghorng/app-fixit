import 'package:flutter/material.dart';

import 'widgets/error_state_content.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center( // Center handles the alignment
      child: Padding(
        padding: const EdgeInsets.all(32.0), // Padding is its own widget
         child: ErrorStateContent(
        errorMessage: "We couldn't reach the server. Please check your WiFi.",
        onRetry: () {
        },
      ),
      ),
    );
  }
}