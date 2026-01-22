import 'package:flutter/material.dart';

class SupportLiveChatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color primaryColor;

  const SupportLiveChatButton({
    super.key,
    required this.onPressed,
    this.primaryColor = const Color(0xFF0056D2), // primaryBlue
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.chat_bubble_outline, color: primaryColor),
        label: Text(
          "Live chat",
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}