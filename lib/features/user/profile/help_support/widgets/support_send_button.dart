import 'package:flutter/material.dart';

class SupportSendButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;

  const SupportSendButton({
    super.key,
    required this.onPressed,
    this.label = "Send",
    this.backgroundColor = const Color(0xFF0056D2), // primaryBlue
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}