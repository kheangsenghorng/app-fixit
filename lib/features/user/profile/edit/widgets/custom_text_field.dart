import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final Color contentColor;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.contentColor,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: contentColor.withValues(alpha: 0.4),
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(color: contentColor, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: contentColor.withValues(alpha: 0.2), fontSize: 14),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: contentColor.withValues(alpha: 0.5), size: 20) : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: contentColor.withValues(alpha: 0.1)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: contentColor, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}