import 'package:flutter/material.dart';

class SuccessSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SuccessSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0056D2);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        // Size ensures the clickable area spans the full width
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: primaryBlue,
        ),
      ),
    );
  }
}