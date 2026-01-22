import 'package:flutter/material.dart';

class CustomFieldLabel extends StatelessWidget {
  final String text;

  const CustomFieldLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        fontSize: 14,
      ),
    );
  }
}