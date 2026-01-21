import 'package:flutter/material.dart';

class ErrorDescriptionText extends StatelessWidget {
  final String message;

  const ErrorDescriptionText({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
        height: 1.5, // Added line height for better readability
      ),
    );
  }
}