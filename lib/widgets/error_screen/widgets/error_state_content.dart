import 'package:flutter/material.dart';

import 'connection_error_icon.dart';
import 'error_description_text.dart';
import 'error_retry_button.dart';
import 'error_title_text.dart';


class ErrorStateContent extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateContent({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // We use a Column to hold the children you defined
    return Column(
      mainAxisSize: MainAxisSize.min, // Essential for Centering/BottomSheets
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. THE ICON
        const ConnectionErrorIcon(),
        const SizedBox(height: 24),

        // 2. THE HEADER
        ErrorTitleText(title: "Connection Error"),
        const SizedBox(height: 8),

        // 3. THE ERROR MESSAGE

        ErrorDescriptionText(message: errorMessage),
        const SizedBox(height: 32),
        // The final piece of the puzzle
        ErrorRetryButton(onRetry: onRetry),
      ],
    );
  }
}