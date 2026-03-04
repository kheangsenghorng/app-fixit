import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller; // Added back
  final Color contentColor;

  const PhoneInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.contentColor,
    this.controller, // FIXED: Added to constructor
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
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: contentColor.withValues(alpha: 0.1)),
            ),
          ),
          child: Row(
            children: [
              const Text("🇰🇭", style: TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: contentColor.withValues(alpha: 0.5), size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: contentColor, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: contentColor.withValues(alpha: 0.2), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}