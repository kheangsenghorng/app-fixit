import 'package:flutter/material.dart';

class FeedbackHeader extends StatelessWidget {
  final String title;

  const FeedbackHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}