import 'package:flutter/material.dart';

class FeedbackInstructionText extends StatelessWidget {
  final String text;

  const FeedbackInstructionText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }
}